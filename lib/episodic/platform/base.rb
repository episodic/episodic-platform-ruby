module Episodic #:nodoc:
  
  #
  # Episodic::Platform is a Ruby library for Episodic's Platform REST API (http://app.episodic.com/help/server_api)
  #
  # == Getting started
  # 
  # To get started you need to require 'episodic/platform':
  # 
  #   require 'episodic/platform'
  # 
  # Before you can use any of the object methods, you need to create a connection using <tt>Base.establish_connection!</tt>.  The 
  # <tt>Base.establish_connection!</tt> method requires that you pass your Episodic API Key and Episodic Secret Key.
  # 
  #   Episodic::Platform::Base.establish_connection!('my_api_key', 'my_secret_key')
  #
  # == Handling errors
  #
  # Any errors returned from the Episodic Platform API are converted to exceptions and raised from the called method.  For example,
  # the following response would cause <tt>Episodic::Platform::InvalidAPIKey</tt> to be raised.
  # 
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <error>
  #     <code>1</code>
  #     <message>Invalid API Key</message>
  #   </error>
  #
  module Platform
    API_HOST = 'app.episodic.com'
    API_VERSION = 'v2'
    
    #
    # Episodic::Platform::Base is the abstract super class of all classes who make requests against the Episodic Platform REST API.
    #
    # Establishing a connection with the Base class is the entry point to using the library:
    #
    #   Episodic::Platform::Base.establish_connection!('my_api_key', 'my_secret_key')
    #
    class Base 
      
      class << self
        
        #
        # Helper method to construct an Episodic Platform API request URL.
        #
        # ==== Parameters
        #
        # api_name<String>:: Specifies the API you are calling.  Examples are "write", query" and "analytics"
        # method_name<String>:: The method being invoked.
        #
        # ==== Returns
        #
        # URI:: The constructed URL.
        #
        def construct_url api_name, method_name
          return URI.parse("http://#{connection.connection_options[:api_host] || API_HOST}/api/#{API_VERSION}/#{api_name}/#{method_name}")
        end
        
      end
      
    end
  end
  
end
