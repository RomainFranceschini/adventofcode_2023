instances = Hash(Int32, Int32).new(1)
instances[1] = 1
i = 1

File.each_line("#{__DIR__}/../input/day04") do |line|
  copies = (instances[i] ||= 1)
  drawn, chosen = line.split(':').last.split('|').map(&.strip.split.map(&.to_i).to_set)
  i += 1
  i.upto(i + (drawn & chosen).size - 1) { |i| instances[i] += copies }
end

puts instances.values[0, i].sum
