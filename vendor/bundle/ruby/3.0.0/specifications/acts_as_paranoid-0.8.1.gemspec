# -*- encoding: utf-8 -*-
# stub: acts_as_paranoid 0.8.1 ruby lib

Gem::Specification.new do |s|
  s.name = "acts_as_paranoid".freeze
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Zachary Scott".freeze, "Goncalo Silva".freeze, "Rick Olson".freeze]
  s.date = "2022-04-22"
  s.description = "Check the home page for more in-depth information.".freeze
  s.email = ["e@zzak.io".freeze]
  s.homepage = "https://github.com/ActsAsParanoid/acts_as_paranoid".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.2.33".freeze
  s.summary = "Active Record plugin which allows you to hide and restore records without actually deleting them.".freeze

  s.installed_by_version = "3.2.33" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activerecord>.freeze, [">= 5.2", "< 7.1"])
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 5.2", "< 7.1"])
    s.add_development_dependency(%q<appraisal>.freeze, ["~> 2.3"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.14"])
    s.add_development_dependency(%q<minitest-focus>.freeze, ["~> 1.3"])
    s.add_development_dependency(%q<pry>.freeze, ["~> 0.14.1"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_development_dependency(%q<rake-manifest>.freeze, ["~> 0.2.0"])
    s.add_development_dependency(%q<rdoc>.freeze, ["~> 6.3"])
    s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.25"])
    s.add_development_dependency(%q<rubocop-minitest>.freeze, ["~> 0.19.0"])
    s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.21.2"])
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 5.2", "< 7.1"])
    s.add_dependency(%q<activesupport>.freeze, [">= 5.2", "< 7.1"])
    s.add_dependency(%q<appraisal>.freeze, ["~> 2.3"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.14"])
    s.add_dependency(%q<minitest-focus>.freeze, ["~> 1.3"])
    s.add_dependency(%q<pry>.freeze, ["~> 0.14.1"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rake-manifest>.freeze, ["~> 0.2.0"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 6.3"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 1.25"])
    s.add_dependency(%q<rubocop-minitest>.freeze, ["~> 0.19.0"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.21.2"])
  end
end
