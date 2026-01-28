class Cinema

  attr_reader :seating_chart, :rows, :seats_per_row

  def initialize(rows = ("A" .. "T").to_a, seats_per_row = 25)
    @rows = rows
    @seats_per_row = seats_per_row
    @seating_chart = generate_seating_chart
  end

  def generate_seating_chart
    chart = {}
    @rows.each do |row|
      chart[row] = Array.new(@seats_per_row, ' ')
    end
    chart
  end
  
end