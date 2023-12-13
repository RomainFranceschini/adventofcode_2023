total = 0

File.each_line("#{__DIR__}/../input/day04") do |line|
  drawn, chosen = line.split(':').last.split('|').map(&.strip.split.map(&.to_i).to_set)
  winning = (drawn & chosen)
  next if winning.empty?
  total += 2 ** (winning.size - 1)
end

puts total
