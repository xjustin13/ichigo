# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Seed from YML and CSV files
common_dir    = Rails.root.join('db', 'seeds')
common_tables = Dir["#{common_dir}/*.{yml,csv}"].map{|f| File.basename(f, File.extname(f))}
env_dir       = Rails.root.join('db', 'seeds', Rails.env)
env_tables    = Dir["#{env_dir}/*.{yml,csv}"].map{|f| File.basename(f, File.extname(f))}

ActiveRecord::Fixtures.create_fixtures(env_dir, env_tables)
ActiveRecord::Fixtures.create_fixtures(common_dir, common_tables)
