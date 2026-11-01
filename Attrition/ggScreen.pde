public class ggScreen{  
  PImage lost;
  boolean gameWon = false;

  void setUp() {
    lost = loadImage("sonion.jpeg");
  }

  void draw() {
    if (gameWon) {
      drawWinScreen();
    } else {
      drawLoseScreen();
    }
  }

  void drawLoseScreen() {
    stroke(0);
    strokeWeight(2);
    fill(255);
    rect(750, 400, 300, 100);
    fill(0);
    textAlign(LEFT, CENTER);
    textSize(20);
    text("GAME OVER\npress B to go back to menu", 760, 440);
    image(lost, 300, 300);
  }

  void drawWinScreen() {
    background(20, 20, 40);
    fill(255, 215, 0);
    textAlign(CENTER, CENTER);
    textSize(48);
    text("YOU WIN", width / 2, 200);

    fill(255);
    textSize(20);
    text("All 10 waves cleared!", width / 2, 290);

    fill(200);
    textSize(16);
    text("press B to return to menu", width / 2, 340);
  }

  void Draw() {
    draw();
  }

  void handleClick(int mx, int my) {}
  void handleKey(char k) {}
  void onEnter() {}
  void onExit() {}
  void update() {}
}
