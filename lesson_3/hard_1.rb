#1
nil

#2
{:a=>"hi there"}

#3
A. "one is: one"
"two is: two"
"three is: three"

B. "one is: one"
"two is: two"
"three is: three"

C."one is: two"
"two is: three"
"three is: one"

#4
def dot_separated_ip_address?(input_string)
  dot_separated_words = input_string.split(".")
  while dot_separated_words.size == 4 do
    word = dot_separated_words.pop
    return true if is_an_ip_number?(word)
  end
  false
end