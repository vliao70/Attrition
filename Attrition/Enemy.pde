public class Enemy {
  float x;
  float y;
  float speed;
  float currHealth;
  float maxHealth;
  float damage;
  float armor;
  float armorHp;
  float maxArmorHp;
  PVector dir;
  float currAtkCd;
  float atkCd;
  Player p;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  float enemyHeight;
  float enemyWidth;
  int tileFormX;
  int tileFormY;
  boolean justDied = false;

  public Enemy(Player p, float x, float y) {
    this.x = x;
    this.y = y;
    speed = 50;
    damage = 25;
    maxHealth = 100;
    currHealth = maxHealth;
    atkCd = 3;
    currAtkCd = 0;
    armor = 0;
    this.p = p;
    enemyHeight = 16;
    enemyWidth = 16;
    dir = PVector.sub(new PVector(p.x, p.y), new PVector(this.x, this.y));
  }

  void update(float playerX, float playerY, float dt) {
    move(dt);
    currAtkCd += 0.5 * dt;
    if (shouldAttack()) shoot(p.x, p.y);
    for (Bullet b : bullets) {
      if (!b.isExpired()) b.update(dt);
    }
    takeDamage();
    tileFormX = (int)(x / gameWorld.map.tileSize);
    tileFormY = (int)(y / gameWorld.map.tileSize);
  }

  void Draw() {
    fill(120);
    stroke(0);
    strokeWeight(4);
    rect(x, y, enemyWidth, enemyHeight);
    for (Bullet b : bullets) {
      if (!b.isExpired()) b.Draw();
    }
  }

  // pen >= armor: bullet fully penetrates -> damage splits between hp and armorHp based on pen
  //   hp takes damage * pen, armorHp takes damage * (1 - pen)
  // pen < armor: bullet doesn't penetrate -> full damage hits armorHp first, overflow
  //   (if armorHp runs out mid-hit) spills over to hp
  void applyDamage(Bullet b) {
    float pen = constrain(b.armorPen, 0, 1);
  
    if (armor <= 0) {
      currHealth -= b.damage; // no armor system at all — full damage to hp
      return;
    }
  
    if (pen >= armor) {
      float hpDamage = b.damage * pen;
      float armorDamage = b.damage * (1.0 - pen);
      currHealth -= hpDamage;
      armorHp = max(armorHp - armorDamage, 0);
    } else {
      if (armorHp > 0) {
        if (b.damage <= armorHp) {
          armorHp -= b.damage;
        } else {
          float overflow = b.damage - armorHp;
          armorHp = 0;
          currHealth -= overflow;
        }
      } else {
        currHealth -= b.damage;
      }
    }
  }

  void takeDamage() {
    for (Bullet b : p.bullets) {
      if (b.isAoe && (b.keepExploding() || b.hitsEnemy(this))) {
        if (new PVector(x + enemyWidth - b.x, y + enemyHeight - b.y).mag() < b.range) {
          applyDamage(b);
          b.age = b.lifetime + 1;
        }
      } else if (!b.isExpired() && b.hitsEnemy(this)) {
        applyDamage(b);
        b.age = b.lifetime + 1;
      }
    }
  }

  boolean shouldAttack() { return currAtkCd >= atkCd; }

  void shoot(float targetX, float targetY) {
    Bullet newBullet = new Bullet(
      PVector.sub(new PVector(targetX, targetY), new PVector(x, y)).normalize(), x, y
    );
    bullets.add(newBullet);
    currAtkCd = 0;
  }

  boolean isDead() { return currHealth <= 0; }

  void updateBehavior() {}

  void move(float dt) {
    imasquare next = bfs(tileFormY, tileFormX, player.tileFormY, player.tileFormX, gameWorld.map.grid);
    if (next != null) {
      float targetX = next.col * gameWorld.map.tileSize + gameWorld.map.tileSize / 2;
      float targetY = next.row * gameWorld.map.tileSize + gameWorld.map.tileSize / 2;
      PVector moveDir = new PVector(targetX - x, targetY - y);
      moveDir.normalize();
      x += moveDir.x * speed * dt;
      y += moveDir.y * speed * dt;
    }
  }

  imasquare bfs(int startRow, int startCol, int targetRow, int targetCol, int[][] map) {
    boolean[][] visited = new boolean[map.length][map[0].length];
    ArrayList<imasquare> queue = new ArrayList<imasquare>();
    imasquare start = new imasquare(startRow, startCol, null);
    queue.add(start);
    visited[startRow][startCol] = true;
    int[][] directions = {{1,0},{-1,0},{0,1},{0,-1}};

    while (queue.size() > 0) {
      imasquare current = queue.remove(0);
      if (current.row == targetRow && current.col == targetCol) {
        imasquare step = current;
        while (step.parent != null && step.parent.parent != null) {
          step = step.parent;
        }
        return step;
      }
      for (int[] d : directions) {
        int newRow = current.row + d[0];
        int newCol = current.col + d[1];
        if (newRow >= 0 && newRow < map.length && newCol >= 0 && newCol < map[0].length) {
          if (!visited[newRow][newCol] && map[newRow][newCol] != gameWorld.map.WALL) {
            visited[newRow][newCol] = true;
            queue.add(new imasquare(newRow, newCol, current));
          }
        }
      }
    }
    return null;
  }
}

