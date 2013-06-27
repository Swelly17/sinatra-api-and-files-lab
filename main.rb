require 'rubygems'
require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'imdb'

get '/' do
 f = File.new('films.csv', 'r')
@films =[]
f.each do |comma|
  @films << comma.split(',')
  end
erb :index
end

get '/film/:title' do
  @indi_film = params[:title]
  film_info = File.new('films.csv', 'r')
  @film_info = []
  film_info.each do |comma|
    if comma.split(',')[0] == @indi_film then
      @film_info = comma.split(',')
    end
  end
  film_info.close
  puts @film_info.inspect
erb :indi_film
end

get '/new_film' do
  erb :new_film
end

post '/new_film' do
  @new_film = params[:title]
  @film = Imdb::Search.new(@title).movies.first
  @title = new_film.title
  @release = new_film.release_date
  @director = new_film.director
  @poster = new_film.poster

  output_file = File.new('films.csv', 'a+')
  output_file.puts("#{@new_film},#{@title}, #{@releae}, #{@director}, #{@poster}")
  output_file.close

  redirect to("/film/#{URI::encode(@title)}")
 end

  # #This will send you to the newly created movie
  # redirect to("/movie/#{URI::encode(@title)}")
