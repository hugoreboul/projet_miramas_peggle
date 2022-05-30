//==================
// GROUPE 4 - PEGGLE
//==================
import processing.video.*;
import gab.opencv.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import processing.sound.*;
//==================
Capture cam_;
OpenCV opencv_;
//==================
List<Image> images = new ArrayList<Image>();
PImage projectile;
PImage floating_square;
PImage floating_img;
PImage bg;
PImage brick_pink;
PImage brick_green;
PImage brick_green_3;
PImage brick_green_2;
PImage brick_green_1;
PImage ball_image;
PImage debris;
PImage laser_counter;
PImage surface;
PImage gun;
float scanner = 0;
float axe_ball;
float y = 180;
int screen_width;
int screen_height;
int counter = 0;
int t;
int interval = 120;
int state = 0;
int ball;
String movement;
String s = "";
String time = "120";
long move_delay = System.currentTimeMillis();
boolean gameover = false;
boolean image_bool;
PFont font;
SoundFile file;
//==================
// VARIABLES OPENCV
float timeMS_ = millis();
float timeS_ = timeMS_ * 0.001;
float timeSOld_ = timeMS_;
int videoWidth_ = 320;
int videoHeight_ = 180;
// SCALE DU RETOUR CAMERA
// int scale_ = 6;
int scale_ = 1;
//======================
PImage[] frames_ = new PImage[2];
int currentFrameIndex_ = 0;
boolean first_ = true;
PImage fullFrame_ = new PImage(videoWidth_*scale_,videoHeight_*scale_);
Flow flow_ = null;
HotSpot[] hotSpots_ = new HotSpot[2];
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
  // musique
  file = new SoundFile(this,"./data/sample.mp3");
  file.loop();
  // affichage fullscreen 1920
  fullScreen();
  bg = loadImage("./data/Space Background_01.png");
  screen_width = 1920;
  screen_height = 1080;  
  //===================
  // DEBUT SETUP OPENCV
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  }else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    //cam_ = new Capture(this, videoWidth_, videoHeight_, "HD Pro Webcam C920");
    cam_ = new Capture(this, videoWidth_, videoHeight_, "EasyCamera");
    opencv_ = new OpenCV(this, videoWidth_, videoHeight_);
    flow_ = opencv_.flow;
    flow_.setPyramidScale(0.5); // default : 0.5
    flow_.setLevels(1); // default : 4
    flow_.setWindowSize(8); // default : 8
    flow_.setIterations(1); // default : 2
    flow_.setPolyN(3); // default : 7
    flow_.setPolySigma(1.5); // default : 1.5
    int m = 100;
    int w = 130;
    int h = 180;
    int x = m;
    int y = m;
    // création du hotspot de tir 
    x = 0;
    y = 0;
    hotSpots_[0] = new HotSpot(x,y,w,h);
    // création du hotspot de mouvement
    x = videoWidth_ / 2 - m/2 + m/5;
    y = videoHeight_ / 2 - h / 2;
    w = 190;
    hotSpots_[1] = new HotSpot(x,y,w,h);
    cam_.start();     
  }
