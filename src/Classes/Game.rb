require 'nokogiri'
require 'open-uri'

class BallSet
	attr_accessor :name
	attr_accessor :count
	attr_accessor :elected

	def initialize
		@name = nil
		@count = nil
		@elected = nil
	end

	def valid?
		!(@name.nil? && @count.nil? && @elected.nil?)
	end
	def to_s
		"(#{self.name}: #{self.elected}/#{self.count})"
	end
end

class Game
  attr_accessor :name

	attr_accessor :properties

	attr_accessor :ballSets

  attr_reader :computedToDrawID
  attr_reader :strategies
  attr_reader :saveFile

  attr_reader :draws
  attr_reader :drawsModified
  attr_reader :modified
  attr_reader :lastDrawID

	def initialize
		@properties = {}
		@ballSets = []
		@name = nil
	end

	def getArchieveYearsList
		archivesLink = nil
		archivesLink = "#{@properties['baseUrl']}#{@properties['archieveLink']}" if @properties.has_key?("baseUrl") && @properties.has_key?("archieveLink")

		self.error("Archieve link not set for '#{@name}'") if archivesLink.nil?

		file = self.getHTTPFile(archivesLink)

		htmldoc = Nokogiri::HTML(file) do |config|
			config.noblanks
		end

		htmldoc.css('ul.year li').each do |li|
			year = li.children.text
			link = li.children.attr('href').value if !li.children.attr('href').nil?
			puts "#{year}:  #{link}"
		end
	end

  def to_s
  	string = "#{self.name}: \n"
  	@properties.each do |property, value|
  		string += " [#{property} : #{value}]\n"
  	end
  	@ballSets.each do |ballSet|
  		string += ballSet.to_s + "\n"
  	end
  	string
  end

  def error(message)
  	puts message
  	exit
  end

  def getHTTPFile(url)
		begin
			file = open(url)
		rescue OpenURI::HTTPError => e
  		if e.message == '404 Not Found'
    		# handle 404 error
    		self.error("Archieve link '#{url}' not found for '#{@name}'")
  		else
    		raise e
  		end
		end
		file
  end

end
