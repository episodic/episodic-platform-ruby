module Episodic #:nodoc:
  
  module Platform
    
    #
    # Class for making requests against the Episodic Platform Analytics API.
    #
    class AnalyticsMethods < Base 
      
      class << self
        
        #
        # Fetches a previously generated report.
        #
        # ==== Parameters
        #
        # report_token<String>:: This is the value returned from one of the report generation methods.
        #
        # ==== Returns
        #
        # String:: The contents of the report.
        #
        def get_report token
          params = {
            :report_token => token,
          }
          
          response = connection.do_get(construct_url("analytics", "get_report"), params)
          
          return response.body
        end
        
        #
        # Generates a report for all episodes in a show. The report will contain information such as 
        # the total views, complete views, downloads, etc for each episode in the show.
        #
        # It is important to note that this method just generates the report and returns a token
        # that can be used to get the report by calling <tt>Episodic::Platform::AnalyticsMethods.get_report</tt>.
        #
        # ==== Parameters
        #
        # show_id<String>:: The id of the show that contains your episodes.  To get a list of your 
        #    shows see <tt>Episodic::Platform::QueryMethods.show</tt>. 
        # date_range<String>:: Specifies period of your report. The value of this parameter must be one 
        #    of 'today', 'last_seven', 'last_thirty'.
        # date_grouping<String>:: Must be one of 'daily' or 'aggregate' to list the data by day or just a total 
        #    for the entire period respectively.
        # format<String>:: The format parameter is required and must be one of 'csv' or 'xml'.
        #
        # ==== Returns
        #
        # Episodic::Platform::TokenResponse:: This response object includes a token that can be used to 
        #    actually get the report by calling <tt>Episodic::Platform::AnalyticsMethods.get_report</tt>.
        #
        def episodes_summary_report show_id, date_range, date_grouping, format
          
          params = {
            :show_id => show_id,
            :date_range => date_range,
            :date_grouping => date_grouping,
            :format => format
          }
          
          response = connection.do_get(construct_url("analytics", "request_episodes_summary_report"), params)
          
          # Convert to a hash
          return parse_token_response(response)
        end

        #
        # Generates a report for a specific episode in a show. The report will contain information 
        # such as the total views, complete views, downloads, etc for each episode in the show. 
        #
        # It is important to note that this method just generates the report and returns a token
        # that can be used to get the report by calling <tt>Episodic::Platform::AnalyticsMethods.get_report</tt>.
        #
        # ==== Parameters
        #
        # show_id<String>:: The id of the show that contains your episodes.  To get a list of your 
        #    shows see <tt>Episodic::Platform::QueryMethods.show</tt>. 
        # episode_id<String>:: The id of the episodes to generate the report for.  To get a list of your
        #    episodes see <tt>Episodic::Platform::QueryMethods.episodes</tt>.
        # date_range<String>:: Specifies period of your report. The value of this parameter must be one 
        #    of 'today', 'last_seven', 'last_thirty'.
        # format<String>:: The format parameter is required and must be one of 'csv' or 'xml'.
        #
        # ==== Returns
        #
        # Episodic::Platform::TokenResponse:: This response object includes a token that can be used to 
        #    actually get the report by calling <tt>Episodic::Platform::AnalyticsMethods.get_report</tt>.
        #
        def episode_daily_report show_id, episode_id, date_range, format
          
          params = {
            :show_id => show_id,
            :date_range => date_range,
            :id => episode_id,
            :format => format
          }
          
          response = connection.do_get(construct_url("analytics", "request_episode_daily_report"), params)
          
          # Convert to a hash
          return parse_token_response(response)
        end

        #
        # Generates a report for all campaigns in a specific show. The report will contain information 
        # such as the total views, complete views, downloads, click throughs, etc for each campaign in the show. 
        #
        # It is important to note that this method just generates the report and returns a token
        # that can be used to get the report by calling <tt>Episodic::Platform::AnalyticsMethods.get_report</tt>.
        #
        # ==== Parameters
        #
        # show_id<String>:: The id of the show that contains your campaigns.  To get a list of your 
        #    shows see <tt>Episodic::Platform::QueryMethods.show</tt>. 
        # date_range<String>:: Specifies period of your report. The value of this parameter must be one 
        #    of 'today', 'last_seven', 'last_thirty'.
        # format<String>:: The format parameter is required and must be one of 'csv' or 'xml'.
        #
        # ==== Returns
        #
        # Episodic::Platform::TokenResponse:: This response object includes a token that can be used to 
        #    actually get the report by calling <tt>Episodic::Platform::AnalyticsMethods.get_report</tt>.
        #
        def campaigns_daily_report show_id, date_range, format
          
          params = {
            :show_id => show_id,
            :date_range => date_range,
            :format => format
          }
          
          response = connection.do_get(construct_url("analytics", "request_campaigns_daily_report"), params)
          
          # Convert to a hash
          return parse_token_response(response)
        end
        
        protected
        
        #
        # Method factored out to make unit testing easier.  This method simply creates the <tt>::Episodic::Platform::TokenResponse</tt>
        # object.
        #
        # ==== Parameters
        #
        # response<Episodic::Platform::HTTPResponse>:: The response from any token request
        #
        # ==== Returns
        #
        # ::Episodic::Platform::TokenResponse:: The parsed response.
        #
        def parse_token_response response
          return TokenResponse.new(response)
        end
      end
    end
    
    #
    # All token request methods have a similar response structure.  This class extends <tt>Episodic::Platform::Response</tt>
    # and adds a method to get the token of the generated report.
    #
    class TokenResponse < Response
      
      #
      # Constructor
      #
      # ==== Parameters
      #
      # response<Episodic::Platform::HTTPResponse>:: The response object returned from an Episodic Platform API request.
      #
      def initialize response
        super(response, "ForceArray" => false)
      end
      
      #
      # Get the token used to request the generated report.  This token is passed to 
      # <tt>Episodic::Platform::AnalyticsMethods.get_report</tt>.
      #
      def token
        return @parsed_body["report_token"]
      end
      
    end
    
  end
  
end
