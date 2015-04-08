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

	#private instance variables
	attr_reader :archiveLinks

	def initialize
		@properties = {}
		@ballSets = []
		@name = nil
		@archiveLinks = {}
	end

	def init
		self.getArchieveYearsList

		@archiveLinks.each do |year, url|
			puts "Processing #{year} (#{url})"
			htmldoc = self.getHTMLDoc(url)
			processArchiveDoc htmldoc
		end
	end

	def getArchieveYearsList

		archivesLink = self.makeLink(@properties['baseUrl'], @properties['archieveLink'])

		self.error("Archieve link not set for '#{@name}'") if archivesLink.nil?

		htmldoc = self.getHTMLDoc(archivesLink)

		htmldoc.css('ul.year li').each do |li|
			year = li.children.text
			link = li.children.attr('href').value if !li.children.attr('href').nil?
			@archiveLinks[year] = self.makeLink(@properties['baseUrl'], link)
		end
	end

	def processArchiveDoc (htmldoc)
		htmldoc.css('div.archives').each do |game|
			datedoc = game.children.css("a")
			date_link = datedoc.attr('href').value if (!datedoc.nil? && !datedoc.attr('href').nil?)
			date_string = date_link.reverse.split('/', 2).collect(&:reverse).first if !date_link.nil?
			date = Date.strptime(date_string, '%d-%m-%Y')
			puts date.to_s
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

	def getHTMLDoc(url)
		file = self.getHTTPFile(url)

		htmldoc = Nokogiri::HTML(file) do |config|
			config.noblanks
		end
		htmldoc
	end

	def makeLink(baseUrl, link)
		return "#{baseUrl}#{link}" if !baseUrl.nil? && !link.nil?
		nil
	end
end
