sum = 0

File.each_line("#{__DIR__}/../input/day01") do |line|
  values = StaticArray(Int32, 2).new(-1)
  line.each_char
    .select(&.number?)
    .map(&.to_i)
    .with_index
    .each { |value, index| values[Math.min(1, index)] = value }
  values[1] = values[0] unless values.last > 0
  sum += values.first * 10 + values.last
end

puts sum