public class CreditsScreen extends Screen{
  MenuManager menuManager;
  
  String[] navLabels = {"PLAY", "LOADOUT", "INFO", "CREDITS"};
  float NAV_H = 50;
  float TAB_W = 1280 / 4;
  
  CreditsScreen(MenuManager menuManager){
    this.menuManager = menuManager;
  }
  
  void draw(){
    background(75);
    drawNavBar();
    drawCredits();
  }
  
  void drawCredits() {
    fill(255);
    stroke(0);
    strokeWeight(2);
    rect(100,150,1080,500);
    
    fill(0);
    textAlign(LEFT, CENTER);
    textSize(20);
    text("Menu Screens, Weapon editor, class system, game design,\n Weapon stats, Wave system, enemies\n\n" + 
         "Implementing in game interactions, collisions, \nsome UI's, and map generation\n\n" +
         "Being the coolest cs teacher\n\n", 110, 370);
    
    fill(0);
    textAlign(LEFT, CENTER);
    textSize(20);
    text("\nVince Liao\n\n\n" + 
         "Ryan Qian\n\n\n" + 
         "Mr. Konstantinovich\n\n", 740, 350);
  }
  
  void handleClick(int x, int y){
    if(y < 50){
      int temp = (int) (x / TAB_W);
      if(temp == 0){
        menuManager.switchTo("main");
      } else if (temp == 1){
        menuManager.switchTo("loadout");
      } else if (temp == 2){
        menuManager.switchTo("settings");
      } else if (temp == 3){
        menuManager.switchTo("credits");
      } else {
        fill(0);
        text("sonion there is a problem", 1280/2, 720 / 2);
        text(temp, 1280/2, 720 / 2 + 100);
      }
    }
  }
  
  void drawNavBar(){
    for (int i = 0; i < navLabels.length; i++){
      float x = i * TAB_W;
 
      if (i == 3){
        fill(255);
      } else {
        fill(30,230);
      }
      stroke(0);
      strokeWeight(0);
      rect(x, 0, TAB_W, NAV_H);
 
      if (i == 3){
        fill(0);
      } else {
        fill(255);
      }
      textAlign(CENTER, CENTER);
      textSize(16);
      text(navLabels[i], x + TAB_W / 2, NAV_H / 2);
    }
  }
}
