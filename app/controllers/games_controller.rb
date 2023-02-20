require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('a'..'z').to_a.sample() }
    @time = Time.now
  end

  def score
    # compute score and store in a var
    answer = params[:attempt].chars
    grid = params[:letters].split(' ')
    time = Time.parse(params[:time])
    url = "https://wagon-dictionary.herokuapp.com/#{params[:attempt]}"
    data = JSON.parse(URI.open(url).read)
    session[:tries] = session[:tries] || 1
    session[:tries] += 1
    session[:total_score] = session[:total_score] || 0

    if data['found']
      if answer.all? { |x| answer.count(x) <= grid.count(x) }
        @response = 'Great job, its a real word that matches the grid'
        @score = (100 / (Time.now - time)) * answer.length
        session[:total_score] += @score
      else
        @response = "Its a real word but doesn't match the grid"
        @score = 0
      end
    else
      @response = 'the word is not found'
      @score = 0
    end
  end
end
