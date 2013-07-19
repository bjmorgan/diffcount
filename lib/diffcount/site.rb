class Site
  
  attr_reader :site_type
  attr_reader :number
  attr_reader :path
  attr_reader :init_pos
  attr_reader :occupied_by
  
  @@number_list = {}
  
  def init_vacs
    Vacancy.new( self ) unless occupied?
  end
  
  def occupied?
    ! @occupied_by.empty?
  end

  def self.set_lattice_types( types )
    @@lattice_types = types
  end

  def self.init_from_bounds( type )
    r = type.number_bounds
    low = r.map{ |a| a.abs }.min
    high = r.map{ |a| a.abs }.max
    (low..high).collect{ |n| Site.new( r[0].sign * n, type ) }
  end

  def self.from_number( number )
    @@number_list[ number ]
  end

  def initialize( number, type )
    @number = number
    p number
    @site_type = type
    @@number_list[@number] = self
    @occupied_by = []
    @init_pos = Coordinate.new(site_type.get_coordinates)
  end

  def atom_arrives( atom )
    @occupied_by << atom
  end

  def atom_departs( atom )
    @occupied_by.delete( atom )
  end

  def occupied_by
    @occupied_by.collect{ |atom| atom.number }
  end

  def is_lattice_site?
    return ( @@lattice_types.include?( @site_type ) )
  end
  
  def is_interstitial?
    return !is_lattice_site?
  end

  def to_s
    @number.to_s
  end

end

class Fixnum

  def sign
    self <=> 0.0
  end

end
