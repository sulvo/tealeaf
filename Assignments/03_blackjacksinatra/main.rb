require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true


helpers do

  DEALER_MIN_AMOUNT_TO_HIT = 17
  BLACKJACK_NUMBER = 21
  DEALER_NAMES = %w[Raylene Pralene Shaneen Doreen Planteen Marlene Janine]

  attr_accessor :player,:dealer,:deck,:dealer_hand,:player_hand

  def choosedealer
    DEALER_NAMES.shuffle.pop
  end

  def start
    session[:turn] = :player 
    session[:deck] = Deck.new
    deal()
    whatnext()
  end

  def deal
    session[:player_hand] = Hand.new
    session[:dealer_hand] = Hand.new
    session[:deck].shuffle!
    2.times { session[:player_hand] << session[:deck].pop }
    2.times { session[:dealer_hand] << session[:deck].pop }
  end

  def whatnext
  	set_temp_hand()
  	if session[:temp_hand].value >= BLACKJACK_NUMBER
  		final_result()
  	else
    	erb :play
    end
  end

  def choose_hit_or_stay
    session[:temp_hand].value >= BLACKJACK_NUMBER ? final_result : nil
    case session[:turn]
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
        if (session[:dealer_hand] < DEALER_MIN_AMOUNT_TO_HIT) || (session[:dealer_hand] > DEALER_MIN_AMOUNT_TO_HIT && session[:dealer_hand] < BLACKJACK_NUMBER && session[:dealer_hand] < session[:player_hand]) then self.hit
        else stay
        end
    end
  end

  def set_temp_hand
    session[:temp_hand] = Hand.new
    if session[:turn] == :player 
      session[:temp_hand] = session[:player_hand]
    elsif session[:turn] == :dealer 
      session[:temp_hand] = session[:dealer_hand]
    else session[:temp_hand] = nil
    end
  end

  def hit
    case session[:turn]
      when :player
        session[:player_hand] << session[:deck].pop
      when :dealer
        session[:dealer_hand] << session[:deck].pop
      else
        error(0001,"Must specify player or dealer")
    end
    whatnext()
  end

  def stay
    case session[:turn]
      when :player
        session[:turn] = :dealer
        whatnext()
      when :dealer
        puts "#{session[:dealer]} stays, with a hand total of #{session[:dealer_hand].value}"
        final_result()
    end
  end

  def final_result
 
    if session[:player_hand].value > BLACKJACK_NUMBER
      message = "Sorry, you bust! #{session[:dealer]} wins!"
    elsif session[:dealer_hand].value > BLACKJACK_NUMBER
      message = "#{session[:dealer]} busts - YOU WIN!"
    elsif session[:player_hand].value > session[:dealer_hand].value
      message = "With a total hand of #{session[:player_hand].value}, YOU WIN!"
    elsif session[:player_hand].value < session[:dealer_hand].value
      message = "With a total hand of #{session[:dealer_hand].value} to your #{session[:player_hand].value}, #{session[:dealer]} wins!"
    else
      error(010,"Cannot determine the winner")
    end
 
 #   erb :final_result
 	"Final Result Page"

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

  def to_image
  	self.suit.to_s + "_" + self.rank.to_s + ".png"
  end

end


## ROUTES ##

get '/' do
	if session[:user] == true
		redirect '/play'
	else
		redirect '/login'
	end
end

get '/login' do
	erb :login
end

post '/login' do
	session[:user] = params['user'].capitalize
	redirect '/play'
end

get '/play' do
	if !session[:user].nil?
		session[:dealer] = choosedealer()
		erb :start
	else
		redirect '/login'
	end
end

post '/play' do
	if params['startgame']
		start()
	elsif params['player_action'] == "hit"
		hit()
	elsif params['player_action'] == "stay"
		stay()
	else
		redirect '/play'
	end
end




=begin
get('/') do
	"Hello world, it's #{Time.now.strftime("%H:%M%p, %A %d %B %Y")}"
end

get('/template') do
	erb :template
end

get('/template/nested') do
	erb :'/templates/nested'
end

get('/form') do
	erb :'/templates/form'
end

post '/form001' do
	@user = params['user']
	@class = params['class']
	binding.pry
end
=end
