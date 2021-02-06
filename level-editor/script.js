// Store a reference to the window
var window;

// Store the selected tab
var selectedTab;

// Store the hex data for the tiles and map
var editorData = { "tiles" : "<-- PASTE TILE DATA HERE -->", "map" : "<-- PASTE MAP DATA HERE -->" };

function setup() {
    
    holder = document.getElementById("canvasHolder");
    
    var canvas = createCanvas(holder.offsetWidth, holder.offsetHeight);
    canvas.parent("canvasHolder");
    
    selectTab("tiles");
    initEditorTextChangeListener();
    
}

function draw() {
    
    clear();
    
    
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
       editorData[selectedTab] = event.target.value;
    });
}