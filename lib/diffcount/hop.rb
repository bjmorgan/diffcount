class Hop

  @@ion_hops = []
  @@active_hops = []

  attr_reader :ion_number
  attr_reader :old_site
  attr_reader :new_site

  def initialize( ion_number, old_site, new_site )
    @ion_number = ion_number
    @old_site = old_site
    @new_site = new_site
    @timestep = $timestep
    @@ion_hops[@timestep] ||= []
    @@ion_hops[@timestep] << self
    @@active_hops << self
  end

  def to_s
    "#{@timestep}: #{@old_site} -> #{@new_site}"
  end

  def self.all_at_time( timestep )
    @@ion_hops[timestep].each{ |hop| puts "ion #{hop.ion_number}: #{hop.old_site} -> #{hop.new_site}" }
  end

  def self.make_hop_inactive( hop )
    @@active_hops.delete( hop )
  end

  def self.active_hops
    @@active_hops
  end

end
