

require_relative 'Game'
require_relative '../conf'

class GamesManager
	attr_reader :games

	def initialize
		@games = []
	end

	def loadGamesFromXml

		doc = Nokogiri::XML(File.open($confFile)) do |config|
			config.noblanks
		end

		doc.xpath("//lottery").each do |node|
			aGame = Game.new
			aGame.name = node.xpath("//name").first.children.text

			["baseUrl", "archieveLink", "dateFmt", "winCategories"].each do |property|
				if !node.xpath("//#{property}").empty? then
					aGame.properties[property] = node.xpath("//#{property}").children.text
				end
			end

			node.xpath("//ballSet").each do |set|
				b = BallSet.new
				doc1 = Nokogiri::XML(set.to_s) do |config|
					config.noblanks
				end
				["name", "count", "elected"].each do |property|
					if !doc1.xpath("//#{property}").empty? && b.instance_variable_defined?("@#{property}") then
						b.instance_variable_set("@#{property}", doc1.xpath("//#{property}").children.text)
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
