public class CollisionObject {
  // top left coord
  int x;
  int y;
  int colWidth;
  int colHeight;
  
  boolean shouldCollide;
  int type;
  
  float healTickTimer = 0;
  float healTickRate = 0.1;
  int healsLeft = 50;
  
  boolean anchorUsed = false;

  
  public CollisionObject(int x, int y, int colWidth, int colHeight){
    this.x = x;
    this.y = y;
    this.colWidth = colWidth;
    this.colHeight = colHeight;
    shouldCollide = true;
  }
  
  public CollisionObject(int x, int y, int colWidth, int colHeight, boolean shouldCollide, int type) {
    this(x,y,colWidth, colHeight);
    this.shouldCollide = shouldCollide;
    this.type = type;
  }

  void Draw(float dt) {
    if (shouldCollide) {
      fill(100,100,100);
      noStroke();
      rect(x,y,colWidth,colHeight);
      //image(wallCrate,x,y,colWidth,colHeight);
    } else if (type == gameWorld.map.HEAL) {
        boolean playerInside = player.x > x && player.x < x + colWidth && player.y > y && player.y < y + colHeight;
        boolean healing = playerInside && healsLeft > 0 && player.currHealth < player.maxHealth;
      
       if (healsLeft > 0) {
         if (healing) {
           fill(0, 255, 100);
         } else {
           fill(144, 238, 144);
         }
       } else {
         fill(160, 160, 160);
       }
       noStroke();
       rect(x, y, colWidth, colHeight);
        
    } else if (type == gameWorld.map.WORKSHOP) {
      fill (255,165,0);
      noStroke();
      rect(x,y,colWidth,colHeight);
      workshop();
    } else if (type == gameWorld.map.ANCHOR) {
      if (!anchorUsed) {
        fill ( 160, 32, 240); 
      } else {
        fill (80, 16, 120);
      }
       
      noStroke();
      rect(x,y,colWidth,colHeight);
    }
  }
  
  void Update(float dt) {
    if (shouldCollide) {
      collide(dt);
      collideBullets(dt);
    }
    if (type == gameWorld.map.HEAL) {
      heal(dt, 1);
    }
    
  }
  
  void anchor() {
    float pLeft = player.x - player.playerWidth / 2;
    float pRight = player.x + player.playerWidth / 2;
    float pTop = player.y - player.playerHeight / 2;
    float pBottom = player.y + player.playerHeight / 2;
  
    float cLeft = x;
    float cRight = x + colWidth;
    float cTop = y;
    float cBottom = y + colHeight;
    
    boolean inside =
      pRight > cLeft &&
      pLeft < cRight &&
      pBottom > cTop &&
      pTop < cBottom;
    
    if (inside) {
      if (qPressed && !anchorUsed) {
        anchorUsed = true;
      }
    }
  }
  
  void workshop() {
    float pLeft = player.x - player.playerWidth / 2;
    float pRight = player.x + player.playerWidth / 2;
    float pTop = player.y - player.playerHeight / 2;
    float pBottom = player.y + player.playerHeight / 2;
  
    float cLeft = x;
    float cRight = x + colWidth;
    float cTop = y;
    float cBottom = y + colHeight;
    
    boolean inside =
      pRight > cLeft &&
      pLeft < cRight &&
      pBottom > cTop &&
      pTop < cBottom;
      
    canOpenMenu = inside;
    
    if (inside) {
      showWorkshopTooltip = true;
    }
  }
  
  void heal(float dt, float amount) {
    float pLeft = player.x - player.playerWidth  / 2;
    float pRight = player.x + player.playerWidth  / 2;
    float pTop = player.y - player.playerHeight / 2;
    float pBottom = player.y + player.playerHeight / 2;
  
    float cLeft = x;
    float cRight  = x + colWidth;
    float cTop = y;
    float cBottom = y + colHeight;
  
    boolean inside = pRight > cLeft && pLeft < cRight && pBottom > cTop && pTop < cBottom;
  
    boolean atFullHp = player.currHealth >= player.maxHealth;
  
    if (inside && healsLeft > 0 && !atFullHp) {
      healTickTimer += dt;
      if (healTickTimer >= healTickRate) {
        healTickTimer = 0;
        player.currHealth = min(player.currHealth + 1, player.maxHealth);
        healsLeft--;
      }
    } else if (!inside || atFullHp) {
      healTickTimer = 0;
    }
  }
  
