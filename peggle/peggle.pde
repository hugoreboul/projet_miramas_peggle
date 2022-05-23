

//=================

import processing.video.*;
import gab.opencv.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

Capture cam;
OpenCV opencv;

//==================
//Image[] images = new Image[5];
List<Image> images = new ArrayList<Image>();
float y = 180;
PImage projectile;
PImage bg;
int scanner;
int ball;
PImage floating_square;
PImage floating_img;
int spacement_x;
int spacement_y;
int screen_width;
int screen_height;
float axe_ball;
PImage gun;
PImage brick_pink;
PImage ball_image;
boolean image_bool;

//==================

void setup(){
  // affichage fullscreen 1920 ===
  //fullScreen();
  //bg = loadImage("../prod/background_02.jpg");
  //w=1920;
  
  // affichage réduit 640 ===
  size(600,800);
  bg = loadImage("../prod/bg.jpg");
  screen_width = 640;
  screen_height = 800;
  
  // affichage réduit 720
//size(720,480);
  //bg=loadImage("../prod/Space Background_04.png");
  //screen_width = 720;
  //screen_height = 480;
  
  
  // projectile ===
  //projectile = loadImage("../prod/boulder.png");
  
  
  // canon_base ===
  gun = loadImage("../prod/gun.png");
  ball_image = loadImage("../prod/bulle_tiny.png");
  
  brick_pink = loadImage("../prod/brick_pink.png");
  
  // floating square ===
  //floating_square = createImage(screen_width/6,screen_width/6,ARGB);
  //for(int i = 0; i < floating_square.pixels.length; i++) {
  //  float a = map(i, 0, floating_square.pixels.length, 255, 0);
  //  floating_square.pixels[i] = color(0, 153, 204, a);
  //}
  
  // floating image
  floating_img = loadImage("../prod/bulle_tiny.png");
  images.add(new Image(brick_pink,180,90));
  
  //images[0].affiche();
  //Image.Image(brick_pink, 180, 90);
  images.add(new Image(brick_pink,300,300));
  // affichage floating square ===
  images.add(new Image(brick_pink,90,180));
  images.add(new Image(brick_pink,250,80));

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
  image(gun, y, height-80, gun.width*3, gun.height*3);
  y++;
  if (y > width) { 
    y = 0; 
  }
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
  //image(floating_img, 90, 80);
  //image(floating_img, 90, height/4, projectile.width/4, projectile.height/4);
  //image(floating_img, mouseX+floating_img.width/4, mouseY+floating_img.height/4);
  //image(floating_img, mouseX-floating_img.width/8, mouseY-floating_img.height/8);
  image(floating_img, mouseX-floating_img.width/4, mouseY-floating_img.height/6, floating_img.width/2, floating_img.height/2);
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
      
    ball=ball+4;
    if (ball > width) {
       ball = 0;
       image_bool=false;
    }
    ball++;
  }
  }
}

void colliderBall()
{
  
}

void mouseClicked() {
  if(image_bool!=true)
  {
    axe_ball=y;
    image_bool=true;
  }
}
