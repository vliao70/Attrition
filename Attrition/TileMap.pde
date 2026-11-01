public class TileMap {
  int[][] grid;
  int tileSize;
  int cols;
  int rows;
  int[][] tileFormGrid;

  final int ANCHOR = 4;
  final int WORKSHOP = 3;
  final int HEAL = 2;
  final int WALL = 1;
  final int SPACE = 0;

  final int NUM_ANCHORS = 4;
  final int NUM_WORKSHOPS = 0;
  final int NUM_HEALS = 0;

  ArrayList<int[]> deactivatedAnchors = new ArrayList<int[]>();
  float anchorRechargeDuration = 60; // seconds to regenerate

  public TileMap(int rows, int cols) {
    this.cols = cols;
    this.rows = rows;
    tileSize = 100;
    grid = new int[rows][cols];
    tileFormGrid = new int[rows][cols];

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        grid[i][j] = WALL;
      }
    }

    carveMaze(1, 1);
    placeSpecialTiles();
    buildCollisionObjects();
  }

  public boolean canCarve(int row, int col) {
    if (row <= 0 || row >= rows - 1 || col <= 0 || col >= cols - 1) return false;
    if (grid[row][col] == SPACE) return false;

    int emptyCount = 0;
    int[][] directions = {{1,0},{-1,0},{0,1},{0,-1}};
    for (int[] dir : directions) {
      int newRow = row + dir[0];
      int newCol = col + dir[1];
      if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
        if (grid[newRow][newCol] == SPACE) emptyCount++;
      }
    }
    return emptyCount < 3;
  }

  public void carveMaze(int row, int col) {
    if (!canCarve(row, col)) return;
    grid[row][col] = SPACE;

    ArrayList<int[]> directions = new ArrayList<int[]>();
    directions.add(new int[]{1,  0});
    directions.add(new int[]{-1, 0});
    directions.add(new int[]{0,  1});
    directions.add(new int[]{0, -1});

    while (directions.size() > 0) {
      int[] dir = directions.remove((int)(Math.random() * directions.size()));
      carveMaze(row + dir[0], col + dir[1]);
    }
  }

  void placeSpecialTiles() {
    ArrayList<int[]> openSpaces = new ArrayList<int[]>();
    for (int r = 1; r < rows - 1; r++) {
      for (int c = 1; c < cols - 1; c++) {
        if (grid[r][c] == SPACE) openSpaces.add(new int[]{r, c});
      }
    }

    // shuffle
    for (int i = openSpaces.size() - 1; i > 0; i--) {
      int j   = (int)(Math.random() * (i + 1));
      int[] t = openSpaces.get(i);
      openSpaces.set(i, openSpaces.get(j));
      openSpaces.set(j, t);
    }

    // place anchors spread far apart
    ArrayList<int[]> anchorPositions = new ArrayList<int[]>();
    float minDist = (rows + cols) / (float)(NUM_ANCHORS + 1);

    for (int[] pos : openSpaces) {
      if (anchorPositions.size() >= NUM_ANCHORS) break;
      boolean tooClose = false;
      for (int[] existing : anchorPositions) {
        if (dist(pos[0], pos[1], existing[0], existing[1]) < minDist) {
          tooClose = true;
          break;
        }
      }
      if (!tooClose) {
        anchorPositions.add(pos);
        grid[pos[0]][pos[1]] = ANCHOR;
      }
    }

    if (anchorPositions.size() < NUM_ANCHORS) {
      for (int[] pos : openSpaces) {
        if (anchorPositions.size() >= NUM_ANCHORS) break;
        if (grid[pos[0]][pos[1]] == SPACE) {
          anchorPositions.add(pos);
          grid[pos[0]][pos[1]] = ANCHOR;
        }
      }
    }

    int workshopsPlaced = 0;
    int healsPlaced     = 0;

    for (int[] pos : openSpaces) {
      if (workshopsPlaced >= NUM_WORKSHOPS && healsPlaced >= NUM_HEALS) break;
      if (grid[pos[0]][pos[1]] == SPACE) {
        if (workshopsPlaced < NUM_WORKSHOPS) {
          grid[pos[0]][pos[1]] = WORKSHOP;
          workshopsPlaced++;
        } else if (healsPlaced < NUM_HEALS) {
          grid[pos[0]][pos[1]] = HEAL;
          healsPlaced++;
        }
      }
    }

    println("Placed: " + anchorPositions.size() + " anchors, " + workshopsPlaced + " workshops, " + healsPlaced + " heals");
  }

  void buildCollisionObjects() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        tileFormGrid[r][c] = WALL;

        if (isWall(r, c)) {
          gameWorld.colObjs.add(new CollisionObject(c * tileSize, r * tileSize, tileSize, tileSize));
          tileFormGrid[r][c] = WALL;
        } else if (isSpace(r, c)) {
          tileFormGrid[r][c] = SPACE;
        } else if (isHeal(r, c)) {
          gameWorld.colObjs.add(new CollisionObject(c * tileSize, r * tileSize, tileSize, tileSize, false, HEAL));
          tileFormGrid[r][c] = HEAL;
        } else if (isWorkshop(r, c)) {
          gameWorld.colObjs.add(new CollisionObject(c * tileSize, r * tileSize, tileSize, tileSize, false, WORKSHOP));
          tileFormGrid[r][c] = WORKSHOP;
        } else if (isAnchor(r, c)) {
          gameWorld.colObjs.add(new CollisionObject(c * tileSize, r * tileSize, tileSize, tileSize, false, ANCHOR));
          tileFormGrid[r][c] = ANCHOR;
        }
      }
    }

    for (int j = -1; j > -4; j--) {
      for (int i = -6; i < rows + 7; i++) {
        gameWorld.colObjs.add(new CollisionObject(i * tileSize, j * tileSize, tileSize, tileSize));
        gameWorld.colObjs.add(new CollisionObject(i * tileSize, (rows - 1 - j) * tileSize, tileSize, tileSize));
      }
    }
    for (int j = -1; j > -7; j--) {
      for (int i = 0; i < cols; i++) {
        gameWorld.colObjs.add(new CollisionObject(j * tileSize, i * tileSize, tileSize, tileSize));
        gameWorld.colObjs.add(new CollisionObject((cols - 1 - j) * tileSize, i * tileSize, tileSize, tileSize));
      }
    }
  }

  void update(float dt) {
    for (int i = deactivatedAnchors.size() - 1; i >= 0; i--) {
      int[] anchor = deactivatedAnchors.get(i);
      anchor[2] -= (int)(dt * 1000); // stored in milliseconds as int
      if (anchor[2] <= 0) {
        grid[anchor[0]][anchor[1]]         = ANCHOR;
        tileFormGrid[anchor[0]][anchor[1]] = ANCHOR;
        deactivatedAnchors.remove(i);
        println("Anchor regenerated at " + anchor[0] + ", " + anchor[1]);
      }
    }
  }

  boolean isDeactivatedAnchor(int r, int c) {
    for (int[] anchor : deactivatedAnchors) {
      if (anchor[0] == r && anchor[1] == c) return true;
    }
    return false;
  }

  void Draw() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        int   tile = tileFormGrid[r][c];
        float x    = c * tileSize;
        float y    = r * tileSize;

        if (tile == WALL) {
          fill(60);
          noStroke();
          rect(x, y, tileSize, tileSize);
        } else if (tile == SPACE) {
          if (isDeactivatedAnchor(r, c)) {
            fill(60, 0, 90);
            noStroke();
            rect(x, y, tileSize, tileSize);
            fill(120, 60, 150);
            textAlign(CENTER, CENTER);
            textSize(12);
            text("A", x + tileSize / 2, y + tileSize / 2);
          } else {
            fill(200);
            noStroke();
            rect(x, y, tileSize, tileSize);
          }
        } else if (tile == ANCHOR) {
          fill(150, 0, 255);
          noStroke();
          rect(x, y, tileSize, tileSize);
          fill(255);
          textAlign(CENTER, CENTER);
          textSize(12);
          text("A", x + tileSize / 2, y + tileSize / 2);
        } else if (tile == WORKSHOP) {
          fill(0, 150, 255);
          noStroke();
          rect(x, y, tileSize, tileSize);
          fill(255);
          textAlign(CENTER, CENTER);
          textSize(12);
          text("W", x + tileSize / 2, y + tileSize / 2);
        } else if (tile == HEAL) {
          fill(0, 200, 100);
          noStroke();
          rect(x, y, tileSize, tileSize);
          fill(255);
          textAlign(CENTER, CENTER);
          textSize(12);
          text("H", x + tileSize / 2, y + tileSize / 2);
        }
      }
    }
  }

  boolean isAnchor(int r, int c) { return grid[r][c] == ANCHOR;}
  boolean isWorkshop(int r, int c) { return grid[r][c] == WORKSHOP;}
  boolean isHeal(int r, int c) { return grid[r][c] == HEAL;}
  boolean isWall(int r, int c) { return grid[r][c] == WALL;}
  boolean isSpace(int r, int c) { return grid[r][c] == SPACE;}
  int getTileAt(int col, int row) { return grid[row][col];}
}
