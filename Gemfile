source 'http://rubygems.org'
ruby '2.0.0', :patchlevel=>'648'

# needed for ed25519 type ssh keys
gem 'rbnacl', '3.4.0',  :require=>false #locked
  gem 'ffi',  '1.12.2', :require=>false #locked
gem 'bcrypt_pbkdf', '1.1.0', :require=>false

# dependencies are indented and locked to highest version we can handle
gem 'rails', '3.2.22' #locked
  gem 'actionmailer',        '3.2.22', :require=>false #locked
    gem 'mail',              '2.5.5',  :require=>false #locked
      gem 'mime-types',      '1.25.1', :require=>false #locked
      gem 'treetop',         '1.4.15', :require=>false #locked
        gem 'polyglot',      '0.3.5',  :require=>false
  gem 'actionpack',          '3.2.22', :require=>false #locked
    gem 'activemodel',       '3.2.22', :require=>false #locked
      gem 'builder',         '3.0.4',  :require=>false #locked
    gem 'erubis',            '2.7.0',  :require=>false
    gem 'journey',           '1.0.4',  :require=>false
    gem 'rack',              '1.4.7',  :require=>false #locked
    gem 'rack-cache',        '1.9.0',  :require=>false #locked
    gem 'rack-test',         '0.6.3',  :require=>false #locked
    gem 'sprockets',         '2.2.3',  :require=>false #locked
      gem 'hike',            '1.2.3',  :require=>false #locked
      gem 'multi_json',      '1.15.0', :require=>false
      gem 'tilt',            '1.4.1',  :require=>false #locked
  gem 'activerecord',        '3.2.22', :require=>false #locked
    gem 'arel',              '3.0.3',  :require=>false #locked
    gem 'tzinfo',            '0.3.60', :require=>false #locked
  gem 'activeresource',      '3.2.22', :require=>false #locked
  gem 'activesupport',       '3.2.22', :require=>false #locked
    gem 'i18n',              '0.9.5',  :require=>false #locked
      gem 'concurrent-ruby', '1.1.9',  :require=>false #locked
  gem 'bundler',             '1.17.3', :require=>false #locked
  gem 'railties',            '3.2.22', :require=>false #locked
    gem 'rack-ssl',          '1.3.4',  :require=>false #locked
    gem 'rake',              '12.3.3', :require=>false #locked
    gem 'rdoc',              '3.12.2', :require=>false #locked
      gem 'json',            '1.8.6',  :require=>false #locked
    gem 'thor',              '1.2.1',  :require=>false

gem 'active_model_serializers', '0.9.9' #locked
gem 'pg', '0.20.0' #locked (last version before deprecation warnings, good for PostgreSQL 9.6)

group :development do
  gem 'pry', '0.14.1'
    gem 'coderay',       '1.1.3', :require=>false
    gem 'method_source', '1.0.0', :require=>false

  gem 'faker', '1.7.3' #locked
  gem 'capistrano', '2.15.9', :require=>false #locked (version 2)
    gem 'highline',        '2.0.3', :require=>false
    gem 'net-scp',         '3.0.0', :require=>false
      gem 'net-ssh',       '4.2.0', :require=>false #locked
    gem 'net-sftp',        '2.1.2', :require=>false #locked
    gem 'net-ssh-gateway', '2.0.0', :require=>false
end

group :production, :staging do
  gem 'passenger', '4.0.60' #locked (version 4)
    gem 'daemon_controller', '1.2.0', :require=>false

  gem 'whenever', '1.0.0', :require=>false
    gem 'chronic', '0.10.2', :require=>false
end

group :assets do
  gem 'sass-rails', '3.2.6' #locked
    gem 'sass',           '3.7.4',  :require=>false #locked
      gem 'sass-listen',  '4.0.0',  :require=>false
        gem 'rb-fsevent', '0.11.1', :require=>false
        gem 'rb-inotify', '0.9.10', :require=>false #locked

  gem 'uglifier', '4.2.0'
    gem 'execjs', '2.8.1', :require=>false
end
