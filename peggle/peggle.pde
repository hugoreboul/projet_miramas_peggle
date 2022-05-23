// GROUPE 4 - PEGGLE

//=================

import processing.video.*;
import gab.opencv.*;
import java.awt.*;

Capture cam;
OpenCV opencv;

//==================

PImage bg;
float scanner = 0;
PImage floating_img;
int screen_width;
int screen_height;
PImage gun;
PImage brick_pink;
PImage surface;
PFont font;
String time = "060";
int t;
int interval = 60;
int state = 0;

//==================


// VARIABLES OPENCV

float timeMS_ = millis();
float timeS_ = timeMS_ * 0.001;
float timeSOld_ = timeMS_;

int videoWidth_ = 320;
int videoHeight_ = 180;
// int scale_ = 6;
int scale_ = 3;

PImage[] frames_ = new PImage[2];
int currentFrameIndex_ = 0;
boolean first_ = true;
PImage fullFrame_ = new PImage(videoWidth_*scale_,videoHeight_*scale_);

Flow flow_ = null;
HotSpot[] hotSpots_ = new HotSpot[6];

//================================
float detectAbsoluteMagMin_ = 2.0; 
float detectAverageMagMax_ = 1.2;
float psAverageMax_ = 0.2;
//=================================

int selectedHotSpotIndex_ = -1;
float selectDelaySo_ = 0.5;
float selectDelayS_ = selectDelaySo_;




//==================

void setup(){
  // affichage fullscreen 1920 ===
  fullScreen();
  bg = loadImage("../prod/Space Background_01.png");
  screen_width = 1920;
  screen_height = 1080;
  
  // affichage réduit 640 ===
  //size(600,800);
  //bg = loadImage("../prod/bg.jpg");
  //screen_width = 640;
  //screen_height = 800;
  
  // état du jeu
  //state = 0;
  
  // canon ===
  gun = loadImage("../prod/gun.png");
  // surface
  surface = loadImage("../prod/surface.png");
  // briques
  brick_pink = loadImage("../prod/brick_pink.png");
  // floating image
  floating_img = loadImage("../prod/bubble.png");
  // font
  font = createFont("Arial", 30);
}



// =============

void draw(){
  // affichage background
  background(bg);
  
  // affichage laser ===
  stroke(226,204,0);
  //line(scanner,0,scanner,height);
  // affichage canon ===
  image(gun, scanner-32, height-160, gun.width*5, gun.height*5);
  // translation à gauche et droite du canon et du laser ===
  scanner++;
  if (keyCode == LEFT) {
    scanner = scanner -2.5;
  } 
  else if (keyCode == RIGHT) {
    scanner = scanner +0.5;
  }
  if (scanner > width) { 
    scanner = 0; 
  }
  if (scanner < 0) { 
    scanner = width; 
  }
  
// ================
  
  // === CAMERA ===
  // protéger avec push matrix et pop matrix

// ===============



  // === TIMER ===
  // affichage timer
  String s = "Timer";
  fill(200);
  text(s,40,40,280,320);
  // countdwon
  t= interval-int(millis()/1000);
  time = nf(t,3);
  if(t==0){
    s = "GAME OVER";
    println("GAME OVER");
  interval+=60;
  }
  text(time,90,52);
  
// =================  

  // === IMAGES  ===
    
  //affichage briques ===
  image(brick_pink, 180, 90);
  image(brick_pink, 300, 300);
  image(brick_pink, 90, 180);
  image(brick_pink, 250, 80);
  image(brick_pink, 490, 480);

  
  // affichage floating image ===
  image(floating_img, mouseX-floating_img.width/12, mouseY+floating_img.height/12, floating_img.width*2, floating_img.height*2);
  
  // affichage surface
  image(surface, 0,0);
  
// ================== 
 
}
