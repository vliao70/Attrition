public class ClassSelectScreen extends Screen {
  MenuManager menuManager;
  PlayerLoadout loadout;
 
  float PANEL_X = 0;
  float PANEL_W = 320;
  float INFO_X = 320;
  float INFO_W = 960;
  float ITEM_H = 80;
  float ITEM_PAD = 10;
 
  PlayerClass[] classes;
  int selectedIndex = 0;
 
  ClassSelectScreen(MenuManager menuManager, PlayerLoadout loadout) {
    this.menuManager = menuManager;
    this.loadout = loadout;
  
    classes = new PlayerClass[]{
      new PlayerClass(
        "ASSAULT",
        "Reload 20% faster.",
        "Throw a frag grenade. The grenade only explodes when you shoot it, dealing massive damage.",
        6,
        color(200, 50, 50)
      ),
      new PlayerClass(
        "SCOUT",
        "Restore 10% of stamina bar on kill.",
        "Enter a rampage where weapons are disabled but dashes and movement speed are greatly enhanced. Dahses will deal damage buring the duration and heal you per kill.",
        20,
        color(200, 170, 50)
      ),
      new PlayerClass(
        "MEDIC",
        "Killing an enemy restores 2.5 HP.",
        "Spawn a heal tile. Heals 1 HP/s. Taking lethal damage inside destroys tile and heals 20 HP.",
        45,
        color(90, 200, 80)
      ),
      new PlayerClass(
        "RECON",
        "All enemies visible on minimap at all times.",
        "Charge 1.5s then fire a piercing laser dealing 100 damage to all enemies in line. Movement slowed while charging.",
        13,
        color(70, 130, 220)
      ),
      new PlayerClass(
        "SPECIALIST",
        "Anchor activation time reduced to 0.5 seconds.",
        "Teleport to the nearest anchor. Movement is disabled when activated. Abillity disabled if none remain.",
        30,
        color(110, 0, 255)
      )
    };
  
    classes[0].icon = loadImage("assaultIcon.png");
    classes[1].icon = loadImage("scoutIcon.png");
    classes[2].icon = loadImage("medicIcon.png");
    classes[3].icon = loadImage("reconIcon.png");
    classes[4].icon = loadImage("specialistIcon.png");
  }
 
  void onEnter() {
    selectedIndex = 0;
  }
 
  void onExit() {}
 
  void update() {}
 
  void draw() {
    background(75);
    drawPanel();
    drawInfo();
    drawBackButton();
  }
 
  void drawPanel() {
    // panel background
    fill(50);
    stroke(180);
    strokeWeight(1);
    rect(PANEL_X, 0, PANEL_W, height);
 
    fill(255);
    textAlign(CENTER, TOP);
    textSize(16);
    text("SELECT CLASS", PANEL_X + PANEL_W / 2, 20);
 
    for (int i = 0; i < classes.length; i++) {
      float itemY = 60 + i * (ITEM_H + ITEM_PAD);
    
      if (i == selectedIndex) {
        fill(classes[i].col);
      } else {
        fill(80);
      }
      stroke(150);
      strokeWeight(1);
      rect(PANEL_X + 10, itemY, PANEL_W - 20, ITEM_H);
    
      // icon on left
      if (classes[i].icon != null) {
        imageMode(CORNER);
        image(classes[i].icon, PANEL_X + 15, itemY + 10, ITEM_H - 20, ITEM_H - 20);
      }
    
      // class name
      if (i == selectedIndex) {
        fill(0);
      } else {
        fill(200);
      }
      textAlign(LEFT, CENTER);
      textSize(18);
      text(classes[i].name, PANEL_X + 100, itemY + ITEM_H / 2);
    }
  }
 
  void drawInfo() {
    PlayerClass pc = classes[selectedIndex];
 
    // info background
    fill(60);
    stroke(180);
    strokeWeight(1);
    rect(INFO_X, 0, INFO_W, height);
 
    float iconSize = 80;
    float iconX = INFO_X + INFO_W / 2 - iconSize / 2;
    float iconY = 60;
    
    noFill();
    noStroke();
    
    if (pc.icon != null) {
      imageMode(CORNER);
      image(pc.icon, iconX, iconY, iconSize, iconSize);
    }
 
    // class name
    fill(pc.col);
    textAlign(CENTER, CENTER);
    textSize(36);
    text(pc.name, INFO_X + INFO_W / 2, 200);
 
    // divider
    stroke(150);
    strokeWeight(1);
    line(INFO_X + 40, 230, INFO_X + INFO_W - 40, 230);
 
    // passive
    fill(180);
    textAlign(LEFT, TOP);
    textSize(14);
    text("PASSIVE", INFO_X + 40, 250);
 
    fill(255);
    textSize(16);
    text(pc.passiveDesc, INFO_X + 40, 275, INFO_W - 80, 120);
 
 
    // active
    fill(180);
    textAlign(LEFT, TOP);
    textSize(14);
    text("ACTIVE  —  " + (int)pc.cooldown + "s COOLDOWN", INFO_X + 40, 400);
 
    fill(255);
    textSize(16);
    text(pc.activeDesc, INFO_X + 40, 425, INFO_W - 80, 120);
 
    // divider
    stroke(150);
    strokeWeight(1);
    line(INFO_X + 40, 530, INFO_X + INFO_W - 40, 530);
 
  }
 
  void drawBackButton() {
    fill(60);
    stroke(180);
    strokeWeight(1);
    rect(10, height - 60, 140, 40);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(13);
    text("BACK", 10 + 140 / 2, height - 60 + 20);
  }
 
  void handleClick(int mx, int my) {
    if (isOver(mx, my, 10, height - 60, 140, 40)) {
      menuManager.switchTo("loadout");
      return;
    }

    if (mx >= PANEL_X && mx <= PANEL_X + PANEL_W) {
      for (int i = 0; i < classes.length; i++) {
        float itemY = 60 + i * (ITEM_H + ITEM_PAD);
        if (isOver(mx, my, PANEL_X + 10, itemY, PANEL_W - 20, ITEM_H)) {
          selectedIndex = i;
          loadout.selectedClass = classes[i];
          return;
        }
      }
    }
  }
 
  void handleKey(char k) {
    if (k == ESC) menuManager.switchTo("loadout");
  }
 
  boolean isOver(float mx, float my, float x, float y, float w, float h) {
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }
}
 
