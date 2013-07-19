class Step
    
  attr_reader :timestep 
  attr_reader :site

  def initialize( timestep, site )
    @timestep = timestep
    @site = site
  end

  def to_s
    "#{timestep} : #{site}"
  end

end
