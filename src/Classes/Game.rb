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
end