public class Infantry extends Enemy {
  Infantry(Player p, float x, float y) {
    super(p, x, y);
    speed = 120;
    maxHealth = 100;
    currHealth = maxHealth;
    armor = 0;
    atkCd = 0.35;
    damage = 2.5;
    enemyWidth = 16;
    enemyHeight = 16;
  }

  void Draw() {
    fill(180, 60, 60);
    stroke(100, 0, 0);
    strokeWeight(2);
    rectMode(CENTER);
    rect(x + enemyWidth/2, y + enemyHeight/2, enemyWidth, enemyHeight);
    rectMode(CORNER);
    for (Bullet b : bullets) {
      if (!b.isExpired()) b.Draw();
    }
  }

  void shoot(float targetX, float targetY) {
    float startX = x + enemyWidth / 2;
    float startY = y + enemyHeight / 2;
    PVector dir = PVector.sub(new PVector(targetX, targetY), new PVector(startX, startY)).normalize();
    Bullet b = new Bullet(dir, startX, startY);
    b.damage = damage;
    b.lifetime = 1.2;
    b.speed = 600;
    bullets.add(b);
    currAtkCd = 0;
  }
}


public class Shielder extends Enemy {
  float shieldArmor = 0.5; // 50% armor on body
  float shotgunRange = 200; // pixels
  PVector moveDir = new PVector(0, 0);

  Shielder(Player p, float x, float y) {
    super(p, x, y);
    speed = 80;
    maxHealth = 80;
    currHealth = maxHealth;
    armor = shieldArmor;
    armorHp = 220;
    maxArmorHp = 220;
    atkCd = 1.25;
    damage = 6;
    enemyWidth = 20;
    enemyHeight = 20;
  }

  void update(float playerX, float playerY, float dt) {
    // track movement direction for shield facing
    float prevX = x;
    float prevY = y;
    move(dt);
    moveDir.set(x - prevX, y - prevY);
    if (moveDir.mag() > 0) moveDir.normalize();

    currAtkCd += 0.5 * dt;

    float playerDist = dist(x, y, playerX, playerY);
    if (shouldAttack() && playerDist < shotgunRange) {
      shootShotgun(playerX, playerY);
    }

    for (Bullet b : bullets) {
      if (!b.isExpired()) b.update(dt);
    }

    takeDamageShielder();
    tileFormX = (int)(x / gameWorld.map.tileSize);
    tileFormY = (int)(y / gameWorld.map.tileSize);
  }

  void Draw() {
    fill(80, 80, 200);
    stroke(40, 40, 120);
    strokeWeight(2);
    rectMode(CENTER);
    rect(x + enemyWidth/2, y + enemyHeight/2, enemyWidth, enemyHeight);
    rectMode(CORNER);

    //shield
    float cx = x + enemyWidth / 2;
    float cy = y + enemyHeight / 2;
    float shieldAngle = atan2(moveDir.y, moveDir.x);

    pushMatrix();
    translate(cx, cy);
    rotate(shieldAngle);
    fill(150, 150, 255, 200);
    stroke(80, 80, 200);
    strokeWeight(3);
    rect(10, -12, 8, 24); //shield
    popMatrix();

    for (Bullet b : bullets) {
      if (!b.isExpired()) b.Draw();
    }
  }

  void shootShotgun(float targetX, float targetY) {
    int pellets = 9;
    float spread = 11;
    PVector baseDir = PVector.sub(new PVector(targetX, targetY), new PVector(x, y)).normalize();
    float baseAngle = atan2(baseDir.y, baseDir.x);

    for (int i = 0; i < pellets; i++) {
      float angle = baseAngle + random(-spread/2, spread/2) * (PI / 180);
      PVector pelletDir = new PVector(cos(angle), sin(angle));
      Bullet b = new Bullet(pelletDir, x + enemyWidth/2, y + enemyHeight/2);
      b.damage = damage;
      b.lifetime = 0.6;
      b.speed = 700;
      bullets.add(b);
    }
    currAtkCd = 0;
  }