// ================
// FIN SETUP OPENCV
//=================
  // canon ===
  gun = loadImage("./data/gun2.png");
  // surface
  surface = loadImage("./data/lunar_surface.png");
  // briques
  brick_pink = loadImage("./data/brick_pink.png");
  brick_green = loadImage("./data/brick_green.png");
  brick_green_1 = loadImage("./data/brick_green_1.png");
  brick_green_2 = loadImage("./data/brick_green_2.png");
  brick_green_3 = loadImage("./data/brick_green_3.png");
  // projectile
  ball_image = loadImage("./data/laser.png");
  // compteur de projectile
  laser_counter = loadImage("./data/laser_counter.png");
  // débris
  debris = loadImage("./data/debris_full.png");
  // font
  font = createFont("Arial", 30);
  images.add(new Image(debris,0,0));
  images.add(new Image(brick_pink,420,110, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,300,320, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,600,220, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,1100,290, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,1300,90, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,1700,230, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,1300,280, brick_pink.width* 3,brick_pink.height* 2));
  //boss
  images.add(new Image(brick_green,890,245, brick_green.width* 3,brick_green.height* 2));
  images.add(new Image(brick_green_1,890,255, brick_green.width* 3,brick_green.height* 2));
  images.add(new Image(brick_green_2,890,265, brick_green.width* 3,brick_green.height* 2));
  images.add(new Image(brick_green_3,890,275, brick_green.width* 3,brick_green.height* 2));
  //====
}
// ====================
// DEBUT HOTSPOTS OPENCV
// =====================
// Détection ppour le hotspot de mouvement
void detectHotSpots_move() {
  HotSpot hs = hotSpots_[1];
  int k = 1;
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
  //println(p_average.x);
  //println(p_average.y);
  println((x2-x1)*(x2-x1));
  boolean absolute_mag_ok = absolute_mag > detectAbsoluteMagMin_;
  boolean average_mag_ok = average_mag < detectAverageMagMax_;
  boolean ps_average_ok = ps_average < psAverageMax_;
  if(System.currentTimeMillis() - move_delay > 1000){
    if(((x2-x1)*(x2-x1)>(y2-y1)*(y2-y1)) && ((x2-x1)*(x2-x1)>0.05)){
      if(x1>x2){
        //scanner = deplacement("droite");
        movement = "droite";
        move_delay = System.currentTimeMillis();
      }
      else {
        //scanner = deplacement("gauche");
        movement = "gauche";
        move_delay = System.currentTimeMillis();
      }
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
}
//===================
// Détection pour le Hotspot de tir
void detectHotSpots_shoot() {
  HotSpot hs = hotSpots_[0];
  int k = 0;
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
  if((y1-y2)*(y1-y2)>((x1-x2)*(x1-x2))&& ((x2-x1)*(x2-x1)>0.02)){
    if(y1>y2){
      tir();
    }
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
  for ( int k = 0 ; k < 2 ; k++ ) { 
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
  // === IMAGES  ===  
  // affichage background
  background(bg);
  // affichage débris
  image(debris,0,0);
  // affichage dispo laser
  if(image_bool == false){
    Image laser_count = new Image(laser_counter, 20, 220);
    laser_count.affiche();
  }
  // affichage image  ===
  if(image_bool == true){
    Image ball_img = new Image(ball_image,int(axe_ball),height-ball, ball_image.width/4, ball_image.height/4);
    ball_img.affiche();
    for(int i=0;i<images.size();i++)
    {
      int coor_ball_x_1=ball_img.x;
      int coor_ball_y_1=ball_img.y;
      int coor_ball_x_2=ball_img.x+ball_img.w;
      int coor_ball_y_2=ball_img.y+ball_img.w;
      int coor_brick_x_1=images.get(i).x;
      int coor_brick_y_1=images.get(i).y+images.get(i).h;
      int coor_brick_x_2=images.get(i).x+images.get(i).w;
      int coor_brick_y_2=images.get(i).y+images.get(i).w+images.get(i).h;
      if (coor_ball_y_1 < coor_brick_y_1 && coor_ball_x_1 > coor_brick_x_1 && coor_ball_x_2 < coor_brick_x_2){
        images.remove(i);
        image_bool=false;
        ball = 0;  
      }
    }
    if(image_bool==true){
      ball=ball+40;
      if (ball > screen_height) {
         ball = 0;
         image_bool=false; 
    }
      ball++;
    }
  }
  // ==================
  // affichage canon ===
  scanner = deplacement(movement);
  image(gun, scanner-32, height-240, gun.width*3, gun.height*3); 
  for(int i=0;i<images.size();i++){
    images.get(i).affiche();
  }
  // translation à gauche et droite du canon et du laser ===
  //scanner++;
  //if (keyCode == LEFT) {
  //  scanner = scanner - 14;
  //} 
  //else if (keyCode == RIGHT) {
  //  scanner = scanner +10;
  //}
  //if (scanner > width-160) { 
  //  scanner = width-160; 
  //}
  //if (scanner < 36) { 
  //  scanner = 36; 
  //}
// ================
// === CAMERA ===
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
      // direction des mouvements
      detectHotSpots_move();
      // déclenchement des tirs
      detectHotSpots_shoot();
      first_ = false; 
    }
  }
  popMatrix();
  timeSOld_ = timeS_;
// ===============
  // === TIMER ===
  // affichage timer
  //fill(200);
  //t= interval-int(millis()/1000);
  //time = nf(t,3);
  //textSize(75);
  //if(t>=0)
  //text(time,10,250);
  //else
  //text(nf(0,2),10,250);
  //if(images.size()==0){
  //  s = "VICTOIRE";
  //  text(s,780,900);
  //}
  //else if(t<=0){
  //  gameover=true;
  //  s = "GAME OVER";
  //  text(s,780,900);
  //}
// =================  
// AFFICHAGE SURFACE
// affichage surface
  image(surface, 0,0);
  for(int i=0;i<images.size();i++){
      images.get(i).affiche();
  }
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
void colliderBall()
{}
//=================
void keyPressed() {
  if ( (keyCode == ESC) || ( keyCode == 'q' ) || ( keyCode == 'Q' )) {
    cam_.stop();
    exit();
  }
  if ( ( keyCode == 'r' ) || ( keyCode == 'R' )){
    reset(); // ADD LOGIC TO CALL YOUR RESET FUNCTION!!!
  }
}
void mouseClicked() {
  if(image_bool!=true){
    axe_ball=scanner;
    image_bool=true;
  }
}
void reset() {
  images.clear();
  images.add(new Image(brick_pink,420,110, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,300,320, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,600,220, brick_pink.width* 3,brick_pink.height* 2));
  //boss
  images.add(new Image(brick_green,890,245, brick_green.width* 3,brick_green.height* 2));
  images.add(new Image(brick_green_1,890,255, brick_green.width* 3,brick_green.height* 2));
  images.add(new Image(brick_green_2,890,265, brick_green.width* 3,brick_green.height* 2));
  images.add(new Image(brick_green_3,890,275, brick_green.width* 3,brick_green.height* 2));
  //====
  images.add(new Image(brick_pink,1100,290, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,1300,90, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,1700,230, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,1300,280, brick_pink.width* 3,brick_pink.height* 2));
   selectedHotSpotIndex_ = -1;
   selectDelaySo_ = 0.5;
   selectDelayS_ = selectDelaySo_;
   timeMS_ = millis();
   timeS_ = timeMS_ * 0.001;
   selectDelayS_ -= timeS_ - timeSOld_;
   interval=20;
   gameover=false;
}
//======================
// fct pour le tir
void tir(){
  if(image_bool!=true){
    axe_ball=scanner;
    image_bool=true;
  }
}
//===============================
// déplacement vers la droite ou la gauche
float deplacement(String message){
  //scanner++;
  if (message == "droite") {
    scanner = scanner - 14;
  } 
  else if (message == "gauche") {
    scanner = scanner +10;
  }
  if (scanner > width-160) { 
    scanner = width-160; 
  }
  if (scanner < 36) { 
    scanner = 36; 
  }
  return scanner;
}
