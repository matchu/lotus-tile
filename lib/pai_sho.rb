require 'open-uri'

class PaiSho
  attr_reader :updated_at, :tiles
  
  def initialize(url)
    @url = url
  end

  TILE_START_LINE = "var xoef = {};"
  TILE_COORD_FORMAT = /xoef\.khev([12]) = ([0-9]+)/

  # Grab the HTML of the Korra page and load the coordinates of the hidden
  # Pai Sho tiles
  def load_tiles!
    tiles = []
    
    open(@url) do |page|
      page.each_line do |line|
        if line.include? TILE_START_LINE
          tiles << Tile.new
        elsif line =~ TILE_COORD_FORMAT
          tile = tiles.last
          coord = $2.to_i
          if $1 == "1"
            tile.row = coord
          elsif $1 == "2"
            tile.col = coord
          end
        end
      end
    end
    
    @updated_at = Time.now.utc
    @tiles = tiles
  end
  
  class Tile
    attr_accessor :row, :col
  end
end
