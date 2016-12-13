require 'bundler/setup'
Bundler.require

require 'active_record'
require 'rake'

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "../lib/support", "*.rb")].each {|f| require f}

DBRegistry[ENV["PLAYLISTER_ENV"]].connect!
DB = ActiveRecord::Base.connection

if ENV["PLAYLISTER_ENV"] == "test"
  ActiveRecord::Migration.verbose = false
end

def migrate_db
  DB.tables.each do |table|
    DB.execute("DROP TABLE #{table}")
  end

  Dir[File.join(File.dirname(__FILE__), "../db/migrate", "*.rb")].each do |f| 
    require f
    migration = Kernel.const_get(f.split("/").last.split(".rb").first.gsub(/\d+/, "").split("_").collect{|w| w.strip.capitalize}.join())
    migration.migrate(:up)
  end
end

def drop_db
  DB.tables.each do |table|
    DB.execute("DROP TABLE #{table}")
  end
end

def seed_db
  kanye = Artist.create(name: "Kanye")
  jay_z = Artist.create(name: "Jay-Z")
  adele = Artist.create(name: "Adele")


  rap = Genre.create(name: "rap")
  hip_hop = Genre.create(name: "hip hop")
  pop = Genre.create(name: "pop")

  song_1 = Song.create(name: "Stronger")
  song_2 = Song.create(name: "Brooklyn we go hard")
  song_3 = Song.create(name: "Rolling in the deep")

  song_1.artist = kanye
  song_2.artist = jay_z
  song_3.artist = adele

  song_1.genre = rap
  song_2.genre = hip_hop
  song_3.genre = pop

  song_1.save
  song_2.save
  song_3.save

end   

