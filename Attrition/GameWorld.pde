public class GameWorld{
  ArrayList<Bullet> bullets;
  TileMap map;
  int waveNumber;
  float cameraX;
  float cameraY;
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<CollisionObject> colObjs = new ArrayList<CollisionObject>();
  PlayerLoadout loadout;

  GameWorld(PlayerLoadout loadout){
    this.loadout = loadout;
  }
  
  void setUp(){
    player.loadout = loadout;
    player.setUp();
    
    
    
    map = new TileMap(20,20);

  }
  
  void update(float dt) {
    player.update(dt);
    
    for (Enemy e : this.enemies) {
      if (!e.isDead()) {
        e.update(player.x, player.y, dt);
      } else {
        for (Bullet b : e.bullets) {
          if (!b.isExpired()) b.update(dt);
        }
      }
    }
  
    hud.update(player.currHealth / player.maxHealth, player.gameTimer);
    gameWorld.map.update(dt);
  
    // win condition
    if (waveManager.gameWon) {
      gameEnded  = true;
      gg.gameWon = true;
    }
  
    // lose condition
    if (player.currHealth <= 0 || player.gameTimer <= 0) {
      gameEnded  = true;
      gg.gameWon = false;
    }
  
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      if (e.isDead()) {
        if (!e.justDied) {
          e.justDied = true;
          if (player.loadout.selectedClass != null) {
            if (player.loadout.selectedClass.name.equals("SCOUT")) {
              player.dodgeRechargeTimer += player.dodgeRechargeDuration * player.maxDodges * 0.1;
              if (player.dodgeRechargeTimer >= player.dodgeRechargeDuration) {
                player.dodgesLeft = min(player.dodgesLeft + 1, player.maxDodges);
                player.dodgeRechargeTimer = 0;
              }
              if (player.scoutActive) {
                player.scoutTimer = min(player.scoutTimer + 2.0, player.scoutDuration + 2.0);
                player.currHealth = min(player.currHealth + 7.5, player.maxHealth);
              }
            }
            if (player.loadout.selectedClass.name.equals("MEDIC")) {
              player.currHealth = min(player.currHealth + 2.5, player.maxHealth);
            }
          }
        }
  
        boolean hasBullets = false;
        for (Bullet b : e.bullets) {
          if (!b.isExpired()) hasBullets = true;
        }
        if (!hasBullets) {
          enemies.remove(i);
        }
      }
    }
  }
  
  void Draw(float dt){
    rectMode(CORNER);
    imageMode(CORNER);
    background(255);
    
    for (CollisionObject ocbj : colObjs) {
      ocbj.Draw(dt);
    }
    
    
    
    for (Enemy e : this.enemies){
      if (!e.isDead()){
        e.Draw();
      }
    }
    
    player.Draw();
  }
  
  void handleClick(int mx, int my){
    player.handleClick(mx,my);
  }
  
  void handleKey(char key){
    player.handleKey(key);
  }
  
  boolean isOnScreen(int x, int y, int width, int height){
    return true;
  }
}
