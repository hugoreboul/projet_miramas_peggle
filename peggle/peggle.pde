

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
int screen_width;
int screen_height;
PImage canon_base;
PImage canon_fut;



//==================

void setup(){
  // affichage fullscreen 1920 ===
  //fullScreen();
  //bg = loadImage("../prod/background_02.jpg");
  //w=1920;
  
  // affichage réduit 640 ===
  size(600,800);
  bg = loadImage("../prod/background_04.jpg");
  screen_width = 640;
  screen_height = 800;
  
  // affichage réduit 720
  size(720,480);
  bg=loadImage("../prod/background_05.jpg");
  screen_width = 720;
  screen_height = 480;
  
  
  // projectile ===
  projectile = loadImage("../prod/boulder.png");
  
  
  // canon_base ===
  canon_base = loadImage("../prod/canon_base.png");
  
  // canon_fut ===
  canon_fut = loadImage("../prod/canon_fut.png");
  
  // floating square ===
  floating_square = createImage(screen_width/6,screen_width/6,ARGB);
  for(int i = 0; i < floating_square.pixels.length; i++) {
    float a = map(i, 0, floating_square.pixels.length, 255, 0);
    floating_square.pixels[i] = color(0, 153, 204, a);
  }
  
  // floating image
  floating_img = loadImage("../prod/bulle_tiny.png");
}

void draw(){
  background(bg);
  stroke(226,204,0);
  line(0,scanner,width,scanner);
  scanner++;
  if (scanner > height) {
   scanner = 0;
  }
  
  // affichage canon_base ===
  image(canon_base, screen_width/3, screen_height/1.1, canon_base.width/4, canon_base.height/4);
  //affichage canon_fut ===
  image(canon_fut,screen_width/2.8, screen_height/1.26, canon_fut.width/4, canon_fut.height/6);
  
  // affichage image  ===
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
  //image(floating_img, mouseX-floating_img.width/8, mouseY-floating_img.height/8);
  image(floating_img, mouseX-floating_img.width/4, mouseY-floating_img.height/6, floating_img.width/2, floating_img.height/2);
  
}
