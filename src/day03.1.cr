sum = 0
coordinates = [] of Point
digits = IO::Memory.new

record Size, width : Int32, height : Int32
record Point, x : Int32, y : Int32 do
  def each_adjacent(& : Point ->)
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        next if dx == 0 && dy == 0
        yield Point.new(x + dx, y + dy)
      end
    end
  end

  def within_bounds?(size : Size) : Bool
    (0...size.width).includes?(x) && (0...size.height).includes?(y)
  end
end

world = File.read("#{__DIR__}/../input/day03")
  .split('\n')
  .map(&.chars)
size = Size.new(world.first.size, world.size)

world.each_with_index do |row, y|
  row.each_with_index do |char, x|
    case char
    when .number?
      coordinates << Point.new(x, y)
      digits << char
    else
      unless coordinates.empty?
        any_symbol_around = coordinates.map { |point|
          has_symbol = false
          point.each_adjacent { |adjacent|
            next unless adjacent.within_bounds?(size)
            neighbour = world[adjacent.y][adjacent.x]
            next if neighbour.number? || neighbour == '.'
            has_symbol = true
            break
          }
          has_symbol
        }.any?

        sum += digits.to_s.to_i if any_symbol_around
      end

      coordinates.clear
      digits.clear
    end
  end
end

puts sum