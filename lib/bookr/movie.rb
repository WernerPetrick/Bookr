class Movie
  attr_reader :title, :genre, :year, :rating

  def initialize(title, genre, year, rating = "PG")
    @title = title
    @genre = genre
    @year = year
    @rating = rating
  end

  def to_s
    "#{@title} - #{@genre} - #{@year} - #{@rating}"
  end
end