GameManager gameManager;
int lastTime;
float dt;
PFont font;
GameWorld gameWorld;
Player player;
HUD hud;
Minimap minimap;

boolean wPressed;
boolean aPressed;
boolean sPressed;
boolean dPressed;
boolean spacePressed;
boolean OnePressed;
boolean TwoPressed;
boolean mouseHeld;
boolean qPressed;
boolean bPressed;

int worldSizeX;
int worldSizeY;

boolean canOpenMenu = false;

float alpha = 1;

boolean showAnchorTooltip = false;
boolean showHealTooltip = false;
boolean showWorkshopTooltip = false;
boolean showGuidesTooltip = false;
boolean showGuides = false;

float timePassed = 0;

boolean gameEnded = false;

ggScreen gg;

boolean showDeactivatedAnchorTooltip = false;
String deactivatedAnchorCooldownDisplay = "";

WaveManager waveManager;

//https://www.reddit.com/r/gamedev/comments/p1tm4/super_newbish_questionwhat_is_delta_time_how_does/
// delta time thing. might be useful

void setup(){
  worldSizeX = 2000;
  worldSizeY = 2000;
  
  size(1280, 720);
  frameRate(60);
  
  
  font = createFont("Montserrat-SemiBold.ttf", 32); //font stuff
  textFont(font);
  
  lastTime = millis();
  
  hud = new HUD();
  
  gameManager = new GameManager();
  gg = new ggScreen();
  gg.setUp();
  
  minimap = new Minimap(gameManager.menuManager.loadout);
  
  
}

void draw(){
  background(0);
  int now = millis();
  dt = (now - lastTime) / 1000.0;
  lastTime = now;
  
  if (gameEnded) {
    background(255);
    gg.Draw();
    
    if (bPressed) {
      gameEnded = false;
      gameManager = new GameManager();
      gameManager.currentScreen = "menu";
      
    }
  
  } else {
  
    pushMatrix();
    
    if (gameManager.currentScreen.equals("game")){
      translate(width/2 - player.x, height/2 - player.y);
    }
    
    gameManager.update(dt);
    gameManager.Draw(dt); 
    if (gameManager.currentScreen.equals("game")) { //player does not exist yet
      waveManager.update(dt);
    }
    
    popMatrix();
    
    if (gameManager.currentScreen.equals("game")) { //hud elements
      hud.Draw();
      minimap.Draw();
      player.drawReticle();
      player.drawScreenEffects();
      waveManager.drawWaveInfo();
    }
        
    timePassed += dt;
    showGuidesTooltip = timePassed > 2 && timePassed < 8;
  }
  
}

void mousePressed(){
  mouseHeld = true;
  gameManager.handleClick(mouseX, mouseY);
}

void mouseReleased(){
  mouseHeld = false;
}

void keyPressed(){
  gameManager.handleKey(key);
  if (key == 'w') wPressed = true;
  if (key == 'a') aPressed = true;
  if (key == 's') sPressed = true;
  if (key == 'd') dPressed = true;
  //if (key == 'g') gameManager.startGame(); 
  if (key == ' ') spacePressed = true;
  if (key == '1') OnePressed = true;
  if (key == '2') TwoPressed = true;
  if (key == 'q') qPressed = true;
  if (key == 'm' && canOpenMenu) gameManager.goToMenu();
  if (key == 'b') bPressed = true;
  
  //CHEATER CHEATER
  if (key == 'c') {
    for (int i = gameWorld.enemies.size() - 1; i >= 0; i--) {
      gameWorld.enemies.get(i).currHealth = 0;
    }
  }
  
  if (key == 'x') {
    player.currHealth = 99999;
    player.maxHealth  = 99999;
  }
  
  if (key == 'z') {
    player.abilityCooldown = 0;
  }
}

void keyReleased(){
  if (key == 'w') wPressed = false;
  if (key == 'a') aPressed = false;
  if (key == 's') sPressed = false;
  if (key == 'd') dPressed = false;
  if (key == ' ') spacePressed = false;
  if (key == '1') OnePressed = false;
  if (key == '2') TwoPressed = false;
  if (key == 'q') qPressed = false;
  if (key == 'b') bPressed = false;
}
