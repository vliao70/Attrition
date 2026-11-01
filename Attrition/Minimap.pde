class Minimap {

  float x = 20;
  float y = 20;

  float w = 200;
  float h = 200;
  
  float scale = 1;
  PlayerLoadout loadout;

  Minimap(PlayerLoadout loadout){
    this.loadout = loadout;
  }

  void Draw(){  
    fill(30, 180);
    stroke(255);
    rect(x, y, w, h);

    drawPlayer();
    drawWall();
    drawEnemies();
  }
  
  void drawWall(){

    int[][] mp = gameWorld.map.grid;
  
  
    for (int r = 0; r < mp.length; r++){
      for (int c = 0; c < mp[0].length; c++){
  
        if (mp[r][c] == gameWorld.map.WALL){
  
          // convert to camera-relative world position
          float wallX = c * gameWorld.map.tileSize;
          float wallY = r * gameWorld.map.tileSize;
  
          // normalize into minimap space
          float wx = (x + (wallX / worldSizeX) * w);
          float wy = (y + (wallY / worldSizeY) * h);
  
          fill(66, 88, 100);
          
          noStroke();
  
          // scale wall size onto minimap
          float miniTileW = (gameWorld.map.tileSize / (float)worldSizeX) * w;
          float miniTileH = (gameWorld.map.tileSize / (float)worldSizeY) * h;
  
          rect(wx, wy, miniTileW, miniTileH);
        } else if (mp[r][c] == gameWorld.map.HEAL) {
  
          // convert to camera-relative world position
          float wallX = c * gameWorld.map.tileSize;
          float wallY = r * gameWorld.map.tileSize;
  
          // normalize into minimap space
          float wx = (x + (wallX / worldSizeX) * w);
          float wy = (y + (wallY / worldSizeY) * h);
  
          fill(144, 238, 144);
          
          noStroke();
  
          // scale wall size onto minimap
          float miniTileW = (gameWorld.map.tileSize / (float)worldSizeX) * w;
          float miniTileH = (gameWorld.map.tileSize / (float)worldSizeY) * h;
  
          rect(wx, wy, miniTileW, miniTileH);
        } else if (mp[r][c] == gameWorld.map.WORKSHOP) {
  
          // convert to camera-relative world position
          float wallX = c * gameWorld.map.tileSize;
          float wallY = r * gameWorld.map.tileSize;
  
          // normalize into minimap space
          float wx = (x + (wallX / worldSizeX) * w);
          float wy = (y + (wallY / worldSizeY) * h);
  
          fill(255, 165, 0);
          
          noStroke();
  
          // scale wall size onto minimap
          float miniTileW = (gameWorld.map.tileSize / (float)worldSizeX) * w;
          float miniTileH = (gameWorld.map.tileSize / (float)worldSizeY) * h;
  
          rect(wx, wy, miniTileW, miniTileH);
        } else if (mp[r][c] == gameWorld.map.ANCHOR) {
          float wallX = c * gameWorld.map.tileSize;
          float wallY = r * gameWorld.map.tileSize;
        
          float wx = (x + (wallX / worldSizeX) * w);
          float wy = (y + (wallY / worldSizeY) * h);
        
          fill(150, 0, 255);
        
          noStroke();
        
          float miniTileW = (gameWorld.map.tileSize / (float)worldSizeX) * w;
          float miniTileH = (gameWorld.map.tileSize / (float)worldSizeY) * h;
        
          rect(wx, wy, miniTileW, miniTileH);
        } else if (mp[r][c] == gameWorld.map.SPACE) {
          if (gameWorld.map.isDeactivatedAnchor(r, c)) {
            float wallX = c * gameWorld.map.tileSize;
            float wallY = r * gameWorld.map.tileSize;
            float wx = (x + (wallX / worldSizeX) * w);
            float wy = (y + (wallY / worldSizeY) * h);
            float miniTileW = (gameWorld.map.tileSize / (float)worldSizeX) * w;
            float miniTileH = (gameWorld.map.tileSize / (float)worldSizeY) * h;
            fill(60, 0, 90);
            noStroke();
            rect(wx, wy, miniTileW, miniTileH);
          }
          
        }
      }
    }
  }

  void drawPlayer() {
    if (loadout.selectedClass != null) {
      fill(loadout.selectedClass.col);
    } else {
      fill(0, 255, 0);
    }
    noStroke();
    float px = x + (player.x / worldSizeX) * w;
    float py = y + (player.y / worldSizeY) * h;
    ellipse(px, py, 8, 8);
  }

  void drawEnemies(){
    boolean recon = player.loadout.selectedClass != null && player.loadout.selectedClass.name.equals("RECON");

    fill(255, 0, 0);
    noStroke();
    for (Enemy e : gameWorld.enemies) {
      if (!e.isDead()) {
         float tileDist = dist(player.tileFormX, player.tileFormY, e.tileFormX, e.tileFormY);
       if (recon || tileDist <= 7) {
          float ex = x + (e.x / worldSizeX) * w;
          float ey = y + (e.y / worldSizeY) * h;
          ellipse(ex, ey, 5, 5);
        }
      }
    }
  }
}
