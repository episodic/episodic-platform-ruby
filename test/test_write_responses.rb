require File.dirname(__FILE__) + '/test_helper.rb'

class TestWriteResponses < Test::Unit::TestCase #:nodoc:
  
  def test_create_episode_response_s3
    response_xml = File.open(File.dirname(__FILE__) + "/fixtures/create-episode-response-s3.xml") {|f|f.read}
    
    response = ::Episodic::Platform::CreateEpisodeResponse.new(Episodic::Platform::HTTPResponse.new(200, response_xml))
    
    assert_equal "p3h7kldgjg1t", response.episode_id
    assert_equal "1-0.mp4", response.uploads.first.filename
    assert_equal "http://randy.dev.assets.episodic.com.s3.amazonaws.com/", response.uploads.first.url
    assert 5, response.uploads.first.params.length
  end
  
  def test_create_episode_response
    response_xml = File.open(File.dirname(__FILE__) + "/fixtures/create-episode-response.xml") {|f|f.read}
    
    response = ::Episodic::Platform::CreateEpisodeResponse.new(Episodic::Platform::HTTPResponse.new(200, response_xml))
    
    assert_equal "p3h7kldgjg1t", response.episode_id
    assert_equal 0, response.uploads.length
  end
end
