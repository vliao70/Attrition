public class Bullet{
  float x;
  float y;
  PVector direction;
  float speed;
  float damage;
  String owner;
  float lifetime;
  float age;
  boolean isAoe;
  float range;
  boolean exploded;
  float explodeDur;
  
  PVector velocity;
  PVector gravity;
  boolean physics = false;
  
  float w = 8;
  float h = 8;
  
  float armorPen = 1.0;
  
  void update(float dt){
    if (physics) {
      velocity.add(PVector.mult(gravity, dt));
      x += velocity.x * dt;
      y += velocity.y * dt;
    } 
    else {
      x += direction.x * speed * dt;
      y += direction.y * speed * dt;
    }
    
    age += dt;
    //println("bullet at " + x + ", " + y + " age: " + age + " lifetime: " + lifetime);
    
    if (exploded){
      explodeDur -= dt;
    }
  }
  
  public Bullet(PVector direction,float x, float y){
    //println("Bullet no-stats created at " + x + ", " + y);
    speed = 300;
    age = 0;
    lifetime = 2;
    this.direction = direction;
    this.x = x;
    this.y = y;
    damage = 10;
    
    exploded = false;
  }
  
  public Bullet(PVector direction,float x, float y, float damage, float speed, float lifetime, boolean isAoe, float range){
    this(direction,x,y);
    this.damage = damage;
    this.speed = speed;
    this.lifetime = lifetime;
    this.isAoe = isAoe;
    this.range = range;
    explodeDur = 0.1;
  }
  
  public Bullet(PVector direction, float x, float y, float damage, float speed, float lifetime, boolean isAoe, float range, boolean physics) {

    this(direction, x, y, damage, speed, lifetime, isAoe, range);
  
    this.physics = physics;
  
    if (physics) {
      velocity = direction.copy().mult(speed);
      gravity = new PVector(0, 600); // tweak strength
    }
  }
  
  public Bullet(PVector direction, float x, float y, StatBlock stats){
    //println("Bullet stats created at " + x + ", " + y);
    age = 0;
    this.lifetime = stats.bulletLifetime;  
    this.x = x;
    this.y = y;
    this.damage = stats.damage;
    this.speed = stats.bulletVelocity;
  
    //deviation code
    float deviationAngle = random(-stats.deviation, stats.deviation) * (PI / 180);
    float cos = cos(deviationAngle);
    float sin = sin(deviationAngle);
    float newX = direction.x * cos - direction.y * sin;
    float newY = direction.x * sin + direction.y * cos;
    this.direction = new PVector(newX, newY).normalize();
  }
   //<>//
  void Draw(/*int camX, int camY*/){
    if (isAoe) {
      fill (255,164,0);
      strokeWeight(2);
      stroke(200,164,50);
      rectMode(CENTER);
      rect(x,y,8,8);
      rectMode(CORNER);
    } else {
      fill(88);
      strokeWeight(0);
      rectMode(CENTER);
      rect(x,y,5,5);
      rectMode(CORNER);
    }
  }
  
  boolean isExpired(){
    return age > lifetime;
  }
  
  boolean keepExploding(){
    if (isAoe && age > lifetime && (!exploded || explodeDur >= 0)){
      exploded = true;
      return true;
    }
    return false;
  }
  
  boolean hitsEnemy(Enemy e){
    float stroke = 4; //enemy strokeWeight
    return x >= e.x - stroke && x <= e.x + e.enemyWidth  + stroke && y >= e.y - stroke && y <= e.y + e.enemyHeight + stroke;
  }
  
  boolean hitsPlayer(Player p){
    return false;
  }
}
