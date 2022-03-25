

//=================

import processing.video.*;
import gab.opencv.*;
import java.awt.*;


Capture cam;
OpenCV opencv;

//==================


PImage projectile;
PImage bg;
int scanner;
PImage floating_square;
PImage floating_img;
int spacement_x;
int spacement_y;




//==================

void setup(){
  // affichage fullscreen 1920 ===
  fullScreen();
  bg = loadImage("../prod/background_02.jpg");
  
  // affichage réduit 640 ===
  //size(640,360);
  //bg = loadImage("../prod/background_03.jpg");
  
  // projectile ===
  projectile = loadImage("../prod/boulder.png");
  
  // floating square ===
  floating_square = createImage(150,150,ARGB);
  for(int i = 0; i < floating_square.pixels.length; i++) {
    float a = map(i, 0, floating_square.pixels.length, 255, 0);
    floating_square.pixels[i] = color(0, 153, 204, a);
  }
  
  // floating image
  floating_img = loadImage("../prod/missile.png");
}

void draw(){
  background(bg);
  stroke(226,204,0);
  line(0,scanner,width,scanner);
  scanner++;
  if (scanner > height) {
   scanner = 0;
  }
  // affichage iamge  ===
  //image(projectile, 0, 0);
  image(projectile, 300, height/2, projectile.width/2, projectile.height/2);
  
  
  // affichage floating square ===
  image(floating_square, 90, 180);
  image(floating_square, 290, 580);
  image(floating_square, 890, 980);
  //image(floating_square, spacement_x, spacement_y);
  //spacement_x++;
  //spacement_y++;
  //for (spacement_x <1920 && spacement_y <1080) {
  //  spacement_x=spacement_x+150;
  //  spacement_y=spacement_y+150
  //}
  //image(floating_square, mouseX-floating_square.width/2, mouseY-floating_square.height/2);
  
  // affichage floating image ===
  //image(floating_img, 90, 80);
  //image(floating_img, 90, height/4, projectile.width/4, projectile.height/4);
  //image(floating_img, mouseX+floating_img.width/4, mouseY+floating_img.height/4);
  image(floating_img, mouseX-floating_img.width/2, mouseY-floating_img.height/2);
  
}
