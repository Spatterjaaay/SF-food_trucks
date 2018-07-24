# Food Trucks in SF

A command-line program that prints out a list of food trucks currently open in San Francisco, CA. The source of food truck data is [San Francisco government’s API](https://dev.socrata.com/foundry/data.sfgov.org/bbb8-hzi6) powered by Socrata.

## Requirements:
* [Ruby 2.0.0](https://www.ruby-lang.org/en/documentation/installation/) or higher
* [RubyGems 2.7.6](https://rubygems.org/pages/download) or higher

## Installing Dependencies:
```
gem install httparty
```

## To run this program:

1. clone this repository
2. navigate to the folder where the show-open-food-trucks.rb is saved and run it
3. if there are more than 10 food trucks, you will be prompted to show more pages, press enter to see more trucks, or hit "n" to exit

```
$ ruby show-open-food-trucks.rb
WELCOME TO OPEN FOODTRUCKS SF
SEE BELOW LIST OF OPEN FOOD TRUCKS AT THIS TIME:

NAME               ADDRESS
--------------------------
Annie's Hot Dogs   800 MARKET ST
Annie's Hot Dogs   870 MARKET ST
Annie's Hot Dogs   101 STOCKTON ST
Athena SF Gyro     699 08TH ST
Bay Area Dots      900 BEACH ST
Bay Area Dots      567 BAY ST
Bob Johnson        Assessors Block 0733/Lot010
Bob Johnson        1709 REVERE AVE
CC Acquisition     298 MARKET ST
Creme Brulee To Go 801 MARKET ST

Would you like to see more results? [y]/n
```

## If it were a full-scale web application:

The terminal application has two core parts, the FoodTruck library and the show-open-foodtrucks script. If I were to build a full web application, I'd keep the FoodTruck library with some modifications. I'd have to replace next_page function with a function that accepts a page number argument and returns the numbered page, because the HTTP protocol is stateless (whereas in the terminal program I can track the page number as an instance variable). Assuming I have a web application, I have to track the user's position in the list elsewhere, for example in a session or the url parameters, and pass this position to the page function as an argument. Also rather than asking the user for input to display the next page, I would use a pagination library to select and display pages of results with next and previous links.


The show-open-foodtrucks script is mostly terminal mode IO, so very little of it is reusable. Instead, I'd use a web framework, like Rails, to interface with the browser. The output would be structured in html or json, rather than plaintext. Instead of the print_page function I'd implement a view that printed a page of results. Furthermore, rather than creating a FoodTruck instance when the program starts, I'd create an instance of it when I receive a request. The response from the API would be cached, so we do not overload the server and help with the latency of the response. The FoodTruck class would need to be modified to load the cached results if they are present and valid, or make an API request if they are expired. One of the ways to determine when the FoodTruck data is valid would be to look when the food trucks generally close and open (is it on every hour or half hour, for example) and update the cache based on that schedule.
