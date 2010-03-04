module Episodic
  
  module Platform
    
    #
    # Base class for responses that return an collection of objects.
    #
    class CollectionResponse < Response
      
      COLLECTION_RESPONSE_ATTRIBUTES = [:page, :pages, :total, :per_page]
      
      #
      # Constructor
      #
      # ==== Parameters
      #
      # response<Episodic::Platform::HttpResponse>:: The response object returned from an Episodic Platform API request.
      # xml_options<Hash>:: A set of options used by XmlSimple when parsing the response body
      #
      def initialize response, xml_options = {}
        super(response, xml_options)
      end
      
      #
      # Override to look up attributes by name
      #
      def method_missing(method_sym, *arguments, &block)
        method_name = method_sym.to_s
        if (COLLECTION_RESPONSE_ATTRIBUTES.include?(method_sym))
          return @parsed_body[method_name].to_i
        end
        
        return super
      end
      
      #
      # Attributes can be accessed as methods.
      #
      def respond_to?(symbol, include_private = false)
        return COLLECTION_RESPONSE_ATTRIBUTES.include?(symbol)
      end
      
    end
  end
end