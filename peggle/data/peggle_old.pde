// GROUPE 4 - PEGGLE

//=================

import processing.video.*;
import gab.opencv.*;
import java.awt.*;

Capture cam_;
OpenCV opencv_;

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
int scale_ = 2;

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

// FIN VARIABLES OPENCV



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
  
  
  // DEBUT SETUP OPENCV
    String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    //cam_ = new Capture(this, videoWidth_, videoHeight_, "2- HD Pro Webcam C9");
    cam_ = new Capture(this, videoWidth_, videoHeight_, "EasyCamera");
    
    opencv_ = new OpenCV(this, videoWidth_, videoHeight_);
    
    flow_ = opencv_.flow;
    
    flow_.setPyramidScale(0.5); // default : 0.5
    flow_.setLevels(1); // default : 4
    flow_.setWindowSize(8); // default : 8
    flow_.setIterations(1); // default : 2
    flow_.setPolyN(3); // default : 7
    flow_.setPolySigma(1.5); // default : 1.5
    
    int m = 10;
    int w = 90;
    int h = 70;
    
    int x = m;
    int y = m;
    //hotSpots_[0] = new HotSpot(x,y,w,h);
    //x = videoWidth_ / 2 - w / 2;
    //hotSpots_[1] = new HotSpot(x,y,w,h);
    //x = videoWidth_ - m - w;
    //hotSpots_[2] = new HotSpot(x,y,w,h);
    
    x = m;
    y = videoHeight_ - m - h;
    hotSpots_[0] = new HotSpot(x,y,w,h);
    
    x = videoWidth_ / 2 - w / 2;
    hotSpots_[1] = new HotSpot(x,y,w,h);
    
    x = videoWidth_ - m - w;
    hotSpots_[2] = new HotSpot(x,y,w,h);
    
    cam_.start();     
  }
// ================
// FIN SETUP OPENCV
  
  
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

// ====================


// DEBUT HOTSPOTS OPENCV
// =====================
void detectHotSpots() {
  
  for ( int k = 0 ; k < 3 ; k++ ) {
    
    HotSpot hs = hotSpots_[k];
    
    int nb = 0;
    
    float absolute_mag = 0.0;
    PVector p_average = new PVector(0.,0.);
    float ps_average = 0.0;
    
    int step = 2;
      
    //=======================================
    for( int j = 0 ; j < hs.h ; j += step ) {
      for( int i = 0 ; i < hs.w ; i += step ) {
        PVector p = flow_.getFlowAt(hs.x+i,hs.y+j);
        absolute_mag += p.mag();
        p_average.add(p);
        nb++;
      }   
    }
    absolute_mag /= nb;
    p_average.div(nb);
    float average_mag = p_average.mag();
    
    //=======================================
    for( int j = 0 ; j < hs.h ; j += step ) {
      for( int i = 0 ; i < hs.w ; i += step ) {
        PVector p = flow_.getFlowAt(hs.x+i,hs.y+j);
        ps_average += p.dot(p_average);
        nb++;
      }   
    }
    ps_average /= nb;
    
    noFill();
    stroke(0,0,255);
    strokeWeight(2.);
    float x1 = hs.x + hs.w / 2.;
    float y1 = hs.y + hs.h / 2.;
    float x2 = x1 + p_average.x;
    float y2 = y1 + p_average.y;
    line(x1,y1,x2,y2);
    
    boolean absolute_mag_ok = absolute_mag > detectAbsoluteMagMin_;
    boolean average_mag_ok = average_mag < detectAverageMagMax_;
    boolean ps_average_ok = ps_average < psAverageMax_;
       
    if ( selectDelayS_ < 0.) {
      
      if ( absolute_mag_ok ) {
        
        if ( average_mag_ok )  {
          
          if ( ps_average_ok )  {
            
            selectedHotSpotIndex_ = selectedHotSpotIndex_ == k ? -1 : k;
            selectDelayS_ = selectDelaySo_;
          }
        }
      }
    }
  }
}

//===================
void drawHotSpots() {
  noFill();
  strokeWeight(1.);
  for ( int k = 0 ; k < 3 ; k++ ) { 
    stroke(255,0,0);
    if ( ( selectedHotSpotIndex_ >= 0 ) && ( k == selectedHotSpotIndex_ ) ) {
      stroke(0,255,0);
    }
    rect(hotSpots_[k].x,hotSpots_[k].y,hotSpots_[k].w,hotSpots_[k].h);
  }
}

// =============

// FIN HOTSPOTS OPENCV

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
    scanner = scanner -7;
  } 
  else if (keyCode == RIGHT) {
    scanner = scanner +5;
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

pushMatrix();
synchronized(this) {
    
    timeMS_ = millis();
    timeS_ = timeMS_ * 0.001;
    
    selectDelayS_ -= timeS_ - timeSOld_;
  

    
    if ( frames_[currentFrameIndex_] != null ) {
      
      //frames_[currentFrameIndex_].resize(640*scale,360*scale); // slow...
      
      frames_[currentFrameIndex_].loadPixels();
      fullFrame_.loadPixels();
      for (int j = 0; j < fullFrame_.height ; j+=2) {
        for ( int i = 0 ; i < fullFrame_.width ; i++ ) {
          int index_src = ( j / scale_ ) * frames_[currentFrameIndex_].width + ( i / scale_ );
          int index_dst = j * fullFrame_.width + i;
          fullFrame_.pixels[index_dst] = frames_[currentFrameIndex_].pixels[index_src];
        }
      }
      fullFrame_.updatePixels();
      
      tint(255, 255, 255, 255);
      image(fullFrame_, 0, 0);
      stroke(255,0,0);
      strokeWeight(1.);
      

      scale(scale_);
      
      
      opencv_.drawOpticalFlow();
      
      drawHotSpots();
      
      detectHotSpots();
    
      first_ = false; 
    }
  }
popMatrix();
  timeSOld_ = timeS_;



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
  image(brick_pink, 180, 90, brick_pink.width*4,brick_pink.height*2);
  image(brick_pink, 300, 300, brick_pink.width*4,brick_pink.height*2);
  image(brick_pink, 1700, 180, brick_pink.width*4,brick_pink.height*2);
  image(brick_pink, 1300, 80, brick_pink.width*4,brick_pink.height*2);
  image(brick_pink, 890, 245, brick_pink.width*4,brick_pink.height*2);

  
  // affichage floating image ===
  image(floating_img, mouseX-floating_img.width/12, mouseY+floating_img.height/12, floating_img.width*2, floating_img.height*2);
  
  // affichage surface
  image(surface, 0,0);
  
// ================== 
 
}

//============================
void captureEvent(Capture c) {
  
  synchronized(this) {
    
    c.read();
    //opencv.useColor(RGB);
    opencv_.useGray();
    opencv_.loadImage(cam_);
    opencv_.flip(OpenCV.HORIZONTAL);
    //opencv_.flip(OpenCV.VERTICAL);
    opencv_.calculateOpticalFlow();
    
    frames_[currentFrameIndex_] = opencv_.getSnapshot();
    
  }
  
}

//=================
void keyPressed() {
  if ( (keyCode == ESC) || ( keyCode == 'q' ) || ( keyCode == 'Q' )) {
    cam_.stop();
    exit();
  }
   
}
