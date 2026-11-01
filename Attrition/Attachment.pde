public class Attachment {
  String name;
  float weightMod;
  float ergoMod;
  float recoilMod;
  int magSizeMod;
  float velocityMod;
  float damageMod;
  float deviationMod;
  float armorPenMod;
  float fireRateMod;
  float reticleReturnSpeedMod;
  PImage layerImage;
  float layerX;
  float layerY;
  float layerW;
  float layerH;
 
  Attachment(String name, float weightMod, float ergoMod, float recoilMod, int magSizeMod, float velocityMod, float damageMod, float deviationMod, float armorPenMod, float fireRateMod, float reticleReturnSpeedMod){
    this.name = name;
    this.weightMod = weightMod;
    this.ergoMod = ergoMod;
    this.recoilMod = recoilMod;
    this.magSizeMod = magSizeMod;
    this.velocityMod = velocityMod;
    this.damageMod = damageMod;
    this.deviationMod = deviationMod;
    this.armorPenMod = armorPenMod;
    this.fireRateMod = fireRateMod;
    this.reticleReturnSpeedMod = reticleReturnSpeedMod;
  }
  
  void setLayer(PImage img, float x, float y, float w, float h) {
    this.layerImage = img;
    this.layerX = x;
    this.layerY = y;
    this.layerW = w;
    this.layerH = h;
  }
}
 
public class AttachmentSlot {
  String type; // "STOCK", "OPTIC", "GRIP", "MUZZLE", "MAGAZINE"
  float dotX;
  float dotY;
  Attachment equipped;
  Attachment[] options;
  String requiredSlot; 
  String requiredAttachment;
  boolean visible;  
 
  AttachmentSlot(String type, float dotX, float dotY, Attachment[] options){
    this.type = type;
    this.dotX = dotX;
    this.dotY = dotY;
    this.options = options;
    this.equipped = null;
    this.requiredSlot = null;
    this.requiredAttachment = null;
    this.visible = true;
  }
  
  AttachmentSlot(AttachmentSlot other){
    this.type = other.type;
    this.dotX = other.dotX;
    this.dotY = other.dotY;
    this.options = other.options;
    this.equipped = other.equipped;
    this.requiredSlot = other.requiredSlot;
    this.requiredAttachment = other.requiredAttachment;
    this.visible = other.visible;
  }
  
  AttachmentSlot(String type, float dotX, float dotY, Attachment[] options, String requiredSlot, String requiredAttachment){
    this(type, dotX, dotY, options);
    this.requiredSlot = requiredSlot;
    this.requiredAttachment = requiredAttachment;
    this.visible = false;
  }


  boolean isClicked(int mx, int my, float radius){
    return dist(mx, my, dotX, dotY) <= radius;
  }
 
  void equip(int index){
    if (index >= 0 && index < options.length){
      equipped = options[index];
    } else {
      println("out of bounds for Attachment.equip");
    }
  }
 
  void unequip(){
    equipped = null;
  }
 
  int equippedIndex(){
    if (equipped == null){
      return -1;
    }
    for (int i = 0; i < options.length; i++){
      if (options[i] == equipped){
        return i;
      }
    }
    return -1;
  }
  
}
