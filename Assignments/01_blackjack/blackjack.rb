## Define @deck of Cards
$rawdeck = 
	[2, :clubs, "2 of Clubs"],
	[3, :clubs, "3 of Clubs"],
	[4, :clubs, "4 of Clubs"],
	[5, :clubs, "5 of Clubs"],
	[6, :clubs, "6 of Clubs"],
	[7, :clubs, "7 of Clubs"],
	[8, :clubs, "8 of Clubs"],
	[9, :clubs, "9 of Clubs"],
	[10, :clubs, "10 of Clubs"],
	[10, :clubs, "Jack of Clubs"],
	[10, :clubs, "Queen of Clubs"],
	[10, :clubs, "King of Clubs"],
	["A", :clubs, "Ace of Clubs"],
	[2, :diamonds, "2 of Diamonds"],
	[3, :diamonds, "3 of Diamonds"],
	[4, :diamonds, "4 of Diamonds"],
	[5, :diamonds, "5 of Diamonds"],
	[6, :diamonds, "6 of Diamonds"],
	[7, :diamonds, "7 of Diamonds"],
	[8, :diamonds, "8 of Diamonds"],
	[9, :diamonds, "9 of Diamonds"],
	[10, :diamonds, "10 of Diamonds"],
	[10, :diamonds, "Jack of Diamonds"],
	[10, :diamonds, "Queen of Diamonds"],
	[10, :diamonds, "King of Diamonds"],
	["A", :diamonds, "Ace of Diamonds"],
	[2, :hearts, "2 of Hearts"],
	[3, :hearts, "3 of Hearts"],
	[4, :hearts, "4 of Hearts"],
	[5, :hearts, "5 of Hearts"],
	[6, :hearts, "6 of Hearts"],
	[7, :hearts, "7 of Hearts"],
	[8, :hearts, "8 of Hearts"],
	[9, :hearts, "9 of Hearts"],
	[10, :hearts, "10 of Hearts"],
	[10, :hearts, "Jack of Hearts"],
	[10, :hearts, "Queen of Hearts"],
	[10, :hearts, "King of Hearts"],
	["A", :hearts, "Ace of Hearts"],
	[2, :spades, "2 of Spades"],
	[3, :spades, "3 of Spades"],
	[4, :spades, "4 of Spades"],
	[5, :spades, "5 of Spades"],
	[6, :spades, "6 of Spades"],
	[7, :spades, "7 of Spades"],
	[8, :spades, "8 of Spades"],
	[9, :spades, "9 of Spades"],
	[10, :spades, "10 of Spades"],
	[10, :spades, "Jack of Spades"],
	[10, :spades, "Queen of Spades"],
	[10, :spades, "King of Spades"],
	["A", :spades, "Ace of Spades"]


class CardDeck < Array
	def initialize
		self << $rawdeck.shuffle
	end
end


## Deal 

class Deal

	def self.new
		@deck = CardDeck.new
		@hand_dealer = Array.new
		@hand_player = Array.new

		@hand_dealer << @deck[0].delete_at(0)
		@hand_player << @deck[0].delete_at(0)
		@hand_dealer << @deck[0].delete_at(0)
		@hand_player << @deck[0].delete_at(0)

		@hand_player_sum = 0;

		puts "Lara has dealt your cards and her own"
		puts "Your cards are:"
		@hand_player_sum = 0		
		@hand_player.each do |value, suit, name|
			puts name
			value.is_a?(Fixnum) ? @hand_player_sum += value : @hand_player_sum += -1000
		end
		puts "...giving you a total hand of #{@hand_player_sum}"

##		puts "\n------------\nDEALER HAND\n------------\n"
##		@hand_dealer.each { |value,suit,name| puts name }
##		puts "\n------------\nPLAYER HAND\n------------\n"
##		@hand_player.each { |value,suit,name| puts name}
		
		Deal.whatnext
	end

	def self.hit
				@hand_player << @deck[0].delete_at(0)
				puts "Your cards are:"
				@hand_player_sum = 0
				@hand_player.each do |value, suit, name|
					puts name
					value.is_a?(Fixnum) ? @hand_player_sum += value : @hand_player_sum += -1000
				end
				puts "...giving you a total hand of #{@hand_player_sum}"
				Deal.whatnext
	end

	def self.whatnext(waiting=false)
		if waiting == true
			puts "that wasn't a valid input - type H or S"
		else
			puts "What would you like to do now?"
		end
		puts "Hit or Stay?"
		case gets.chomp.downcase
			when "hit", "h"
				Deal.hit
			when "stay", "s"
				Deal.stay
			else
				Deal.whatnext
		end
	end

	def self.stay
		puts "Lara's hand looks like this..."
		@hand_dealer_sum = 0		
		@hand_player.each do |value, suit, name|
			puts name
			value.is_a?(Fixnum) ? @hand_player_sum += value : @hand_player_sum += -1000
		end
		puts "...giving her a total hand of #{@hand_dealer_sum}"




	end


end


## Intro the game and collect name

puts "Welcome to RubyJack"
puts "Please tell me your name:"

playername = gets.chomp.capitalize

puts "Thanks #{playername}, your dealer's name is Lara"
puts "Are you ready to get started? (y/n)"

## Get permission to start the game

case gets.chomp.downcase
	when "y", "yes", ""
		Deal.new
	when "n", "no"
		puts "OK then, bye!"
	else
		puts "Still waiting..."
		Deal.whatnext(true)
end