require File.dirname(__FILE__) + '/test_helper.rb'

class TestConnection < Test::Unit::TestCase #:nodoc:
  
  def test_convert_params_for_request
    
    now = Time.now
    
    params = {
      "foo" => "bar",
      "date" => now,
      "hash_value" => { "text_value" => "my_value", "external_field" => { 123 => "happy", 576 => "sad"}, "date_value" => now },
      "array_value" => ["234", "678", "789"],
      "nil_value" => nil,
      "boolean_value" => true
    }
    
    connection = Episodic::Platform::Connection.new(nil, nil, nil)
    result = connection.send(:convert_params_for_request, params)
    
    assert_equal "bar", result["foo"]
    assert_equal now.to_i.to_s, result["date"]
    assert_equal "my_value", result["hash_value[text_value]"]
    assert_equal "123|happy;576|sad;", result["hash_value[external_field]"]
    assert_equal now.to_i.to_s, result["hash_value[date_value]"]
    assert_equal "234,678,789", result["array_value"]
    assert_equal "", result["nil_value"]
    assert_equal "true", result["boolean_value"]
  end
  
end
