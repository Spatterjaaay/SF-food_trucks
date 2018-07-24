#!/usr/bin/env ruby
require_relative 'food_truck'

# prints results in a table with apropriate headers (name, address)
def print_page(page)
  longest = page.collect { |truck| truck["applicant"].length }.max

  printf "%-#{longest}s %s\n", "NAME", "ADDRESS"
  puts "-" * (longest + 8)

  page.each do |truck|
    printf "%-#{longest}s %s\n", truck["applicant"], truck["location"]
  end
end

# start of the program
# creates a new foodtruck instance which loads data from the API
begin
  foodtruck = FoodTruck.new
rescue StandardError
  puts "OOPS. SOMETHING WENT WRONG WITH RETRIEVING THE DATA"
  exit
end

puts "WELCOME TO OPEN FOODTRUCKS SF"
puts "SEE BELOW LIST OF OPEN FOOD TRUCKS AT THIS TIME:\n\n"

# get the first page from the foodtruck instance
page = foodtruck.next_page

# print a message if no foodtrucks are open
if page == nil
  puts "NO FOODTRUCKS ARE OPEN"
  exit
end

# prints first page of up to 10 results
print_page(page)

# gets next batch of results, returns nil if no results are left
page = foodtruck.next_page

# if there are additional results, prompts user for input and displays them
while page
  puts "\nWould you like to see more results? [y]/n"
  if gets.chomp.downcase == "n"
    exit
  end
  print_page(page)
  page = foodtruck.next_page
end
