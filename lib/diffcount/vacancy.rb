class Vacancy < Particle

  @@number_of_vacancies = 0
  @@number_list = {}
  
  def initialize( initial_site )
    @@number_of_vacancies += 1
    @number = @@number_of_vacancies
    super( initial_site )
    @@number_list[@number] = self
    @previous_interstitial_site = @site.is_interstitial? ? @site : 0
  end
  
  def time_since_last_interstitial
    return ( $timestep - @path.init_time )
  end
  
  def reset_path
    @previous_interstitial_site = @site
    @path = Diffusion_Path.new( @site )
  end

  def check_for_hops
    Hop.active_hops.each do |hop|
      if hop.new_site == @site # vacancy has moved
        puts hop
        puts "Moving vacancy #{@number} from site: #{hop.new_site} to site: #{hop.old_site}"
        @site = hop.old_site
        # add the new site to the vacancy history
        @full_path.add_step( @site )
        @path.add_step( @site )
        if @site.is_interstitial? # 
          case @previous_interstitial_site
          when 0
            # do nothing
          when @site # we have returned to our original site
            puts "Vacancy #{@number} returned to site #{@site} in #{time_since_last_interstitial} steps"
          else
            puts "Vacancy #{@number} completed a diffusion event from #{@previous_interstitial_site} to #{@site} in #{time_since_last_interstitial} steps"
            puts @path
          end
        end
        Hop.make_hop_inactive( hop )
      end
    end
    reset_path if @site.is_interstitial?
  end

end
