public class WaveManager {
  int currentWave = 0;
  int totalWaves  = 10;

  float waveEndTimer = 0;
  boolean allEnemiesCleared = false;
  boolean waveEnding = false;
  boolean active = false;
  boolean allSpawned = false;
  boolean gameWon = false;
  float spawnTimer = 0;
  int[] spawnQueue = new int[5];

  //infantry, shielder, cloaker, gunner, sniper, spawnInterval, waveBreak, fallbackTimer
  float[][] waves = {
    {8,  0,  0, 0, 0,  0.50, 5,  45}, //infantry wave
    {10, 2,  0, 0, 0,  0.50, 5,  45}, //introduce shielder
    {8,  4,  1, 0, 0,  0.60, 5, 45}, //CLOAKER
    {4, 12,  2, 0, 0,  0.60, 5, 45}, //shielder spam
    {6,  2,  5, 0, 0,  0.60, 5, 45}, //cloaker rush
    {14, 2,  0, 1, 0,  0.10, 10, 85}, //gunner
    {4,  8,  2, 0, 2,  0.70, 10, 85}, //sniper
    {14, 10, 3, 1, 3,  0.70, 10, 95}, //random bs go
    {30, 0, 0, 0, 5,  0.15, 10, 115},
    {20, 10, 6, 3, 3,  0.25, 10, 140},
  };

  WaveManager() {}

  void start() {
    startWave(0);
  }

  void startWave(int index) {
    currentWave = index;
    allSpawned = false;
    allEnemiesCleared = false;
    waveEnding = false;
    spawnTimer = 0;
    active = true;

    spawnQueue[0] = (int)waves[index][0];
    spawnQueue[1] = (int)waves[index][1];
    spawnQueue[2] = (int)waves[index][2];
    spawnQueue[3] = (int)waves[index][3];
    spawnQueue[4] = (int)waves[index][4];

    waveEndTimer = waves[index][7]; // fallback timer

    println("Wave " + (index + 1) + " started -- " +
      spawnQueue[0] + " inf, " +
      spawnQueue[1] + " shield, " +
      spawnQueue[2] + " cloaker, " +
      spawnQueue[3] + " gunner, " +
      spawnQueue[4] + " sniper");
  }

  void update(float dt) {
    if (!active || gameWon) return;

    if (!allSpawned) {
      spawnTimer += dt;
      if (spawnTimer >= waves[currentWave][5]) { // spawnInterval
        spawnTimer = 0;
        spawnNextEnemy();
      }

      if (spawnQueue[0] <= 0 && spawnQueue[1] <= 0 &&
          spawnQueue[2] <= 0 && spawnQueue[3] <= 0 && spawnQueue[4] <= 0) {
        allSpawned = true;
        waveEnding = true;
        waveEndTimer = waves[currentWave][7]; // fallback
      }
    }

    if (allSpawned && !allEnemiesCleared) {
      boolean allDead = true;
      for (Enemy e : gameWorld.enemies) {
        if (!e.isDead()) {
          allDead = false;
        }
      }
      if (allDead) {
        allEnemiesCleared = true;
        waveEnding = true;
        waveEndTimer = waves[currentWave][6]; // wave break
        println("Wave " + (currentWave + 1) + " cleared!");
      }
    }

    if (waveEnding) {
      waveEndTimer -= dt;
      if (waveEndTimer <= 0) {
        if (currentWave + 1 >= totalWaves) {
          gameWon = true;
          println("All waves cleared!");
        } else {
          startWave(currentWave + 1);
        }
      }
    }
  }

  void spawnNextEnemy() {
    ArrayList<Integer> available = new ArrayList<Integer>();
    if (spawnQueue[0] > 0) available.add(0);
    if (spawnQueue[1] > 0) available.add(1);
    if (spawnQueue[2] > 0) available.add(2);
    if (spawnQueue[3] > 0) available.add(3);
    if (spawnQueue[4] > 0) available.add(4);
    if (available.size() == 0) return;

    int typeIndex = available.get((int)(Math.random() * available.size()));
    spawnQueue[typeIndex]--;

    float spawnX  = 0;
    float spawnY  = 0;
    boolean valid = false;
    int attempts  = 0;

    while (!valid && attempts < 50) {
      attempts++;
      float mapW = gameWorld.map.cols * gameWorld.map.tileSize;
      float mapH = gameWorld.map.rows * gameWorld.map.tileSize;
      float screenLeft = player.x - width  / 2;
      float screenRight = player.x + width  / 2;
      float screenTop = player.y - height / 2;
      float screenBottom = player.y + height / 2;

      int edge = (int)(Math.random() * 4);
      if (edge == 0) {
        spawnX = (float)(Math.random() * mapW);
        spawnY = gameWorld.map.tileSize;
      } else if (edge == 1) {
        spawnX = (float)(Math.random() * mapW);
        spawnY = mapH - gameWorld.map.tileSize;
      } else if (edge == 2) {
        spawnX = gameWorld.map.tileSize;
        spawnY = (float)(Math.random() * mapH);
      } else {
        spawnX = mapW - gameWorld.map.tileSize;
        spawnY = (float)(Math.random() * mapH);
      }

      boolean offScreen = spawnX < screenLeft  || spawnX > screenRight || spawnY < screenTop   || spawnY > screenBottom;
      int tileX = (int)(spawnX / gameWorld.map.tileSize);
      int tileY = (int)(spawnY / gameWorld.map.tileSize);
      boolean inBounds = tileX >= 0 && tileX < gameWorld.map.cols && tileY >= 0 && tileY < gameWorld.map.rows;

      if (inBounds && offScreen && gameWorld.map.grid[tileY][tileX] != gameWorld.map.WALL) {
        valid = true;
      }
    }

    if (!valid){
      return;
    }

    if (typeIndex == 0) {
      gameWorld.enemies.add(new Infantry(player, spawnX, spawnY));
    } else if (typeIndex == 1) {
      gameWorld.enemies.add(new Shielder(player, spawnX, spawnY));
    } else if (typeIndex == 2) {
      gameWorld.enemies.add(new Cloaker(player, spawnX, spawnY));
    } else if (typeIndex == 3) {
      gameWorld.enemies.add(new Gunner(player, spawnX, spawnY));
    } else if (typeIndex == 4) {
      gameWorld.enemies.add(new Sniper(player, spawnX, spawnY));
    }
  }

  void drawWaveInfo() {
    float boxW = 160;
    float boxH = 50;
    float boxX = width - boxW - 20;
    float boxY = 20;

    fill(40, 200);
    noStroke();
    rect(boxX, boxY, boxW, boxH);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("WAVE", boxX + boxW / 2, boxY + 14);
    textSize(22);
    text((currentWave + 1) + " / " + totalWaves, boxX + boxW / 2, boxY + 35);
  }
}
