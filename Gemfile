source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use postgresql as the database for Active Record
# gem 'pg'
# visual view of models
# gem 'rails-erd'
# rake erd filetype=dot
gem 'rails-erd' #, github: 'ready4god2513/rails-erd', branch: 'rails-4.2-support-fix'
#visual view of models dependecy
gem 'ruby-graphviz'
#charting tool https://github.com/ankane/chartkick
# gem "chartkick"
# charting helper https://github.com/ankane/groupdate
# gem 'groupdate'
gem 'googlecharts'

#gem 'thin'
#gem "rack-timeout"
#gem 'exception_handler'

#intall luhn for credit card verification => not used for now
gem 'luhn'

#gem 'RedCloth'
# #to import csv, excel etc
# gem 'roo'

## Gemfile for Rails 3+, Sinatra, and Merb
gem 'will_paginate', '~> 3.0.6'

#get multi form
#gem 'wicked'
#gem for getting csv files
#gem 'fastercsv', '~> 1.5.5'
#gem for parsing excel, ods or any spreadsheet
#https://github.com/roo-rb/roo
gem 'roo', '~> 2.3'

#get auto complete
gem 'rails4-autocomplete'
#get jquery ui is required for auto complete
gem "jquery-ui-rails"

#login gem
gem 'devise', github: 'plataformatec/devise'
#before_filter :admin_only, :except => :show

# Use SCSS for stylesheets
#gem 'sass-rails', '~> 4.0.3'
# Use boostrap for styling
gem 'bootstrap-sass', '3.2.0.0'
gem 'bootstrap-datepicker-rails'
#Rails Bootstrap Forms for styling all bootstrap forms
gem 'bootstrap_form'

#simple form looks better
gem 'simple_form'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'

#paginate gem
gem 'kaminari'

#what you see if what you get form
gem 'bootsy'

# background worker process
gem 'delayed_job_active_record'
# background worker web interface see routes
gem "delayed_job_web"
gem 'delayed-web'

gem 'resque'
gem 'resque-web', require: 'resque_web'
# gem install resque-cleaner
gem 'resque-cleaner'

gem "daemons"
gem "rspec"

#date picker
#gem 'jquery-ui-rails'
#https://github.com/joliss/jquery-ui-rails

gem "select2-rails"

#http://www.eyecon.ro/bootstrap-datepicker/
gem 'simple-form-datepicker'

#date picker option 2
# first dependecies
gem 'momentjs-rails', '~> 2.9',  :github => 'derekprior/momentjs-rails'
#actual gem below
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true

# Use boostrap for testing
group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
 gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', '~> 1.3.3',       group: :development

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# gem 'bcrypt',               '3.1.7'
# Use unicorn as the app server
#gem 'unicorn'

# gem for SQL Server 
gem 'tiny_tds', '~> 0.7.0'
gem 'activerecord-sqlserver-adapter', '~> 4.2.0'

#gems for Oracle
gem 'ruby-oci8', '~>2.2.1'

#gems for Oracle
#gem 'ruby-oci8', '~>2.1.5'
#gem 'activerecord-oracle_enhanced-adapter', :git => 'git://github.com/rsim/oracle-enhanced.git'
#gem 'activerecord-oracle_enhanced-adapter', github: 'rsim/oracle-enhanced', branch: 'rails42'
gem "activerecord-oracle_enhanced-adapter", "~> 1.6.0"

#get arel for sql quries
gem 'arel', '~> 6.0'

gem 'upmin-admin'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#rails charting http://ankane.github.io/chartkick/
#gem "chartkick"

#image uploader
gem 'carrierwave'

#dependencies for gruff
# need to install on ubuntu sudo apt-get install libmagickwand-dev imagemagick
gem 'rmagick', '~> 2.15.1'
# gem 'rake-compiler', '~> 0.9.5'
# gem 'rspec', '~> 3.2.0'
# gem 'rubocop', '~> 0.31.0'

#https://github.com/topfunky/gruff
gem 'gruff'
#to group https://github.com/ankane/groupdate
#gem 'groupdate'
group :development do
 gem 'byebug'
 gem 'webrick'
end
# Use debugger
# gem 'debugger', group: [:development, :test]
#gem 'request-log-analyzer'
group :production do

  gem 'rails_12factor', '0.0.2'
  #gem 'unicorn',        '4.8.3'
  #gem 'passenger'
  #gem 'thin'
  gem 'puma'
  #gem 'unicorn'
end
