class Diffusion_Path
        
  attr_reader :history
  attr_reader :init_time
            
  def initialize( initial_site )
    @history = [Step.new(0, initial_site)]
    @init_time = $timestep
  end     
        
  def add_step( site )
    @history << Step.new($timestep - @init_time, site)
  end
  
  def to_s
    @history.collect{ |step| "(#{@init_time + step.timestep}) #{step.to_s}" }.join("\n")
  end

  def output
    init_site = @history[0].site
    final_site = @history[-1].site
    intermediate_sites = history[1..-2]
    "#{"%5d" % init_site.to_s} => #{ "%5d" % final_site.to_s } ( #{ intermediate_sites.collect{ |step| step.site }.join(' ') } ) [ #{vec.map{ |r| "%5.2f" % r.to_s }.join(' ')} ]"
  end

  def vec
    init_site = @history[0].site
    final_site = @history[-1].site
    p init_site.init_pos
    p final_site.init_pos
    dr(init_site.init_pos, final_site.init_pos)
  end
  
end