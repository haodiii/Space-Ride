// Made by Haodi

String message = "Welcome to Space Tour";
float x, y; // X and Y coordinates of text
float hr, vr;  // horizontal and vertical radius of the text
float angle;
float distance= 25;
float focusX, focusY;
float thirdBallRatio=2;
PVector endPoints[] = new PVector[200];
int fc, num = 200, edge = 120;
ArrayList ballCollection;
boolean save = false;
import java.util.*;
PGraphics STAR;
ParticleSystem2 ps;
PImage sprite;  
import processing.video.*;
Movie movie;

int mode = 1;
// 0 is false;
boolean buttonClicked = false;

void mousePressed() {
}

void setup() {
  size(800, 600, P2D);
  //eyes
  smooth();
  for (int i=0; i<endPoints.length; i++) {
    float d=0;
    int x=0, y=0;
    while (d<5*distance/6 || d>distance) {
      x = int(random(96));
      y =int(random(64));
      d =dist(40, 40, x, y);
    }
    endPoints[i] = new PVector(x, y);
  }

  for (int i=0; i<endPoints.length; i++) {
    print(int(endPoints[i].x)+",");
  }
  println();
  println();
  println();
  for (int i=0; i<endPoints.length; i++) {
    print(int(endPoints[i].y)+",");
  }
  // texts scene 1
  textFont(createFont("SourceCodePro-Regular.ttf", 50));
  textAlign(CENTER, CENTER);

  hr = textWidth(message) / 2;
  vr = (textAscent() + textDescent()) / 2;
  noStroke();
  x = width / 2;
  y = height / 2;
  //scattered stars scene 4
  smooth();
  ballCollection = new ArrayList();
  createStuff();

  //scene 2
  STAR = createGraphics(800, 600);
  background(0);

  //scene 3
  orientation(LANDSCAPE);
  sprite = loadImage("silver.png");
  ps = new ParticleSystem2(1000);

  //scene 5
  background(0);
  movie = new Movie(this, "mybluestar.mov");
  movie.loop();
}



void draw() {
  background(0);
  if (random(10)>9.6) {
    focusX= random(96);
    focusY = random(64);
    if (random(10)>9.5)thirdBallRatio = random(2.5, 3);
  }
  noStroke();

  angle +=0.02;
  fill(0);


  ellipse(map(focusX, 0, 96, 40, 56), map(focusY, 0, 64, 26, 34), distance*2, distance*2);
  stroke(180, 140, 10);
  strokeWeight(0.05);
  pushMatrix();
  translate(map(focusX, 0, 96, 40, 56), map(focusY, 0, 64, 26, 34));
  for (int i=0; i<endPoints.length; i++) {
    line(0, 0, endPoints[i].x-48, endPoints[i].y-32);
  }
  noStroke();
  popMatrix();

  fill(26, 237, 205);
  ellipse(map(focusX, 0, 96, 38, 58), map(focusY, 0, 64, 24, 36), distance*1, distance*1);

  fill(0);
  ellipse(map(focusX, 0, 96, 36, 64), map(focusY, 0, 64, 22, 38), distance/thirdBallRatio, distance/thirdBallRatio);

  // Title Screen
  if (mode == 1) {  
    titleScreen1();
  } else if (mode == 2) {
    titleScreen2();
  } else if (mode == 3) {
    titleScreen3();
  } else if (mode == 4) {
    titleScreen4();
  } else if (mode == 5) {
    titleScreen5();
  }
}

void keyPressed() {
  if (key == '1') {
    mode = 1;
  } else if (key == 's') {
    mode = 2;
    fc = frameCount;
    save = true;
  } else if (key == 't') {
    mode = 3;
  } else if (key == 'a') {
    mode = 4;
  } else if (key == 'r') {
    mode = 5;
  }
}

void titleScreen1() {
  rect(0, 0, width, height);

  // If the cursor is over the text, change the position
  if (abs(mouseX - x) < hr &&
    abs(mouseY - y) < vr) {
    x += random(-5, 5);
    y += random(-5, 5);
  }
  fill(174, 175, 191);
  text("Welcome to a Space Tour", x, y);
}

void titleScreen2() {
  runTile();
  for (int y = 0; y < height; y += STAR.height) {
    for (int x = 0; x < width; x += STAR.width) {
      image(STAR, x, y);
    }
  }
}

void runTile() {
  float x = random(20, STAR.width-20);
  float y = random(20, STAR.height-20);
  STAR.beginDraw();
  STAR.noStroke();
  STAR.fill(0, 20);
  STAR.rect(0, 0, STAR.width, STAR.height);
  STAR.fill(50, random(40, 120), 250);
  STAR.ellipse(x, y, 50, 50);
  STAR.endDraw();
}

void titleScreen3() {
  background(0);
  ps.update();
  ps.display();

  ps.setEmitter(mouseX, mouseY);

  fill(255);
  textSize(2);
  text("Frame rate: " + int(frameRate), 10, 10);
}


void movieEvent(Movie m) {
  m.read();
}
void titleScreen4() {
  image(movie, 0, 0, width-20, height-100);
}


void titleScreen5() {
  for (int i=0; i<ballCollection.size(); i++) {
    Ball mb = (Ball) ballCollection.get(i);
    mb.run();
  }
  if (save) {
    if (frameCount%20==0 && frameCount < fc + 361) saveFrame("image-####.gif");
  }
}

void mouseReleased() {
  createStuff();
}

void createStuff() {
  ballCollection.clear();
  for (int i=0; i<num; i++) {
    PVector org = new PVector(random(edge, width-edge), random(edge, height-edge));
    float radius = random(20, 60);
    PVector loc = new PVector(org.x+radius, org.y);
    float offSet = random(TWO_PI);

    int dir = 1;
    float r = random(1);
    if (r>.5) dir =-1;
    Ball myBall = new Ball(org, loc, radius, dir, offSet);
    ballCollection.add(myBall);
  }
}
class Ball {
  PVector org, loc;
  float sz = 8;
  float theta, radius, offSet;
  int s, dir, d = 50;

  Ball(PVector _org, PVector _loc, float _radius, int _dir, float _offSet) {
    org = _org;
    loc = _loc;
    radius = _radius;
    dir = _dir;
    offSet = _offSet;
  }

  void run() {
    display();
    move();
  }

  void move() {
    loc.x = org.x + sin(theta+offSet)*radius;
    loc.y = org.y + cos(theta+offSet)*radius;
    theta += (0.0523/3*dir);
  }
  void display() {
    noStroke();
    for (int i=0; i<5; i++) {
      fill(255, i*50);
      ellipse(loc.x, loc.y, sz-2*i, sz-2*i);
    }
  }
}
