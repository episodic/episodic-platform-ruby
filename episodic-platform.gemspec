# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{episodic-platform}
  s.version = "0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Randy Simon"]
  s.date = %q{2010-03-03}
  s.description = %q{Ruby client library for Episodic's Platform REST API

For more information about Episodic's Platform API see {http://app.episodic.com/help/server_api}[http://app.episodic.com/help/server_api]

Rdocs are located at {http://episodic.github.com/episodic-platform-ruby/doc/index.html}[http://episodic.github.com/episodic-platform-ruby/doc/index.html]}
  s.email = ["support@episodic.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/episodic/platform.rb", "lib/episodic/platform/analytics_methods.rb", "lib/episodic/platform/base.rb", "lib/episodic/platform/collection_response.rb", "lib/episodic/platform/connection.rb", "lib/episodic/platform/exceptions.rb", "lib/episodic/platform/query_methods.rb", "lib/episodic/platform/response.rb", "lib/episodic/platform/write_methods.rb", "script/console", "script/destroy", "script/generate", "test/fixtures/1-0.mp4", "test/fixtures/create-episode-response-s3.xml", "test/fixtures/create-episode-response.xml", "test/fixtures/episodes-response.xml", "test/fixtures/episodes-summary-report-response.xml", "test/fixtures/invalid-param-response-multiple.xml", "test/fixtures/invalid-param-response-single.xml", "test/fixtures/playlists-response.xml", "test/fixtures/shows-response.xml", "test/test_analytics_requests.rb", "test/test_analytics_responses.rb", "test/test_connection.rb", "test/test_error_responses.rb", "test/test_helper.rb", "test/test_query_requests.rb", "test/test_query_responses.rb", "test/test_write_requests.rb", "test/test_write_responses.rb"]
  s.homepage = %q{http://github.com/episodic/episodic-platform-ruby}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{episodic-platform}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Ruby client library for Episodic's Platform REST API  For more information about Episodic's Platform API see {http://app.episodic.com/help/server_api}[http://app.episodic.com/help/server_api]  Rdocs are located at {http://episodic.github.com/episodic-platform-ruby/doc/index.html}[http://episodic.github.com/episodic-platform-ruby/doc/index.html]}
  s.test_files = ["test/test_analytics_requests.rb", "test/test_analytics_responses.rb", "test/test_connection.rb", "test/test_error_responses.rb", "test/test_helper.rb", "test/test_query_requests.rb", "test/test_query_responses.rb", "test/test_write_requests.rb", "test/test_write_responses.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_development_dependency(%q<gemcutter>, [">= 0.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.5.0"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_dependency(%q<gemcutter>, [">= 0.3.0"])
      s.add_dependency(%q<hoe>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
    s.add_dependency(%q<gemcutter>, [">= 0.3.0"])
    s.add_dependency(%q<hoe>, [">= 2.5.0"])
  end
end
