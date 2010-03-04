require File.dirname(__FILE__) + '/test_helper.rb'

class TestQueryResponses < Test::Unit::TestCase #:nodoc:
  
  def test_episodes_response
    response_xml = File.open(File.dirname(__FILE__) + "/fixtures/episodes-summary-report-response.xml") {|f|f.read}
    
    response = ::Episodic::Platform::AnalyticsMethods.send(:parse_token_response, Episodic::Platform::HTTPResponse.new(200, response_xml))
    
    assert response.token
    
  end
  
end
