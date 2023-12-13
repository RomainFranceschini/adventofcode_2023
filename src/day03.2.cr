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

  def left(size : Size) : self?
    return nil unless x - 1 >= 0
    Point.new(x - 1, y)
  end

  def right(size : Size) : self?
    return nil unless x + 1 < size.width
    Point.new(x + 1, y)
  end
end

world = File.read("#{__DIR__}/../input/day03")
  .split('\n')
  .map(&.chars)
size = Size.new(world.first.size, world.size)
coordinates = [] of Point
visited = Set(Point).new
chars = [] of Char
sum = 0i64
values = [] of Int32

world.each_with_index do |row, y|
  row.each_with_index do |char, x|
    next unless char == '*'
    point = Point.new(x, y)

    point.each_adjacent do |adjacent|
      next unless adjacent.within_bounds?(size)
      if world[adjacent.y][adjacent.x].number?
        coordinates << adjacent
      end
    end

    coordinates.each do |adjacent|
      next if visited.includes?(adjacent)

      visited << adjacent
      chars << world[adjacent.y][adjacent.x]

      left = adjacent
      while left = left.left(size)
        break if visited.includes?(left)
        visited << left
        left_char = world[left.y][left.x]
        break unless left_char.number?
        chars.insert(0, left_char)
      end

      right = adjacent
      while right = right.right(size)
        break if visited.includes?(right)
        visited << right
        right_char = world[right.y][right.x]
        break unless right_char.number?
        chars << right_char
      end

      values << chars.join.to_i
      chars.clear
    end

    puts values
    sum += values.product if values.size == 2

    visited.clear
    values.clear
    coordinates.clear
  end
end

puts sum