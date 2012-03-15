require 'pai_sho'

class PaiShoApp < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :haml, :format => :html5
  
  set :pai_sho, PaiSho.new('http://www.korranation.com/')
  
  get '/' do
    pai_sho.load_tiles! if pai_sho_stale?
    haml :board
  end
  
  STALE_INTERVAL = 10 * 60 # 10 minutes
  def pai_sho_stale?
    if pai_sho.updated_at
      # If we already have tile data, check if it's expired yet
      expiry_time = pai_sho.updated_at + STALE_INTERVAL
      Time.now > expiry_time
    else
      # If we don't have tile data, then, yes, our lack of data is stale
      true
    end
  end
  
  helpers do
    def human_time(datetime)
      datetime.strftime "%B %e, %l:%M%P"
    end
    
    def include_tiles_javascript
      tile_hashes = pai_sho.tiles.map { |t| "{row: #{t.row}, col: #{t.col}}" }
      tiles_json = "[#{tile_hashes.join(',')}]"
      "<script type='text/javascript'>var TILES = #{tiles_json}</script>"
    end
    
    def pai_sho
      settings.pai_sho
    end
  end
end
