// Store a reference to the window
var window;

// Store the selected tab
var selectedTab;

// Store the number of editable tiles (this will depend on the amount of tiles free after adding sprites)
var noTilesX = 16;
var noTilesY = 8;

// Store the number of map tiles
var noMapTilesX = 200;
var noMapTilesY = 13;

// Store the hex data for the tiles and map
var editorData = { "tiles" : "<-- PASTE TILE DATA HERE -->", "map" : "<-- PASTE MAP DATA HERE -->" };
var tileData = Array(noTilesX * noTilesY);
var mapData = Array(noMapTilesX * noMapTilesY);

// Store offset vertical and horizontal (for scroll wheel)
var offsetTiles = 0;
var offsetMap = 0;

// Set pixel colours
var pixelColours = { "00":255, "01":170, "10":85, "11":0 };

function setup() {
    
    holder = document.getElementById("canvasHolder");
    
    var canvas = createCanvas(holder.offsetWidth, holder.offsetHeight);
    canvas.parent("canvasHolder");
    
    selectTab("tiles");
    initEditorTextChangeListener();
    
}

function draw() {
    
    clear();
    
    if (selectedTab == "tiles") {
        drawTiles();
    } else {
        drawLevelMap();
    }
    
}

function drawTiles() {
    drawTileGrid();
}

function drawLevelMap() {
    drawMapGrid();
}

function selectTab(tab) {
    selectedTab = tab;
    
    document.getElementById("tiles").classList.remove("selected");
    document.getElementById("map").classList.remove("selected");
    document.getElementById(tab).classList.add("selected");
    
    document.getElementById("editorText").value = editorData[tab];
}

function initEditorTextChangeListener() {
    document.getElementById("editorText").addEventListener("change", (event) => {
        var newData = event.target.value.replaceAll("\n\n",",").toUpperCase();
        editorData[selectedTab] = newData;
        document.getElementById("editorText").value = newData;
        if (selectedTab == "tiles") decodeTileData(newData);
        else decodeMapData(newData);
    });
}

function drawTileGrid() {
    for (var i = 0; i < noTilesX; i++) {
        for (var j = 0; j < noTilesY; j++) {
            drawTile(i, j, holder.offsetWidth / noTilesX, holder.offsetWidth / noTilesX, noTilesY);
        }
    }
}

function drawTile(x, y, width, height) {
    stroke(0,0,0);
    drawRect(x * width, y * height, width, height, 255);
    var rowData = tileData[y * noTilesX + x];
    if (rowData) {
        var pixelWidth = width / 8;
        var pixelHeight = height / 8;
        for (var i = 0; i < 8; i++) {
            for (var j = 0; j < 8; j++) {
                noStroke();
                drawRect(x * width + j * pixelWidth, y * height + i * pixelHeight, pixelWidth, pixelHeight, pixelColours[rowData[i * 8 + j]]);
            }
        }
    }
}

function drawMapGrid() {
    for (var i = 0; i < noMapTilesX; i++) {
        for (var j = 0; j < noMapTilesY; j++) {
            drawMapTile(i, j, holder.offsetHeight / noMapTilesY, holder.offsetHeight / noMapTilesY, noMapTilesY);
        }
    }
}

function drawMapTile(x, y, width, height) {
    stroke(0,0,0);
    drawRect(offsetMap + x * width, y * height, width, height, 255);
    var column = mapData[x];
    if (column) {
        var tilePos = column[y];
        if (tilePos) {
            var rowData = tileData[tilePos];
            if (rowData) {
                var pixelWidth = width / 8;
                var pixelHeight = height / 8;
                for (var i = 0; i < 8; i++) {
                    for (var j = 0; j < 8; j++) {
                        noStroke();
                        drawRect(offsetMap + x * width + j * pixelWidth, y * height + i * pixelHeight, pixelWidth, pixelHeight, pixelColours[rowData[i * 8 + j]]);
                    }
                }
            }
        }
    }
}

function drawRect(x, y, width, height, colour) {
    fill(colour);
    quad(x,y, x+ width,y, x + width,y+height, x,y+height);
}

function decodeTileData(dataString) {
    var separatedTiles = dataString.replaceAll("DB ", "").replaceAll("$", "").split("\n");
    for (var i = 0; i < separatedTiles.length; i++) {
        var rowData = [];
        var tilePixelData = separatedTiles[i].split(",");
        for (var j = 0; j < tilePixelData.length; j+=2) {
            var firstRow = hexToBinary(tilePixelData[j]);
            var secondRow = hexToBinary(tilePixelData[j+1]);
            for (var k = 0; k < firstRow.length; k++) {
                rowData.push(firstRow[k] + secondRow[k]);
            }
        }
        tileData[i] = rowData;
    }
}

function decodeMapData(dataString) {
    var separatedTiles = dataString.replaceAll("DB ", "").replaceAll("$", "").split("\n");
    for (var i = 0; i < separatedTiles.length; i++) {
        var rowData = [];
        var tilePixelData = separatedTiles[i].split(",");
        for (var j = 0; j < tilePixelData.length; j++) {
            rowData.push(parseInt(tilePixelData[j], 16));
        }
        mapData[i] = rowData;
    }
}

function hexToBinary(hex){
    return ("00000000" + (parseInt(hex, 16)).toString(2)).substr(-8);
}

function mouseWheel(event) {
    if (selectedTab == "tiles") {
        
    } else {
        offsetMap += event.delta * 0.1;
        if (offsetMap > 0) offsetMap = 0;
    }
}