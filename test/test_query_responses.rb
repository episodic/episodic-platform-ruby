require File.dirname(__FILE__) + '/test_helper.rb'

class TestQueryResponses < Test::Unit::TestCase #:nodoc:
  
  def test_episodes_response
    response_xml = File.open(File.dirname(__FILE__) + "/fixtures/episodes-response.xml") {|f|f.read}
    
    episodes_response = ::Episodic::Platform::QueryMethods.send(:parse_episodes_response, Episodic::Platform::HTTPResponse.new(200, response_xml))
    
    assert_equal 14, episodes_response.total
    assert_equal 20, episodes_response.per_page
    assert_equal 1, episodes_response.page
    assert_equal 1, episodes_response.pages
    
    # Now look at the details of one of the episodes
    episode = episodes_response.episodes.detect {|e| e.id == "oo3kyjwjzcap"}
    assert episode
    
    # Verify some properties
    assert_equal "Episode 2", episode.name
    assert_equal nil, episode.description
    assert_equal Time.utc(2010,"jan",6,2,13,12), episode.air_date
    assert_equal nil, episode.off_air_date
    assert_equal "00:00:28", episode.duration
    assert_equal "on_the_air", episode.status
    
    custom_fields = episode.custom_fields
    assert_equal 4, custom_fields.length
    
    first_field = custom_fields.detect{|f| f.position == 1}
    assert first_field
    assert_equal "text", first_field.type
    assert_equal false, first_field.required
    assert_equal "Series Name", first_field.name
    assert_equal 1, first_field.values.length
    assert_equal "Game Trailers", first_field.values.first
    
    second_field = custom_fields.detect{|f| f.position == 2}
    assert second_field
    assert_equal "number", second_field.type
    assert_equal true, second_field.required
    assert_equal "Number Field", second_field.name
    assert_equal 1, second_field.values.length
    assert_equal "567", second_field.values.first
    
    third_field = custom_fields.detect{|f| f.position == 3}
    assert third_field
    assert_equal "date", third_field.type
    assert_equal false, third_field.required
    assert_equal "Publish Date", third_field.name
    assert_equal 1, third_field.values.length
    assert_equal "2010-01-29 18:51:00", third_field.values.first
    
    forth_field = custom_fields.detect{|f| f.position == 4}
    assert forth_field
    assert_equal "external_select", forth_field.type
    assert_equal false, forth_field.required
    assert_equal "Category", forth_field.name
    assert_equal 2, forth_field.values.length
    assert_equal ["123", "Drama"], forth_field.values.first
    
    assert_equal 1, episode.playlists.length
    assert_equal "oo3my8ozcnb5", episode.playlists.first.id
    assert_equal 1, episode.playlists.first.position
    
    assert_equal 3, episode.thumbnails.length
    assert_equal "http://localhost/cdn/development/randysimon/assets/207/a38.jpg", episode.thumbnails.first.url
    
    assert_equal 1, episode.players.length
    assert_equal "Default Player", episode.players.first.name
    assert_equal true, episode.players.first.default
    assert_equal "http://localhost/cdn/development/randysimon/5/oo3kyjwjzcap/config.xml", episode.players.first.config
    assert episode.players.first.embed_code
    
    assert_equal 1, episode.downloads.length
    assert_equal "http://localhost/cdn/development/randysimon/assets/480/a38.mp4", episode.downloads.first.url
  end
  
  def test_playlists_response
    response_xml = File.open(File.dirname(__FILE__) + "/fixtures/playlists-response.xml") {|f|f.read}
    
    response = ::Episodic::Platform::QueryMethods.send(:parse_playlists_response, Episodic::Platform::HTTPResponse.new(200, response_xml))
    
    assert_equal 17, response.total
    assert_equal 20, response.per_page
    assert_equal 1, response.page
    assert_equal 1, response.pages
    
    # Now look at the details of one of the episodes
    playlist = response.playlists.detect {|p| p.id == "ootudbh0gdfl"}
    assert playlist
    
    # Verify some properties
    assert_equal "test1", playlist.name
    assert_equal nil, playlist.description
    assert_equal Time.utc(2010,"jan",7,21,20,37), playlist.created_at
    
    custom_fields = playlist.custom_fields
    assert_equal 3, custom_fields.length
    
    first_field = custom_fields.detect{|f| f.position == 1}
    assert first_field
    assert_equal "text", first_field.type
    assert_equal false, first_field.required
    assert_equal "text field", first_field.name
    assert_equal 0, first_field.values.length
    
    second_field = custom_fields.detect{|f| f.position == 2}
    assert second_field
    assert_equal "date", second_field.type
    assert_equal false, second_field.required
    assert_equal "date field", second_field.name
    assert_equal 1, second_field.values.length
    assert_equal "2010-02-11 22:42:00", second_field.values.first
    
    third_field = custom_fields.detect{|f| f.position == 3}
    assert third_field
    assert_equal "external_select", third_field.type
    assert_equal false, third_field.required
    assert_equal "External Select Field", third_field.name
    assert_equal 0, third_field.values.length
    
    assert_equal 7, playlist.episodes.length
    assert_equal "oz049unr3jep", playlist.episodes.first.id
    assert_equal 1, playlist.episodes.first.position
    
    assert_equal 0, playlist.thumbnails.length
    
    assert_equal 1, playlist.players.length
    assert_equal "Default Player", playlist.players.first.name
    assert_equal true, playlist.players.first.default
    assert_equal "http://localhost/cdn/development/randysimon/6/playlists/ootudbh0gdfl/playlist.xml", playlist.players.first.config
    assert playlist.players.first.embed_code
  end
  
  def test_shows_response
    response_xml = File.open(File.dirname(__FILE__) + "/fixtures/shows-response.xml") {|f|f.read}
    
    response = ::Episodic::Platform::QueryMethods.send(:parse_shows_response, Episodic::Platform::HTTPResponse.new(200, response_xml))
    
    assert_equal 2, response.total
    assert_equal 20, response.per_page
    assert_equal 1, response.page
    assert_equal 1, response.pages
    
    # Try to get the show that we could not find
    show = response.shows.detect {|s| s.id == "adfadsfasdf"}
    assert show
    assert !show.exists?
    
    # Now look at the details of one of the shows
    show = response.shows.detect {|s| s.id == "89675"}
    assert show
    assert show.exists?
    
    assert_equal "My show", show.name
    assert_equal "My description", show.description
    
    assert_equal 1, show.players.length
    assert_equal "Default Player", show.players.first.name
    assert_equal true, show.players.first.default
    assert_equal "http://localhost/cdn/development/randysimon/5/latest/config.xml", show.players.first.config
    assert show.players.first.embed_code
  end
end
