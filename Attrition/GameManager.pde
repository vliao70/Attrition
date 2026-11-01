public class GameManager{
  String currentScreen;
  PlayerLoadout loadout;
  MenuManager menuManager;
  
  
  GameManager(){
    currentScreen = "menu";
    loadout = new PlayerLoadout();
    menuManager = new MenuManager(loadout, this);

    gameWorld = null;
  }
  
  void update(float dt){
    if (gameEnded) {
      gg.Draw();
    } else if (currentScreen.equals("menu")){
      menuManager.update();
    } else if (currentScreen.equals("game")){
      gameWorld.update(dt);
    } 
  }
  
  void Draw(float dt){
    
    if (currentScreen.equals("menu")){
      menuManager.draw();
    } else if (currentScreen.equals("game")){
      gameWorld.Draw(dt);
    }
  }
  
  void goTo(String screen){
    currentScreen = screen;
    if (screen.equals("menu")){
      menuManager.onEnter();
    } else if (screen.equals("game")){
      if (gameWorld == null) {
        player    = new Player(loadout);
        gameWorld = new GameWorld(loadout);
        gameWorld.setUp();
        hud.player = player;
      }
    }
  }
  
  void startGame(){
    goTo("game");
    
    waveManager = new WaveManager();
    waveManager.start();
  }
   
  void goToMenu(){
    goTo("menu");
  }
  
  void handleClick(int mx, int my){
    if (currentScreen.equals("menu")){
      menuManager.handleClick(mx, my);
    } else if (currentScreen.equals("game")){
      gameWorld.handleClick(mx, my);
    }
  }
  
  void handleKey(char key){
    if (currentScreen.equals("menu")){
      menuManager.handleKey(key);
    } else if (currentScreen.equals("game")){
      gameWorld.handleKey(key);
    }
  }
}
