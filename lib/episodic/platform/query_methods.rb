module Episodic #:nodoc:
  
  module Platform
    
    #
    # Class for making requests against the Episodic Platform Query API.
    #
    class QueryMethods < Base 
      
      class << self
        
        #
        # Queries for episodes in your network.  The options parameter allows you to limit
        # your results.  Acceptable options are:
        #   show_id - A single id or an Array of show ids.  If this param is not provided then 
        #       all shows in your network are queried.
        #   id - A single id or an Array of episode ids.  If this param is not provided then 
        #       all episodes in the your network or specified shows are queried.
        #   search_term - This string is used to perform a keywords search against the title, 
        #       description, tags and custom fields of an episode. Tags should be separated by
        #       commas.
        #   search_type - The search_type parameter must be one of "tags", "name_description" 
        #       or "all". The default is "all" 
        #   tag_mode - The tag_mode parameter can be "any" for an OR combination of tags, or 
        #       "all" for an AND combination. The default is "any". This parameter is ignored if 
        #       the search_type is not "tags".
        #   status - The status parameter can be used to limit the list of episodes with a 
        #       certain publishing status. The value must be a comma delimited list of one or more 
        #       of "off_the_air", "publishing", "on_the_air", "waiting_to_air", "publish_failed"
        #   sort_by - The sort_by parameter is optional and specifies a field to sort the results 
        #       by. The value must be one of "updated_at", "created_at", "air_date" or "name". 
        #       The default is "created_at".
        #   sort_dir - The sort_dir parameter is optional and specifies the sort direction. The 
        #       value must be one of "asc" or "desc". The default is "asc". 
        #   include_views - A value that must be one of "true" or "false" to indicate if total 
        #       views and complete views should be included in the response. The default is "false". 
        #       NOTE: Setting this to "true" may result in slower response times.  
        #   page - A value that must be an integer indicating the page number to return the results 
        #       for. The default is 1.
        #   per_page - A value that must be an integer indicating the number of items per page. The 
        #       default is 20. NOTE: The smaller this value is the better your response times will be. 
        #   embed_width - An integer value in pixels that specifies the width of the player. The 
        #       returned embed code width may be larger that this to account for player controls 
        #       depending on the player you are using. If only the width is provided, the height is 
        #       determined by maintaining the aspect ratio.
        #   embed_height - An integer value in pixels that specifies the height of the player. The 
        #       embed code height may be larger that this to account for player controls depending on 
        #       the player you are using. The default height is 360. 
        #
        # ==== Parameters
        #
        # options<Hash>:: A hash of optional attributes.
        #
        # ==== Returns
        #
        # ::Episodic::Platform::EpisodesResponse:: The parsed response.
        #
        def episodes options = {}
          
          # Clone the options into our params hash
          params = options.clone
          
          # Make the request
          response = connection.do_get(construct_url("query", "episodes"), params)
          
          # Convert to a hash
          return parse_episodes_response(response)
        end

        #
        # Third-party applications can register to be notified of changes to episodes and 
        # playlists in their network by providing an Modification URL in their network settings. 
        # When an episode/playlist is created, modified or deleted the Episodic System when 
        # make a POST request to specified URL with an XML representation of the modified object.
        #
        # This method allows the caller to query for all callbacks registered since a specified time. 
        # Although, failed callbacks are marked as failed and retried, this method allows the caller 
        # to see a history of callbacks to perhaps reprocess them if something went wrong with their 
        # initial processing.
        # 
        # Acceptable filter options are:
        #   pending_only - Set this parameter to 'true' if only unprocessed callbacks should be 
        #       returned. The default is 'false'. 
        #   page - A value that must be an integer indicating the page number to return the results 
        #       for. The default is 1.
        #   per_page - A value that must be an integer indicating the number of items per page. The 
        #       default is 20. NOTE: The smaller this value is the better your response times will be. 
        #
        # ==== Parameters
        #
        # since<Time>:: All callbacks registered since the provided date will be included in the 
        #     response.
        # options<Hash>:: A hash of optional attributes.
        #
        # ==== Returns
        #
        # String:: The XML response from the server.
        #
        def modification_callbacks since, options = {}
          
          # Clone the options into our params hash
          params = options.clone
           params[:since] = since
          
          # Make the request
          response = connection.do_get(construct_url("query", "modification_callbacks"), params)
          
          # Convert to a hash
          return response.body
        end
        
        #
        # Queries for playlists in your network.  The options parameter allows you to limit
        # your results.  Acceptable options are:
        #   show_id - A single id or an Array of show ids.  If this param is not provided then 
        #       all shows in your network are queried.
        #   id - A single id or an Array of playlist ids.  If this param is not provided then 
        #       all playlists in the your network or specified shows are queried.
        #   search_term - This string is used to perform a keywords search against the title, 
        #       description, and custom fields of a playlist. 
        #   sort_by - The sort_by parameter is optional and specifies a field to sort the results 
        #       by. The value must be one of "updated_at", "created_at", "name". 
        #       The default is "created_at".
        #   sort_dir - The sort_dir parameter is optional and specifies the sort direction. The 
        #       value must be one of "asc" or "desc". The default is "asc".   
        #   page - A value that must be an integer indicating the page number to return the results 
        #       for. The default is 1.
        #   per_page - A value that must be an integer indicating the number of items per page. The 
        #       default is 20. NOTE: The smaller this value is the better your response times will be. 
        #   embed_width - An integer value in pixels that specifies the width of the player. The 
        #       returned embed code width may be larger that this to account for player controls 
        #       depending on the player you are using. If only the width is provided, the height is 
        #       determined by maintaining the aspect ratio.
        #   embed_height - An integer value in pixels that specifies the height of the player. The 
        #       embed code height may be larger that this to account for player controls depending on 
        #       the player you are using. The default height is 360. 
        #
        # ==== Parameters
        #
        # options<Hash>:: A hash of optional attributes.
        #
        # ==== Returns
        #
        # ::Episodic::Platform::PlaylistsResponse:: The parsed response.
        #
        def playlists options = {}
          
          # Clone the options into our params hash
          params = options.clone
          
          # Make the request
          response = connection.do_get(construct_url("query", "playlists"), params)
          
          # Convert to a hash
          return parse_playlists_response(response)
        end
        
        #
        # Queries for shows in your network.  The options parameter allows you to limit
        # your results.  Acceptable options are:
        #   id - A single id or an Array of episode ids.  If this param is not provided then 
        #       all shows in the your network or specified shows are queried.
        #   sort_by - The sort_by parameter is optional and specifies a field to sort the results 
        #       by. The value must be one of "updated_at", "created_at" or "name". The 
        #       default is "created_at". 
        #   sort_dir - The sort_dir parameter is optional and specifies the sort direction. The 
        #       value must be one of "asc" or "desc". The default is "asc". 
        #   page - A value that must be an integer indicating the page number to return the results 
        #       for. The default is 1.
        #   per_page - A value that must be an integer indicating the number of items per page. The 
        #       default is 20. NOTE: The smaller this value is the better your response times will be.  
        #
        # ==== Parameters
        #
        # options<Hash>:: A hash of optional attributes.
        #
        # ==== Returns
        #
        # ::Episodic::Platform::ShowsResponse:: The parsed response.
        #
        def shows options = {}
          
          # Clone the options into our params hash
          params = options.clone
          
          # Make the request
          response = connection.do_get(construct_url("query", "shows"), params)
          
          # Convert to a hash
          return parse_shows_response(response)
        end
        
        protected
        
        #
        # Method factored out to make unit testing easier.  This method simply creates the <tt>::Episodic::Platform::EpisodesResponse</tt>
        # object.
        #
        # ==== Parameters
        #
        # response<Episodic::Platform::HTTPResponse>:: The response from an episodes request
        #
        # ==== Returns
        #
        # ::Episodic::Platform::EpisodesResponse:: The parsed response.
        #
        def parse_episodes_response response
          return ::Episodic::Platform::EpisodesResponse.new(response, {"ForceArray" => ["episode", "thumbnail", "player", "download", "field", "playlist"]})
        end
        
        #
        # Method factored out to make unit testing easier.  This method simply creates the <tt>::Episodic::Platform::ShowsResponse</tt>
        # object.
        #
        # ==== Parameters
        #
        # response<Episodic::Platform::HTTPResponse>:: The response from a shows request
        #
        # ==== Returns
        #
        # ::Episodic::Platform::EpisodesResponse:: The parsed response.
        #
        def parse_shows_response response
          return ::Episodic::Platform::ShowsResponse.new(response, {"ForceArray" => ["show", "thumbnail", "player"]})
        end
        
        #
        # Method factored out to make unit testing easier.  This method simply creates the <tt>::Episodic::Platform::PlaylistsResponse</tt>
        # object.
        #
        # ==== Parameters
        #
        # response<Episodic::Platform::HTTPResponse>:: The response from a playlists request
        #
        # ==== Returns
        #
        # ::Episodic::Platform::EpisodesResponse:: The parsed response.
        #
        def parse_playlists_response response
          return ::Episodic::Platform::PlaylistsResponse.new(response, {"ForceArray" => ["playlist", "thumbnail", "player", "field", "episode"]})
        end
        
      end  
    end
    
    #
    # Extends <tt>Episodic::Platform::CollectionResponse</tt> to handle a collection of shows in the response.
    #
    class ShowsResponse < CollectionResponse
      
      #
      # Get the list of shows from the response.  
      #
      # ==== Returns
      #
      # Array:: An array of <tt>Episodic::Platform::ShowItem</tt> objects.
      #
      def shows
        @show_items ||= @parsed_body["show"].collect {|e| ShowItem.new(e)}
        return @show_items
      end
      
    end
    
    #
    # Extends <tt>Episodic::Platform::CollectionResponse</tt> to handle a collection of episodes in the response.
    #
    class EpisodesResponse < CollectionResponse
      
      #
      # Get the list of episodes from the response.  
      #
      # ==== Returns
      #
      # Array:: An array of <tt>Episodic::Platform::EpisodeItem</tt> objects.
      #
      def episodes
        @episode_items ||= @parsed_body["episode"].collect {|e| EpisodeItem.new(e)}
        return @episode_items
      end
      
    end
    
    #
    # Extends <tt>Episodic::Platform::CollectionResponse</tt> to handle a collection of playlists in the response.
    #
    class PlaylistsResponse < CollectionResponse
      
      #
      # Get the list of playlists from the response.  
      #
      # ==== Returns
      #
      # Array:: An array of <tt>Episodic::Platform::EpisodeItem</tt> objects.
      #
      def playlists
        @playlist_items ||= @parsed_body["playlist"].collect {|e| PlaylistItem.new(e)}
        return @playlist_items
      end
      
    end
    
    #
    # Base class for parsed items from a query response.
    #
    class Item
      
      #
      # Constructor
      #
      # ==== Parameters
      #
      # item<Hash>:: The parsed item in the response.  This may be a show, episode or playlist item.
      #
      def initialize(item)
        super()
        @item = item
      end
      
      #
      # Explcitly declare to avoid <tt>warning: Object#id will be deprecated; use Object#object_id</tt>.
      #
      # ==== Parameters
      #
      # String:: The id of the item.
      #
      def id
        return @item["id"]  
      end
      
      #
      # When requesting specific items in a query it may be the case that the item specified could not
      # be found.  In this case the XML returned looks something like the following for the item:
      #
      #    <id>adfadsfasdf</id>
      #    <error>
      #      <code>6</code>
      #      <message>Show not found</message>
      #    </error>
      #
      # Therefore, this method allows the caller to check if the item actually exists before trying to pull
      # out other properties that will result in an exception.  You really only need to use this method when
      # you make a query request with IDs specified.
      #
      # ==== Returns
      #
      # Boolean:: <tt>true</tt> if the item was found and requests for other attributes will succeed.
      #
      def exists?
        return @item["error"].nil?  
      end
      
      #
      # Gets the list of thumbnails for this item.
      #
      # ==== Returns
      #
      # Array:: An array of <tt>Episodic::Platform::ThumbnailItem</tt> objects.
      #
      def thumbnails
        @thumbnails ||= nested_items("thumbnails", "thumbnail", ThumbnailItem)
        return @thumbnails
      end
      
      #
      # Gets the list of players for this item.
      #
      # ==== Returns
      #
      # Array:: An array of <tt>Episodic::Platform::PlayerItem</tt> objects.
      #
      def players
        @players ||= nested_items("players", "player", PlayerItem)
        return @players
      end
      
      #
      # Overridden to pull properties from the item.
      #
      def method_missing(method_sym, *arguments, &block)
        method_name = method_sym.to_s
        
        value = @item[method_name]
        
        # Dates are always in UTC
        if (value && date_fields.include?(method_sym))
          return value.empty? ? nil : Time.parse("#{value} +0000")
        elsif (value && boolean_fields.include?(method_sym))
          return @item[method_sym.to_s] == "true"
        elsif (value && integer_fields.include?(method_sym))
          return value.empty? ? nil : value.to_i
        end
        
        return value && value.empty? ? nil : value
      end
      
      #
      # Always return <tt>true</tt>.
      #
      def respond_to?(symbol, include_private = false)
        return true
      end
      
      protected
      
      #
      # Helper method to pull out nested items.
      #
      # ==== Parameters
      #
      # group_name<String>:: This is something like "episodes".
      # element_name<String>:: This is something like "episode".
      # clazz<Class>:: This is the class of the item to create (i.e. EpisodeItem)
      #
      # ==== Returns
      #
      # Array:: An array of items of type <tt>clazz</tt>
      #
      def nested_items group_name, element_name, clazz
        if (@item[group_name] && @item[group_name][element_name])
          return @item[group_name][element_name].collect {|v| clazz.new(v)}
        else
          return []
        end        
      end 
      
      #
      # Should be overridden by subclasses to provide a list of fields that should
      # be converted to a <tt>Time</tt> object.
      #
      # ==== Returns
      #
      # Array:: A list of field names as symbols.
      #
      def date_fields
        return []
      end
      
      #
      # Should be overridden by subclasses to provide a list of fields that should
      # be converted to a <tt>Boolean</tt> object.
      #
      # ==== Returns
      #
      # Array:: A list of field names as symbols.
      #
      def boolean_fields
        return []
      end
      
      #
      # Should be overridden by subclasses to provide a list of fields that should
      # be converted to a <tt>Integer</tt> object.
      #
      # ==== Returns
      #
      # Array:: A list of field names as symbols.
      #      
      def integer_fields
        return []
      end
    end
    
    #
    # Represents a show from a list of shows returned from a call to <tt>Episodic::Platform::QueryMethods.shows</tt>.
    #
    class ShowItem < Item     
    end
    
    #
    # Represents a episode from a list of episodes returned from a call to <tt>Episodic::Platform::QueryMethods.episodes</tt>.
    #
    class EpisodeItem < Item
      
      #
      # Gets the list of downloads for this item.
      #
      # ==== Returns
      #
      # Array:: An array of <tt>Episodic::Platform::DownloadItem</tt> objects.
      #
      def downloads
        @downloads ||= nested_items("downloads", "download", DownloadItem)
        return @downloads
      end
      
      #
      # Gets the list of custom fields for this item.
      #
      # ==== Returns
      #
      # Array:: An array of <tt>Episodic::Platform::CustomItem</tt> objects.
      #
      def custom_fields
        @custom_fields ||= nested_items("custom_fields", "field", CustomFieldItem)
        return @custom_fields
      end
      
      #
      # Gets the list of playlists for this item.
      #
      # ==== Returns
      #
      # Array:: An array of <tt>Episodic::Platform::EpisodePlaylistItem</tt> objects.
      #
      def playlists
        @playlists ||= nested_items("playlists", "playlist", EpisodePlaylistItem)
        return @playlists
      end
      
      #
      # Provides a list of fields that are actually dates.
      #
      # ==== Returns
      #
      # Array:: A list of field names as symbols.
      #
      def date_fields
        return [:air_date, :off_air_date]
      end
      
    end
    
    #
    # Represents a playlist from a list of playlists returned from a call to <tt>Episodic::Platform::QueryMethods.playlists</tt>.
    #
    class PlaylistItem < Item     
      
      #
      # Gets the list of custom fields for this item.
      #
      # ==== Returns
      #
      # Array:: An array of <tt>Episodic::Platform::CustomItem</tt> objects.
      #
      def custom_fields
        @custom_fields ||= nested_items("custom_fields", "field", CustomFieldItem)
        return @custom_fields
      end
      
      #
      # Gets the list of episodes for this item.
      #
      # ==== Returns
      #
      # Array:: An array of <tt>Episodic::Platform::PlaylistEpisodeItem</tt> objects.
      #
      def episodes
        @episodes ||= nested_items("episodes", "episode", PlaylistEpisodeItem)
        return @episodes
      end
      
      #
      # Provides a list of fields that are actually dates.
      #
      # ==== Returns
      #
      # Array:: A list of field names as symbols.
      #
      def date_fields
        return [:created_at]
      end      
    end
    
    #
    # Represents a thumbnail element in a response.
    #
    class ThumbnailItem < Item
      
      #
      # Since the URL is stored in the element content we need to explicitly define
      # this method to get the URL for a thumbnail.
      #
      # ==== Returns
      #
      # String:: The URL to the thumbnail.
      #
      def url
        return @item["content"]
      end
      
    end
    
    #
    # Represents a player element in a response.
    #
    class PlayerItem < Item
      
      #
      # Provides a list of fields that are actually dates.
      #
      # ==== Returns
      #
      # Array:: A list of field names as symbols.
      #
      def boolean_fields
        return [:default]
      end
      
    end
    
    #
    # Represents a download element in a response.
    #
    class DownloadItem < Item
      
      #
      # Get the url for the downloadable file.
      #
      # ==== Returns
      #
      # String:: The URL
      #
      def url
        return @item["url"].first
      end
      
    end
    
    #
    # Represents a playlist element in an episodes response.
    #    
    class EpisodePlaylistItem < Item
      
      #
      # Provides a list of fields that are actually integers.
      #
      # ==== Returns
      #
      # Array:: A list of field names as symbols.
      #
      def integer_fields
        return [:position]
      end
      
    end
    
    #
    # Represents an episode element in a playlist response.
    #    
    class PlaylistEpisodeItem < Item
      
      #
      # Provides a list of fields that are actually integers.
      #
      # ==== Returns
      #
      # Array:: A list of field names as symbols.
      #
      def integer_fields
        return [:position]
      end
      
    end    
    
    #
    # Represents a custom field element returned from an episodes or playlists request.
    #
    class CustomFieldItem < Item
      
      #
      # Get the values for this field.  Values are always returned as strings except when
      # the type is <tt>external_select</tt> then it is an array or two element arrays with the
      # external id and external value respectively.
      #
      # ==== Returns
      # 
      # Array:: In most cases this will be a single element array.
      #
      def values
        
        if (@values.nil?)
          @values = []
          _values = @item["value"]  
          unless (_values.is_a?(Array))
            _values = [_values]
          end
          _values.compact.each do |v|
            if (v.is_a?(Hash))
              @values << [v["id"].strip, v["content"].strip]
            else
              @values << v.strip
            end
          end
        end
        
        return @values
      end
      
      #
      # Explicitly declare to avoid <tt>warning: Object#type is deprecated; use Object#class</tt>.
      #
      def type
        return @item["type"]
      end
      
      #
      # Provides a list of fields that are actually integers.
      #
      # ==== Returns
      #
      # Array:: A list of field names as symbols.
      #
      def integer_fields
        return [:position]
      end
      
      #
      # Provides a list of fields that are actually dates.
      #
      # ==== Returns
      #
      # Array:: A list of field names as symbols.
      #
      def boolean_fields
        return [:required]
      end
    end
  end
  
end
