class Particle

  def initialize( site )
    @site = site
    @previous_site = @site 
    @full_path = Diffusion_Path.new( @site )
    @path = Diffusion_Path.new( @site )
    @previous_lattice_site = @site.is_lattice_site? ? @site : 0
  end

end
