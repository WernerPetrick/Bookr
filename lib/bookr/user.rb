class User
  attr_reader :name, :age

  def initialize(name, age, password)
    @name = name
    @age = age
    @password = password
  end

  def can_watch?(movie)
    case movie.rating
    when "G"
      true
    when "PG"
      @age >= 10
    when "13"
      @age >= 13
    when "R"
      @age >= 17
    else
      false
    end
  end

end