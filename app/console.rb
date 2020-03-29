require 'csv'

puts 'please enter the route: '
user_input = gets.chomp

# Check if user input is valid
if !user_input.match(/[A-Z]{3}-[A-|]{3}$/)
  return puts 'Invalid data.'
end

# Split user input in array
array = user_input.split('-')
user_departure = array[0]
user_arrival = array[1]

csv_path = './app/input-routes.csv'

# Check if departure and arrival airports exist in the collection (on the csv file)
check_departure = CSV.foreach(csv_path).detect { |departure, arrival| departure == user_departure }
check_arrival = CSV.foreach(csv_path).detect { |departure, arrival| arrival == user_arrival }
if (check_departure == nil || check_arrival == nil)
  return puts 'Impossible to define a route. Please, try again.'
end

# Find and push every route leaving from the departure airport
routes = []
CSV.foreach(csv_path).with_index do |row, i|
  if (row[0] == user_departure)
    routes.push( [ row[0], row[1], Integer(row[2]) ] )
  end
end

# Function to add the next path of the route
def search_routes array, destination
  array.map do |row|
    next if row[row.count - 2] == destination

    CSV.foreach('./app/input-routes.csv') do |row_two|
      next if row[row.count - 2] == destination
      if (row[row.count - 2] == row_two[0])
        row.append(row.pop + Integer(row_two.last))
        row.insert(-2, row_two[1])
      end
    end
  end

  return array
end

# Recursive function to add next path until arrive to the destination
def recursive_search array, destination
  # Initialize empty array
  results = []
  # Loop and push result to results array
  loop do
    results.last.nil? ? loops = array : loops = results.last
    result = search_routes loops, destination
    # If result equals last push to results stop iteration
    if results.last == result
      return result
      break
    else
      results.push(result)
    end
  end
  return results.last
  # exlude routes which do not have the destination as final route
  final_routes = []
  results.last.each do |route|
    if(route.include?(destination))
      final_routes.append(route)
    end
  end
  return final_routes
end

# Function to fetch the cheapest travel route
def find_cheapest array
  values = array.map(&:last)
  route = array.find { |a| a.last == values.min }
  return route
end

# Function to make a string to run on bash
def to_string array
  last = '$' + array.pop.to_s
  return array.join(' - ') + ' > ' + last
end

routes = recursive_search routes, user_arrival
best_route = find_cheapest routes

puts 'best route: ' + to_string(best_route)
