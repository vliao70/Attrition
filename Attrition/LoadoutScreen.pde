public class LoadoutScreen extends Screen {
  MenuManager menuManager;
  PlayerLoadout loadout;

  boolean showWeaponPopup = false;
  int popupSlot = 0;

  String[] navLabels = {"PLAY", "LOADOUT", "INFO", "CREDITS"};
  float NAV_H = 50;
  float TAB_W = 1280 / 4;

  // layout
  float TOP_Y = 50;
  float TOP_H = 335;
  float BOT_Y = 385;
  float BOT_H = 335;
  float L_X = 0;
  float L_W = 640;
  float R_X = 640;
  float R_W = 640;
  float L_BAR = 60;
  float R_BAR = 60;

  // buttons
  float BTN_X = 450;
  float BTN_W = 190;
  float BTN_H = 30;

  // popup
  float POP_W = 400;
  float POP_H = 420;
  float POP_X = 440;
  float POP_Y = 150;
  float POP_ITEM_H = 55;

  PImage weapon1Img;
  PImage weapon2Img;
  PImage skillsImg;

  LoadoutScreen(MenuManager menuManager, PlayerLoadout loadout) {
    this.menuManager = menuManager;
    this.loadout = loadout;
  }

  void onEnter() {
    showWeaponPopup = false;
    popupSlot = 0;
    weapon1Img = loadImage("placeholder1.png");
    weapon2Img = loadImage("placeholderAux.png");
    skillsImg = loadImage("placeholderSkills.png");
  }

  void onExit() {
    showWeaponPopup = false;
    popupSlot = 0;
  }

  void update() {}
  void handleKey(char k) {}

  void draw() {
    background(100);
    drawNavBar();
    drawQuadrants();
    drawButtons();
    drawImages();
    if (showWeaponPopup) {
      drawWeaponPopup();
    }
  }

  void drawNavBar() {
    for (int i = 0; i < navLabels.length; i++) {
      float x = i * TAB_W;
      if (i == 1) {
        fill(255);
      } else {
        fill(30, 230);
      }
      stroke(0);
      strokeWeight(0);
      rect(x, 0, TAB_W, NAV_H);
      if (i == 1) {
        fill(0);
      } else {
        fill(255);
      }
      textAlign(CENTER, CENTER);
      textSize(16);
      text(navLabels[i], x + TAB_W / 2, NAV_H / 2);
    }
  }

  void drawQuadrants() {
    stroke(180);
    strokeWeight(1);
    fill(50);
    rect(0, TOP_Y, 1280, TOP_H - L_BAR);
    rect(L_X, BOT_Y, L_W,  BOT_H - L_BAR);
    rect(R_X, BOT_Y, R_W,  BOT_H - R_BAR);
  }

  void drawButtons() {
    fill(60);
    strokeWeight(1);

    float TOP_BAR_Y = TOP_Y + TOP_H - L_BAR;
    float BOT_L_BAR_Y = BOT_Y + BOT_H - L_BAR;
    float BOT_R_BAR_Y = BOT_Y + BOT_H - R_BAR;
    float W1_BTN_X = 1280 - BTN_W - 10;

    rect(0, TOP_BAR_Y,   1280, L_BAR);
    rect(L_X, BOT_L_BAR_Y, L_W,  L_BAR);
    rect(R_X, BOT_R_BAR_Y, R_W,  R_BAR);

    rect(W1_BTN_X, TOP_BAR_Y, BTN_W, BTN_H);
    rect(W1_BTN_X, TOP_BAR_Y + BTN_H, BTN_W, BTN_H);

    rect(BTN_X, BOT_L_BAR_Y, BTN_W, BTN_H);
    rect(BTN_X, BOT_L_BAR_Y + BTN_H, BTN_W, BTN_H);

    rect(R_X + BTN_X, BOT_R_BAR_Y, BTN_W, R_BAR);

    textAlign(CENTER, CENTER);
    textSize(20);
    fill(255);
    text(loadout.getWeapon1Name(), 640, TOP_BAR_Y   + L_BAR / 2);
    text(loadout.getWeapon2Name(), BTN_X / 2, BOT_L_BAR_Y + L_BAR / 2);
    text("CLASS", R_X + BTN_X / 2, BOT_R_BAR_Y + R_BAR / 2);

    textSize(12);
    text("SWITCH", W1_BTN_X + BTN_W / 2, TOP_BAR_Y   + BTN_H / 2);
    text("CUSTOMIZE", W1_BTN_X + BTN_W / 2, TOP_BAR_Y   + BTN_H + BTN_H / 2);
    text("SWITCH", BTN_X + BTN_W / 2, BOT_L_BAR_Y + BTN_H / 2);
    text("CUSTOMIZE", BTN_X + BTN_W / 2, BOT_L_BAR_Y + BTN_H + BTN_H / 2);
    text("CUSTOMIZE", R_X + BTN_X + BTN_W / 2, BOT_R_BAR_Y + R_BAR / 2);
  }

  void drawImages() {
    imageMode(CENTER);
    if (weapon1Img != null){
      image(weapon1Img, 640, TOP_Y + (TOP_H - L_BAR) / 2);
    }
    if (weapon2Img != null) {
      image(weapon2Img, L_W / 2, BOT_Y + (BOT_H - L_BAR) / 2);
    }
    if (skillsImg  != null){
      image(skillsImg,  R_X + R_W / 2, BOT_Y + (BOT_H - R_BAR) / 2);
    }
    imageMode(CORNER);
  }

  void handleClick(int x, int y) {
    if (showWeaponPopup) {
      handlePopupClick(x, y);
      return;
    }

    if (y < 50) {
      int temp = (int)(x / TAB_W);
      if (temp == 0) {
        menuManager.switchTo("main");
      } else if (temp == 1) {
        menuManager.switchTo("loadout");
      } else if (temp == 2) {
        menuManager.switchTo("info");
      } else if (temp == 3) {
        menuManager.switchTo("credits");
      }
    }

    float TOP_BAR_Y = TOP_Y + TOP_H - L_BAR;
    float BOT_L_BAR_Y = BOT_Y + BOT_H - L_BAR;
    float BOT_R_BAR_Y = BOT_Y + BOT_H - R_BAR;
    float W1_BTN_X = 1280 - BTN_W;

    if (isOver(x, y, W1_BTN_X, TOP_BAR_Y + BTN_H, BTN_W, BTN_H)) {
      menuManager.weaponEditor.setCurrentWeapon(loadout.weapon1);
      menuManager.switchTo("weaponEditor");
      return;
    }
    if (isOver(x, y, W1_BTN_X, TOP_BAR_Y, BTN_W, BTN_H)) {
      popupSlot = 1;
      showWeaponPopup = true;
      return;
    }

    if (isOver(x, y, BTN_X, BOT_L_BAR_Y + BTN_H, BTN_W, BTN_H)) {
      menuManager.weaponEditor.setCurrentWeapon(loadout.weapon2);
      menuManager.switchTo("weaponEditor");
      return;
    }
    if (isOver(x, y, BTN_X, BOT_L_BAR_Y, BTN_W, BTN_H)) {
      popupSlot = 2;
      showWeaponPopup = true;
      return;
    }

    if (isOver(x, y, R_X + BTN_X, BOT_R_BAR_Y, BTN_W, R_BAR)) {
      menuManager.switchTo("classSelect");
      return;
    }
  }

  void drawWeaponPopup() {
    fill(0, 150);
    noStroke();
    rect(0, 0, 1280, 720);

    fill(60);
    stroke(180);
    strokeWeight(1);
    rect(POP_X, POP_Y, POP_W, POP_H);

    fill(255);
    textAlign(CENTER, TOP);
    textSize(15);
    text("SELECT WEAPON", POP_X + POP_W / 2, POP_Y + 12);

    Weapon[] weapons;
    if (popupSlot == 1) {
      weapons = loadout.getPrimaryWeapons();
    } else {
      weapons = loadout.getSecondaryWeapons();
    }

    for (int i = 0; i < weapons.length; i++) {
      float itemY = POP_Y + 45 + i * (POP_ITEM_H + 5);
      Weapon current;
      if (popupSlot == 1) {
        current = loadout.weapon1;
      } else {
        current = loadout.weapon2;
      }

      if (weapons[i].name.equals(current.name)) {
        fill(200);
      } else {
        fill(90);
      }
      stroke(150);
      strokeWeight(1);
      rect(POP_X + 10, itemY, POP_W - 20, POP_ITEM_H);

      fill(255);
      textAlign(CENTER, CENTER);
      textSize(14);
      text(weapons[i].name, POP_X + POP_W / 2, itemY + POP_ITEM_H / 2);
    }

    fill(80);
    stroke(180);
    rect(POP_X + POP_W / 2 - 60, POP_Y + POP_H - 42, 120, 32);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(13);
    text("CLOSE", POP_X + POP_W / 2, POP_Y + POP_H - 26);
  }

  void handlePopupClick(int mx, int my) {
    if (isOver(mx, my, POP_X + POP_W / 2 - 60, POP_Y + POP_H - 42, 120, 32)) {
      showWeaponPopup = false;
      return;
    }

    Weapon[] weapons;
    if (popupSlot == 1) {
      weapons = loadout.getPrimaryWeapons();
    } else {
      weapons = loadout.getSecondaryWeapons();
    }

    for (int i = 0; i < weapons.length; i++) {
      float itemY = POP_Y + 45 + i * (POP_ITEM_H + 5);
      if (isOver(mx, my, POP_X + 10, itemY, POP_W - 20, POP_ITEM_H)) {
        if (popupSlot == 1) {
          loadout.weapon1 = new Weapon(weapons[i]);
        } else if (popupSlot == 2) {
          loadout.weapon2 = new Weapon(weapons[i]);
        }
        return;
      }
    }
  }

  boolean isOver(float mx, float my, float x, float y, float w, float h) {
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }
}
