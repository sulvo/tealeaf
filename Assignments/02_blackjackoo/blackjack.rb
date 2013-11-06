#verbs

# deal
# hit
# calculate_total
# whatnext
# stay
# start
# playagain
# finalise
# randomdealer
#actions

#objects
def error(id="NO_ID",message="An error occurred")
  puts message + " (#{id})"
end

class Game

  attr_accessor :player,:dealer,:deck,:dealer_hand,:player_hand

  def choosedealer
    %w[Raylene Pralene Shaneen Doreen Planteen Marlene Janine].shuffle.pop
  end

  def initialize(player="Player")	
    @player = player
    @deck = Deck.new
    @dealer = self.choosedealer()
  end

  def deal
    @player_hand = []
    @dealer_hand = []
    @deck.shuffle!
    @player_hand << @deck.pop
    @dealer_hand << @deck.pop
    @player_hand << @deck.pop
    @dealer_hand << @deck.pop
  end

  def hit
    case @turn
      when :player
        @player_hand << @deck.pop
        calculate_total("player")
      when :dealer
        @dealer_hand << @deck.pop
        calculate_total("dealer")
      else
        error(0001,"Must specify player or dealer")
    end
    whatnext
  end


  def stay
    @turn == :player ? @turn = :dealer
  end

  def cardvalue(card)
    ### Method to work out the value of a card ###
  end

  def whatnext
    case @turn
      when :player
        puts "Your hand looks like this:"
        @player_hand.each { |card| puts card }
        puts "Would you like to hit or stay?"
        case gets.chomp.downcase
          when "hit", "h" then self.hit
          when "stay", "s" then self.stay
          else "Please type \"hit\" or \"stay\""
            whatnext("player")
        end  
      when :dealer
        puts "#{@dealer}'s hand looks like this:"
        @dealer_hand.each { |card| puts card }
        if @dealer_hand < 17 then self.hit
        elsif @dealer_hand > 17 && @dealer_hand < 21 && @dealer_hand < @player_hand
        #### Add method to decide the dealer's next move #### 
    end

  end

  def self.start
    @turn = :player
    puts "====== Welcome to Blackjack ======\n"
    puts ">> What is your name?"
    playername = gets.chomp
    puts
    @currentgame = Game.new(playername)
    self.deal
    puts "#{@currentgame.dealer} has dealt your hand and her own"
    puts "Her hand is hidden"
    self.whatnext("player")
  end


end


class Card

  attr_accessor :suit,:rank,:name

  def initialize(suit,rank)
    @suit = suit.downcase.to_sym
    rank.is_a?(Fixnum) ? @rank = rank : @rank = rank.downcase.to_sym
    @name = rank.to_s.capitalize + " of " + suit.to_s.capitalize
  end

  def to_s
    @name
  end

end

class Deck < Array
  
  def initialize
    suits = [:hearts,:clubs,:diamonds,:spades]
    ranks = [2,3,4,5,6,7,8,9,10,:jack,:queen,:king,:ace]
    suits.each do |suit|
      ranks.each do |rank| self << Card.new(suit,rank)
      end
    end
  end

end 

class Hand < Array

  def initialize

  end

end


####### Initialise the game
Game.start