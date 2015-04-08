#!/home/kelu/.rvm/rubies/default/bin/ruby

require_relative 'Classes/GamesManager'

manager = GamesManager.new
manager.loadGamesFromXml
manager.print

game = manager.games.first
game.init
manager = nil
