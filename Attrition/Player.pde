public class Player{
  float x;
  float y;
  PVector dirMovement;
  float speed;
  float currHealth;
  float maxHealth;
  Weapon weapon1;
  Weapon weapon2;
  Weapon activeWeapon;
  boolean[] keys[];
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  PImage sprite;
  float playerWidth;
  float playerHeight;
  
  float dodgeDuration;
  boolean shouldDodge;
  float dodgeAmt = 10;
  int maxDodges = 4;
  int dodgesLeft = 4;
  float dodgeRechargeTimer = 0;
  float dodgeRechargeDuration;
  
  float hurtDur;
  boolean justTookDmg;
  float hurtSlowAmt;
  
  int currentAmmo;
  int savedAmmo1;
  int savedAmmo2;
  boolean reloading;
  float reloadTimer;
  float reloadDuration;
  boolean fullAuto;
  float fireRate;
  float fireCooldown;
  
  float timeSinceLastShot;
  float firstShotAccuracyWindow;
  
  PlayerLoadout loadout;
  
  float reticleX;
  float reticleY;
  float reticleReturnSpeed;
  float reticleMaxOffset;
  float reticleVX = 0;
  float reticleVY = 0;
  float springStiffness;
  float springDamping;
  
  float recoilBuildup = 0;
  float maxRecoilBuildup = 4.0;
  int tileFormX;
  int tileFormY;
  
  float healTimer = 0;

  boolean activatingAnchor = false;
  float anchorActivateTimer = 0;
  float anchorActivateDuration = 3.0;
  float gameTimer = 120;
  float maxTimer = 120;
  boolean gameOver = false;
  boolean gameWon = false;
  int anchorsActivated = 0;
  int totalAnchors = 4;
  
  float abilityCooldown = 0;
  Bullet assaultGrenade = null;
  
  boolean scoutActive = false;
  float scoutTimer = 0;
  float scoutDuration = 5.0;
  
  float regenTimer = 0; //passive healing
  float regenDelay = 5.0;
  float timeSinceDamage = 67;
  
  ArrayList<CollisionObject> medicHealTiles = new ArrayList<CollisionObject>();
  
  boolean reconActive = false;
  float reconChargeTimer = 0;
  float reconChargeDuration = 1.5;
  float reconLaserTimer = 0;
  float reconLaserDuration = 0.3;
  float reconLaserX1, reconLaserY1, reconLaserX2, reconLaserY2;
  boolean showReconLaser  = false;
  
  boolean specialistCharging = false;
  float specialistChargeTimer = 0;
  float specialistChargeDuration = 3.0;
  
  PImage FAILURE;
  float FAILURETimer = 0;
  float FAILUREDuration = 1.0;
  PImage airball;
  PImage lol;
  
  void setUp() {
    x = 150;
    y = 150;
    speed = 100;
    dirMovement = new PVector(0, 0);
    playerWidth = 20;
    playerHeight = 20;
    dodgeDuration = 0.4;
    shouldDodge = false;
    currHealth = 100;
    maxHealth = 100;
    hurtDur = 0.5;
    justTookDmg = false;
    hurtSlowAmt = 1;
    weapon1 = loadout.weapon1;
    weapon2 = loadout.weapon2;
    activeWeapon = weapon1;
    currentAmmo = activeWeapon.getStatBlock().magSize;
    reloading = false;
    reloadTimer = 0;
    reloadDuration = 2.0;
    timeSinceLastShot = 67;
    firstShotAccuracyWindow = 1.5;
    
    savedAmmo1  = weapon1.getStatBlock().magSize;
    savedAmmo2  = weapon2.getStatBlock().magSize;
    currentAmmo = savedAmmo1;
    
    fullAuto = true;
    fireRate = activeWeapon.getStatBlock().fireRate;

    refreshFireMode();
    applyStatModifiers();
    applyClassPassive();
    
    reticleX = x;
    reticleY = y;
    reticleVX = 0;
    reticleVY = 0;

    gameTimer = 120;
    gameOver = false;
    gameWon = false;
    anchorsActivated = 0;
    
    airball = loadImage("airball.jpeg");
    lol = loadImage("LOL.jpeg");
    println("airball loaded: " + (airball != null) + " w:" + airball.width);
    println("lol loaded: " + (lol != null) + " w:" + lol.width);
  }
  
  Player(PlayerLoadout loadout) {
    this.loadout = loadout;
  }
  
  void update(float dt) {
    dirMovement.set(0, 0);

    if (wPressed) dirMovement.y -= 1;
    if (sPressed) dirMovement.y += 1;
    if (aPressed) dirMovement.x -= 1;
    if (dPressed) dirMovement.x += 1;
  
    if (dirMovement.mag() > 0) {
      dirMovement.normalize();
    }
    
    for (CollisionObject ocbj : gameWorld.colObjs) {
      ocbj.Update(dt);
    }
  
    x += dirMovement.x * speed * dt;
    y += dirMovement.y * speed * dt;
    
    for (Bullet b : bullets) {
      if (!b.isExpired()) {
        b.update(dt);
      } else if (b.isAoe && b.explodeDur >= 0) {
        b.update(dt);
      }
    }
    
  
    if (spacePressed && dodgesLeft > 0 && !shouldDodge) {
      shouldDodge = true;
      dodgesLeft--;
      dodgeRechargeTimer = 0;
    }
    
    if (shouldDodge) {
      dodgeDuration -= dt;
      if (dodgeDuration > 0) {
        x += dirMovement.x * dodgeAmt;
        y += dirMovement.y * dodgeAmt;
      } else {
        shouldDodge = false;
        dodgeDuration = map(activeWeapon.getStatBlock().weight, 0, 100, 0.25, 0.05);
      }
    }
    
    if (justTookDmg) {
      hurtDur -= dt;
      if (hurtDur >= 0) {
        x -= dirMovement.x * hurtSlowAmt;
        y -= dirMovement.y * hurtSlowAmt;
      } else {
        hurtDur = 0.5;
        justTookDmg = false;
      }
    }
    
    if (reloading) { //pinned
      reloadTimer += dt;
      if (reloadTimer >= reloadDuration) {
        currentAmmo = activeWeapon.getStatBlock().magSize;
        reloading = false;
        reloadTimer = 0;
      }
    }
    
    timeSinceLastShot += dt;
    
    if (fireCooldown > 0){
      fireCooldown -= dt;
    }
    
    if (fullAuto && mouseHeld && fireCooldown <= 0 && mouseButton == LEFT && !scoutActive) {
      shoot(reticleX, reticleY);
      fireCooldown = 1.0 / fireRate;
    }
    
    
    float worldMouseX = mouseX + x - width/2;
    float worldMouseY = mouseY + y - height/2;
    
    float forceX = (worldMouseX - reticleX) * springStiffness;
    float forceY = (worldMouseY - reticleY) * springStiffness;
    
    reticleVX = (reticleVX + forceX * dt) * (1.0 - springDamping * dt);
    reticleVY = (reticleVY + forceY * dt) * (1.0 - springDamping * dt);
    
    reticleX += reticleVX * dt;
    reticleY += reticleVY * dt;
    
    if (timeSinceLastShot > 0.1) {
      recoilBuildup = max(recoilBuildup - dt * 1, 0);
    }
    
    takeDamage();
    
    tileFormX = (int)(x / gameWorld.map.tileSize);
    tileFormY = (int)(y / gameWorld.map.tileSize);
  
    //anchor interaction
    if (gameWorld.map.tileFormGrid[tileFormY][tileFormX] == gameWorld.map.ANCHOR) {
      showAnchorTooltip = true;
      showDeactivatedAnchorTooltip = false;
      if (qPressed) {
        activatingAnchor = true;
        anchorActivateTimer += dt;
        if (anchorActivateTimer >= anchorActivateDuration) {
          gameTimer = min(gameTimer + 20, maxTimer);
          anchorsActivated++;
          gameWorld.map.grid[tileFormY][tileFormX] = gameWorld.map.SPACE;
          gameWorld.map.tileFormGrid[tileFormY][tileFormX] = gameWorld.map.SPACE;
          gameWorld.map.deactivatedAnchors.add(
            new int[]{tileFormY, tileFormX, (int)(gameWorld.map.anchorRechargeDuration * 1000)}
          );
          anchorActivateTimer = 0;
          activatingAnchor = false;
          showAnchorTooltip = false;
          showDeactivatedAnchorTooltip = true;
          for (int[] anchor : gameWorld.map.deactivatedAnchors) {
            if (anchor[0] == tileFormY && anchor[1] == tileFormX) {
              deactivatedAnchorCooldownDisplay = "" + (anchor[2] / 1000);
            }
          }
        }
      } else {
        activatingAnchor = false;
        anchorActivateTimer = 0;
      }
    } else {
      showAnchorTooltip = false;
      activatingAnchor = false;
      anchorActivateTimer = 0;
  
      if (gameWorld.map.isDeactivatedAnchor(tileFormY, tileFormX)) {
        showAnchorTooltip = false;
        showDeactivatedAnchorTooltip = true;
        boolean found = false;
        for (int[] anchor : gameWorld.map.deactivatedAnchors) {
          if (!found && anchor[0] == tileFormY && anchor[1] == tileFormX) {
            int secsLeft = anchor[2] / 1000;
            deactivatedAnchorCooldownDisplay = "" + secsLeft;
            found = true;
          }
        }
      } else {
        showDeactivatedAnchorTooltip = false;
      }
    }
  
    //game timer countdown
    gameTimer -= dt;
    gameTimer = max(0, gameTimer);
    
    if (abilityCooldown > 0) {
      abilityCooldown -= dt;
      if (abilityCooldown < 0) abilityCooldown = 0;
    }
    
    if (assaultGrenade != null) {
      if (!assaultGrenade.isExpired()) {
        assaultGrenade.update(dt);
    
        for (Bullet b : bullets) {
          if (assaultGrenade != null && !b.isExpired() && !b.isAoe) {
            float d = dist(b.x, b.y, assaultGrenade.x, assaultGrenade.y);
            if (d < 15) {
              explodeAssaultGrenade();
            }
          }
        }
      } else {
        if (loadout.selectedClass != null) {
          abilityCooldown = loadout.selectedClass.cooldown;
        }
        FAILURETimer = FAILUREDuration;
        FAILURE = airball;
        assaultGrenade = null;
      }
    }
    
    if (scoutActive) {
      scoutTimer -= dt;
      if (scoutTimer <= 0) {
        scoutActive = false;
        scoutTimer  = 0;
      }
    }
    
    if (dodgesLeft < maxDodges) {
      dodgeRechargeTimer += dt;
      if (scoutActive) {
        dodgeRechargeTimer += dt * 2; // 3x total
      }
      if (dodgeRechargeTimer >= dodgeRechargeDuration) {
        dodgesLeft++;
        dodgeRechargeTimer = 0;
      }
    }
    
    //scout dash damage
    if (scoutActive && shouldDodge) {
      for (Enemy e : gameWorld.enemies) {
        if (!e.isDead()) {
          float d = dist(x, y, e.x + e.enemyWidth / 2, e.y + e.enemyHeight / 2);
          if (d < 30) {
            e.currHealth -= 50;
          }
        }
      }
    }
    
    timeSinceDamage += dt; //passive healing
    if (timeSinceDamage >= regenDelay) {
      float regenRate;
      if (loadout.selectedClass != null && loadout.selectedClass.name.equals("MEDIC")) {
        regenRate = 5.0;
      } else {
        regenRate = 2.5;
      }
      float regenCap = maxHealth;
      if (currHealth < regenCap) {
        currHealth = min(currHealth + regenRate * dt, regenCap);
      }
    }
    
    if (reconActive) { //slow down during charging
      speed = map(activeWeapon.getStatBlock().weight, 0, 100, 200, 50);
      reconChargeTimer += dt;
      if (reconChargeTimer >= reconChargeDuration) {
        fireReconLaser();
      }
    } else { //restore speed
      Weapon otherWeapon;
      if (activeWeapon == weapon1) {
        otherWeapon = weapon2;
      } else {
        otherWeapon = weapon1;
      }
      float blendedWeight = activeWeapon.getStatBlock().weight * 0.75 + otherWeapon.getStatBlock().weight * 0.25; speed = map(blendedWeight, 0, 150, 350, 0);
    }
    
    if (showReconLaser) {//laser fade
      reconLaserTimer -= dt;
      if (reconLaserTimer <= 0) {
        showReconLaser = false;
      }
    }
    
    if (specialistCharging){ //movement disabled during spec ability
      x -= dirMovement.x * speed * dt;
      y -= dirMovement.y * speed * dt;
    
      specialistChargeTimer += dt;
      if (specialistChargeTimer >= specialistChargeDuration) {
        completeSpecialistTeleport();
      }
    }
    
    if (scoutActive) {
      speed *= 1.5;
    }
    
    if (FAILURETimer > 0) {
      FAILURETimer -= dt;
    }
  }
  
  void handleKey(char key) {
    if (key == '1') {
      if (activeWeapon != weapon1) switchWeapon();
    }
    if (key == '2') {
      if (activeWeapon != weapon2) switchWeapon();
    }
    if (key == 'r') reload();
    if (key == 'v') {
      activeWeapon.cycleFireMode();
      refreshFireMode();
    }
    if (key == '0') {
      gameTimer = 6000;
    }
  }
  
  void switchWeapon() {
    reloading   = false;
    reloadTimer = 0;
    if (activeWeapon == weapon1) {
      savedAmmo1 = currentAmmo;
      activeWeapon = weapon2;
      currentAmmo = savedAmmo2;
    } else {
      savedAmmo2 = currentAmmo;
      activeWeapon = weapon1;
      currentAmmo = savedAmmo1;
    }
    refreshFireMode();
    applyStatModifiers();
  }
  
  void Draw() {
    rectMode(CENTER);
    if (scoutActive) {
      stroke(50, 150, 255);
      strokeWeight(3);
    } else {
      stroke(0);
      strokeWeight(2);
    }
    if (loadout.selectedClass != null) {
      fill(loadout.selectedClass.col);
    } else {
      fill(0);
    }
    rect(x, y, 20, 20);
    rectMode(CORNER);
  
    for (Bullet b : bullets) {
      if (!b.isExpired()) b.Draw();
    }
    
    if (assaultGrenade != null && !assaultGrenade.isExpired()) {
      
      noFill();
      stroke(255, 100, 0, 100);
      strokeWeight(1);
      ellipse(assaultGrenade.x, assaultGrenade.y, 150 * 2, 150 * 2);
    
      fill(255, 100, 0);
      stroke(200, 80, 0);
      strokeWeight(2);
      ellipse(assaultGrenade.x, assaultGrenade.y, 12, 12);
      noStroke();
    }
    
    if (showReconLaser) {
      float alpha = map(reconLaserTimer, 0, reconLaserDuration, 0, 255);
      stroke(0, 255, 255, alpha);
      strokeWeight(3);
      line(reconLaserX1, reconLaserY1, reconLaserX2, reconLaserY2);
      
      stroke(0, 200, 255, alpha * 0.3);
      strokeWeight(8);
      line(reconLaserX1, reconLaserY1, reconLaserX2, reconLaserY2);
      noStroke();
    }
    
    if (specialistCharging) {
      float progress = specialistChargeTimer / specialistChargeDuration;
      noFill();
      stroke(110, 0, 255, 180);
      strokeWeight(2);
      arc(x, y, 40, 40, -HALF_PI, -HALF_PI + TWO_PI * progress);
      noStroke();
    }
  }
  
  void handleClick(int mx, int my) {
    if (mouseButton == LEFT && !scoutActive){
      shoot(reticleX, reticleY);
    }
    if (mouseButton == RIGHT){
      ability();
    }
  }
  
  void ability() {
    if (loadout.selectedClass == null){
      System.out.println("selected class is null sonion");
      return;
    }
    if (loadout.selectedClass.name.equals("ASSAULT")) {
      throwAssaultGrenade();
    }
    if (loadout.selectedClass.name.equals("SCOUT")) {
      activateScout();
    }
    if (loadout.selectedClass.name.equals("MEDIC")) {
      activateMedic();
    }
    if (loadout.selectedClass.name.equals("RECON")) {
      activateRecon();
    } 
    if (loadout.selectedClass.name.equals("SPECIALIST")) {
      activateSpecialist();
    }
  }
  
  void throwAssaultGrenade() {
    if (abilityCooldown > 0 || assaultGrenade != null){
      return;
    }
  
    PVector dir = PVector.sub(new PVector(reticleX, reticleY), new PVector(x, y)).normalize();
    assaultGrenade = new Bullet(dir, x, y, 20, 300, 1.5, true, 150);
    assaultGrenade.physics = false;
  }
  
  void explodeAssaultGrenade() {
    if (assaultGrenade == null){
      return;
    }
    float ex = assaultGrenade.x;
    float ey = assaultGrenade.y;
    float radius = 150;
    float damage = 80;
    
    for (Enemy e : gameWorld.enemies) {
      if (!e.isDead()) {
        if (dist(ex, ey, e.x, e.y) <= radius) {
          e.currHealth -= damage;
        }
      }
    }
    if (dist(ex, ey, x, y) <= radius) {
      currHealth -= damage;
      justTookDmg = true;
      FAILURETimer = FAILUREDuration;
      FAILURE = lol;
    }
    
    if (loadout.selectedClass != null) {
      abilityCooldown = loadout.selectedClass.cooldown;
    }
    assaultGrenade = null;
  }
  
  void activateScout() {
    if (abilityCooldown > 0){
      return;
    }
    scoutActive = true;
    scoutTimer = scoutDuration;
    abilityCooldown = loadout.selectedClass.cooldown;
  }
  
  void shoot(float targetX, float targetY) {
    if (activeWeapon == null) return;
    if (reloading) return;
    if (currentAmmo <= 0) { reload(); return; }
    if (fireCooldown > 0) return;
  
    currentAmmo--;
    fireCooldown = 1.0 / fireRate;
    StatBlock stats = activeWeapon.getStatBlock();
    boolean isShotgun = activeWeapon.name.equals("M1888");
  
    float accuracyScale;
    if (isShotgun) {
      accuracyScale = 1.0; // shotgun always uses full deviation, no first-shot bonus
    } else {
      accuracyScale = 1.0 - min(timeSinceLastShot / firstShotAccuracyWindow, 1.0);
    }
  
    timeSinceLastShot = 0;
    PVector baseDir = PVector.sub(new PVector(targetX, targetY), new PVector(x, y)).normalize();
  
    if (isShotgun) {
      int pelletCount = 16;
      float spreadAngleDeg = stats.deviation; // total cone width, tweak to taste
      float pelletDamage = stats.damage;
  
      float velocityVariance = 0.15; // ±15% velocity spread

      for (int i = 0; i < pelletCount; i++) {
        PVector pelletDir = baseDir.copy();
        pelletDir.rotate(radians(random(-spreadAngleDeg / 2, spreadAngleDeg / 2)));
    
        float pelletVelocity = stats.bulletVelocity * random(1.0 - velocityVariance, 1.0 + velocityVariance);
    
        StatBlock pelletStats = new StatBlock(
          stats.weight, stats.ergonomics, stats.recoil,
          stats.magSize, pelletVelocity, pelletDamage,
          stats.deviation, stats.armorPen, stats.bulletLifetime,
          stats.fireRate, stats.fullAuto, stats.reticleReturnSpeed
        );
    
        Bullet pellet = new Bullet(pelletDir, x, y, pelletStats);
        pellet.armorPen = stats.armorPen / 100.0;
        bullets.add(pellet);
      }
    } else {
      StatBlock modifiedStats = new StatBlock(
        stats.weight, stats.ergonomics, stats.recoil,
        stats.magSize, stats.bulletVelocity, stats.damage,
        stats.deviation * accuracyScale,
        stats.armorPen, stats.bulletLifetime, stats.fireRate, stats.fullAuto, stats.reticleReturnSpeed
      );
      Bullet newBullet = new Bullet(baseDir, x, y, modifiedStats);
      newBullet.armorPen = stats.armorPen / 100.0;
      bullets.add(newBullet);
    }
  
    
    maxRecoilBuildup = stats.recoil/10 - stats.weight/100;
    if (isShotgun) { //pinned
      float kick = stats.recoil * 15;
      reticleVX += random(-kick, kick);
      reticleVY += random(-kick, kick);
    } else {
      recoilBuildup = min(recoilBuildup + 0.15, maxRecoilBuildup);
      float kick = stats.recoil * recoilBuildup * 4;
      reticleVX += random(-kick, kick);
      reticleVY += random(-kick, kick);
    }
  }
  
  void activateMedic() {
    if (abilityCooldown > 0){
      return;
    }
    //snap to tile grid
    int tileX = (int)(x / gameWorld.map.tileSize) * gameWorld.map.tileSize;
    int tileY = (int)(y / gameWorld.map.tileSize) * gameWorld.map.tileSize;
  
    CollisionObject healTile = new CollisionObject(
      tileX, tileY, gameWorld.map.tileSize, gameWorld.map.tileSize, false, gameWorld.map.HEAL
    );
    gameWorld.colObjs.add(healTile);
    medicHealTiles.add(healTile);
    abilityCooldown = loadout.selectedClass.cooldown;
  }
  
  void reload() {
    if (reloading) return;
    if (currentAmmo == activeWeapon.getStatBlock().magSize) return;
    reloading   = true;
    reloadTimer = 0;
  }
  
  void activateRecon() {
    if (abilityCooldown > 0){
      return;
    }
    if (reconActive){
      return;
    }
    reconActive = true;
    reconChargeTimer = 0;
    abilityCooldown = loadout.selectedClass.cooldown;
  }
  
  void fireReconLaser() { //this thing is called raycasting: checks little steps if there is a wall, but i removed wall stopping it
    PVector dir = PVector.sub(new PVector(reticleX, reticleY), new PVector(x, y)).normalize();

    reconLaserX1 = x;
    reconLaserY1 = y;
  
    float laserX = x;
    float laserY = y;
    float step = 50;
    float maxDist = 6767;
    float traveled = 0;
    
    int aliveBeforeCount = 0;
      for (Enemy e : gameWorld.enemies) {
        if (!e.isDead()) aliveBeforeCount++;
      }
  
    while (traveled < maxDist) {
      laserX += dir.x * step;
      laserY += dir.y * step;
      traveled += step;
  
      for (Enemy e : gameWorld.enemies) {
        if (!e.isDead()) {
          if (dist(laserX, laserY, e.x, e.y) < 20) {
            e.currHealth -= 100;
          }
        }
      }
    }
    
    int aliveAfterCount = 0;
      for (Enemy e : gameWorld.enemies) {
        if (!e.isDead()) aliveAfterCount++;
      }
      if (aliveAfterCount >= aliveBeforeCount) {
        FAILURETimer = FAILUREDuration;
        FAILURE = airball;
      }
      
    reconLaserX2 = laserX;
    reconLaserY2 = laserY;
    showReconLaser = true;
    reconLaserTimer = reconLaserDuration;
    reconActive = false;
    reconChargeTimer = 0;
  }

  void activateSpecialist(){
    if (abilityCooldown > 0 || specialistCharging){
      return;
    }
    
    int[] nearest = findNearestAnchor();
    if (nearest == null){
      return;
    }
    specialistCharging = true;
    specialistChargeTimer = 0;
  }
  
  int[] findNearestAnchor() {
    int[] nearest = null;
    float nearestDist = 67676767;
  
    for (int r = 0; r < gameWorld.map.rows; r++) {
      for (int c = 0; c < gameWorld.map.cols; c++) {
        if (gameWorld.map.tileFormGrid[r][c] == gameWorld.map.ANCHOR) {
          float worldX = c * gameWorld.map.tileSize + gameWorld.map.tileSize / 2;
          float worldY = r * gameWorld.map.tileSize + gameWorld.map.tileSize / 2;
          float d = dist(x, y, worldX, worldY);
          if (d < nearestDist) {
            nearestDist = d;
            nearest = new int[]{r, c};
          }
        }
      }
    }
    return nearest;
  }
  
  void completeSpecialistTeleport() {
    int[] nearest = findNearestAnchor();
    if (nearest == null) {
      specialistCharging    = false;
      specialistChargeTimer = 0;
      return;
    }
  
    x = nearest[1] * gameWorld.map.tileSize + gameWorld.map.tileSize / 2;
    y = nearest[0] * gameWorld.map.tileSize + gameWorld.map.tileSize / 2;
  
    specialistCharging = false;
    specialistChargeTimer = 0;
    abilityCooldown = loadout.selectedClass.cooldown;
  }
  
  void applyClassPassive() {
    if (loadout.selectedClass == null) return;
    if (loadout.selectedClass.name.equals("SPECIALIST")) {
      anchorActivateDuration = 0.5;
    } else {
      anchorActivateDuration = 2.0;
    }
  }
  
  void takeDamage() {
    if (scoutActive && shouldDodge){ //scout
      return;
    }
    for (Enemy e : gameWorld.enemies) {
      for (Bullet b : e.bullets) {
        if (b.x >= -playerWidth/2+x && b.x <= playerWidth/2+x &&
            b.y >= -playerHeight/2+y && b.y <= playerHeight/2+y) {
          if (!b.isExpired()) {
            currHealth -= b.damage;
            b.age = b.lifetime + 1;
            justTookDmg = true;
            timeSinceDamage = 0;
          }
        }
      }
    }
    if (currHealth <= 0) {
      for (int i = medicHealTiles.size() - 1; i >= 0; i--) {
        CollisionObject tile = medicHealTiles.get(i);
        float tileLeft = tile.x;
        float tileRight = tile.x + tile.colWidth;
        float tileTop = tile.y;
        float tileBottom = tile.y + tile.colHeight;
        if (x > tileLeft && x < tileRight && y > tileTop && y < tileBottom) {
          currHealth = 20;
          gameWorld.colObjs.remove(tile);
          medicHealTiles.remove(i);
          justTookDmg = false;
        }
      }
    }
  }
  
  void refreshWeapons() {
    weapon1 = loadout.weapon1;
    weapon2 = loadout.weapon2;
    activeWeapon = weapon1;
  }
  
  void refreshFireMode() {
    StatBlock stats = activeWeapon.getStatBlock();
    fullAuto = stats.fullAuto;
    fireRate = stats.fireRate;
    applyStatModifiers();
  }
  
  void applyStatModifiers() {
    StatBlock active = activeWeapon.getStatBlock();
    Weapon otherWeapon;
    if (activeWeapon == weapon1) {
      otherWeapon = weapon2;
    } else {
      otherWeapon = weapon1;
    }
    StatBlock other = otherWeapon.getStatBlock();
    float blendedWeight = active.weight * 0.75 + other.weight * 0.25;
    
    speed = map(blendedWeight, 0, 150, 350, 0);
    dodgeDuration = map(blendedWeight, 0, 100, 0.25, 0.05);
    dodgeRechargeDuration = map(active.weight, 0, 100, 0, 5);
    reloadDuration = map(active.ergonomics, 0, 100, 4, 1);
    firstShotAccuracyWindow = map(active.ergonomics, 0, 100, 1.5, 0.5);
    reticleReturnSpeed = active.reticleReturnSpeed;
    springStiffness = active.reticleReturnSpeed * 25;
    springDamping = active.reticleReturnSpeed * 2.5;
    
    if (loadout.selectedClass != null && loadout.selectedClass.name.equals("ASSAULT")) {
      reloadDuration *= 0.8;
    }
  }
  
  void drawReticle() {
    StatBlock stats = activeWeapon.getStatBlock();
    float screenX = reticleX - x + width/2;
    float screenY = reticleY - y + height/2;
    float d = dist(reticleX, reticleY, x, y);
    float spreadRadius = max(stats.deviation * (d / 100.0), 8);
    noFill();
    stroke(0);
    strokeWeight(1);
    ellipse(screenX, screenY, spreadRadius * 2, spreadRadius * 2);
    fill(0);
    noStroke();
    ellipse(screenX, screenY, 4, 4);
  }
  
  boolean isDead() {
    return currHealth <= 0;
  }
  
  void drawScreenEffects() {
    if (FAILURETimer > 0 && FAILURE != null) {
      float alpha = map(FAILURETimer, 0, FAILUREDuration, 0, 130);
      tint(255, alpha);
      imageMode(CENTER);
      image(FAILURE, width / 2, height / 2, 300, 300);
      imageMode(CORNER);
      noTint();
    }
  }
}

public class PlayerClass{
  String name;
  String passiveDesc;
  String activeDesc;
  float cooldown;
  color col;
  PImage icon;
 
  PlayerClass(String name, String passiveDesc, String activeDesc, float cooldown, color col) {
    this.name = name;
    this.passiveDesc = passiveDesc;
    this.activeDesc = activeDesc;
    this.cooldown = cooldown;
    this.col = col;
  }
}
