#!/usr/bin/ruby -w

def load_file( filename )
  begin
    read_in = File.new(filename, 'r')
  rescue
    abort "\"#{ filename }\" not found"
  end
end

executable_name = File.basename($PROGRAM_NAME)
abort "usage: #{executable_name} N_MOBILE_IONS N_LATTICE_SITES (oct|tet1|tets) [NSKIP]" if ARGV.length < 3
# Assume close-packed with 3D periodic boundary conditions
# ntet = nlattice*2
# noct = nlattice

Cell.init

nions    = ARGV[0].to_i # the number of mobile ions
nlattice = ARGV[1].to_i # the number of available lattice sites
siteid   = ARGV[2]      # index for defining the lattice site species
nskip    = ARGV[3].nil? ? 1 : ARGV[3].to_i

if (siteid == 'tets') # probably a better way of doing this if multiple site types count as lattice types
	nlattice /= 2
	nions -= nlattice
end

oct_def  = Polyhedron.new( 'oct', [-nlattice,-1], 'oct_c.out' ) # arguments: id_string, site_id_bounds, pos_filename
tet1_def = Polyhedron.new( 'tet1', [1, nlattice], 'tet1_c.out' )
tet2_def = Polyhedron.new( 'tet2', [nlattice+1, nlattice*2], 'tet2_c.out' )

oct = Site.init_from_bounds( oct_def )
tet1 = Site.init_from_bounds( tet1_def )
tet2 = Site.init_from_bounds( tet2_def )
sites = tet1 + tet2 + oct

case siteid
  when 'oct'
    Site.set_lattice_types( [ oct_def ] )
  when 'tet1'
    Site.set_lattice_types( [ tet1_def ] )
  when 'tets'
  	Site.set_lattice_types( [ tet1_def, tet2_def ] )
  else
    abort( "Sorry, I didn't recongise \"#{siteid}\" as a defect type.")
end

Ion.init_files

# read initial configuration from site data file

file = load_file( 'atoms_sites.dat' )
$frame = 0
$timestep = 0
# initialise ions
ions = file.gets.split[1..-1].collect { |site_number| Ion.new( Site.from_number( site_number.to_i) ) }
vacs = sites.collect{ |site| site.init_vacs }.compact

while ( tline = file.gets )
  $frame += 1
  next unless ( $frame % nskip == 0 )
  $timestep += 1
  break if tline.nil?
  puts "New Step: #{$timestep}"
  tline.split[1..-1].each_with_index do |site_number, index| 
    ions[index].update_site( site_number.to_i )
  end
  vacs.each{ |vacancy| vacancy.check_for_hops }
end

Ion.write_flags( 0, $timestep )
