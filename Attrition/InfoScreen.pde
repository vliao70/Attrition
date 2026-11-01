public class InfoScreen extends Screen {
  MenuManager menuManager;

  String[] navLabels = {"PLAY", "LOADOUT", "INFO", "CREDITS"};
  float NAV_H = 50;
  float TAB_W = 1280 / 4;

  InfoScreen(MenuManager menuManager) {
    this.menuManager = menuManager;
  }

  void draw() {
    background(75);
    drawNavBar();
    drawInfo();
  }

  void handleClick(int x, int y) {
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
  }

  void drawNavBar() {
    for (int i = 0; i < navLabels.length; i++) {
      float x = i * TAB_W;
      if (i == 2) {
        fill(255);
      } else {
        fill(30, 230);
      }
      stroke(0);
      strokeWeight(0);
      rect(x, 0, TAB_W, NAV_H);
      if (i == 2) {
        fill(0);
      } else {
        fill(255);
      }
      textAlign(CENTER, CENTER);
      textSize(16);
      text(navLabels[i], x + TAB_W / 2, NAV_H / 2);
    }
  }

  void drawInfo() {
    float col1X = 60;
    float col2X = 660;
    float startY = 80;
    float gap    = 22;
    float sectionGap = 40;

    // --- LEFT COLUMN: Controls ---
    float ly = startY;
    fill(255);
    textAlign(LEFT, TOP);
    textSize(20);
    text("CONTROLS", col1X, ly);

    ly += sectionGap;
    textSize(13);
    fill(180);
    text("MOVEMENT", col1X, ly);
    fill(255);
    ly += gap;
    text("WASD: Move", col1X, ly);
    text("SPACE: Dodge (4 charges)", col1X, ly + gap);
    ly += gap * 2;

    ly += gap;
    fill(180);
    text("COMBAT", col1X, ly);
    fill(255);
    ly += gap;
    text("LMB: Shoot", col1X, ly);
    ly += gap;
    text("RMB: Class ability", col1X, ly);
    ly += gap;
    text("R: Reload", col1X, ly);
    ly += gap;
    text("V: Cycle fire mode", col1X, ly);
    ly += gap;
    text("1 / 2: Switch weapon", col1X, ly);
    ly += gap * 2;

    ly += gap;
    fill(180);
    text("INTERACTION", col1X, ly);
    fill(255);
    ly += gap;
    text("Q: Activate anchor", col1X, ly);
    ly += gap;

    ly += gap;
    fill(180);
    text("OBJECTIVE", col1X, ly);
    fill(255);
    ly += gap;
    text("Survive endless waves. Activate anchors", col1X, ly);
    ly += gap;
    text("to extend game timer.", col1X, ly);

    // --- RIGHT COLUMN: Enemies ---
    ly = startY;
    fill(255);
    textAlign(LEFT, TOP);
    textSize(20);
    text("ENEMIES", col2X, ly);

    ly += sectionGap;
    textSize(13);

    fill(180, 60, 60);
    text("INFANTRY", col2X, ly);
    fill(255);
    ly += gap;
    text("Fast, low health. Shoots rapidly at close", col2X, ly);
    ly += gap;
    text("range. Dangerous in groups.", col2X, ly);
    ly += gap * 2;

    fill(80, 80, 200);
    text("SHIELDER", col2X, ly);
    fill(255);
    ly += gap;
    text("Carries a shield on its front. Immune to low", col2X, ly);
    ly += gap;
    text("pen bullets from the front. Fires a devastating", col2X, ly);
    ly += gap;
    text("shotgun at close range. FAL pierces shield.", col2X, ly);
    ly += gap * 2;

    fill(180, 50, 180);
    text("Cloaker", col2X, ly);
    fill(255);
    ly += gap;
    text("Nearly invisible at range. Reveals and rushes", col2X, ly);
    ly += gap;
    text("you within 3 tiles. Immune to velocity bullets", col2X, ly);
    ly += gap;
    text("while invisible. Use secondaries.", col2X, ly);
    ly += gap * 2;

    fill(255, 140, 0);
    text("GUNNER", col2X, ly);
    fill(255);
    ly += gap;
    text("High health. Fires sustained bursts from range.", col2X, ly);
    ly += gap;
    text("Requires line of sight. Shoots at last known", col2X, ly);
    ly += gap;
    text("position if you break LOS.", col2X, ly);
  }

  void onEnter() {}
  void onExit() {}
  void update() {}
}
