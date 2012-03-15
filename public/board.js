var container = $("#board-overlay");
var squares = [8, 12, 14, 16, 16, 18, 18, 18, 18, 18, 18, 18, 18, 16, 16, 14, 12, 8];
var diameter = squares.length;
var sqDimX = 34;
var sqDimY = 34;

// Build a tiles map such that TILES_MAP[row][col] returns true/false based on
// if there is a hidden tile present.

var TILES_MAP = [];
for(var i = 0; i < diameter; i++) {
  TILES_MAP[i] = [];
  for(var j = 0; j < squares[i]; j++) {
    TILES_MAP[i][j] = false;
  }
}


for(var i in TILES) {
  var tile = TILES[i];
  TILES_MAP[tile.row][tile.col] = true;
}

// Now, korra.js's board-building script, with a little extra to mark tiles.

for(var i = 0; i < diameter; i++) {
  var row = $("<div />").addClass("board-row").
    css({ "width": sqDimX * squares[i] });

  $(container).append(row);

  for(var j = 0; j < squares[i]; j++) {
    var square = $("<div />").addClass("board-square").
      css({ 'top': sqDimY * i, 'left': sqDimX * j }).
      attr({ "data-x": i, "data-y": j });
    
    if(TILES_MAP[i][j]) {
      square.addClass('hidden-tile');
    }
    
    $(row).append(square);
  }
}
