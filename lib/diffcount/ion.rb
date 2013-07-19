require 'fileutils'

class Ion < Particle
      
  attr_reader :site
  attr_reader :hops
  attr_reader :number
  attr_reader :flags
    
  @@nions = 0
  @@diff_event_file = "diff_events.list"
  @@flags_file   = "flags.list"
  @@list = []

  def initialize( initial_site )
    @@nions += 1
    @number = @@nions
    @@list << self
    super( initial_site )
    @site.atom_arrives( self )
    @hops = []
    @previous_lattice_site = @site.is_lattice_site? ? @site : 0
    @flags = {}
  end
  
  def time_since_last_lattice
    return ( $timestep - @path.init_time )
  end
  
  def reset_path
    @previous_lattice_site = @site
    @path = Diffusion_Path.new( @site )
  end
  
  def update_site( site_number )
    @site = Site.from_number( site_number )
    if moved?
      puts "Ion #{@number} moved after #{time_since_last_move} steps, from site #{@previous_site} to #{@site}"
      @previous_site.atom_departs( self )
      @site.atom_arrives( self )
      @hops << Hop.new( @number, @previous_site, @site )
      # add the new site to the ion history
      @full_path.add_step( @site )
      @path.add_step( @site )
      @previous_site = @site
      if @site.is_lattice_site? # 
        case @previous_lattice_site 
        when 0
          # do nothing
        when @site # we have returned to our original site
          puts "Ion #{@number} returned to site #{@site} in #{time_since_last_lattice} steps"
        else
          record_event
        end
      end
    end
    reset_path if @site.is_lattice_site?
  end

  def record_event
    puts "Ion #{@number} completed a diffusion event from #{@previous_lattice_site} to #{@site} in #{time_since_last_lattice} steps"
    puts @path
    puts "dr = #{@path.vec.map{ |r| r.to_s }.join(' ') }"
    File.open( @@diff_event_file, 'a' ) { |io| io.write( "#{$timestep}: ion #{"%4d" % @number}:    #{@path.output}\n" ) } 
    mark_flags
  end

  def mark_flags
    (@path.init_time..$timestep).each{ |t| @flags[t] = true }
  end

  def puts_hops
    hops.each{ |hop| puts hop }
  end

  def moved?
    return (@site != @previous_site)
  end

  def time_since_last_move
    return ( $timestep - @full_path.history[-1].timestep )
  end

  def time_since_last_lattice
    return ( $timestep - @path.init_time )
  end

  def self.init_files
    FileUtils.rm( @@diff_event_file ) if File.exist?( @@diff_event_file )
    File.open( @@diff_event_file, 'w' ) 
  end

  def self.flags_at( step )
    @@list.collect{ |ion| ion.flags.has_key?( step ) ? '1' : '0' }.join(' ')
  end

  def self.write_flags( i_step, f_step )
    int_file = File.open( @@flags_file, 'w' )
    ( i_step..f_step ).each{ |step| int_file.puts( flags_at( step ) ) }
    int_file.close
  end

end
