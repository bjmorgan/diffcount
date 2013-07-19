class Coordinate < Array

end

def dr( r1, r2 )
	Cell.minimum_image( r1.zip( r2 ).collect{ |i,j| j - i } )
end

