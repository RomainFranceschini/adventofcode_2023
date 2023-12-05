sum = 0
File.each_line("#{__DIR__}/../input/day02") do |line|
  game, sets = line.split(':')
  skip = false
  values = { "red" => 0, "blue" => 0, "green" => 0 }
  sets.split(';') do |reveal|
    reveal.split(',').each do |cubes|
      number, color = cubes.strip.split(' ')
      values[color] = Math.max(values[color], number.to_i)
    end
  end
  sum += values.values.product
end
puts sum