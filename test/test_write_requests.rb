require File.dirname(__FILE__) + '/test_helper.rb'

class TestWriteRequests < Test::Unit::TestCase #:nodoc:

  def setup
    ::Episodic::Platform::Base.establish_connection!(TEST_API_KEY, TEST_SECRET_KEY, :api_host => TEST_HOST)  
  end
  
  def test_create_playlist
    custom_fields = {
      "text field" => "foo",
      "date field" => Time.now,
      "External Select Field" => {
        "id1" => "val1",
        "id2" => "val2"
      }
    }
    response = ::Episodic::Platform::WriteMethods.create_playlist("p7kpeeqkh2pt", "My Manual Playlist #{Time.now.to_i}", {"episode_ids" => ["ozv6spajltkx", "oz049unr3jep"], "custom_fields" => custom_fields})
    
    assert response.playlist_id
   
 end
 
  def test_update_playlist
    custom_fields = {
      "text field" => "bar"
    }
    response = ::Episodic::Platform::WriteMethods.update_playlist("p32khwxhm6m9", {"name" => "My Manual Playlist #{Time.now.to_i}", "episode_ids" => ["ozv6spajltkx"], "custom_fields" => custom_fields, "replace_episodes" => true})
    
    assert response.playlist_id
   
  end
  
  def test_create_asset
    response = ::Episodic::Platform::WriteMethods.create_asset("5", "My New Asset #{Time.now.to_i}", File.dirname(__FILE__) + "/fixtures/1-0.mp4")
    
    assert response.asset_id
  end
  
  def test_create_update_episode
    
    # Use the API test account for this test
    Episodic::Platform::Base.establish_connection!(TEST_API_KEY, TEST_SECRET_KEY, :api_host => TEST_HOST)
    
    response = ::Episodic::Platform::WriteMethods.create_episode("p7kpeeqkh2pt", "My Episode #{Time.now}", {:upload_types => "s3", :video_filename => "1-0.mp4", :thumbnail_filename => "thumb.png"})
    
    episode_id = response.episode_id
    assert episode_id
    assert ::Episodic::Platform::WriteMethods.upload_file_for_episode(response.upload_for_filepath(File.dirname(__FILE__) + "/fixtures/1-0.mp4"))
    assert ::Episodic::Platform::WriteMethods.upload_file_for_episode(response.upload_for_filepath(File.dirname(__FILE__) + "/fixtures/thumb.png"))
    
    # Now update the video on the episode
    response = ::Episodic::Platform::WriteMethods.update_episode(episode_id, {:upload_types => "s3", :video_filename => "3-0.m4v", :off_air_date => Time.now.to_i})
    assert ::Episodic::Platform::WriteMethods.upload_file_for_episode(response.upload_for_filepath(File.dirname(__FILE__) + "/fixtures/3-0.m4v"))
  end
end