  // front-facing hits (dot > 0.5) go through the armor/armorHp penetration system;
  // hits from the side/back bypass the shield entirely and go straight to hp
  void takeDamageShielder() {
    for (Bullet b : p.bullets) {
      if (!b.isExpired() && b.hitsEnemy(this)) {
        PVector toPlayer = new PVector(p.x - x, p.y - y);
        toPlayer.normalize();
        float dot = moveDir.dot(toPlayer);

        if (dot > 0.5) {
          applyDamage(b);
        } else {
          currHealth -= b.damage;
        }
        b.age = b.lifetime + 1;
      }

      if (b.isAoe && (b.keepExploding() || b.hitsEnemy(this))) {
        if (new PVector(x + enemyWidth - b.x, y + enemyHeight - b.y).mag() < b.range) {
          applyDamage(b);
          b.age = b.lifetime + 1;
        }
      }
    }
  }

  void takeDamage() {
    takeDamageShielder();
  }
}

public class Cloaker extends Enemy {
  float attackRange = 20;
  float stunTimer = 0;
  float stunDuration = 2.5;
  boolean stunned = false;
  float boostSpeed = 425;
  float normalSpeed = 70;
  float highVelThreshold = 1250/2; //damage immunity from fast bullets

  Cloaker(Player p, float x, float y) {
    super(p, x, y);
    speed = normalSpeed;
    maxHealth = 50;
    currHealth = maxHealth;
    armor = 0;
    enemyWidth = 14;
    enemyHeight = 14;
  }

  void update(float playerX, float playerY, float dt) {
    float tileDist = dist(tileFormX, tileFormY, player.tileFormX, player.tileFormY);
    boolean inRange = tileDist <= 2.25;
    boolean sameTile = tileFormX == player.tileFormX && tileFormY == player.tileFormY;
  
    if (stunned) {
      stunTimer -= dt;
      if (stunTimer <= 0) {
        stunned = false;
      }
    } else {
      if (inRange) {
        speed = boostSpeed;
      } else {
        speed = normalSpeed;
      }
  
      if (sameTile) {
        //direct movement toward player so it can actualy chase the player instead of the middle
        PVector toPlayer = new PVector(p.x - (x + enemyWidth/2), p.y - (y + enemyHeight/2));
        if (toPlayer.mag() > 0) toPlayer.normalize();
        x += toPlayer.x * speed * dt;
        y += toPlayer.y * speed * dt;
  
        //hitbox check
        boolean hitsPlayer = x + enemyWidth  > p.x - p.playerWidth  / 2 && x < p.x + p.playerWidth  / 2 && y + enemyHeight > p.y - p.playerHeight / 2 && y < p.y + p.playerHeight / 2;
  
        if (hitsPlayer) {
          player.currHealth -= 30;
          player.justTookDmg = true;
          player.timeSinceDamage = 0;
          stunned = true;
          stunTimer = stunDuration;
          speed = normalSpeed;
        }
      } else {
        move(dt); //BFS if not in the same tile
      }
    }
  
    for (Bullet b : bullets) {
      if (!b.isExpired()) b.update(dt);
    }
  
    takeDamage();
    tileFormX = (int)(x / gameWorld.map.tileSize);
    tileFormY = (int)(y / gameWorld.map.tileSize);
  }

  void Draw() {
    float tileDist = dist(tileFormX, tileFormY, player.tileFormX, player.tileFormY);
    float alphaVal;
    if (stunned || tileDist <= 2.5) {
      alphaVal = 255;
    } else {
      alphaVal = 10;
    }
    fill(180, 50, 180, alphaVal);
    stroke(100, 0, 100, alphaVal);
    strokeWeight(2);
    rectMode(CENTER);
    rect(x + enemyWidth/2, y + enemyHeight/2, enemyWidth, enemyHeight);
    rectMode(CORNER);
  }

  // same base applyDamage system, but skipped entirely while invisible
  // and hit by a bullet at or above highVelThreshold (dodge, no damage at all)
  void takeDamage() {
    for (Bullet b : p.bullets) {
      if (b.isAoe && (b.keepExploding() || b.hitsEnemy(this))) {
        if (new PVector(x + enemyWidth - b.x, y + enemyHeight - b.y).mag() < b.range) {
          applyDamage(b);
          b.age = b.lifetime + 1;
        }
      } else if (!b.isExpired() && b.hitsEnemy(this)) {
        float tileDist = dist(tileFormX, tileFormY, player.tileFormX, player.tileFormY);
        boolean invisible = tileDist > 2.25 && !stunned;

        if (invisible && b.speed >= highVelThreshold) {
          b.age = b.lifetime + 1; // dodged — no damage
        } else {
          applyDamage(b);
          b.age = b.lifetime + 1;
        }
      }
    }
  }
}

