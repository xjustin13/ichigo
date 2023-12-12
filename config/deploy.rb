require 'bundler/capistrano'
require 'whenever/capistrano'
ENVS = {'production'=>{:url=>'plaincipher.com', :port=>33333},
        'staging'   =>{:url=>'plaincipher.com', :port=>44444}}
set(:rails_env, ENV['RAILS_ENV'])
raise('Invalid RAILS_ENV!!!') unless ENVS.keys.include?(rails_env)
default_run_options[:pty] = true

# Repo
set(:application, 'ichigo')
set(:repository, "git@github.com:xjustin13/#{application}.git")
set(:branch, 'main')
set(:scm, :git)

# Server
set(:keep_releases, 2)
set(:username, 'trietcao')
set(:url,  ENVS[rails_env][:url])
set(:port, ENVS[rails_env][:port])
server("#{username}@#{url}:#{port}", :app, :web, :db, :primary=>true)
set(:use_sudo, false)
set(:deploy_to, capture("echo -n $HOME/#{application}"))
set(:log_file, capture("echo -n $HOME/#{application}/shared/log/#{rails_env}.log"))
# Shared cache directories persist between deploys. Local versions don't get deployed.
set(:whenever_command, 'bundle exec whenever')
set(:default_environment, {
  'PATH'=>"$HOME/.rbenv/shims:$PATH",
  'CC'=>'gcc7',
  'CXX'=>'g++7',
  'CPP'=>'cpp7',
  'MAKE'=>'gmake'
})

# Database
set(:db_env, YAML::load(File.open("config/database.yml"))[rails_env])
set(:db_username, db_env['username'])
set(:db_database, db_env['database'])

before('deploy',            'deploy:web:disable')
after( 'deploy',            'deploy:web:enable')
before('deploy:migrations', 'deploy:web:disable')
after( 'deploy:migrations', 'deploy:web:enable')

# this is called during deploy:cold, deploy, and deploy:migrations
after('deploy:create_symlink', 'deploy:cleanup')

before('deploy:cold') do
  run("[ ! -d '#{current_path}' ]") #exits if deployment already exists
  run("dropdb -U #{db_username} #{db_database}; createdb -U #{db_username} #{db_database}")
end
after('deploy:cold') do
  run("cd -- #{latest_release} && RAILS_ENV=#{rails_env} #{rake} db:seed")
  puts('======> SEEDED DATABASE FOR COLD DEPLOY')
  message = "======> DEPLOYED #{current_revision} COLD"
  write_log(message, :warn)
  puts("#{message} TO #{rails_env.upcase}")
end
after('deploy:migrations') do
  message = "======> DEPLOYED #{current_revision} WITH MIGRATIONS"
  write_log(message, :warn)
  puts("#{message} TO #{rails_env.upcase}")
end
after('deploy') do
  message = "======> DEPLOYED #{current_revision} WITHOUT MIGRATIONS"
  write_log(message, :warn)
  puts("#{message} TO #{rails_env.upcase}")
end
after('deploy:web:disable') do
  message = '======> DISABLED WEB ACCESS (503)'
  # must manually write log with current_release to circumvent bug
  run("cd -- #{current_release} && RAILS_ENV=#{rails_env} LOG_LEVEL=warn #{rake} log:write '#{message} @ #{Time.now.utc}'")
  puts("#{message} TO #{rails_env.upcase}")
end
after('deploy:web:enable') do
  message = '======> RE-ENABLED WEB ACCESS'
  write_log(message, :warn)
  puts("#{message} TO #{rails_env.upcase}")
end
namespace :deploy do
  # Cap runs deploy:restart automatically but it's an empty task by default.
  desc 'RESTART by touching restart.txt'
  task(:restart) do
    run("touch #{current_path}/tmp/restart.txt")
  end
end

def write_log(message, log_level=:info)
  run("cd -- #{latest_release} && RAILS_ENV=#{rails_env} LOG_LEVEL=#{log_level} #{rake} log:write '#{message} @ #{Time.now.utc}'")
end
