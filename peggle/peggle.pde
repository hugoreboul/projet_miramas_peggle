// GROUPE 4 - PEGGLE

//=================

import processing.video.*;
import gab.opencv.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


Capture cam_;
OpenCV opencv_;

//==================

PImage bg;
List<Image> images = new ArrayList<Image>();
float scanner = 0;
//Image[] images = new Image[5];
PImage projectile;
PImage floating_square;
PImage floating_img;
int screen_width;
int screen_height;
float axe_ball;
PImage gun;
float y = 180;
PImage surface;
PFont font;
String time = "060";
int t;
int interval = 60;
int state = 0;
PImage ball_image;
boolean image_bool;
int ball;
PImage brick_pink;
PImage brick_green;

//==================


// VARIABLES OPENCV

float timeMS_ = millis();
float timeS_ = timeMS_ * 0.001;
float timeSOld_ = timeMS_;

int videoWidth_ = 320;
int videoHeight_ = 180;
// int scale_ = 6;
int scale_ = 1;

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
    
    //x = m;    
    x = 0;
    y = 0;
    hotSpots_[0] = new HotSpot(x,y,w,h);
    
    x = videoWidth_ / 2 - m/2 + m/5;
    y = videoHeight_ / 2 - h / 2;
    w = 190;
    hotSpots_[1] = new HotSpot(x,y,w,h);
  
    
    cam_.start();     
  }
// ================
// FIN SETUP OPENCV
  

  
  // état du jeu
  //state = 0;

  
  // canon ===
  gun = loadImage("../prod/gun2.png");
  // surface
  surface = loadImage("../prod/surface.png");
  // briques
  brick_pink = loadImage("../prod/brick_pink.png");
  brick_green = loadImage("../prod/brick_green.png");
  // projectile
  ball_image = loadImage("../prod/bulle_tiny.png");

  // font
  font = createFont("Arial", 30);
  images.add(new Image(brick_pink,180,90, brick_pink.width* 3,brick_pink.height* 2));
  
  //images[0].affiche();
  //Image.Image(brick_pink, 180, 90);
  images.add(new Image(brick_pink,300,300, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,180,90, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,1700,180, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,1300,80, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_pink,890,245, brick_pink.width* 3,brick_pink.height* 2));
  images.add(new Image(brick_green,600,120, brick_green.width*3,brick_green.height*2));


}

// ====================


// DEBUT HOTSPOTS OPENCV
// =====================
void detectHotSpots() {
  
  for ( int k = 0 ; k < 2 ; k++ ) {
    
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

  // affichage background

  background(bg);
  
  // affichage laser ===
  //stroke(226,204,0);
  //line(scanner,0,scanner,height);
  
  // affichage canon ===
  image(gun, scanner-32, height-240, gun.width*3, gun.height*3);
  
    for(int i=0;i<images.size()-1;i++)
  {
      images.get(i).affiche();
  }
    for(int i=0;i<images.size()-1;i++)
  {
      images.get(i).affiche();
  }

  // translation à gauche et droite du canon et du laser ===
  scanner++;
  if (keyCode == LEFT) {
    scanner = scanner - 14;
  } 
  else if (keyCode == RIGHT) {
    scanner = scanner +10;
  }
  if (scanner > width-160) { 
    scanner = width-160; 
  }
  if (scanner < 36) { 
    scanner = 36; 
  }

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


  
  // affichage floating image ===
  //image(floating_img, mouseX-floating_img.width/12, mouseY+floating_img.height/12, floating_img.width*2, floating_img.height*2);
  
  // affichage surface
  image(surface, 0,0);
  
  for(int i=0;i<images.size()-1;i++)
  {
      images.get(i).affiche();
  }

  
  // affichage image  ===
  //image(projectile, 0, 0);
  //image(projectile, 300, height/2, projectile.width/2, projectile.height/2);


  //image(floating_square, spacement_x, spacement_y);
  //spacement_x++;
  //spacement_y++;
  //for (spacement_x <1920 && spacement_y <1080) {
  //  spacement_x=spacement_x+150;
  //  spacement_y=spacement_y+150
  //}
  //image(floating_square, mouseX-floating_square.width/2, mouseY-floating_square.height/2);
  
  // affichage floating image ===
  //image(floating_img, mouseX-floating_img.width/4, mouseY-floating_img.height/6, floating_img.width/2, floating_img.height/2);
  if(image_bool==true)
  {
    Image ball_img=new Image(ball_image,int(axe_ball),height-80-ball, ball_image.width/4, ball_image.height/4);
    ball_img.affiche();
    //image(ball_image, axe_ball, height-80-ball, ball_image.width/2, ball_image.height/2);
    for(int i=0;i<images.size()-1;i++)
    {
      int coor_ball_x_1=ball_img.x;
      int coor_ball_y_1=ball_img.y;
      int coor_ball_x_2=ball_img.x+ball_img.w;
      int coor_ball_y_2=ball_img.y+ball_img.w;
      int coor_brick_x_1=images.get(i).x;
      int coor_brick_y_1=images.get(i).y+images.get(i).h;
      int coor_brick_x_2=images.get(i).x+images.get(i).w;
      int coor_brick_y_2=images.get(i).y+images.get(i).w+images.get(i).h;
      println(":::");
      println(coor_ball_x_1);
      println(coor_brick_x_1);
      if (coor_ball_y_1 < coor_brick_y_1 && coor_ball_x_1 > coor_brick_x_1 && coor_ball_x_2 < coor_brick_x_2)
      {
        images.remove(i);
        image_bool=false;
        ball = 0;
      }
    }
    if(image_bool==true)
    {
      

    ball=ball+8;
    if (ball > screen_height) {
       ball = 0;
       image_bool=false;
    }
    ball++;
  }
  }

  
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

void colliderBall()
{}

//=================
void keyPressed() {
  if ( (keyCode == ESC) || ( keyCode == 'q' ) || ( keyCode == 'Q' )) {
    cam_.stop();
    exit();
  }
   
}

void mouseClicked() {
  if(image_bool!=true)
  {
    axe_ball=scanner;
    image_bool=true;
  }
}
