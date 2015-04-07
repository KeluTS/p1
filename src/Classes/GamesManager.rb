
require 'nokogiri'
require_relative 'Game'
require_relative '../conf'

class GamesManager
	attr_reader :games

	def initialize
		@games = []
	end

	def loadGamesFromXml

		doc = Nokogiri::XML(File.open($confFile))

		doc.xpath("//lottery").each do |node|
			aGame = Game.new
			aGame.name = node.xpath("//name").sort_by{ |n| n.ancestors.length }.first.children.text
			puts aGame.name

			["baseUrl", "archieveLink", "dateFmt", "winCategories"].each do |property|
				if !node.xpath("//#{property}").empty? then
					aGame.properties[property] = node.xpath("//#{property}").children.text
				end
			end

			node.xpath("//ballSet").each do |set|
				b = BallSet.new
				["name", "count", "elected"].each do |property|
					if !set.xpath("//#{property}").empty? && b.instance_variable_defined?("@#{property}") then
					puts "@#{property} => " + set.xpath("//#{property}").children.text + "\n"
						b.instance_variable_set("@#{property}", set.xpath("//#{property}").children.text)
					end
				end
				aGame.ballSets << b if b.valid?
				b = nil
			end
			@games << aGame
		end
	end

	def print
		games.each do |game|
			puts game.to_s
		end
	end
end
