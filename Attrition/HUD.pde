public class HUD {
  Player player;
  int wave;
  float x;
  float y;
  float dx = 0;
  float dy = 0;
  float hpPercent;
  float timer = 120;
  float maxTimer = 120;

  void update(float healthPercent, float timer) {
    hpPercent  = max(healthPercent, 0);
    this.timer = timer;
  }

  void Draw() {
    drawHealthBar(hpPercent);
    drawDodgeBar();
    drawAmmoCounter();
    drawCoord();
    drawTimer();
    drawClassAbility(); //<>// //<>//
    drawAnchorTt();
    drawWorkshopTt();
    drawHealTt();

  }

  void drawHealTt() {
    if (showHealTooltip) {
      fill(0);
      textAlign(LEFT, CENTER);
      textSize(20);
      text("Stay within range to consume its power and heal.", 450, 430);
    }
  }

  void drawWorkshopTt() {
    if (showWorkshopTooltip) {
      fill(0);
      textAlign(LEFT, CENTER);
      textSize(20);
      text("You are able to open menu here by pressing M.", 450, 430);
    }
  }

  void drawAnchorTt() {
    if (showAnchorTooltip) {
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(20);
      text("Hold Q to activate anchor (+20s)", width / 2, 430);
  
      if (player.activatingAnchor) {
        float barW = 300;
        float barX = width / 2 - barW / 2;
        float barY = 460;
        float barH = 12;
        float progress = player.anchorActivateTimer / player.anchorActivateDuration;
  
        fill(80);
        noStroke();
        rect(barX, barY, barW, barH);
  
        fill(150, 0, 255);
        rect(barX, barY, barW * progress, barH);
  
        noFill();
        stroke(0);
        strokeWeight(1);
        rect(barX, barY, barW, barH);
      }
    } else if (showDeactivatedAnchorTooltip) {
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(20);
      text("Anchor recharging: " + deactivatedAnchorCooldownDisplay + "s", width / 2, 430);
    }
  }

  void drawTimer() {
    if (player == null) return;

    int t = max(0, (int)timer);
    int minutes = t / 60;
    int seconds = t % 60;
    String secStr = (seconds < 10) ? "0" + seconds : "" + seconds;

    float pct = timer / maxTimer;
    if (pct > 0.5) {
      fill(0, 180, 0);
    } else if (pct > 0.25) {
      fill(220, 180, 0);
    } else {
      fill(220, 50, 50);
    }
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(30);
    text(minutes + ":" + secStr, width / 2, 35);

    fill(0);
    textSize(14);
    textAlign(CENTER, CENTER);

    if (player.gameOver) {
      
    } else if (player.gameWon) {
      
    }
  }

  void drawCoord() {
    fill(0);
    textAlign(LEFT, CENTER);
    textSize(14);
    text(round(player.x) + ", " + round(player.y), 30, 230);
  }

  void drawHealthBar(float healthPercent) {
    noStroke();
    strokeWeight(2);
    fill(150);
    rect(1060, height - 35, 200, 15);
    strokeWeight(0);
    fill(200, 0, 0);
    rect(1060, height - 35, 200 * healthPercent, 15);
  }

  void drawAmmoCounter() {
    if (player == null) return;
    if (player.activeWeapon == null) return;

    float barX = 1060;
    float barY = height - 80;
    float barW = 200;
    float barH = 30;

    fill(0);
    textAlign(LEFT, CENTER);
    textSize(14);
    text(player.activeWeapon.name, barX, barY - 15);
    if (player.activeWeapon.fireModes[player.activeWeapon.fireModeIndex]) {
      text("[AUTO]", barX + 150, barY - 15);
    } else {
      text("[SEMI]", barX + 150, barY - 15);
    }

    fill(150);
    strokeWeight(0);
    rect(barX, barY, barW, barH);

    int magSize = player.activeWeapon.getStatBlock().magSize;
    float fillW;
    if (player.reloading) {
      fillW = (player.reloadTimer / player.reloadDuration) * barW;
    } else {
      fillW = (float)player.currentAmmo / magSize * barW;
    }

    fill(220, 200, 100);
    rect(barX, barY, fillW, barH);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(13);
    if (player.reloading) {
      text(player.currentAmmo + " / " + magSize, barX + barW / 2, barY + barH / 2);
    } else {
      text(player.currentAmmo + " / " + magSize, barX + barW / 2, barY + barH / 2);
    }
  }

  void drawDodgeBar() {
    if (player == null) return;

    float barX = 1060;
    float barY = height - 43;
    float barW = 200;
    float barH = 8;

    fill(150);
    strokeWeight(0);
    rect(barX, barY, barW, barH);

    float fullDodges = player.dodgesLeft;
    float partialDodge;
    if (player.dodgesLeft < player.maxDodges) {
      partialDodge = player.dodgeRechargeTimer / player.dodgeRechargeDuration;
    } else {
      partialDodge = 0;
    }

    float fillW = ((fullDodges + partialDodge) / player.maxDodges) * barW;
    fill(100, 150, 255);
    rect(barX, barY, fillW, barH);

    stroke(0);
    strokeWeight(1);
    for (int i = 1; i < player.maxDodges; i++) {
      float lineX = barX + (barW / player.maxDodges) * i;
      line(lineX, barY, lineX, barY + barH);
    }
  }
  
  void drawClassAbility() {
  if (player == null) return;
  if (player.loadout.selectedClass == null) return;

  PlayerClass pc = player.loadout.selectedClass;

  float iconSize = 50;
  float iconX = 1060 - iconSize - 10;
  float iconY = height - iconSize - 27;
  
  fill(pc.col);
  noStroke();
  rect(iconX, iconY, iconSize, iconSize);
  
  // icon drawn smaller with padding inside the box
  float padding = 8;
  float imgSize = iconSize - padding * 2;
  if (pc.icon != null) {
    imageMode(CORNER);
    image(pc.icon, iconX + padding, iconY + padding, imgSize, imgSize);
  }

  //draw a dark overlay and countdown while recharge thing
  if (player.abilityCooldown > 0) {
    float cdPct = player.abilityCooldown / pc.cooldown;

    //dark overlay to show cooldown
    fill(0, 180);
    rect(iconX, iconY, iconSize, iconSize * cdPct);

    //countdown text
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(16);
    text((int)player.abilityCooldown + "s", iconX + iconSize / 2, iconY + iconSize / 2);
  } else {
    //ready
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(11);
    text("RMB", iconX + iconSize / 2, iconY + iconSize / 2);
  }

  noFill();
  stroke(0);
  rect(iconX, iconY, iconSize, iconSize);

  //class name label below
  fill(0);
  noStroke();
  textAlign(CENTER, TOP);
  textSize(10);
  text(pc.name, iconX + iconSize / 2, iconY + iconSize + 2);
}

  void drawWaveCounter()  {}
  void drawWeaponSlots()  {}
  void drawBossBar(int health, int maxHealth) {}
}
