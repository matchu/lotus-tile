require 'pai_sho'
require 'tzinfo'

class PaiShoApp < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :haml, :format => :html5
  
  set :timezone, TZInfo::Timezone.get('America/New_York')
  set :pai_sho, PaiSho.new('http://www.korranation.com/')
  
  get '/' do
    pai_sho.load_tiles! if pai_sho_stale?
    haml :board
  end
  
  after do
    # Cache this request
    etag pai_sho_hash, :weak
    expires expiry_time, :public
    last_modified pai_sho.updated_at
  end
  
  STALE_INTERVAL = 10 * 60 # 10 minutes
  def expiry_time
    pai_sho.updated_at + STALE_INTERVAL
  end
  
  def pai_sho_hash_chr(i)
    (i + 65).chr
  end
  
  def pai_sho_hash
    pai_sho.tiles.map { |t| pai_sho_hash_chr(t.row) + pai_sho_hash_chr(t.col) }.join('')
  end
  
  def pai_sho_stale?
    if pai_sho.updated_at
      # If we already have tile data, check if it's expired yet
      Time.now > expiry_time
    else
      # If we don't have tile data, then, yes, our lack of data is stale
      true
    end
  end
  
  helpers do
    def human_time(datetime)
      settings.timezone.utc_to_local(datetime).strftime "%B %e, %l:%M%P EST"
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
