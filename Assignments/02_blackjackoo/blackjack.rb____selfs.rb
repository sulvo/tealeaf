require 'pry'

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
    @turn = :player	
    @player = player
    @deck = Deck.new
    @dealer = self.choosedealer()
  end

  def deal
    @player_hand = Hand.new
    @dealer_hand = Hand.new
    @deck.shuffle.shuffle.shuffle!
    2.times do
      @player_hand << @deck.pop
      @dealer_hand << @deck.pop
    end
  end

  def hit
    case @turn
      when :player
        @player_hand << @deck.pop
        return_total(:player)
      when :dealer
        @dealer_hand << @deck.pop
        return_total(:dealer)
      else
        error(0001,"Must specify player or dealer")
    end
    whatnext
  end

  def stay
    case @turn
      when :player
        puts "You stay"
        @turn = :dealer
        self.whatnext
      when :dealer
        puts "#{@dealer} stays"
        self.finalise
    end
  end

  def self.cardvalue(card)
    whoseturn
    case
      when card.rank.is_a?(Fixnum)
        return card.rank
      when card.rank == :jack || card.rank == :queen || card.rank == :king
        return 10
      when card.rank == :ace
        return hand.value <= 10 ? 11 : 1
      else error(0002,"Must specify a valid card rank")
    end
  end

  def whoseturn
    hand = Hand.new
    case @turn
      when :player then hand = @player_hand
      when :dealer then hand = @dealer_hand
      else hand = nil
    end
  end

  def whatnext
    whoseturn()
    hand >= 21 ? self.finalise :
    @turn == :player ? "Your hand looks like this:" :
    @turn == :dealer ? "#{@dealer}'s hand looks like this:" :
    hand.each { |card| puts card }
    self.choosemove
  end

  def choosemove
    case @turn
      when :player
        puts "Would you like to hit or stay?"
        case gets.chomp.downcase
          when "hit", "h" then self.hit
          when "stay", "s" then self.stay
          else "Please type \"hit\" or \"stay\""
            choosemove
        end  
      when :dealer
        if (@dealer_hand < 17) || (@dealer_hand > 17 && @dealer_hand < 21 && @dealer_hand < @player_hand) then self.hit
        else stay
        end
        #### Add method to decide the dealer's next move #### 
    end
  end

  def self.start
    puts "====== Welcome to Blackjack ======\n"
    puts ">> What is your name?"
    playername = gets.chomp
    puts
    currentgame = Game.new(playername)
    currentgame.deal
    puts "#{self.dealer} has dealt your hand and her own"
    puts "Her hand is hidden"
    currentgame.whatnext("player")
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

  attr_accessor :value

  def initialize
  end

  def update_score
    #code
  end

  def value
    self.each do |card|
      @value += Game.cardvalue(card)
    end
  end



end


####### Initialise the game
Game.start