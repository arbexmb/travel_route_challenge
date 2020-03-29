require 'csv'

def validate_user_input input
  return input.match(/[A-Z]{3}-[A-|]{3}$/) ? true : false
end

def split_user_input input
  return input.split('-')
end

def check_departure_and_arrival dep, arr
  check_dep = CSV.foreach('./app/input-routes.csv').detect { |row| row[0] == dep }
  check_arr = CSV.foreach('./app/input-routes.csv').detect { |row| row[1] == arr }
  return (check_dep == nil || check_arr == nil) ? false : true
end

def find_routes_from_departure departure
  routes = []

  CSV.foreach('./app/input-routes.csv').with_index do |row, i|
    if (row[0] == departure)
      routes.push( [ row[0], row[1], Integer(row[2]) ] )
    end
  end

  return routes
end

def find_next_destination routes_from_departure, destination
  routes_from_departure.map do |row|
    next if row[row.count - 2] == destination

    CSV.foreach('./app/input-routes.csv') do |row_two|
      next if row[row.count - 2] == destination
      if (row[row.count - 2] == row_two[0])
        row.append(row.pop + Integer(row_two.last))
        row.insert(-2, row_two[1])
      end
    end

  end
  return routes_from_departure
end

def find_next_destination_recursive routes, destination
  # Initialize empty array
  results = []
  # Loop and push result to results array
  loop do
    results.last.nil? ? loops = routes : loops = results.last
    result = find_next_destination loops, destination
    # If result equals last push to results, stop iteration
    if results.last == result
      # exlude routes which do not have the destination as final route
      final_routes = []
      results.last.each do |route|
        if(route.include?(destination))
          final_routes.append(route)
        end
      end
      return final_routes
      break
    else
      results.push(result)
    end
  end
end

def find_cheapest routes
  values = routes.map(&:last)
  route = routes.find { |a| a.last == values.min }
  return route
end

def best_route_string route
  last = '$' + route.pop.to_s
  return route.join(' - ') + ' > ' + last
end

def is_number? string
  true if Integer(string) rescue false
end

def price_validation price
  if(is_number?(price))
    int_price = price.to_i
    if int_price <= 0
      return false
    end
    return true
  end
  return false
end

def api_validation json
  is_hash = json.is_a?(Hash)
  has_route_key = json.key?('route')
  route_validation = validate_user_input json['route']
  has_price_key = json.key?('price')
  price_validation = price_validation json['price']

  if (is_hash && has_route_key && route_validation && has_price_key && price_validation)
    return true
  end

  return false
end

def csv_append user_input
  array = user_input['route'].split('-')
  price = user_input['price'].to_s
  array.append(price)
  begin
    CSV.open('./app/input-routes.csv', 'ab') do |csv|
      csv << array
    end
  rescue
    return false
  end
end

def api_cheapest user_input
  user_departure = split_user_input(user_input)[0]
  user_arrival = split_user_input(user_input)[1]

  # Check if departure and arrival airports exist in the collection (on the csv file)
  if(!check_departure_and_arrival user_departure, user_arrival)
    return false
  end

  # Find and push every route leaving from the departure airport
  routes_from_departure = find_routes_from_departure user_departure

  # Recursive add new destinations to route, until reach destination
  routes = find_next_destination_recursive routes_from_departure, user_arrival
  if routes.length < 1
    return false
  end

  # Find the best route inside the routes array
  best_route = find_cheapest routes

  return best_route_string(best_route)
end
