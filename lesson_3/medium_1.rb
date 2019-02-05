#1
10.times { |number| puts (" " * number) + "The Flintstones Rock!" }

#2
This is because you can not add a string to integers.
To fix use string interpolation:
puts "the value of 40 + 2 is #{40 + 2}"
or puts "the valiue of 40 + 2 is " + (40+2).to_s

#3
def factors(number)
  divisor = number
  factors = []
  while divisor > 0 do
    factors << number / divisor if number % divisor == 0
    divisor -= 1
  end
  factors
end

puts factors(0)
puts factors(8)
puts factors(-22)


Bonus 1. number % divisor == 0 is used to only push numbers that do not have remainders,
  which makes them a factor of the original number
Bonus 2. this is the return value because it is the last line of code executed

#4
Using the buffer = input_array + [new_element] is creating a new array called buffer,
 not modifying existing input_array like buffer << new_element does

#5
The problem is that the method can not see the local varialbe called limit because it was
initialized outside of the method. This is fixed by putting the limit variable in the method like so:

def fib(first_num, second_num)
  limit = 15
  while first_num + second_num < limit
    sum = first_num + second_num
    first_num = second_num
    second_num = sum
  end
  sum
end

result = fib(0, 1)
puts "result is #{result}"

#6
def not_so_tricky_method(a_string_param, an_array_param)
  a_string_param += "rutabaga"
  an_array_param += ["rutabaga"]

  return a_string_param, an_array_param
end

my_string = "pumpkins"
my_array = ["pumpkins"]
my_string, my_array = not_so_tricky_method(my_string, my_array)

puts "My string looks like this now: #{my_string}"
puts "My array looks like this now: #{my_array}"

#7
34

#8
Yes, the data will be changed because although it looks like assignment, it is is really assigning
with element reference, which changes the original element. Instead, Spot could have assigned his
changes to a variable, which would have made a new reference, instead of a reference to the original
hash.

#9
paper

#10
'no'