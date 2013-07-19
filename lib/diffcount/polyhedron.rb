class Polyhedron

  attr_reader :number_bounds
  attr_reader :string

  def initialize( string, number_bounds, pos_filename )
    @string = string
    @number_bounds = number_bounds
    @pos_file = File.new( pos_filename, 'r' )
  end

  def get_coordinates
  	@pos_file.readline.split.map{ |string| string.to_f }
  end

end
