class Image {
  PImage im;
  int x, y;  // position 
  int w, h;  // dimension
  float a ;  // angle de rotation de l’image

  Image(PImage _im, int _x, int _y) {
    im = _im;
    x = _x;
    y = _y;
    w = 100;
    h = 100;
    a=0;
  }
  
    Image(PImage _im, int _x, int _y, int _w, int _h) {
    im = _im;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    a=0;
  }

  void affiche() {
    image(im, x, y, w, h);
  }
}
