puts "Welcome to the calculator"
puts "-------------------------"
print "Enter your first number: "
num1 = gets.chomp.to_f
print "What's the second number after #{num1}?"
num2 = gets.chomp.to_f
puts "Great, what operation should we carry out on #{num1} and #{num2}?"
puts "1) Add   2) Subtract   3) Multiply   4) Divide"

case gets.chomp.to_i
	when 1
		ans = num1 + num2
	when 2
		ans = num1 - num2
	when 3
		ans = num1 * num2
	when 4
		ans = num1 / num2
	else
		ans = false
end

puts ans ? "The answer is #{ans}" : "You did not choose a number between 1 and 4"