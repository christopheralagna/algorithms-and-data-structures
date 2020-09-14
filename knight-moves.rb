
require 'pry'

class Chess
  attr_reader :coordinates, :graph

  def initialize()
    @coordinates = create_coordinates()
    @graph = build_graph()
  end

  def create_coordinates()
    coordinates = []
    for i in 0..7 do
      for j in 0..7 do
        coordinates.push([i,j])
      end
    end
    return coordinates
  end

  def build_graph()
    mapped_connections = []
    @coordinates.each do |coordinate|
      mapped_connections.push(Space.new(coordinate))
    end
    return mapped_connections
  end

end

class Space
  attr_reader :coordinate, :possible_moves

  def initialize(coordinate)
    @coordinate = coordinate
    @single_moves = [[1,2],[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1],[-2,1],[-1,2]]
    @possible_moves = get_connections()
  end

  def get_connections()
    possible_moves = []
    @single_moves.each do |move|
      new_x = @coordinate[0] + move[0]
      new_y = @coordinate[1] + move[1]
      unless new_x < 0 || new_x > 7 || new_y < 0 || new_y > 7
        possible_moves.push([new_x, new_y])
      end
    end
    return possible_moves
  end

end

class Knight

  def initialize(graph)
    @graph = graph
  end

  def knight_moves(current_space, end_space, original_space = current_space, route_data = [[],[]])
    #the first subarray in route_data holds the current route
    #the second subarray in route_data holds all valid sets of paths to end_space

    if current_space.is_a?(Array) && end_space.is_a?(Array)
      #turn initial coordinates into Space objects
      current_space = @graph.detect { |space| space.coordinate == current_space }
      end_space = @graph.detect { |space| space.coordinate == end_space }
      #original_space used to return results when recursion is complete
      original_space = current_space
    end

    if current_space == end_space
      #add current route to paths data. delete last element of current route.
      route_data[0] << current_space.coordinate
      route_data[1] << route_data[0]
      route_data[0] = route_data[0].slice(0,route_data[0].length-1)
      return route_data
    #knight can get anywhere across the board in 6 moves... it also saves plenty of computing power
    elsif route_data[0].length > 5
      return route_data
    #don't try the same space twice
    elsif route_data[0].include?(current_space.coordinate)
      return route_data
    end

    route_data[0] << current_space.coordinate

    current_space.possible_moves.each do |new_space|
      new_space = @graph.detect { |space| space.coordinate == new_space }
      route_data = knight_moves(new_space, end_space, original_space, route_data)
      #once completed all possible_moves for given current_space, remove the last element in current route
      if current_space.possible_moves[-1] == new_space.coordinate
        route_data[0] = route_data[0].slice(0,route_data[0].length-1)
      end
    end

    unless current_space == original_space
      return route_data
    else
      #takes the shortest path archived from recursion process
      shortest_route = route_data[1].min_by { |path| path.length }
      if shortest_route.length - 1 == 1
        puts "\nYou made it in 1 move! Here's your path:"
      else 
        puts "\nYou made it in #{shortest_route.length - 1} moves! Here's your path:"
      end
      shortest_route.each do |space|
        puts "\t#{space}"
      end
      puts "\n"
    end
  end
end

board = Chess.new()
knight = Knight.new(board.graph)

knight.knight_moves([0,0],[7,7])
