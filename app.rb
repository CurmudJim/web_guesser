require 'sinatra'
require 'sinatra/reloader' if development?
enable :sessions

SECRET_NUMBER = rand(1..100)
@@guess_limit = 5
@@guesses = Array.new

def check(number, guesses)
  if number > SECRET_NUMBER
    direction = "high"
  else
    direction = "low"
  end

  if number > 0
    if number == SECRET_NUMBER
      @color = "lightgreen"
      return "You got it!"
    elsif guesses.include?(number)
      @color = "lightgray"
      return "You already guessed that!"
    elsif (SECRET_NUMBER - number).abs > 5
      @color = "lightcoral"
      return "Way too #{direction}!"
    else
      @color = "lightyellow"
      return "Too #{direction}."
    end
  end
end

get '/' do
  default_message = "Enter a valid number (1-100)"
  guess = params['guess'].to_i
  @color = "lightblue"
  if guess <= 0
    @message = default_message
  else
    @message = check(guess , @@guesses)
  end

  if guess >= 1 && !@@guesses.include?(guess)
    @@guesses.push(guess)
    @@guess_limit -= 1
  end

  if params['cheat'] == "Cheat"
    @color = "red"
    @message = "Enter #{SECRET_NUMBER}, CHEATER!"
  end


  if params['reset'] || @@guess_limit == 0
    if @@guess_limit == 0
      @message = "Try Again!"
    else
      @message = default_message
    end
    SECRET_NUMBER = rand(1..100)
    @@guess_limit = 5
    @@guesses = Array.new
    @color = "lightblue"
  end

  erb :index
end
