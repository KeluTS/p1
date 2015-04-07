#!/home/kelu/.rvm/rubies/default/bin/ruby

require_relative 'Classes/GamesManager'

manager = GamesManager.new
manager.loadGamesFromXml
manager.print
manager = nil
