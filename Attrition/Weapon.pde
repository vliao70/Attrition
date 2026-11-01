public class Weapon {
  String name;
  //base stats yummy
  float baseWeight;
  float baseErgonomics;
  float baseRecoil;
  int baseMagSize;
  float baseBulletVelocity;
  float baseDamage;
  float baseDeviation;
  float baseArmorPen;
  float baseBulletLifetime;
  AttachmentSlot[] slots;
  float baseFireRate;
  boolean[] fireModes;
  int fireModeIndex;
  float baseReticleReturnSpeed;
  
  PImage baseImage;
  float baseScale = 1.0;
  float baseX = 190;
  float baseY = 180;
 
  Weapon(String name, float weight, float ergonomics, float recoil, int magSize, float bulletVelocity, float damage,
  float deviation, float armorPen, float bulletLifetime, AttachmentSlot[] slots, float fireRate, boolean[] fireModes, float reticleReturnSpeed){
    this.name = name;
    this.baseWeight = weight;
    this.baseErgonomics = ergonomics;
    this.baseRecoil = recoil;
    this.baseMagSize = magSize;
    this.baseBulletVelocity = bulletVelocity;
    this.baseDamage = damage;
    this.baseDeviation = deviation;
    this.baseArmorPen = armorPen;
    this.slots = slots;
    this.baseBulletLifetime = bulletLifetime;
    this.baseFireRate = fireRate;
    this.fireModes = fireModes;
    this.fireModeIndex = 0;
    this.baseReticleReturnSpeed = reticleReturnSpeed;
  }
  
  Weapon(Weapon other){
    this.name = other.name;
  
    this.baseWeight = other.baseWeight;
    this.baseErgonomics = other.baseErgonomics;
    this.baseRecoil = other.baseRecoil;
    this.baseMagSize = other.baseMagSize;
    this.baseBulletVelocity = other.baseBulletVelocity;
    this.baseDamage = other.baseDamage;
    this.baseDeviation = other.baseDeviation;
    this.baseArmorPen = other.baseArmorPen;
    this.baseBulletLifetime = other.baseBulletLifetime;
    this.baseFireRate = other.baseFireRate;
  
    this.slots = new AttachmentSlot[other.slots.length];
    this.fireModes = other.fireModes;
    this.fireModeIndex = other.fireModeIndex;
    this.baseReticleReturnSpeed = other.baseReticleReturnSpeed;
  
    for (int i = 0; i < other.slots.length; i++){
      this.slots[i] = new AttachmentSlot(other.slots[i]);
    }
    this.baseImage = other.baseImage;
    this.baseScale = other.baseScale;
    this.baseX = other.baseX;
    this.baseY = other.baseY;
  }
  
  void cycleFireMode(){
    if (fireModes.length <= 1){
      println(name + " cannot change fire mode");
    } else {
      fireModeIndex = (fireModeIndex + 1) % fireModes.length;
      if (fireModes[fireModeIndex]){
        println(name + " switched to AUTO");
      } else {
        println(name + " switched to SEMI");
      }
    }
  }
  
  void updateVisibility(){
    for (AttachmentSlot slot : slots){
      if (slot.requiredSlot == null){
        slot.visible = true;
      } else {
        slot.visible = false;
        for (AttachmentSlot other : slots){
          if (other.type.equals(slot.requiredSlot)){
            //println("checking: " + other.type + " equipped: " + (other.equipped != null ? other.equipped.name : "null") + " required: " + slot.requiredAttachment);
            if (other.equipped != null && other.equipped.name.equals(slot.requiredAttachment)){
              slot.visible = true;
            }
          }
        }
        //println(slot.type + " visible: " + slot.visible);
        if (!slot.visible){
          slot.equipped = null;
        }
      }
    }
  }
 
  //base stats + attachment modifiers, then returns a updated statBlock
  StatBlock getStatBlock(){
    float weight = baseWeight;
    float ergo = baseErgonomics;
    float recoil = baseRecoil;
    int mag = baseMagSize;
    float velocity = baseBulletVelocity;
    float damage = baseDamage;
    float deviation = baseDeviation;
    float armorPen = baseArmorPen;
    float lifetime = baseBulletLifetime;
    float fireRate = baseFireRate;
    float reticleReturnSpeed = baseReticleReturnSpeed;
 
    for (AttachmentSlot slot : slots){
      if (slot.equipped != null){
        weight += slot.equipped.weightMod;
        ergo += slot.equipped.ergoMod;
        recoil += slot.equipped.recoilMod;
        mag += slot.equipped.magSizeMod;
        velocity += slot.equipped.velocityMod;
        damage += slot.equipped.damageMod;
        deviation += slot.equipped.deviationMod;
        armorPen += slot.equipped.armorPenMod;
        fireRate += slot.equipped.fireRateMod;
        reticleReturnSpeed += slot.equipped.reticleReturnSpeedMod;
      }
    }
 
    deviation = max(deviation, 0);
    return new StatBlock(weight, ergo, recoil, mag, velocity, damage, deviation, armorPen, lifetime, fireRate, fireModes[fireModeIndex], reticleReturnSpeed);
    
  }
}

class StatBlock {
  float weight;
  float ergonomics;
  float recoil;
  int magSize;
  float bulletVelocity;
  float damage;
  float deviation;
  float armorPen;
  float bulletLifetime;
  float fireRate;
  boolean fullAuto;
  float reticleReturnSpeed;
 
  StatBlock(float weight, float ergonomics, float recoil, int magSize, float bulletVelocity, float damage, float deviation, float armorPen, float bulletLifetime, float fireRate, boolean fullAuto, float reticleReturnSpeed){
    this.weight = weight;
    this.ergonomics = ergonomics;
    this.recoil = recoil;
    this.magSize = magSize;
    this.bulletVelocity = bulletVelocity;
    this.damage = damage;
    this.deviation = deviation;
    this.armorPen = armorPen;
    this.bulletLifetime = bulletLifetime;
    this.fireRate = fireRate;
    this.fullAuto = fullAuto;
    this.reticleReturnSpeed = reticleReturnSpeed;
  }
}
