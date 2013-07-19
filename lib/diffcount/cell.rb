class Cell

	def self.init
		open_cell_file
		load_cell_data
	end

	def self.open_cell_file
		cell_file_name = 'cellbox.out'
		@file = File.new( cell_file_name, 'r' )
	end

	def self.load_cell_data
		data = []
		cell_file_name = 'cellbox.out'
		file = File.new( cell_file_name, 'r' )
		(0..3).each{ |line| data << file.readline.split.map{ |s| s.to_f } }
		@matrix = data[0..2]
		@lengths = data[3]
		# warn("This code only applies the Minimum Image Convention correctly to orthorhombic cells ")
	end

	def self.minimum_image( vec ) # only works for orthorhombic cells since we read Cartesian coordinates for the site centers
		Coordinate.new( vec.zip(@lengths).collect do |dr, length|
			dr -= length  if ( dr >  length / 2.0 )
			dr += length if ( dr < -length / 2.0 )
			dr
		end )
	end

end