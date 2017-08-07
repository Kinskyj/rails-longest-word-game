require 'open-uri'
require 'json'

class GameEngineController < ApplicationController

  def game
    @grid = generate_grid(9)
    @grid_display = display_grid(@grid)
  end

  def score
    @start_time = Time.parse(params[:start_time])
    @user_input = params[:user_input]
    @end_time = Time.now
    @grid_result = params[:grid_result]
    @result = run_game(@user_input, @grid_result, @start_time, @end_time)
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    alphabet = ("A".."Z").to_a
    grid = ""
    i = 1
    while i <= grid_size
      grid << alphabet[rand(0..25)]
      i = i + 1
    end

    return grid
  end

  def display_grid(grid)

    letter_string = ""

    grid.split("")[0..(grid.length-1)].each do |letter|
      letter_string += "#{letter} - "
    end

    letter_string += "#{grid[grid.length-1]}"

    return letter_string
  end

  def increment_hash(array_letter)
    hash_letter = {}

    array_letter.each do |letter|
      hash_letter.key?(letter) ? hash_letter[letter] += 1 : hash_letter[letter] = 1
    end

    return hash_letter
  end

  def check_dico?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word.downcase}"
    response_serialized = open(url).read
    response_hash = JSON.parse(response_serialized)

    return response_hash["found"]
  end

  def check_word_grid?(word, grid)
    word_hash = increment_hash(word.upcase.split(""))
    grid_hash = increment_hash(grid.split(""))

    result = word_hash.map do |letter, frequency|
      (frequency <= grid_hash[letter] ? true : false) if grid_hash.key?(letter)
    end

    return result.all?
  end

  def run_game(attempt, grid, start_time, end_time)
    # check word
    if check_dico?(attempt) && check_word_grid?(attempt, grid)
      # calculate the results
      score = "Your score: #{attempt.length - (end_time - start_time) / 10}"
      message = "Well done !"
    else
      score = 0
      check_dico?(attempt) ? message = "not in the grid" : message = "not an english word"
    end

    time = "Time taken to answer: #{end_time - start_time}"

    return { time: time, score: score, message: message }
  end
end
