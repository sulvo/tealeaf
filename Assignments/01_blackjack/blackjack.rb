## Define $deck of Cards
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
	[:ace, :clubs, "Ace of Clubs"],
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
	[:ace, :diamonds, "Ace of Diamonds"],
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
	[:ace, :hearts, "Ace of Hearts"],
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
	[:ace, :spades, "Ace of Spades"]

$hand_player_sum = 0
$hand_dealer_sum = 0

class CardDeck < Array
	def initialize
		self << $rawdeck.shuffle
	end
end


dealers = ["Noelene", "Raylene", "Praline", "Shaneen", "Doreen"].shuffle!
$dealername = dealers[0]





class Deal

	def self.new
		$deck = CardDeck.new
		$hand_dealer = Array.new
		$hand_player = Array.new

		$hand_player << $deck[0].delete_at(0)
		$hand_dealer << $deck[0].delete_at(0)
		$hand_player << $deck[0].delete_at(0)
		$hand_dealer << $deck[0].delete_at(0)

		$hand_player_sum = 0;
		puts ""
		puts "#{$dealername} has dealt your cards and her own"
		Deal.playerhand
		Deal.whatnext
	end

	def self.hit
		puts ""
		$hand_player << $deck[0].delete_at(0)
		Deal.playerhand
		if $hand_player_sum == 21
			puts "21!"
			Deal.finalise
		elsif $hand_player_sum > 21
			puts "Bust!"
			Deal.finalise
		else
			Deal.whatnext
		end
	end

	def self.playerhand
		puts ""
		puts "Your cards are:"
		$hand_player_sum = 0		
		$hand_player.each do |value, suit, name|
			puts name
			if value.is_a?(Fixnum)
				$hand_player_sum += value
			elsif value == :ace && $hand_player_sum <= 10
				$hand_player_sum += 11
			elsif value == :ace && $hand_player_sum > 10
				$hand_player_sum += 1
			else puts "Error001"
			end
				end
		puts "...giving you a total hand of #{$hand_player_sum}"
	end

	def self.dealerhand()
		$hand_dealer_sum = 0		
		$hand_dealer.each do |value, suit, name|
			puts name
			if value.is_a?(Fixnum)
				$hand_dealer_sum += value
			elsif value == :ace && $hand_dealer_sum <= 10
				$hand_dealer_sum += 11
			elsif value == :ace && $hand_dealer_sum > 10
				$hand_dealer_sum += 1
			else puts "Error002"
			end
		end
	end

	def self.whatnext(waiting=false)
		puts ""
		if waiting == true
			puts "That wasn't a valid input - type H or S"
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
				Deal.whatnext(true)
		end
	end

	def self.finalise
		puts ""
		if (($hand_player_sum > $hand_dealer_sum) && ($hand_player_sum <= 21)) || ($hand_player_sum == 21)
			puts "With a total of #{$hand_player_sum}, YOU WIN!"
			puts ""
		elsif ($hand_dealer_sum > $hand_player_sum) && ($hand_dealer_sum <= 21)
			puts "With a total of #{$hand_player_sum}, YOU LOSE!"
			puts ""
		elsif ($hand_player_sum > 21)
			puts "You got too cocky"
			puts ""
		elsif ($hand_dealer_sum > 21)
			puts "#{$dealername} busts with a total of #{$hand_dealer_sum}"
			puts ""
		else puts "Stalemate!"
			puts ""
		end
		puts "Play again?"
		case gets.chomp.downcase
		when "yes", "y", ""
			Deal.new
		else exit
		end
	end

	def self.stay
		puts ""
		puts "#{$dealername}'s hand looks like this..."
		puts ""
		Deal.dealerhand
		puts "...giving her a total hand of #{$hand_dealer_sum}"
		puts ""
		Deal.dealernextstep
	end

	def self.dealerhit
		puts ""
		puts "#{$dealername} hits"
		$hand_dealer << $deck[0].delete_at(0)
		puts ""
		puts "Her hand looks like this:"
		Deal.dealerhand
		Deal.dealernextstep
	end

	def self.dealernextstep
		puts ""
		if ($hand_dealer_sum < 17) || ($hand_dealer_sum < $hand_player_sum)
			sleep(1)
			Deal.dealerhit
		elsif $hand_dealer_sum > 21
			Deal.finalise
		else
			puts "#{$dealername} stays with a hand total of #{$hand_dealer_sum}"
			Deal.finalise
		end
	end


end


## Intro the game and collect name

puts "Welcome to RubyJack"
puts "Please tell me your name:"

playername = gets.chomp.capitalize

puts "Thanks #{playername}, your dealer's name is #{$dealername}"
puts ""
puts "Are you ready to get started?"

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