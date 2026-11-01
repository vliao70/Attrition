public class MenuManager{
  Screen currentScreen;
  PlayerLoadout loadout;
  GameManager manager;
  
  //screen slop
  MainMenuScreen mainMenu;
  LoadoutScreen loadoutScreen;
  WeaponEditorScreen weaponEditor;
  InfoScreen settings;
  CreditsScreen credits;
  ClassSelectScreen classSelect;
 
  MenuManager(PlayerLoadout loadout, GameManager manager){
    this.loadout = loadout;
    this.manager = manager;
  
    mainMenu = new MainMenuScreen(this);
    loadoutScreen = new LoadoutScreen(this, loadout);
    settings = new InfoScreen(this);
    credits = new CreditsScreen(this);
    weaponEditor = new WeaponEditorScreen(this, loadout);
    classSelect = new ClassSelectScreen(this, loadout);
    //aux = new AuxScreen(this, loadout);
    loadout.selectedClass = classSelect.classes[0]; 
  
    currentScreen = mainMenu;
    currentScreen.onEnter();
  }
  
  void update(){
    currentScreen.update();
  }
  
  void draw(){
    currentScreen.draw();
  }

  void handleClick(int x, int y){
    currentScreen.handleClick(x, y);
  }
  
  void handleKey(char key){
    currentScreen.handleKey(key);
  }
  
  void switchTo(String screen){
    currentScreen.onExit();
 
    if (screen.equals("main")){
      currentScreen = mainMenu; //<>//
    } else if (screen.equals("loadout")){ //<>//
      currentScreen = loadoutScreen;
    } else if (screen.equals("weaponEditor")){
      currentScreen = weaponEditor;
    } else if (screen.equals("aux")){

    } else if (screen.equals("settings")){
      currentScreen = settings;
    } else if (screen.equals("info")) {
      currentScreen = settings;
    } else if (screen.equals("credits")){
      currentScreen = credits;
    } else if (screen.equals("classSelect")){
      currentScreen = classSelect;
    } else {
      println("what the heck??? how did you get here?????");
      return;
    }
 
    currentScreen.onEnter();
  }
  
  void onEnter(){
    switchTo("main");
  }
  
  void startGame(){
    manager.startGame();
  }
}
