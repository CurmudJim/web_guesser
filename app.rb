require 'sinatra'
require 'sinatra/reloader'

number = rand(40)

get '/' do
  @number = number
  erb :index
end
