require 'time'
require 'digest/sha1'
require 'digest/md5'
require 'net/http'
require 'uri'
require 'zlib'

def require_library_or_gem(library, gem_name = nil)
  if RUBY_VERSION >= '1.9'
    gem(gem_name || library, '>=0') 
  end
  require library
rescue LoadError => library_not_installed
  begin
    require 'rubygems'
    require library
  rescue LoadError
    raise library_not_installed
  end
end

$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require_library_or_gem 'curb' unless defined? Curb
require_library_or_gem 'xmlsimple', 'xml-simple' unless defined? XmlSimple
require_library_or_gem 'hanna', 'mislav-hanna' unless defined? Hanna

class Class # :nodoc:
  def cattr_reader(*syms)
    syms.flatten.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}
          @@#{sym}
        end

        def #{sym}
          @@#{sym}
        end
      EOS
    end
  end
  
  def cattr_writer(*syms)
    syms.flatten.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}=(obj)
          @@#{sym} = obj
        end

        def #{sym}=(obj)
          @@#{sym} = obj
        end
      EOS
    end
  end
  
  def cattr_accessor(*syms)
    cattr_reader(*syms)
    cattr_writer(*syms)
  end
end if Class.instance_methods(false).grep(/^cattr_(?:reader|writer|accessor)$/).empty?

require 'platform/exceptions'
require 'platform/response'
require 'platform/collection_response'
require 'platform/connection'
require 'platform/base'
require 'platform/analytics_methods'
require 'platform/query_methods'
require 'platform/write_methods'

Episodic::Platform::Base.class_eval do
  include Episodic::Platform::Connection::Management
end
