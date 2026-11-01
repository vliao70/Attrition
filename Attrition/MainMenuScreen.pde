public class MainMenuScreen extends Screen{
  MenuManager menuManager;
  
  String[] navLabels = {"PLAY", "LOADOUT", "INFO", "CREDITS"};
  float NAV_H = 50;
  float TAB_W = 1280 / 4;
 
  
  MainMenuScreen(MenuManager menuManager){
    this.menuManager = menuManager;
  }
 
  void draw(){
    pushMatrix();
    pushStyle();
  
    resetMatrix();
  
    imageMode(CORNER);
    

    drawBg();
    drawNavBar();
    drawLogo();
    drawButtons();
    
    popStyle();
    popMatrix();
  }
  
  void drawBg() {
    PImage img = loadImage("background.jpeg");
    image(img, 0, 50, 1280, 720);
    return;
  }
  
  void handleClick(int x, int y) {
    if (y < 50) {
      int temp = (int)(x / TAB_W);
      if (temp == 0) {
        menuManager.switchTo("main");
      } else if (temp == 1)  {
        menuManager.switchTo("loadout");
     } else if (temp == 2) {
        menuManager.switchTo("info");
      } else if (temp == 3) {
        menuManager.switchTo("credits");
      }
    }
  
    if (x >= 100 && x <= 450 && y >= 290 && y <= 390) {
      menuManager.startGame();
      return;
    }
  }
  
  void drawButtons() {
    fill(255, 128);
    rect(100, 290, 350, 100);
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(0);
    text("PLAY", 100 + 350 / 2, 290 + 50);
    
    fill(255, 128);
    noStroke();
    rect(100, 400, 350, 80);
    rect(100, 490, 350, 80);
  
    textAlign(CENTER, CENTER);
    textSize(13);
    fill(0);
    text("please edit your loadout", 100 + 350 / 2, 400 + 80/2);
    text("before you press play, or else", 100 + 350 / 2, 490 + 80/2);
  }
  
  void drawNavBar(){
    for (int i = 0; i < navLabels.length; i++){
      float x = i * TAB_W;
 
      if (i == 0){
        fill(255);
      } else {
        fill(30,230);
      }
      stroke(0);
      strokeWeight(0);
      rect(x, 0, TAB_W, NAV_H);
 
      if (i == 0){
        fill(0);
      } else {
        fill(255);
      }
      textAlign(CENTER, CENTER);
      textSize(16);
      text(navLabels[i], x + TAB_W / 2, NAV_H / 2);
    }
  }
  void drawLogo(){
    PImage img = loadImage("logo.png");
    image(img, 50, 100);
  }
  
  
  
  void onEnter(){}
  
  void onExit(){}
  
  void update(){}
}
