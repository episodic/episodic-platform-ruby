require File.dirname(__FILE__) + '/test_helper.rb'

class TestQueryRequests < Test::Unit::TestCase #:nodoc:

  def setup
    ::Episodic::Platform::Base.establish_connection!(TEST_API_KEY, TEST_SECRET_KEY, :api_host => TEST_HOST)  
  end
  
  def test_episodes
    episode_response = ::Episodic::Platform::QueryMethods.episodes()
    
    assert episode_response.total > 0
    assert_equal 1, episode_response.page
    assert_equal episode_response.total, episode_response.episodes.length

    episodes = episode_response.episodes
    assert episodes.first.thumbnails
    assert episodes.first.players
    assert episodes.first.downloads
  end
  
  def test_playlists
    response = ::Episodic::Platform::QueryMethods.playlists()
    
    puts response.xml
    
    assert response.total > 0
    assert_equal 1, response.page
    assert_equal response.total, response.playlists.length

    playlists = response.playlists
    assert playlists.first.thumbnails
    assert playlists.first.players
  end
  
  def test_shows
    response = ::Episodic::Platform::QueryMethods.shows({:id => ["5", "adfadsfasdf"]})
    
    puts response.xml
    
    assert response.total > 0
    assert_equal 1, response.page
    assert_equal response.total, response.shows.length

    shows = response.shows
    assert shows.first.thumbnails
    assert shows.first.players    
  end
  
  def test_modification_Callbacks
    response = ::Episodic::Platform::QueryMethods.modification_callbacks(Time.now)
    
    assert response
    puts response
  end
  
  def test_auth_failure
    ::Episodic::Platform::Base.establish_connection!("5bb6a3a17bb247yd13a716d8fc17153c", "fe18740f831e5edcdbe0209105e67dc7", :api_host => "localhost:3000")
    
    assert_raise(Episodic::Platform::InvalidAPIKey) {::Episodic::Platform::QueryMethods.episodes()}
  end
end
