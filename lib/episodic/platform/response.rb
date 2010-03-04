module Episodic
  module Platform
    
    #
    # Base class for responses.  This class takes the response and parses the body using XmlSimple.  
    # If the response body contains an error then this method will throw the appropriate exception.
    #
    class Response
      
      #
      # Constructor
      #
      # ==== Parameters
      #
      # response<Episodic::Platform::HttpResponse>:: The response object returned from an Episodic Platform API request.
      # xml_options<Hash>:: A set of options used by XmlSimple when parsing the response body
      #
      def initialize response, xml_options = {}
        @response = response
        xml_options['ForceArray'] ||= false
        @parsed_body = ::XmlSimple.xml_in(@response.body, xml_options.merge({'KeepRoot' => true}))
        
        # Now that we have parsed the response, we can make sure that it is valid or otherwise
        # throw an exception.
        if @parsed_body["error"]
          handle_error_response(@parsed_body["error"])
        else
          # Remove the root element
          @parsed_body = @parsed_body[@parsed_body.keys.first]
        end
      end
      
      #
      # Provides access to the unparsed XML response
      #
      # ==== Returns 
      #
      # String:: The XML response as a string.
      #
      def xml
        return @response.body
      end
      
      protected
      
      #
      # Uses the code in the error response XML to determine which exception should be raised and raises it.
      # The message in the XML is included in the exception.
      #
      # ==== Parameters
      #
      # error<Hash>:: The parsed error response.
      #
      def handle_error_response error
        code = error["code"].to_i
        message = error["message"]
        
        # Figure out which exception to raise
        case code
          when 1 then raise ::Episodic::Platform::InvalidAPIKey.new(message, @response)
          when 2 then raise ::Episodic::Platform::ReportNotFound.new(message, @response)
          when 3 then raise ::Episodic::Platform::MissingRequiredParameter.new(message, @response)
          when 4 then raise ::Episodic::Platform::InvalidParameters.new(message, @response, error["invalid_parameters"])
          when 5 then raise ::Episodic::Platform::RequestExpired.new(message, @response)
          when 6 then raise ::Episodic::Platform::NotFound.new(message, @response)
          when 7 then raise ::Episodic::Platform::APIAccessDisabled.new(message, @response)
        else
          raise ::Episodic::Platform::ResponseError.new(message, @response)
        end
      end
    end
    
    #
    # The raw response.  This contains the response code and body.
    #
    class HTTPResponse
      
      attr_reader :response_code, :body
      
      #
      # Constructor
      #
      # ==== Parameters
      #
      # response_code<Integer>:: The code returned from the request
      # body<String>:: The xml of the response
      #
      def initialize response_code, body
        @response_code = response_code
        @body = body
      end
    end
  end
end