public class Gunner extends Enemy {
  float shootSpeed = 50;
  float normalSpeed = 90;
  int shotsFired = 0;
  int maxShots = 100;
  boolean shooting = false;
  float tileDetectRange = 6;
  float lastKnownPlayerX;
  float lastKnownPlayerY;
  boolean hasLastKnown = false;
  int state = 0;
  float delay = 0.75;
  float timer = 0;

  Gunner(Player p, float x, float y) {
    super(p, x, y);
    speed = normalSpeed;
    maxHealth = 200;
    currHealth = maxHealth;
    armor = 0.15;
    armorHp = 150;
    maxArmorHp = 150;
    atkCd = 0.025;
    damage = 10;
    enemyWidth = 30;
    enemyHeight = 30;
  }

  void update(float playerX, float playerY, float dt) {
    float tileDist = dist(tileFormX, tileFormY, player.tileFormX, player.tileFormY);
    boolean inRange = tileDist <= tileDetectRange;
    boolean los = hasLineOfSight();
  
    // update last known position when we can see player
    if (los && inRange) {
      lastKnownPlayerX = playerX;
      lastKnownPlayerY = playerY;
      hasLastKnown = true;
    }
  
    if (shooting) {
      speed = shootSpeed;
      move(dt);
      currAtkCd += 0.5 * dt;
      if (shouldAttack()) {
        if (los) { //shoot at last known position if no LOS
          shootBullet(playerX, playerY);
        } else if (hasLastKnown) {
          shootBullet(lastKnownPlayerX, lastKnownPlayerY);
        }
        shotsFired++;
        if (shotsFired >= maxShots) {
          state = 0;
          shooting = false;
          shotsFired = 0;
          speed = normalSpeed;
        }
      }
    } else {
      speed = normalSpeed;
      move(dt);
      if (inRange && los) {
        if (state == 0){
          state = 1;
          timer = 0;
        }
        if (state == 1){
          timer += dt;
          if (timer >= delay){
            state = 2;
          }
        }
        if (state == 2){
           shooting = true;
        }

      }
    }
  
    for (Bullet b : bullets) {
      if (!b.isExpired()) b.update(dt);
    }
  
    takeDamage();
    tileFormX = (int)(x / gameWorld.map.tileSize);
    tileFormY = (int)(y / gameWorld.map.tileSize);
  }

  boolean hasLineOfSight() {
    PVector dir = PVector.sub(new PVector(p.x, p.y), new PVector(x, y)).normalize();
    float checkX = x;
    float checkY  = y;
    float step = 10;
    float maxDist = dist(x, y, p.x, p.y);
    float traveled = 0;

    while (traveled < maxDist) {
      checkX += dir.x * step;
      checkY += dir.y * step;
      traveled += step;

      int tileCol = (int)(checkX / gameWorld.map.tileSize);
      int tileRow = (int)(checkY / gameWorld.map.tileSize);

      if (tileRow >= 0 && tileRow < gameWorld.map.rows && tileCol >= 0 && tileCol < gameWorld.map.cols) {
        if (gameWorld.map.grid[tileRow][tileCol] == gameWorld.map.WALL) {
          return false;
        }
      }
    }
    return true;
  }

  void shootBullet(float targetX, float targetY) {
    float startX = x + enemyWidth / 2;
    float startY = y + enemyHeight / 2;
    PVector dir = PVector.sub(new PVector(targetX, targetY), new PVector(startX, startY)).normalize();
    Bullet b = new Bullet(dir, startX, startY);
    b.damage = damage;
    b.lifetime = 1;
    b.speed = 2000;
    bullets.add(b);
    currAtkCd = 0;
  }

  void Draw() {
    if (state == 1 || state == 2) {
      fill(255, 140, 0);
    } else {
      fill(180, 100, 0);
    }
    stroke(120, 60, 0);
    strokeWeight(5);
    rectMode(CENTER);
    rect(x + enemyWidth/2, y + enemyHeight/2, enemyWidth, enemyHeight);
    rectMode(CORNER);

    for (Bullet b : bullets) {
      if (!b.isExpired()) b.Draw();
    }
  }
}

