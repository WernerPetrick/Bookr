require 'date'
require 'artii'
require 'colorize'
require 'tty-box'
require 'tty-prompt'
require_relative 'lib/bookr/movie'
require_relative 'lib/bookr/user'
require_relative 'lib/bookr/cinema'

prompt = TTY::Prompt.new

def quit
  puts "Thank you for using Bookr. Goodbye!".cyan
  exit
end

def receipt(movie, snack_items = nil, snack_total = 0)

  if movie.rating == "G" || movie.rating == "PG"
     movie_price = 12.55
  elsif movie.rating == "18"
     movie_price = 16.79
  else
    movie_price = 14.12
  end

  box_lines = []
  box_lines << "#{movie.title} (Movie) - $#{'%.2f' % movie_price}"

  if snack_items
    snack_items.each do |snack, data|
      box_lines << "#{snack}(#{data[:quantity]}) -- $#{'%.2f' % data[:total]}"
    end
  end

  font = Artii::Base.new font: 'small'
  title = font.asciify("Receipt")
  today = Time.now.strftime("%Y-%m-%d %H:%M") 
  box_content = title + "\n\n" + box_lines.join("\n") + "\n\nTotal: $#{'%.2f' % (movie_price + snack_total)}"
  box = TTY::Box.frame(width: 35, height: box_content.lines.count + 4, border: {top_left: :cross, top_right: :cross, bottom_left: :cross, bottom_right: :cross},  title: {top_left: "Bookr: Movie Booking System", bottom_right: today}) do
    box_content
  end
  puts box
end

def snacks_menu
  snacks = {
    Popcorn: 4.00,
    Slushie: 3.50,
    Smarties: 2.00,
    Astros: 2.00,
    Soda: 2.50,
  }

  puts "\n---- Snacks Menu ----\n".underline
  snacks.each do |snack, price| 
    puts "#{snack}: $ #{'%.2f' % price}"
  end

  print "\n=> Please enter the snacks you want (comma separated): ".yellow
  selected_snacks = gets.chomp.split(",").map(&:strip)

  snack_counts = selected_snacks.tally 
  receipt_items = {}
  snack_counts.each do |snack, count|
    price = snacks[snack.to_sym] || 0
    receipt_items[snack] = {quantity: count, total: price * count}
  end

  total = receipt_items.values.sum { |item| item[:total] }

  return receipt_items, total
end

def book_seat(selected)

  cinema = Cinema.new 

  if selected
    puts "Please select an open seat from the seating chart.".bold
    puts "\n---- Seating Chart ----\n".underline
    cinema.seating_chart
  else
    puts "Your seat number is number A8"
  end
end

def booking_menu(movie_choice)
  prompt = TTY::Prompt.new

  puts "\nBooking Menu for #{movie_choice.title}\n".underline.green

  seat_choice = prompt.yes?("Would you like to select a seat?")

  if seat_choice
    book_seat(true)
  else
    book_seat(false)
  end

  snack_items = {}
  snack_total = 0
  snack_choice = prompt.yes?("Would you like to buy snacks for the movie?")
  
  if snack_choice
    snack_items, snack_total = snacks_menu
  else 
    puts "No snacks selected. Enjoy the movie!"
  end

  receipt(movie_choice, snack_items, snack_total)
end

def select_movie(movies)
  available_movies(movies)
  print "\n=> Please select the movie number you want to book: ".yellow
  movie_choice = gets.chomp.to_i - 1
  booking_menu(movies[movie_choice])
end

def available_movies(movies)
  puts "\nCurrently Showing:\n".underline
  movies.each_with_index do |movie, index|
    puts "#{index + 1}. 🎬 #{movie.title} (#{movie.year}) - #{movie.rating}"
  end
end

def main_menu(user)

  movies = [
    Movie.new("The Lion King", "Animation", 1994, "G"),
    Movie.new("The Avengers", "Action", 2012, "13"),
    Movie.new("The Dark Knight", "Action", 2008, "13"),
    Movie.new("Inception", "Sci-Fi", 2010, "13"),
  ]

  puts "\n" + "-"*30
  puts "Welcome, #{user.name}!".center(30, " 🎬 ")
  puts "What would you like to do today?\n"

  puts "1. View Movies".green
  puts "2. Book a Movie".green
  puts "3. Exit".red

  print "\n=> Choose an option: ".yellow
  choice = gets.chomp

  if choice == "1"
    available_movies(movies)
    main_menu(user)
  elsif choice == "2"
    select_movie(movies)
  elsif choice == "3"
    quit
  end
end

a = Artii::Base.new font: 'slant'
title = a.asciify('Bookr')

puts title

puts "Create Account or Sign Up\n".underline

puts "1. Create Account".green
puts "2. Sign Up".green
puts "3. Exit".red

user_response = gets.chomp

case user_response
when "1"
  name = prompt.ask("Please enter your name: ")
  age = prompt.ask("Please enter your age: ")
  password = prompt.mask("Type in a password: ")
  user = User.new(name, age, password)
  puts "Account created successfully!".green
  main_menu(user)
when "2"
  name = prompt.ask("=> Name: ")
  password = prompt.mask("=> Password: ")
  quit
when "3"
  quit
end