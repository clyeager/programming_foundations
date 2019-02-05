#1
ages.has_key?('Spot')
ages.include?('Spot')
ages.key?('Spot')

#2
munsters_description.swapcase!
munsters_description.capitalize!
munsters_description.downcase!
munsters_description.upcase!

#3
ages.merge!(additional_ages)

#4
advice.include? "Dino"

#5
flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

#6
flintstones.push("Dino")

#7
flintstones.concat(["Dino", "Hoppy"])

#8
advice.slice!(0, advice.index('house'))
slice does not mutate the advice string

#9
title.count('t')

#10
title.center(40)



