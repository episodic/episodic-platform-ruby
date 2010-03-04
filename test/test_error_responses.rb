require File.dirname(__FILE__) + '/test_helper.rb'

class TestErrorResponses < Test::Unit::TestCase #:nodoc:
  
  def test_invalid_param_single_response
    response_xml = File.open(File.dirname(__FILE__) + "/fixtures/invalid-param-response-single.xml") {|f|f.read}
    
    begin
      ::Episodic::Platform::Response.new(Episodic::Platform::HTTPResponse.new(200, response_xml))
      
      assert false, "Expected exception to be thrown"
    rescue Episodic::Platform::InvalidParameters => e
      assert e.message.include?("extensible_metadata_field_values_date_value")
    end
  end
  
  def test_invalid_param_multiple_response
    response_xml = File.open(File.dirname(__FILE__) + "/fixtures/invalid-param-response-multiple.xml") {|f|f.read}
    
    begin
      ::Episodic::Platform::Response.new(Episodic::Platform::HTTPResponse.new(200, response_xml))
      
      assert false, "Expected exception to be thrown"
    rescue Episodic::Platform::InvalidParameters => e
      assert e.message.include?("extensible_metadata_field_values_date_value")
    end
  end
  
end
