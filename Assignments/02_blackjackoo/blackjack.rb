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

  DEALER_MIN_AMOUNT_TO_HIT = 17
  BLACKJACK_NUMBER = 21
  DEALER_NAMES = %w[Raylene Pralene Shaneen Doreen Planteen Marlene Janine]

  attr_accessor :player,:dealer,:deck,:dealer_hand,:player_hand

  def initialize
    @dealer = choosedealer()
    puts "====== Welcome to Blackjack ======\n"
    puts ">> I'm your dealer, #{@dealer}, what's your name?"
    @player = gets.chomp
    puts
  end

  def choosedealer
    DEALER_NAMES.shuffle.pop
  end

  def start
    @turn = :player 
    @deck = Deck.new
    deal()
    puts "#{dealer} has dealt your hand and her own"
    puts "#{dealer}'s first card is hidden. Her second card is #{dealer_hand[1]}"
    whatnext()
  end

  def deal
    @player_hand = Hand.new
    @dealer_hand = Hand.new
    @deck.shuffle!
    2.times { @player_hand << @deck.pop }
    2.times { @dealer_hand << @deck.pop }
  end

  def whatnext
    set_temp_hand()
    case @turn
      when :player
        puts "Your hand looks like this:"
      when :dealer
        sleep(2)
        puts "#{@dealer}'s hand looks like this:"
      else error()
    end
    puts
    @temp_hand.each { |card| puts card }
    puts "\nFor a total of #{@temp_hand.value}"
    choose_hit_or_stay()
  end

  def choose_hit_or_stay
    @temp_hand.value >= BLACKJACK_NUMBER ? final_result : nil
    case @turn
      when :player
        puts "Would you like to hit or stay?"
        case gets.chomp.downcase
          when "hit", "h" then hit
          when "stay", "s" then stay
          else
            "Please type \"hit\" or \"stay\""
            choose_hit_or_stay()
        end  
      when :dealer
        if (@dealer_hand < DEALER_MIN_AMOUNT_TO_HIT) || (@dealer_hand > DEALER_MIN_AMOUNT_TO_HIT && @dealer_hand < BLACKJACK_NUMBER && @dealer_hand < @player_hand) then self.hit
        else stay
        end
    end
  end

  def set_temp_hand
    @temp_hand = Hand.new
    if @turn == :player 
      @temp_hand = @player_hand
    elsif @turn == :dealer 
      @temp_hand = @dealer_hand
    else @temp_hand = nil
    end
  end

  def hit
    case @turn
      when :player
        @player_hand << @deck.pop
      when :dealer
        @dealer_hand << @deck.pop
      else
        error(0001,"Must specify player or dealer")
    end
    whatnext()
  end

  def stay
    case @turn
      when :player
        puts "You stay, with a hand total of #{@player_hand.value}"
        @turn = :dealer
        whatnext()
      when :dealer
        puts "#{@dealer} stays, with a hand total of #{dealer_hand.value}"
        final_result()
    end
  end

  def final_result
    if @player_hand.value > BLACKJACK_NUMBER
      puts "Sorry, you bust! #{@dealer} wins!"
    elsif @dealer_hand.value > BLACKJACK_NUMBER
      puts "#{@dealer} busts - YOU WIN!"
    elsif @player_hand.value > @dealer_hand.value
      puts "With a total hand of #{@player_hand.value}, YOU WIN!"
    elsif @player_hand.value < @dealer_hand.value
      puts "With a total hand of #{@dealer_hand.value} to your #{@player_hand.value}, #{@dealer} wins!"
    else
      error(010,"Cannot determine the winner")
    end
    play_again()
  end

  def play_again(show_instructions=false)
    puts
    puts "Please type \"yes\" or \"no\"" if show_instructions
    puts "Would you like to play again?"
    case gets.chomp.downcase
      when "y", "yes", "uh huh", "uh-huh", "yep", "yip", "yessir", "i would", "definitely", "affirmative"
        puts "Great! Starting new game..."
        sleep(2)
        start
      when "n", "no", "nope", "nuh-uh", "nooo", "noo", "no way", "nosir", "unlikely"
        puts "OK, byeeeee!"
        sleep(2)
        exit
      else
        play_again(true)
    end
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

  attr_reader :total

  def initialize
    @total = 0
  end

  def value
    hand_running_total = 0
    self.each do |card|
      if card.rank.is_a?(Fixnum)
          hand_running_total += card.rank
      elsif card.rank == :jack || card.rank == :queen || card.rank == :king
          hand_running_total += 10
      elsif card.rank == :ace
          hand_running_total <= 10 ? hand_running_total += 11 : hand_running_total += 1
        else error(0005,"Must specify a valid card rank")
      end
    end
    @total = hand_running_total
  end

end


####### Initialise the game
currentgame = Game.new
currentgame.start