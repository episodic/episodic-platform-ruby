module Episodic
  module Platform
    
    #
    # Abstract super class of all Episodic::Platform exceptions
    #
    class EpisodicPlatformException < StandardError
    end
    
    class FileUploadFailed < EpisodicPlatformException  
    end
    
    #
    # An execption that is raised as a result of the response content.
    #
    class ResponseError < EpisodicPlatformException
      
      attr_reader :response
      
      #
      # Constructor
      #
      # ==== Parameters
      #
      # message<String>:: The message to include in the exception
      # response<Episodic::Platform::HTTPResponse>:: The response object.
      #
      def initialize(message, response)
        @response = response
        super(message)
      end
    end
    
    #
    # There was an unexpected error on the server. .
    #
    class InternalError < ResponseError
    end

    #
    # The API Key wasn't provided or is invalid or the signature is invalid.
    #    
    class InvalidAPIKey < ResponseError
    end

    #
    # The requested report could not be found. Either the report token is invalid or the report has expired and is no longer available.
    #  
    class ReportNotFound < ResponseError
    end
    
    #
    # The request failed to specifiy one or more of the required parameters to an API method. 
    # 
    class MissingRequiredParameter < ResponseError
    end

    #
    # The request is no longer valid because the expires parameter specifies a time that has passed. 
    #
    class RequestExpired < ResponseError
    end
    
    #
    # The specified object (i.e. show, episode, etc.) could not be found.  
    #
    class NotFound < ResponseError
    end
    
    #
    # API access for the user is disabled.   
    #
    class APIAccessDisabled < ResponseError
    end
    
    #
    # The value specified for a parameter is not valid.    
    #
    class InvalidParameters < ResponseError
      
      #
      # Constructor.  Override to include inforation about the invalid parameter(s).
      #
      # ==== Parameters
      #
      # message<String>:: The message to include in the exception
      # response<Episodic::Platform::HTTPResponse>:: The response object.
      # invalid_parameters<Object>:: This is either a Hash or an Array of hashes if there is more than one invalid parameter.
      #
      def initialize(message, response, invalid_parameters)
        
        if (invalid_parameters)
          invalid_parameters["invalid_parameter"] = [invalid_parameters["invalid_parameter"]] if invalid_parameters["invalid_parameter"].is_a?(Hash)
          
          # Append to the message
          invalid_parameters["invalid_parameter"].each do |ip|
            message << "\n#{ip['name']}: #{ip['content']}"
          end
        end
        
        super(message, response)
      end
    end
  end
end