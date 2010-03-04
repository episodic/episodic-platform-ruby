module Episodic #:nodoc:
  
  module Platform
    
    #
    # Class for making requests against the Episodic Platform Write API.
    #
    class WriteMethods < Base 
      
      class << self
        
        #
        # The Create Asset method is used to upload a new video or image asset for use in one of your shows.
        #
        # NOTE: This method of uploading has been deprecated.  The preferred method is to call 
        # <tt>Episodic::Platform::create_episode</tt> or <tt>Episodic::Platform::update_episode</tt>
        # with <tt>upload_types</tt> specified.  
        #
        # You may still use this method but we will limit your usage to 5 assets a day.
        #
        # ==== Parameters
        #
        # show_id<String>:: The ID of the show to create the asset in.
        # name<String>:: The name of the new asset. This value must be less than 255 characters. 
        # filename<String>:: The full path to the file on the file system.  This is the image or video.
        #
        # ==== Returns
        #
        # Episodic::Platform::WriteResponse:: The parsed response.
        #
        def create_asset show_id, name, filename
          params = {}
          
          # Add the required fields
          params[:show_id] = show_id
          params[:name] = name
          
          response = connection.do_post(construct_url("write", "create_asset"), params, {"uploaded_data" => filename})
          
          return Episodic::Platform::WriteResponse.new(response)         
        end
        
        #
        # Creates an episode in the Episodic System in the specified show.  This method will 
        # return the information needed to upload the video file for this episode.  If you are 
        # adding a file to the episode then the <tt>upload_file_for_episode</tt> must be called 
        # immediately after this method. For example, 
        #
        #   ::Episodic::Platform::WriteMethods.create_episode("oz04s1q0i29t", "My Episode", {:upload_types => "s3", :video_filename => "1-0.mp4"})  
        #   ::Episodic::Platform::WriteMethods.upload_file_for_episode(response.upload_for_filepath("/path/to/file/1-0.mp4"))
        #
        # The last parameter to this method is a list of optional attributes.  Acceptable 
        # options are:
        #   air_date - Setting this date in the future will tell the Episodic Platform to publish 
        #       the episode but not make it available in playlists until this date has passed. 
        #       This defaults to now if not provided.
        #   custom_fields- If you have set up custom metadata fields on the show that you are 
        #       creating the episode in you can also assign values to those fields by passing 
        #       in a Hash of name/value pairs where the name is the name of your custom field.  
        #       In the case that the field you are trying to set is a external select field then 
        #       the value should be a Hash mapping ids to display values. 
        #   description - A string value to be used as the description for the episode. 
        #       Descriptions must be less than 255 characters
        #   off_air_date - When this date is reached the episode will be removed from all 
        #       playlists. This defaults to indefinite if not provided.
        #   publish - This must either <tt>true</tt> or <tt>false</tt> to indicate whether the 
        #       episode should be submitted for publishing.  The default is <tt>false</tt>. 
        #   publish_format_ids - Publishing resolutions and bitrates defaults are set on the 
        #       containing show but can be overridden on the episode.  If you wish to override the 
        #       defaults, this value should be an Array of publishing profile ids. 
        #   tags - A comma delimitted list of tags for the new episode.
        #   upload_types - This is only used when there is a 'video_filename' and/or 'thumbnail_filename' included. 
        #       The caller may pass in a single value or a comma delimited list.  However, it is important to note that your 
        #       network must support the one of specified upload types or the call will fail.  Currently, the only valid value
        #       is 's3'.
        #   asset_ids - The list of assets in the order they are to appear in the episode.  Ingored if the upload_types and 
        #       asset_filename parameters are not blank.
        #   thumbnail_id - The id of the thumbnail to set on the episode.  Ignored if the upload_types and thumbnail_filename parameters
        #       are not blank.
        #   video_filename - If an upload_type is specified this is the name of the file that will be uploaded and made the single video for
        #       the episode.
        #   thumbnail_filename - If an upload_type is specified this is the name of the file that will be uploaded and made the thumbnail
        #       for the episode.
        #   ping_url - The URL the Episodic system will issue a GET request against to notify you 
        #       that publishing has completed.  The ping URL should accept two parameters: the 
        #       episode id and a status which will be one of 'success' or 'failure'.
        #
        # ==== Parameters
        #
        # show_id<String>:: The ID of the show to create the episode in.
        # name<String>:: The name of the episode.  This must be unique across your show.
        # options<Hash>:: A hash of optional attributes.
        #
        # ==== Returns
        #
        # Episodic::Platform::CreateUpdateEpisodeResponse:: An object that contains the XML response as well as some 
        #    helper methods including <tt>upload_for_filepath</tt> to be used when calling 
        #    <tt>Episodic::Platform::WriteMethods.upload_file_for_episode</tt>.
        #
        def create_episode(show_id, name, options = {})
          
          # Clone the options into our params hash
          params = options.clone
          
          # Add the required fields
          params[:show_id] = show_id
          params[:name] = name
          
          response = connection.do_post(construct_url("write", "create_episode"), params)
          
          return Episodic::Platform::CreateUpdateEpisodeResponse.new(response)
          
        end 
        
        #
        # Creates a manual playlist in the Episodic System in the specified show.    
        #
        # The last parameter to this method is a list of optional attributes.  Acceptable 
        # options are:
        #   description - A string value to be used as the description for the playlist. 
        #       Descriptions must be less than 255 characters
        #   episode_ids - An array or list of comma separated valid episode ids in the order 
        #       they should appear in the playlist. 
        #   behavior - Indicates what the player should do when an episode in the playlist finishes. 
        #       Valid values are '0' (display a list of other episodes in the playlist), 
        #       '1' (start playing the next episode immediately) or '2' (display the list 
        #       but start playing after 'auto_play_delay' seconds). The default is '0'. 
        #   auto_play_delay - If the 'behavior' value is '2' then this is the number of seconds 
        #       to wait until the next episode is played. The default is 5.  
        #   custom_fields - If you have set up custom metadata fields on the show that you are 
        #       creating the playlist in you can also assign values to those fields by passing 
        #       in a Hash of name/value pairs where the name is the name of your custom field.  
        #       In the case that the field you are trying to set is a external select field then 
        #       the value should be a Hash mapping ids to display values.
        #   upload_types - The caller may pass in a single value or a comma delimited list.  However, 
        #       it is important to note that your network must support the one of specified upload 
        #       types or the call will fail.  Currently, the only valid value is 's3'.  
        #   video_filename - If an upload_type is specified this is the name of the file that will be 
        #       uploaded and made the single video for the episode.
        #   thumbnail_filename - If an upload_type is specified this is the name of the file that will 
        #       be uploaded and made the thumbnail for the episode.
        #
        # ==== Parameters
        #
        # show_id<String>:: The ID of the show to create the playlist in.
        # name<String>:: The name of the playlist.  This must be unique across your show.
        # options<Hash>:: A hash of optional attributes.
        #
        # ==== Returns
        #
        # Episodic::Platform::WriteResponse:: The parsed response.
        #
        def create_playlist show_id, name, options = {}
          
          # Clone the options into our params hash
          params = options.clone
          
          # Add the required fields
          params[:show_id] = show_id
          params[:name] = name
          
          response = connection.do_post(construct_url("write", "create_playlist"), params)
          
          return Episodic::Platform::WriteResponse.new(response)
        end
        
        #
        # Updates an episode in the Episodic System.  This method will 
        # return the information needed to upload the video file for this episode.  If you are 
        # adding a file to the episode then the <tt>upload_file_for_episode</tt> must be called 
        # immediately after this method. For example, 
        #
        #   ::Episodic::Platform::WriteMethods.update_episode("jz54h6q0i39y", {:upload_types => "s3", :thumbnail_filename => "my_thumb.jpg"})  
        #   ::Episodic::Platform::WriteMethods.upload_file_for_episode(response.upload_for_filepath("/path/to/file/my_thumb.jpg"))
        #
        # The last parameter to this method is a list of optional attributes.  Acceptable 
        # options are:
        #   air_date - Setting this date in the future will tell the Episodic Platform to publish 
        #       the episode but not make it available in playlists until this date has passed. 
        #       This defaults to now if not provided.
        #   custom_fields- If you have set up custom metadata fields on the show that you are 
        #       creating the episode in you can also assign values to those fields by passing 
        #       in a Hash of name/value pairs where the name is the name of your custom field.  
        #       In the case that the field you are trying to set is a external select field then 
        #       the value should be a Hash mapping ids to display values. 
        #   description - A string value to be used as the description for the episode. 
        #       Descriptions must be less than 255 characters
        #   off_air_date - When this date is reached the episode will be removed from all 
        #       playlists. This defaults to indefinite if not provided.
        #   publish_format_ids - Publishing resolutions and bitrates defaults are set on the 
        #       containing show but can be overridden on the episode.  If you wish to override the 
        #       defaults, this value should be an Array of publishing profile ids. 
        #   tags - A comma delimitted list of tags for the new episode.
        #   upload_types - This is only used when there is a 'video_filename' and/or 'thumbnail_filename' included. 
        #       The caller may pass in a single value or a comma delimited list.  However, it is important to note that your 
        #       network must support the one of specified upload types or the call will fail.  Currently, the only valid value
        #       is 's3'.
        #   thumbnail_id - The id of the thumbnail to set on the episode.  Ignored if the upload_types and thumbnail_filename parameters
        #       are not blank.
        #   video_filename - If an upload_type is specified this is the name of the file that will be uploaded and made the single video for
        #       the episode.
        #   thumbnail_filename - If an upload_type is specified this is the name of the file that will be uploaded and made the thumbnail
        #       for the episode.
        #
        # ==== Parameters
        #
        # id<String>:: The ID of the episode to update.
        # options<Hash>:: A hash of optional attributes.
        #
        # ==== Returns
        #
        # Episodic::Platform::CreateUpdateEpisodeResponse:: An object that contains the XML response as well as some 
        #    helper methods including <tt>upload_for_filepath</tt> to be used when calling 
        #    <tt>Episodic::Platform::WriteMethods.upload_file_for_episode</tt>.
        #
        def update_episode(id, options = {})
          
          # Clone the options into our params hash
          params = options.clone
          
          # Add the required fields
          params[:id] = id
          
          response = connection.do_post(construct_url("write", "update_episode"), params)
          
          return Episodic::Platform::CreateUpdateEpisodeResponse.new(response)
          
        end 
        
        #
        # Updates a manual playlist in the Episodic System with the specified ID.    
        #
        # The last parameter to this method is a list of optional attributes.  Acceptable 
        # options are:
        #   name - The name of the playlist. his must be unique across your show.
        #   description - A string value to be used as the description for the playlist. 
        #       Descriptions must be less than 255 characters
        #   episode_ids - An array or list of comma separated valid episode ids in the order 
        #       they should appear in the playlist. 
        #   replace_episodes - Indicates if the existing episodes should be replaced by the new 
        #       ones or added to. The default is 'false'. 
        #   behavior - Indicates what the player should do when an episode in the playlist finishes. 
        #       Valid values are '0' (display a list of other episodes in the playlist), 
        #       '1' (start playing the next episode immediately) or '2' (display the list 
        #       but start playing after 'auto_play_delay' seconds). The default is '0'. 
        #   auto_play_delay - If the 'behavior' value is '2' then this is the number of seconds 
        #       to wait until the next episode is played. The default is 5.  
        #   custom_fields - If you have set up custom metadata fields on the show that you are 
        #       creating the playlist in you can also assign values to those fields by passing 
        #       in a Hash of name/value pairs where the name is the name of your custom field.  
        #       In the case that the field you are trying to set is a external select field then 
        #       the value should be a Hash mapping ids to display values.
        #
        # ==== Parameters
        #
        # id<String>:: The ID of the playlist to update.
        # options<Hash>:: A hash of optional attributes.
        #
        # ==== Returns
        #
        # Episodic::Platform::WriteResponse:: The parsed response.
        #        
        def update_playlist id, options = {}
          # Clone the options into our params hash
          params = options.clone
          
          # Add the required fields
          params[:id] = id
          
          response = connection.do_post(construct_url("write", "update_playlist"), params)
          
          return Episodic::Platform::WriteResponse.new(response)          
        end
        
        #
        # Uploads the video and/or images to the Episodic System.  This method requires that you first called <tt>create_episode</tt> or
        # <tt>update_episode</tt> since the second parameter passed to this method is returned from
        # one of those method calls.
        #
        # ==== Parameters
        #
        # pending_upload<Hash>:: This is the result of the call to <tt>upload_for_filepath</tt> 
        #    on the object returned from <tt>create_episode</tt> or <tt>update_episode_video</tt>.
        #
        # ==== Returns
        #
        # Boolean:: <tt>true</tt> if the upload was successful.  Otherwise, this will raise an exception
        #
        def upload_file_for_episode(pending_upload)
          
          c = Curl::Easy.new(pending_upload[:upload].url)  
          c.multipart_form_post = true
          
          fields = []
          pending_upload[:upload].params.each_pair do |key, value|
            fields << Curl::PostField.content(key, value)
          end
          
          fields << Curl::PostField.file("file", pending_upload[:filepath])
          
          begin
            c.http_post(*fields)
            raise ::Episodic::Platform::FileUploadFailed.new("Status #{c.response_code} returned from file upload request") if c.response_code > 399
            return true
          rescue Curl::Err::CurlError  => e
            raise ::Episodic::Platform::FileUploadFailed.new(e.message)
          end
        end
        
        protected
        
        #
        # Method factored out to make unit testing easier.  This method simply creates the <tt>::Episodic::Platform::WriteResponse</tt>
        # object.
        #
        # ==== Parameters
        #
        # response<Episodic::Platform::HTTPResponse>:: The response from any create request (i.e. create_episode, create_playlist, etc)
        #
        # ==== Returns
        #
        # ::Episodic::Platform::WriteResponse:: The parsed response.
        #
        def parse_create_response response
          return ::Episodic::Platform::EpisodesResponse.new(response)
        end
      end
    end
    
    #
    # All write methods have a similar response structure.  This class extends <tt>Episodic::Platform::Response</tt>
    # and adds a method to get the id of the created/updated object ('playlist_id', 'episode_id', etc).
    #
    class WriteResponse < Response
      
      #
      # Constructor
      #
      # ==== Parameters
      #
      # response<Episodic::Platform::HTTPResponse>:: The response object returned from an Episodic Platform API request.
      # xml_options<Hash>:: A set of options used by XmlSimple when parsing the response body
      #
      def initialize response, xml_options = {"ForceArray" => false}
        super(response, xml_options)
      end
      
      #
      # Override to just check for the value in the attributes
      #
      def method_missing(method_sym, *arguments, &block)
        return @parsed_body[method_sym.to_s]
      end
      
      #
      # Always return true.
      #
      def respond_to?(symbol, include_private = false)
        return true
      end
    end
    
    #
    # Extends <tt>Episodic::Platform::WriteResponse</tt> to add methods for getting upload
    # information.
    #
    class CreateUpdateEpisodeResponse < WriteResponse
      
      #
      # Override to define array elements.
      #
      # ==== Parameters
      #
      # response<Episodic::Platform::HTTPResponse>:: The response object returned from an Episodic Platform API request.
      #
      def initialize(response)
        super(response, "ForceArray" => ["upload"])
      end
      
      #
      # Get the array of <tt>Upload</tt> objects that represent the pending uploads
      #
      # ==== Returns
      #
      # Array:: An array of <tt>Upload</tt> objects
      #
      def uploads
        unless @uploads
          @uploads = []
          @parsed_body["upload"].each do |upload|
            @uploads << Upload.new(upload) 
          end unless @parsed_body["upload"].nil?
        end
        
        return @uploads
      end
      
      #
      # Get the pending upload information for a specific file expressed by file path.
      # The object returned from this method can be passed to <tt>Episodic::Platform::WriteMethods.upload_file_for_episode</tt>.
      #
      # ==== Parameters
      #
      # filepath<String>:: The path to the file to be uploaded.
      #
      # ==== Returns
      #
      # Hash:: A hash with the filepath (passed in) and the corresponding upload params
      #
      def upload_for_filepath filepath 
        filename = File.basename(filepath)
        
        upload = uploads.detect{|u| u.filename == filename}
        
        return upload ? {:filepath => filepath, :upload => upload} : nil
      end
    end
    
    #
    # Represents a pending upload.  This includes the URL, filename as well as 
    # a list of params to be included in the POST.
    #
    class Upload
      
      attr_reader :filename, :url, :params
      
      #
      # Constructor
      #
      # ==== Parameters
      #   
      # upload<Hash>:: A hash for an upload element in the response.
      #
      def initialize(upload)
        @filename = upload["filename"]
        @url = upload["url"]
        @params = {}
        upload["param"].each do |param|
          @params[param["name"]] = param["content"]
        end
      end
    end
    
  end
  
end
