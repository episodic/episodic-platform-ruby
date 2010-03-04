require File.dirname(__FILE__) + '/test_helper.rb'

class TestQueryRequests < Test::Unit::TestCase #:nodoc:

  def setup
    ::Episodic::Platform::Base.establish_connection!(TEST_API_KEY, TEST_SECRET_KEY, :api_host => TEST_HOST)  
  end
  
  def test_episodes_summary_report
    response = ::Episodic::Platform::AnalyticsMethods.episodes_summary_report("5", "last_thirty", "daily", "csv")
    
    assert response.token
    
    report = ::Episodic::Platform::AnalyticsMethods.get_report(response.token)
    
    puts report
    assert report
  end
  
  def test_episode_daily_report
    response = ::Episodic::Platform::AnalyticsMethods.episode_daily_report("5", "ozv6spajltkx", "last_thirty", "csv")
    
    assert response.token
    
    report = ::Episodic::Platform::AnalyticsMethods.get_report(response.token)
    
    puts report
    assert report
  end
  
  def test_campaigns_daily_report
    response = ::Episodic::Platform::AnalyticsMethods.campaigns_daily_report("5", "last_thirty", "csv")
    
    assert response.token
    
    report = ::Episodic::Platform::AnalyticsMethods.get_report(response.token)
    
    puts report
    assert report
  end
  
end
