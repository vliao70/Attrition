public class WeaponEditorScreen extends Screen{
  MenuManager menuManager;
  PlayerLoadout loadout;
  //stats tab layout
  float TAB_Y = 555;
  float TAB_H = 40;
  float TAB_W_S = 150;
  String statsTab = "WEAPON";
 
  //stats bar layout
  float STATS_Y = 600;
  float STATS_H = 120;
 
  /*placeholder vals
  float statWeight = 45;
  float statErgo = 70;
  float statRecoil = 55;
  float statMagSize = 30;
  float statDamage = 80;
  float statVelocity = 65;
  float statDeviation = 40;
  float statArmorPen = 50;
  */
  
  int editingSlot = 1;
 
  float GUN_AREA_W = 1000;  //left area with gun image
  float GUN_AREA_H = 600;  //height of gun area
  float PANEL_X = 1000;  //right panel x
  float PANEL_W = 280;  //right panel width

 
  int selectedSlot = -1; //-1 means nothing selected
 
 /* Temp code
  float[] dotX = {175, 385, 590, 720, 425};
  float[] dotY = {300, 260, 315, 290, 390};
 
  String[] slotNames = {"STOCK", "TOP PICCATINY", "HANDGUARD PICCATINY", "MUZZLE", "MAGAZINE"};
 
  String[][] attachmentOptions = {
    {"Stock A", "Stock B", "Stock C"},
    {"Carry Handle", "Red Dot A", "Scope A", "LPVO A"},
    {"Grip A", "Grip B", "Grip C", "Laser Sight"},
    {"Flash Hider A","Compensator A","Suppressor A"},
    {"Mag 20", "Mag 30", "Mag 45"}
  };
 */
  Weapon currentWeapon;
  StatBlock stats;
  float[] valuesWeapon;
  float[] valuesBal;
  
  //int[] equippedIndex = {0, 0, 0, 0, 1};
  
  float imgDrawX;
  float imgDrawY;
  float imgDrawW;
  float imgDrawH;
 
  WeaponEditorScreen(MenuManager menuManager, PlayerLoadout loadout){
    this.menuManager = menuManager;
    this.loadout = loadout;
    setCurrentWeapon(loadout.weapon1);
    this.stats = currentWeapon.getStatBlock();
    this.valuesWeapon = new float[]{stats.weight, stats.ergonomics, stats.recoil, stats.magSize};
    this.valuesBal = new float[]{stats.damage, stats.bulletVelocity, stats.deviation, stats.armorPen};
  }
  
  void onEnter(){
    selectedSlot = -1;
  }
 
  void onExit(){
    selectedSlot = -1;
  }
 
  void update(){}
  
  void draw(){
    background(75);
    drawGunImage();
    drawDots();
    drawAttachmentPanel();
    if(statsTab.equals("WEAPON")){
      drawWeaponStats();
    } else{
      drawBallisticsStats();
    }
    drawSaveButton();
  }
  
  /*void drawGunImage(){
    fill(50);
    stroke(180);
    strokeWeight(1);
    rect(0, 0, GUN_AREA_W, GUN_AREA_H);
 
    //placeholder
    fill(80);
    noStroke();
    rect(60, 100, 780, 400);
    fill(160);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("GUN IMAGE", GUN_AREA_W / 2, GUN_AREA_H / 2);
  }*/
  
  void drawDots(){
    for (int i = 0; i < currentWeapon.slots.length; i++){
      AttachmentSlot slot = currentWeapon.slots[i];
      if (slot.visible){
        if (i == selectedSlot){
          fill(220);
          stroke(200);
        } else {
          fill(200, 180);
          stroke(200);
        }
        strokeWeight(2);
        ellipse(slot.dotX, slot.dotY, 12 * 2, 12 * 2);
      }
    }
  }
  
  void drawAttachmentPanel(){
    fill(60);
    stroke(180);
    strokeWeight(1);
    rect(PANEL_X, 0, PANEL_W, GUN_AREA_H);
 
    fill(255);
    textAlign(CENTER, TOP);
    textSize(14);
 
    if (selectedSlot == -1){
      text("SELECT A PART", PANEL_X + PANEL_W / 2, 20);
      return;
    }
 
    text(currentWeapon.slots[selectedSlot].type, PANEL_X + PANEL_W / 2, 20);
 
    //attachment options
    float itemH = 60;
    float itemW = PANEL_W - 20;
    float itemX = PANEL_X + 10;
 
    for (int i = 0; i < currentWeapon.slots[selectedSlot].options.length; i++){
      float itemY = 50 + i * (itemH + 8);
 
      //highlight
      if (i == currentWeapon.slots[selectedSlot].equippedIndex()){
        fill(200);
      } else {
        fill(90);
      }
      stroke(150);
      strokeWeight(1);
      rect(itemX, itemY, itemW, itemH);
 
      if (i == currentWeapon.slots[selectedSlot].equippedIndex()){
        fill(90);
      } else {
        fill(200);
      }
      textAlign(CENTER, CENTER);
      textSize(13);
      text(currentWeapon.slots[selectedSlot].options[i].name, itemX + itemW / 2, itemY + itemH / 2);
    }
  }
 
  void drawWeaponStats(){
    String[] labels = {"WEIGHT", "ERGONOMICS", "RECOIL", "MAG SIZE"};
    float barX = 140;
    float barW = 700;
    float barH = 14;
    float rowH = STATS_H / labels.length;
 
    for (int i = 0; i < labels.length; i++){
      float rowY = STATS_Y + i * rowH + rowH / 2;
 
      //labels
      fill(255);
      textAlign(LEFT, CENTER);
      textSize(11);
      text(labels[i], 10, rowY);
 
      fill(80);
      noStroke();
      rect(barX, rowY - barH / 2, barW, barH);
 
      //stat bar
      float fillBar = (valuesWeapon[i] / 100.0) * barW;
      fill(220);
      rect(barX, rowY - barH / 2, fillBar, barH);
 
      //numero stats
      fill(0);
      textAlign(RIGHT, CENTER);
      textSize(10);
      text((int)valuesWeapon[i], barX + fillBar - 4, rowY);
    }
    
    drawStatsTabs();
  }
  
  void drawBallisticsStats(){
    String[] labels = {"DAMAGE", "BULLET VELOCITY", "DEVIATION", "ARMOR PENETRATION"};
    String[] textVals = {valuesBal[0] + "", valuesBal[1] + "", "± " + valuesBal[2], valuesBal[3] + "%"};
 
    float rowH = STATS_H / labels.length;
 
    for (int i = 0; i < labels.length; i++){
      float rowY = STATS_Y + i * rowH + rowH / 2;
 
      //label
      fill(255);
      textAlign(LEFT, CENTER);
      textSize(11);
      text(labels[i], 10, rowY);
 
      //val
      fill(200);
      textAlign(LEFT, CENTER);
      textSize(11);
      text(textVals[i], 240, rowY);
    }
    
    drawStatsTabs();
  }
  
  void drawStatsTabs(){
    //weapon
    if (statsTab.equals("WEAPON")){
      fill(255);
    } else {
      fill(60);
    }
    stroke(180);
    strokeWeight(1);
    rect(5, TAB_Y, TAB_W_S, TAB_H);
 
    if (statsTab.equals("WEAPON")){
      fill(0);
    } else {
      fill(255);
    }
    textAlign(CENTER, CENTER);
    textSize(13);
    text("WEAPON", TAB_W_S / 2 + 5, TAB_Y + TAB_H / 2);
 
    //ballistics
    if (statsTab.equals("BALLISTICS")){
      fill(255);
    } else {
      fill(60);
    }
    stroke(180);
    strokeWeight(1);
    rect(TAB_W_S+5, TAB_Y, TAB_W_S, TAB_H);
 
    if (statsTab.equals("BALLISTICS")){
      fill(0);
    } else {
      fill(255);
    }
    textAlign(CENTER, CENTER);
    textSize(13);
    text("BALLISTICS", TAB_W_S + TAB_W_S / 2 + 5, TAB_Y + TAB_H / 2);
  }
  
  void drawStatsBar(){
    // Background
    fill(40);
    stroke(180);
    strokeWeight(1);
    rect(0, STATS_Y, GUN_AREA_W, STATS_H);
 
    drawStatsTabs();
 
    if (statsTab.equals("WEAPON")){
      drawWeaponStats();
    } else {
      drawBallisticsStats();
    }
  }
 
  void drawSaveButton(){
    fill(80);
    stroke(180);
    strokeWeight(1);
    rect(10, 10, 140, 40);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(13);
    text("SAVE & RETURN", 10 + 140 / 2, 10 + 40 / 2);
  }
  
  void handleClick(int mx, int my){
    // Save button
    if (isOver(mx, my, 10, 10, 140, 40)){
      menuManager.switchTo("loadout");
      return;
    }
    
    if (isOver(mx, my, 0, TAB_Y, TAB_W_S, TAB_H)){
      statsTab = "WEAPON";
      return;
    }
    if (isOver(mx, my, TAB_W_S, TAB_Y, TAB_W_S, TAB_H)){
      statsTab = "BALLISTICS";
      return;
    }
 
    //dot clicks
    if (mx < GUN_AREA_W && my < GUN_AREA_H){
      for (int i = 0; i < currentWeapon.slots.length; i++){
        AttachmentSlot slot = currentWeapon.slots[i];
        if (slot.visible){
          if (slot.isClicked(mx, my, 12)){
            selectedSlot = i;
          }
        }
      }
    }
 
    //attachment clicks
    if (mx >= PANEL_X && selectedSlot != -1){
      float itemH = 60;
      float itemW = PANEL_W - 20;
      float itemX = PANEL_X + 10;
 
      for (int i = 0; i < currentWeapon.slots[selectedSlot].options.length; i++){
        float itemY = 50 + i * (itemH + 8);
        if (isOver(mx, my, itemX, itemY, itemW, itemH)){
          println("Equipped " + currentWeapon.slots[selectedSlot].options[i].name + " in " + currentWeapon.slots[selectedSlot].type); //DEBUG MSG
          currentWeapon.slots[selectedSlot].equip(i);
          currentWeapon.updateVisibility();
          stats = currentWeapon.getStatBlock();
          valuesWeapon = new float[]{stats.weight, stats.ergonomics, stats.recoil, stats.magSize};
          valuesBal = new float[]{stats.damage, stats.bulletVelocity, stats.deviation, stats.armorPen};
          return;
        }
      }
    }
  }
  
  boolean isOver(float mx, float my, float x, float y, float w, float h){ //BEST HELPER OMG
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }
  
  void setCurrentWeapon(Weapon weapon){
    currentWeapon = weapon;
  
    stats = currentWeapon.getStatBlock();
  
    valuesWeapon = new float[]{
      stats.weight,
      stats.ergonomics,
      stats.recoil,
      stats.magSize
    };
  
    valuesBal = new float[]{
      stats.damage,
      stats.bulletVelocity,
      stats.deviation,
      stats.armorPen
    };
  
    selectedSlot = -1;
  }
  
  void drawGunImage() {
    fill(50);
    stroke(180);
    strokeWeight(1);
    rect(0, 0, GUN_AREA_W, GUN_AREA_H);
  
    imageMode(CORNER);
  
    float finalScale = 1.0;
  
    if (currentWeapon.baseImage != null) {
      float imgW = currentWeapon.baseImage.width;
      float imgH = currentWeapon.baseImage.height;
  
      float maxW = GUN_AREA_W - 250;
      float maxH = GUN_AREA_H - 250;
      finalScale = min(maxW / imgW, maxH / imgH) * currentWeapon.baseScale;
  
      imgDrawW = imgW * finalScale;
      imgDrawH = imgH * finalScale;
      imgDrawX = currentWeapon.baseX;
      imgDrawY = currentWeapon.baseY;
  
      image(currentWeapon.baseImage, imgDrawX, imgDrawY, imgDrawW, imgDrawH);
    }
  
    // attachments use same finalScale as base
    for (AttachmentSlot slot : currentWeapon.slots) {
      if (slot.visible && slot.equipped != null && slot.equipped.layerImage != null) {
        float ax = currentWeapon.baseX + (slot.equipped.layerX - currentWeapon.baseX) * finalScale;
        float ay = currentWeapon.baseY + (slot.equipped.layerY - currentWeapon.baseY) * finalScale;
        float aw = slot.equipped.layerW * finalScale;
        float ah = slot.equipped.layerH * finalScale;
        image(slot.equipped.layerImage, ax, ay, aw, ah);
      }
    }
  }
}