  void collide(float dt){
    float moveX = player.dirMovement.x * player.speed * dt;
    float moveY = player.dirMovement.y * player.speed * dt;
  
    float pLeft   = player.x - player.playerWidth  / 2;
    float pRight  = player.x + player.playerWidth  / 2;
    float pTop    = player.y - player.playerHeight / 2;
    float pBottom = player.y + player.playerHeight / 2;
  
    float cLeft   = x;
    float cRight  = x + colWidth;
    float cTop    = y;
    float cBottom = y + colHeight;
  
    float nextLeft   = pLeft   + moveX;
    float nextRight  = pRight  + moveX;
    float nextTop    = pTop    + moveY;
    float nextBottom = pBottom + moveY;
  
    //check if next position overlaps
    boolean overlapX = nextRight > cLeft && nextLeft < cRight && pBottom > cTop && pTop < cBottom;
    boolean overlapY = pRight > cLeft && pLeft < cRight && nextBottom > cTop && nextTop < cBottom;
    boolean overlapXY = nextRight > cLeft && nextLeft < cRight && nextBottom > cTop && nextTop < cBottom;
  
    if (overlapX && overlapY && overlapXY) {
      //corner
      float penX = moveX > 0 ? cLeft - pRight : cRight - pLeft;
      float penY = moveY > 0 ? cTop - pBottom : cBottom - pTop;
  
      if (abs(penX) < abs(penY)) {
        player.dirMovement.x = penX / (player.speed * dt);
      } else {
        player.dirMovement.y = penY / (player.speed * dt);
      }
    } else if (overlapX) {
      if (moveX > 0) {
        float allowed = cLeft - pRight;
        player.dirMovement.x = allowed / (player.speed * dt);
      } else if (moveX < 0) {
        float allowed = cRight - pLeft;
        player.dirMovement.x = allowed / (player.speed * dt);
      }
    } else if (overlapY) {
      if (moveY > 0) {
        float allowed = cTop - pBottom;
        player.dirMovement.y = allowed / (player.speed * dt);
      } else if (moveY < 0) {
        float allowed = cBottom - pTop;
        player.dirMovement.y = allowed / (player.speed * dt);
      }
    }
  }
  
  
    
    
    
  void collideBullets(float dt) {  
    // collision with bullets
    for (Bullet b : player.bullets) {
      float pLeft = b.x - b.w / 2;
      float pRight = b.x + b.w / 2;
      float pTop = b.y - b.h / 2;
      float pBottom = b.y + b.h / 2;
    
      float cLeft = x;
      float cRight = x + colWidth;
      float cTop = y;
      float cBottom = y + colHeight;
    
      boolean inside =
        pRight > cLeft &&
        pLeft < cRight &&
        pBottom > cTop &&
        pTop < cBottom;
        
      if (inside && !b.isAoe) {
        b.age = b.lifetime+1;
      }
    }
    for (Enemy e : gameWorld.enemies) {
      for (Bullet b : e.bullets) {
        float pLeft = b.x - b.w / 2;
        float pRight = b.x + b.w / 2;
        float pTop = b.y - b.h / 2;
        float pBottom = b.y + b.h / 2;
      
        float cLeft = x;
        float cRight = x + colWidth;
        float cTop = y;
        float cBottom = y + colHeight;
      
        boolean inside =
          pRight > cLeft &&
          pLeft < cRight &&
          pBottom > cTop &&
          pTop < cBottom;
          
        if (inside) {
          b.age = b.lifetime+1;
        }
      }
    }
  }
  
  
}
