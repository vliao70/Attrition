public class PlayerLoadout {
  Weapon weapon1;
  Weapon weapon2;
  Weapon[] primaryWeapons;
  Weapon[] secondaryWeapons;
  PlayerClass selectedClass = null;

  PlayerLoadout(){    
    primaryWeapons = new Weapon[]{
      AR15(),
      FAL(),
      Vector(),
      M1888(),
    };
  
    secondaryWeapons = new Weapon[]{
      P320(),
      USP(),
    };
  
    weapon1 = new Weapon(primaryWeapons[0]);
    weapon1.updateVisibility();
    weapon2 = new Weapon(secondaryWeapons[0]);
    weapon2.updateVisibility();
  }

  Weapon AR15(){
    //attachments for each slot
    //weight,ergo,recoil,magSize,damage,velocity,deviation,pen,firerate,firemodes(true=auto),reticleReturnSpeed
    Attachment[] stockOptions = { //add the stats later
      new Attachment("Colt Stock", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
      new Attachment("Troy Stock", -4, 4, 10, 0, 0, 0, 0.5, 0, 0, 0),
      new Attachment("Stock C", 6, -4, -12, 0, 0, 0, -0.5, 0, 0, 0)
    };
    stockOptions[0].setLayer(loadImage("ar15stockA.png"), 25, 258, 228, 135);
    stockOptions[1].setLayer(loadImage("ar15troy.png"), 33, 245, 216, 116);
    stockOptions[2].setLayer(loadImage("ar15stockc.png"), -15, 240, 265, 162);

    Attachment[] opticOptions = {
      new Attachment("Carry Handle", 0, 0, 0, 0, 0, 0, -0.2, 0, 0, 0),
      new Attachment("Red Dot", 2, -2, 0, 0, 0, 0, -0.15, 0, 0, -0.5),
      new Attachment("Battle Scope", 4, -4, -2, 0, 0, 0, -0.35, 0, 0, -0.75),
      new Attachment("Prism Scope", 6, -4, -2, 0, 0, 0, -0.25, 0, 0, -1),
      new Attachment("LPVO", 7, -8, -4, 0, 0, 0, -0.5, 0, 0, -1.5),
      new Attachment("None", -8, 0, 8, 0, 0, 0, 0, 0, 0, 0.5),
    };
    opticOptions[0].setLayer(loadImage("ar15carry.png"), 258, 195, 208, 58);
    opticOptions[1].setLayer(loadImage("ar15red.png"), 340, 175, 96, 78);
    opticOptions[2].setLayer(loadImage("scope.png"), 255, 138, 204, 115);
    opticOptions[3].setLayer(loadImage("ELCAN.png"), 260, 171, 185, 88);
    opticOptions[4].setLayer(loadImage("ar15lpvo.png"), 220, 165, 312, 87);
    
    Attachment[] handguardOptions = {
      new Attachment("Colt", 0, 10, 0, 0, 0, 0, 0, 0, 0, 0),
      new Attachment("MLok", 2, 6, 4, 0, 0, 0, 0, 0, 0, 0)
    };
    handguardOptions[0].setLayer(loadImage("ar15colt.png"), 464, 205, 375, 129);
    handguardOptions[1].setLayer(loadImage("ar15mlok.png"), 455, 247, 360, 63);
    
    Attachment[] muzzleOptions = {
      new Attachment("Flash Hider", 1, 6, -4, 0, 1, 0, 0.25, 0, 0, 0),
      new Attachment("Muzzle Break", 1, 4, -6, 0, 1, 0, 0.25, 0, 0, 0),
      new Attachment("Suppressor", 3, -5, -7, 0, 2, 1, 0, 0, 0, 0),
      new Attachment("None", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    };
    muzzleOptions[0].setLayer(loadImage("ar15flash.png"), 775, 259, 58, 40);
    muzzleOptions[1].setLayer(loadImage("muzzlebreak.png"), 775, 69, 153, 428);
    muzzleOptions[2].setLayer(loadImage("suppressor.png"), 775, 228, 206, 110);

    Attachment[] magOptions = {
      new Attachment("Mag 30", 0, 0, 0, 30, 0, 0, 0, 0, 0, 0),
      new Attachment("Drum mag 50", 15, -20, -3, 50, 0, 0, -0.5, 0, 0, -1)
    };
    magOptions[0].setLayer(loadImage("ar15mag30.png"), 175, 175, 650, 360);
    magOptions[1].setLayer(loadImage("ar15drum.png"), 385, 350, 84, 126);
    
    Attachment[] handguardPiccatinyOptions = {
      new Attachment("None", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
      new Attachment("Grip A", 1, 5, -1, 0, 0, 0, 0, 0, 0, 0.5),
      new Attachment("Grip B", 2, 2, -5, 0, 0, 0, 0, 0, 0, 0.25)
    };
    handguardPiccatinyOptions[1].setLayer(loadImage("ar15gripA.png"), 510, 299, 110, 61);
    handguardPiccatinyOptions[2].setLayer(loadImage("ar15gripB.png"), 600, 299, 48, 79);

    //create slots with dot positions and options
    AttachmentSlot[] slots = {
      new AttachmentSlot("STOCK", 140, 290, stockOptions),
      new AttachmentSlot("MUZZLE", 780, 310, muzzleOptions),
      new AttachmentSlot("OPTIC", 385, 220, opticOptions),
      new AttachmentSlot("HANDGUARD", 580, 290, handguardOptions),
      new AttachmentSlot("MAGAZINE", 415, 390, magOptions),
      new AttachmentSlot("HANDGUARD PICCATINY", 590, 360, handguardPiccatinyOptions, "HANDGUARD", "MLok")
    };
    
    slots[0].equip(0);
    slots[1].equip(muzzleOptions.length-1);
    slots[2].equip(0);
    slots[3].equip(0);
    slots[4].equip(0);
    Weapon weapon = new Weapon("AR-15", 45, 50, 40, 0, 2800/2, 37.5, 4, 35, 1.5, slots, 800.0/60, new boolean[]{true, false}, 8.0); //optimal 5-6, <5 overshoot, >6 sluggish
    weapon.baseImage = loadImage("ar15BaseBetter.png");
    weapon.updateVisibility();
    return weapon;
  }
  
  Weapon FAL(){
    //attachments for each slot
    //weight,ergo,recoil,magSize,damage,velocity,deviation,pen,firerate,firemodes(true=auto),reticleReturnSpeed
    Attachment[] stockOptions = { //add the stats later
      new Attachment("Standard Stock", 0, 0, 0, 0, 0, 0, -1, 0, 0, 0),
      new Attachment("OSW Stock", -2, 2, 3, 0, 0, 0, 0.5, 0, 0, 0),
      new Attachment("SPR Stock", 3, 5, 5, 0, 0, 0, -0.25, 0, 0, 0.25)
    };
    stockOptions[0].setLayer(loadImage("falstockA.png"), -105, 228, 375, 209);
    stockOptions[1].setLayer(loadImage("falOswStock.png"), -11, 225, 276, 191);
    stockOptions[2].setLayer(loadImage("falSprStock.png"), -31, 221, 295, 203);

    Attachment[] opticOptions = {
      new Attachment("None", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
      new Attachment("Red Dot", 1, -1, 0, 0, 0, 0, -0.15, 0, 0, 0.5),
      new Attachment("Battle Scope", 2, -2, 0, 0, 0, 0, -0.25, 0, 0, 0.75),
      new Attachment("Prism Scope", 3, -2, -2, 0, 0, 0, -0.35, 0, 0, 1),
      new Attachment("LPVO", 5, -5, -5, 0, 0, 0, -0.5, 0, 0, 1.5)
    };
    opticOptions[1].setLayer(loadImage("ar15red.png"), 410, 165, 96, 78);
    opticOptions[2].setLayer(loadImage("scope.png"), 355, 128, 204, 115);
    opticOptions[3].setLayer(loadImage("ELCAN.png"), 365, 158, 185, 88);
    opticOptions[4].setLayer(loadImage("ar15lpvo.png"), 300, 155, 312, 87);
    
    Attachment[] handguardPiccatinyOptions = {
      new Attachment("None", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
      new Attachment("Grip A", 1, 4, -2, 0, 0, 0, 0, 0, 0, 0.5),
      new Attachment("Grip B", 2, 2, -5, 0, 0, 0, 0, 0, 0, 0.25)
    };
    handguardPiccatinyOptions[1].setLayer(loadImage("ar15gripA.png"), 650, 299, 110, 61);
    handguardPiccatinyOptions[2].setLayer(loadImage("ar15gripB.png"), 680, 299, 48, 79);
    
    Attachment[] muzzleOptionsLong = {
      new Attachment("Flash Hider", 1, 3, -2, 0, 1, 0, 0.25, 0, 0, 0),
      new Attachment("Muzzle Brake", 1, 2, -4, 0, 1, 0, 0.25, 0, 0, 0),
      new Attachment("SOCOM Supressor", 3, -3, -6, 0, 5, 0, -0.75, 1, 0, 0),
      new Attachment("Osprey Supressor", 3, -1, -2, 0, 5, 1, -0.75, 1, 0, 0),
      new Attachment("None", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    };
    muzzleOptionsLong[0].setLayer(loadImage("falFlash.png"), 1200, 249, 82, 60);
    muzzleOptionsLong[1].setLayer(loadImage("muzzlebreak.png"), 1183, 71, 153, 428);
    muzzleOptionsLong[2].setLayer(loadImage("suppressor.png"), 1180, 232, 206, 110);
    muzzleOptionsLong[3].setLayer(loadImage("osprey.png"), 1165, 237, 264, 80);
    
    Attachment[] muzzleOptionsShort = {
      new Attachment("Flash Hider", 1, 3, -2, 0, 1, 0, 0.25, 0, 0, 0),
      new Attachment("Muzzle Brake", 1, 2, -4, 0, 1, 0, 0.25, 0, 0, 0),
      new Attachment("SOCOM Supressor", 3, -3, -6, 0, 5, 0, -0.75, 1, 0, 0),
      new Attachment("Osprey Supressor", 3, -1, -2, 0, 5, 1, -0.75, 1, 0, 0),
      new Attachment("None", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    };
    muzzleOptionsShort[0].setLayer(loadImage("falFlash.png"), 855, 248, 82, 60);
    muzzleOptionsShort[1].setLayer(loadImage("muzzlebreak.png"), 873, 69, 153, 428);
    muzzleOptionsShort[2].setLayer(loadImage("suppressor.png"), 870, 228, 206, 110);
    muzzleOptionsShort[3].setLayer(loadImage("osprey.png"), 855, 237, 264, 80);

    Attachment[] magOptions = {
      new Attachment("Mag 10", -5, 8, 5, 10, 0, 0, 0, 0, 0, 0),
      new Attachment("Mag 20", 0, 0, 0, 20, 0, 0, 0, 0, 0, 0),
      new Attachment("Mag 30", 5, -8, -5, 30, 0, 0, 0, 0, 0, 0)
    };
      magOptions[0].setLayer(loadImage("falMag10.png"), 476, 350, 124, 90);
      magOptions[1].setLayer(loadImage("falmag20.png"), 478, 350, 104, 177);
      magOptions[2].setLayer(loadImage("falMag30.png"), 478, 350, 154, 245);

    Attachment[] handguardOptions = {
      new Attachment("Default", 5, 0, -5, 0, 0, 0, 0, 0, 0, -2),
      new Attachment("MLok OSW", -3, 7, 6, 0, 0, -6, 0, 0, 0, 2)
    };
      handguardOptions[0].setLayer(loadImage("falhandguardA.png"), 610, 212, 686, 115);
      handguardOptions[1].setLayer(loadImage("falOswHandguard.png"), 610, 225, 300, 95);
    
    //create slots with dot positions and options
    AttachmentSlot[] slots = {
      new AttachmentSlot("STOCK", 175, 280, stockOptions),
      new AttachmentSlot("OPTIC", 385, 180, opticOptions),
      new AttachmentSlot("HANDGUARD", 620, 250, handguardOptions),
      new AttachmentSlot("HANDGUARD PICCATINY", 590, 360, handguardPiccatinyOptions, "HANDGUARD", "MLok OSW"),
      new AttachmentSlot("MUZZLE", 720, 270, muzzleOptionsLong,  "HANDGUARD", "Default"),
      new AttachmentSlot("MUZZLE SHORT", 720, 270, muzzleOptionsShort, "HANDGUARD", "MLok OSW"),
      new AttachmentSlot("MAGAZINE", 425, 330, magOptions)
    };
    
    slots[0].equip(0);
    slots[1].equip(0);
    slots[2].equip(0);
    slots[3].equip(0);
    slots[4].equip(0);
    slots[5].equip(0);
    slots[6].equip(1);

    Weapon weapon = new Weapon("FAL", 60, 50, 65, 0, 2600/2, 55, 5, 50, 2.5, slots, 600/60, new boolean[]{true, false}, 4.5);
    weapon.baseImage = loadImage("falbase.png");
    weapon.baseScale = 0.45;
    weapon.baseX = (750 - weapon.baseImage.width * 0.7) / 2; // center it
    weapon.baseY = (600 - weapon.baseImage.height * 0.7) / 2;
    weapon.updateVisibility();
    return weapon;
  }
  
  Weapon Vector(){
    //attachments for each slot
    AttachmentSlot[] slots = {
    };
    
    //String name, float weight, float ergonomics, float recoil, int magSize, float bulletVelocity, float damage, float deviation, float armorPen, float bulletLifetime, AttachmentSlot[] slots, float fireRate, boolean[] fireModes, float reticleReturnSpeed
    Weapon weapon = new Weapon("Vector", 30, 60, 20, 25, 1200/2, 33.5, 3, 20, 1.0, slots, 1200.0/60, new boolean[]{true, false}, 7.5);

    return weapon;
  }
  
  Weapon M1888(){
    //attachments for each slot
    AttachmentSlot[] slots = {
    };
    
    //String name, float weight, float ergonomics, float recoil, int magSize, float bulletVelocity, float damage, float deviation, float armorPen, float bulletLifetime, AttachmentSlot[] slots, float fireRate, boolean[] fireModes, float reticleReturnSpeed
    Weapon weapon = new Weapon("M1888", 40, 70, 175, 1, 1400/2, 20, 3.75, 10, 1, slots, 600/60, new boolean[]{false}, 6.0);

    return weapon;
  }
  
  Weapon P320(){
    //attachments for each slot
    //weight,ergo,recoil,magSize,damage,velocity,deviation,pen,firerate,firemodes(true=auto),reticleReturnSpeed
    Attachment[] opticOptions = {
      new Attachment("None", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
      new Attachment("Red Dot", 1, -1, 0, 0, 0, 0, -0.5, 0, 0, 0.5),
    };
    
    Attachment[] muzzleOptions = {
      new Attachment("Muzzle Break", 1, 3, -2, 0, 1, 0, 0.25, 0, 0, 0),
      new Attachment("Compensator", 1, 2, -4, 0, 1, 0, 0.25, 0, 0, 0),
      new Attachment("Supressor", 3, -3, -6, 0, 5, 0, -0.75, 1, 0, 0),
      new Attachment("None", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    };

    Attachment[] magOptions = {
      new Attachment("Mag 20", -1, 1, 0, 20, 0, 0, 0, 0, 0, 0),
      new Attachment("Mag 30", 3, -7, 2, 30, 0, 0, 0, 0, 0, 0),
    };

    //create slots with dot positions and options
    AttachmentSlot[] slots = {
      new AttachmentSlot("OPTIC", 385, 220, opticOptions),
      new AttachmentSlot("MUZZLE", 720, 270, muzzleOptions),
      new AttachmentSlot("MAGAZINE", 425, 390, magOptions)
    };
    
    slots[0].equip(0);
    slots[1].equip(muzzleOptions.length-1);
    slots[2].equip(0);


    Weapon weapon = new Weapon("P320", 15, 90, 30, 0, 1200/2, 25, 5, 10, 1.5, slots, 800.0/60, new boolean[]{false}, 5);
    weapon.updateVisibility();
    return weapon;
  }
  
  Weapon USP(){
    //attachments for each slot
    //weight,ergo,recoil,magSize,damage,velocity,deviation,pen,firerate,firemodes(true=auto),reticleReturnSpeed
    Attachment[] opticOptions = {
      new Attachment("None", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
      new Attachment("Red Dot", 1, -1, 0, 0, 0, 0, -0.5, 0, 0, 0.5),
    };
    
    Attachment[] muzzleOptions = {
      new Attachment("Muzzle Break", 1, 3, -2, 0, 1, 0, 0.25, 0, 0, 0),
      new Attachment("Compensator", 1, 2, -4, 0, 1, 0, 0.25, 0, 0, 0),
      new Attachment("Supressor", 3, -3, -6, 0, 5, 0, -0.75, 1, 0, 0),
      new Attachment("None", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    };

    Attachment[] magOptions = {
      new Attachment("Mag 12", -1, 1, 0, 12, 0, 0, 0, 0, 0, 0),
      new Attachment("Mag 17", 2, -4, 1, 17, 0, 0, 0, 0, 0, 0),
    };

    //create slots with dot positions and options
    AttachmentSlot[] slots = {
      new AttachmentSlot("OPTIC", 385, 220, opticOptions),
      new AttachmentSlot("MUZZLE", 720, 270, muzzleOptions),
      new AttachmentSlot("MAGAZINE", 425, 390, magOptions)
    };
    
    slots[0].equip(0);
    slots[1].equip(muzzleOptions.length-1);
    slots[2].equip(0);


    Weapon weapon = new Weapon("USP", 20, 85, 40, 0, 1200/2, 33.5, 4, 20, 1.25, slots, 800.0/60, new boolean[]{false}, 5.5);
    weapon.updateVisibility();
    return weapon;
  }

  String getWeapon1Name(){
    if (weapon1 != null){
      return weapon1.name;
    } else {
      return "missing";
    }
  }
  
  String getWeapon2Name(){
    if (weapon2 != null){
      return weapon2.name;
    } else {
      return "missing";
    }
  }
  
  Weapon[] getPrimaryWeapons(){
    return primaryWeapons;
  }
  
  Weapon[] getSecondaryWeapons(){
    return secondaryWeapons;
  }
  
  Weapon[] getAllWeapons(){
    return new Weapon[]{weapon1, weapon2};
  }
  
}
