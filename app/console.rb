require 'csv'
require './app/helpers.rb'

puts 'please enter the route: '
user_input = gets.chomp

# Check if user input is valid
if(!validate_user_input user_input)
  return puts 'Invalid data.'
end

# Split user input in array
user_departure = split_user_input(user_input)[0]
user_arrival = split_user_input(user_input)[1]

csv_path = './app/input-routes.csv'

# Check if departure and arrival airports exist in the collection (on the csv file)
if(!check_departure_and_arrival user_departure, user_arrival)
  return puts 'Impossible to define a route. Please, try again.'
end

# Find and push every route leaving from the departure airport
routes_from_departure = find_routes_from_departure user_departure

# Recursive add new destinations to route, until reach destination
routes = find_next_destination_recursive routes_from_departure, user_arrival
if routes.length < 1
  return puts 'Impossible to define a route. Please, try again.'
end


# Find the best route inside the routes array
best_route = find_cheapest routes

# print the best route to the console
puts 'best route: ' + best_route_string(best_route)
