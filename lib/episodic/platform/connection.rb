module Episodic
  module Platform
    
    #
    # Class used to make the actual requests to the Episodic Platform API.
    #
    class Connection
      
      attr_reader :episodic_api_key, :episodic_secret_key, :connection_options
      
      #
      # Constructor
      #
      # episodic_api_key<String>:: The caller's Episodic API Key
      # episodic_secret_key<String>:: The caller's Episodic Secret Key
      # options<Hash>:: Used mostly for testing by allowing the caller to override some constants such 
      #   the API host.
      #
      def initialize(episodic_api_key, episodic_secret_key, options = {})
        @episodic_api_key = episodic_api_key
        @episodic_secret_key = episodic_secret_key
        @connection_options = options
      end     
      
      #
      # Perform the POST request to the specified URL.  This method takes the params passed in and
      # generates the signature parameter using the Episodic Secret Key for this connection.  The 
      # signature, the Episodic API Key for this connection and the passed in params are then used to
      # generate the form post.  
      #
      # If there are any filenames passed then these are also included in the form post.
      #
      # ==== Parameters
      #
      # url<URI>:: The URL to the Episodic Platform API endpoint
      # params<Hash>:: A hash of parameters to include include in the post request.
      # file_params<Hash>:: A hash of file parameters. The name is the parameter name and value is the path to the file.
      #
      # ==== Returns
      #
      # Episodic::Platform::HTTPResponse:: The full response object.
      #
      def do_post url, params, file_params = nil
        
        # Convert all the params to strings
        request_params = convert_params_for_request(params)
        
        # Add in the common params
        append_common_params(request_params)
        
        c = Curl::Easy.new(url.to_s)  
        c.multipart_form_post = true
        
        fields = []
        request_params.each_pair do |name, value|
          fields << Curl::PostField.content(name, value)
        end
        file_params.each do |name, value|
          fields << Curl::PostField.file(name, value) 
        end unless file_params.nil?
        
        # Make the request
        c.http_post(*fields)
        
        return Episodic::Platform::HTTPResponse.new(c.response_code, c.body_str)
      end
      
      #
      # Perform the GET request to the specified URL.  This method takes the params passed in and
      # generates the signature parameter using the Episodic Secret Key for this connection.  The 
      # signature, the Episodic API Key for this connection and the passed in params are then used to
      # generate the query string.
      #
      # ==== Parameters
      #
      # url<URI>:: The URL to the Episodic Platform API endpoint
      # params<Hash>:: A hash of parameters to include include in the query string.
      #
      # ==== Returns
      #
      # Episodic::Platform::HTTPResponse:: The full response object.
      #
      def do_get url, params
        
        # Convert all the params to strings
        request_params = convert_params_for_request(params)
        
        # Add in the common params
        append_common_params(request_params)
        
        queryString = ""
        request_params.keys.each_with_index do |key, index|
          queryString << "#{index == 0 ? '?' : '&'}#{key}=#{::URI.escape(request_params[key])}"
        end
        
        # Create the request
        http = Net::HTTP.new(url.host, url.port)
        response = http.start() {|req| req.get(url.path + queryString)}
        
        return Episodic::Platform::HTTPResponse.new(response.code, response.body)
      end
      
      protected
      
      #
      # Helper method to generate the request signature
      #
      # ==== Parameters
      #
      # params<Hash>:: The set of params that will be passed either in the form post or in the 
      #    query string.
      #
      def generate_signature_from_params params
        sorted_keys = params.keys.sort {|x,y| x.to_s <=> y.to_s }
        string_to_sign = @episodic_secret_key
        sorted_keys.each do |key|
          string_to_sign += "#{key.to_s}=#{params[key]}"
        end
        
        return Digest::SHA256.hexdigest(string_to_sign) 
      end
      
      #
      # Apply the common Episodic params such as expires, signature and key
      #
      # ==== Parameters
      #
      # params<Hash>:: The params to update.
      #
      def append_common_params params
        
        # Add an expires value if it has not been added already
        params["expires"] ||= (Time.now.to_i + 30).to_s
        
        # Sign the request
        params["signature"] = self.generate_signature_from_params(params)
        
        # Add our key
        params["key"] = @episodic_api_key        
      end
      
      #
      # Converts all parameters to a form for a request.  This includes converting arrays to comma delimited strings,
      # Times to integers and Hashes to a form depending on its level in the passed in params.
      #
      # ==== Parameters
      #
      # params<Hash>:: The params to convert.
      #
      # ==== Returns
      #
      # Hash:: A single level hash where all keys and values are strings.
      #
      def convert_params_for_request params
        result = {}
        
        params.each_pair do |key, value|
          
          # We don't want to deal with nils
          value = "" if value.nil?
          
          if value.is_a?(Array)
            # Convert to a comma delimited string
            result[key.to_s] = value.join(",")
          elsif value.is_a?(Time)
            #Convert the time to an integer (then string)
            result[key.to_s] = value.to_i.to_s
          elsif value.is_a?(Hash)
            # Used for custom fields
            value.each_pair do |sub_key, sub_value|
              sub_value = "" if sub_value.nil?
              if (sub_value.is_a?(Time))
                result["#{key.to_s}[#{sub_key.to_s}]"] = sub_value.to_i.to_s
              elsif (sub_value.is_a?(Hash))
                # Put the hash in the external select field form
                val = ""
                sub_value.each_pair do |k, v|
                  val << "#{k}|#{v};"
                end
                result["#{key.to_s}[#{sub_key.to_s}]"] = val
              else
                result["#{key.to_s}[#{sub_key.to_s}]"] = sub_value.to_s
              end
            end 
          else
            result[key.to_s] = value.to_s 
          end
        end
        
        return result
      end
      
      module Management #:nodoc:
        def self.included(base)
          base.cattr_accessor :connections
          base.connections = {}
          base.extend ClassMethods
        end
        
        #
        # Manage the creation and destruction of connections for Episodic::Platform::Base and its subclasses. Connections are
        # created with establish_connection!.
        #
        module ClassMethods
          
          #
          # Creates a new connection with which to make requests to the Episodic Platform for the 
          # calling class.
          #   
          #   Episodic::Platform::Base.establish_connection!(episodic_api_key, episodic_secret_key)
          #
          # You can set connections for every subclass of Episodic::Platform::Base. Once the initial 
          # connection is made on Base, all subsequent connections will inherit whatever values you 
          # don't specify explictly.
          #
          # ==== Parameters
          #
          # episodic_api_key<String>:: This is your Episodic API Key
          # episodic_secret_key<String>:: This is your Episodic Secret Key
          #
          def establish_connection!(episodic_api_key, episodic_secret_key, options = {})
            connections[connection_name] = Connection.new(episodic_api_key, episodic_secret_key, options)
          end
          
          #
          # Returns the connection for the current class, or Base's default connection if the current class does not
          # have its own connection.
          #
          # If not connection has been established yet, NoConnectionEstablished will be raised.
          #
          # ==== Returns
          #
          # Episodic::Platform::Connection:: The connection for the current class or the default connection
          #
          def connection
            if connected?
              connections[connection_name] || default_connection
            else
              raise NoConnectionEstablished
            end
          end
          
          #
          # Returns true if a connection has been made yet.
          #
          # ==== Returns
          #
          # Boolean:: <tt>true</tt> if there is at least one connection
          #
          def connected?
            !connections.empty?
          end
          
          #
          # Removes the connection for the current class. If there is no connection for the current class, the default
          # connection will be removed.
          #
          # ==== Parameters
          #
          # name<String>:: The name of the connection.  This defaults to the default connection name.
          #
          def disconnect(name = connection_name)
            name       = default_connection unless connections.has_key?(name)
            connections.delete(name)
          end
          
          #
          # Removes all connections 
          #
          def disconnect!
            connections.each_key {|connection| disconnect(connection)}
          end
          
          private
          
          #
          # Get the name of this connection
          #
          # ==== Returns
          #
          # String:: The connection name
          #
          def connection_name
            name
          end
          
          #
          # Hardcoded default connection name
          #
          def default_connection_name
              'Episodic::Platform::Base'
          end
          
          #
          # Shortcut to get the default connection
          #
          def default_connection
            connections[default_connection_name]
          end
        end
      end
      
    end
  end
end