public class Sniper extends Enemy {
  float normalSpeed    = 60;
  float stopRange      = 7.5; // tiles
  float atkDelay       = 5.0; // seconds between shots
  float chargeTime     = 2.1; // laser charge before firing
  float lockTime       = 0.4; // lock on last position 0.5s before firing
  float atkTimer       = 0;
  float chargeTimer    = 0;
  boolean charging     = false;
  boolean locked       = false;
  float lockedTargetX  = 0;
  float lockedTargetY  = 0;
  float laserFadeTimer = 0;
  float laserFadeDuration = 0.5;
  boolean showLaser    = false;
  float laserEndX, laserEndY;

  Sniper(Player p, float x, float y) {
    super(p, x, y);
    speed = normalSpeed;
    maxHealth  = 80;
    currHealth = maxHealth;
    armor = 0;
    enemyWidth  = 16;
    enemyHeight = 16;
  }

  void update(float playerX, float playerY, float dt) {
    float tileDist = dist(tileFormX, tileFormY, player.tileFormX, player.tileFormY);

    //move toward player until stop range
    if (!charging) {
      if (tileDist > stopRange) {
        move(dt);
      }

      atkTimer += dt;
      if (atkTimer >= atkDelay) {
        atkTimer  = 0;
        charging = true;
        chargeTimer = 0;
        locked = false;
      }
    } else {
      //charging -- count up
      chargeTimer += dt;

      //lock on last position when 0.5s remains
      if (!locked && chargeTimer >= chargeTime - lockTime) {
        locked = true;
        lockedTargetX = playerX;
        lockedTargetY = playerY;
      }

      //fire when charge complete
      if (chargeTimer >= chargeTime) {
        fireSniper();
        charging = false;
        chargeTimer = 0;
        locked = false;
      }
    }

    //fade laser
    if (showLaser) {
      laserFadeTimer -= dt;
      if (laserFadeTimer <= 0) {
        showLaser = false;
      }
    }

    for (Bullet b : bullets) {
      if (!b.isExpired()) b.update(dt);
    }

    takeDamage();
    tileFormX = (int)(x / gameWorld.map.tileSize);
    tileFormY = (int)(y / gameWorld.map.tileSize);
  }

  void fireSniper() {
    float startX = x + enemyWidth / 2;
    float startY = y + enemyHeight / 2;
  
    PVector dir = PVector.sub(new PVector(lockedTargetX, lockedTargetY), new PVector(startX, startY)).normalize();
  
    // check if player is still near locked position
    float distToLocked = dist(player.x, player.y, lockedTargetX, lockedTargetY);
    if (distToLocked < 30) {
      if (!(player.scoutActive && player.shouldDodge)) {
        player.currHealth -= 75;
        player.justTookDmg = true;
        player.timeSinceDamage = 0;
      }
    }
      laserEndX = startX + dir.x * 6767;
    laserEndY = startY + dir.y * 6767;
    showLaser = true;
    laserFadeTimer = laserFadeDuration;
  }

  void Draw() {
    // draw sniper body
    fill(50, 150, 50);
    stroke(20, 80, 20);
    strokeWeight(2);
    rectMode(CENTER);
    rect(x + enemyWidth/2, y + enemyHeight/2, enemyWidth, enemyHeight);
    rectMode(CORNER);

    float startX = x + enemyWidth / 2;
    float startY = y + enemyHeight / 2;

    // red indicator laser while charging
    if (charging) {
      float targetX;
      float targetY;
      if (locked) {
        targetX = lockedTargetX;
        targetY = lockedTargetY;
      } else {
        targetX = player.x;
        targetY = player.y;
      }
    
      PVector dir = PVector.sub(new PVector(targetX, targetY), new PVector(startX, startY)).normalize();
      float endX = startX + dir.x * 6767;
      float endY = startY + dir.y * 6767;
    
      float progress = chargeTimer / chargeTime;
      float alpha = map(progress, 0, 1, 80, 220);
    
      stroke(255, 0, 0, alpha);
      strokeWeight(1);
      line(startX, startY, endX, endY);
    }

    //bright red laser after firing
    if (showLaser) {
      float alpha = map(laserFadeTimer, 0, laserFadeDuration, 0, 255);
      stroke(255, 0, 0, alpha);
      strokeWeight(4);
      line(startX, startY, laserEndX, laserEndY);

      //glow
      stroke(255, 100, 100, alpha * 0.4);
      strokeWeight(10);
      line(startX, startY, laserEndX, laserEndY);
    }

    noStroke();
  }
}
