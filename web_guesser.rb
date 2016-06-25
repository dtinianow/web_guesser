require 'sinatra'
require 'sinatra/reloader'

set :remaining_guesses => 5, :secret_num => rand(100)

get '/' do
  guess = params["guess"].to_i
  cheat = params["cheat"]
  message, color = count_guesses(guess)
  message, color = cheat_mode(guess) if cheat
  erb :index, :locals => {:message => message,
                          :color => color}
end

def reset_game
  settings.secret_num = rand(100)
  settings.remaining_guesses = 5
end

def count_guesses(guess)
  if settings.remaining_guesses == 0 && guess != settings.secret_num
    reset_game
    ["You've lost! A new number has been generated.", 'orange']
  else
    settings.remaining_guesses -= 1
    check_guess(guess)
  end
end

def check_guess(guess)
  if guess - 5 > settings.secret_num
    ["Way too high!", 'red']
  elsif guess + 5 < settings.secret_num
    ["Way too low!", 'red']
  elsif guess > settings.secret_num
    ["Too high!", 'tomato']
  elsif guess < settings.secret_num
    ["Too low!", 'tomato']
  else
    reset_game
    ["You got it right!<br><br>
      The SECRET NUMBER is #{guess}", 'green']
  end
end

def cheat_mode(guess)
  ["The SECRET NUMBER is #{settings.secret_num}", "silver"]
end
