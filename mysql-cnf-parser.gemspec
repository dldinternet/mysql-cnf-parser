# -*- encoding: utf-8 -*-

require File.expand_path('../lib/mysqlcnfparse/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'mysql-cnf-parser'
  gem.version       = MysqlCnfParser::VERSION
  gem.summary       = %q{A mysql config file parser}
  gem.description   = %q{A mysql config file parser base on INI parser}
  gem.license       = 'Apachev2'
  gem.authors       = ['Christo De Lange']
  gem.email         = 'rubygems@dldinternet.com'
  gem.homepage      = 'https://rubygems.org/gems/mysql-cnf-parser'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'iniparse', '~> 1.4', '>= 1.4.4'

  gem.add_development_dependency 'bundler', '~> 1.2'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'cucumber', '~> 0.10', '>= 0.10.2'
end
