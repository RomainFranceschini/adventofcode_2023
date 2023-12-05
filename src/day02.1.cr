LIMITS = {
  "red" => 12,
  "blue" => 14,
  "green" => 13,
}

sum = 0
File.each_line("#{__DIR__}/../input/day02") do |line|
  game, sets = line.split(':')
  skip = false

  sets.split(';') do |reveal|
    reveal.split(',').each do |cubes|
      number, color = cubes.strip.split(' ')
      if number.to_i > LIMITS[color]
        skip = true
        break
      end
    end
    next if skip
  end

  unless skip
    game_id = game.split(' ').last.to_i
    sum += game_id
  end
end
puts sum