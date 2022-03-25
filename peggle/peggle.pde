PImage perso_1;
PImage bg;
int y;

//==================

void setup(){
  fullScreen();
  bg = loadImage("background_01.jpg");
  perso_1 = loadImage("missile.jpg");  
}

void draw(){
  image(perso_1, 0, 0);
  image(perso_1, 0, height/2, perso_1.width/2, perso_1.height/2);
  background(bg);
  stroke(226,204,0);
  line(0,y,width,y);
  y++;
  if (y > height) {
    y = 0;
  }
}
