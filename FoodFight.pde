import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//import gifAnimation.*;
//Gif myAnimation;

import processing.video.*;
Movie myMovie;

Minim minim; 
AudioPlayer shoot1;
AudioPlayer shoot2;
AudioPlayer collide;
AudioPlayer score;

boolean gameTitle = false;
boolean gameSelect = false;
boolean gameInstruction = false;
boolean gameStart = false;
boolean gameEnd = false;

boolean p1Selected = false;
boolean p2Selected = false;

boolean saveScreen = false;
boolean DEBUG = true;

int win = 5;
int particleSize = 40;

int p1Selection;
int p2Selection;

int p1Selectionx;
int p1Selectiony;
int p2Selectionx;
int p2Selectiony;
int MAX_FPS = 60;

PShape smashMash;

PShape p1Choose;
PShape p2Choose;
PShape p1Wait;
PShape p2Wait;

PShape S;
PShape M;
PShape A;
PShape S2;
PShape H;

PShape end;

// game components

ArrayList <Bullet> bullets;
//where our bullets will be stored Bullet (with the capital 'B' = class) & bullets = all the bullets 0,1,2..9,10.. the states
//Bullets bullets;

ArrayList <Particle> particles;

PImage[] p1;
PImage[] p2;


PShape[][] particleShapes; 
//[bullet int][particles variations]

PShape modrian;
PShape modrian_1;
PShape modrian_2;
PShape modrian_3;
PShape modrian_4;

PShape penfold;
PShape penfold_1;
PShape penfold_2;
PShape penfold_3;
PShape penfold_4;

PShape warhol;
PShape warhol_1;
PShape warhol_2;
PShape warhol_3;
PShape warhol_4;


PShape campbell;
PShape campbell_1;
PShape campbell_2;
PShape campbell_3;
PShape campbell_4;

int playerWidth = 120;
int playerHeight = 120;

float[] p1X;
float[] p1Y;

int p1Xpos;
int p1Ypos;
int p2Xpos;
int p2Ypos; 

int p1Score = 0;
int p2Score = 0;

int p1ParticleVariation;
int p2ParticleVariation;
int particlesPerCollision = 3;

int coolDownP1 = 0;
int coolDownP2 = 0;
int SHOTS_PER_SECOND = 3;
int MAXCOOLDOWN = MAX_FPS / SHOTS_PER_SECOND; //captials to show that values will never change

// save final art
PImage artwork;
PImage grad;
color c1, c2;
int Y_AXIS = 1;
int X_AXIS = 2;


void setup() {
  size(displayWidth, displayHeight, P3D);
  smooth(8);
  frameRate (MAX_FPS);

  //  myAnimation  = new Gif(this, "smashmash.gif");
  //  myAnimation.play();
  myMovie = new Movie(this, "comp1.mov");
  myMovie.loop();

  color c1 = color(random(255), random(255), random(255));//first color of the gradient background
  color c2 = color(random(255), random(255), random(255));//second color of the gradient background
  grad = generateGradient(c1, c2, width, height);

  minim = new Minim(this);
  shoot1 = minim.loadFile("shoot.wav");
  shoot2 = minim.loadFile("shoot2.wav");
  collide = minim.loadFile("collide.wav");
  score = minim.loadFile("score.wav");

  //  smashMash = loadShape("SmashMash_Title.svg");
  // player selection
  p1Choose = loadShape("SmashMash_P1Select.svg");
  p2Choose = loadShape("SmashMash_P2Select.svg"); 
  p1Wait = loadShape("SmashMash_P1Selected.svg");
  p2Wait = loadShape("SmashMash_P2Selected.svg"); 

  S = loadShape("SmashMash_S.svg");
  M = loadShape("SmashMash_M.svg");
  A = loadShape("SmashMash_A.svg");
  S2 = loadShape("SmashMash_S.svg");
  H = loadShape("SmashMash_H.svg");

  // Size needs to always be one bigger than the amount of bullet types because
  // state starts at 1 instead of 0
  particleShapes = new PShape[5][];

  modrian = loadShape("SmashMash_Modrian.svg");
  modrian_1 = loadShape("SmashMash_Modrian_1.svg");
  modrian_2 = loadShape("SmashMash_Modrian_2.svg");
  modrian_3 = loadShape("SmashMash_Modrian_3.svg");
  modrian_4 = loadShape("SmashMash_Modrian_4.svg");

  penfold = loadShape("SmashMash_Penfold.svg");
  penfold_1 = loadShape("SmashMash_Penfold_1.svg");
  penfold_2 = loadShape("SmashMash_Penfold_2.svg");
  penfold_3 = loadShape("SmashMash_Penfold_3.svg");
  penfold_4 = loadShape("SmashMash_Penfold_4.svg");


  warhol = loadShape("SmashMash_Warhol.svg");  
  warhol_1 = loadShape("SmashMash_Warhol_1.svg");
  warhol_2 = loadShape("SmashMash_Warhol_2.svg");
  warhol_3 = loadShape("SmashMash_Warhol_3.svg");
  warhol_4 = loadShape("SmashMash_Warhol_4.svg");


  campbell = loadShape("SmashMash_Campbell.svg");
  campbell_1 = loadShape("SmashMash_Campbell_1.svg");
  campbell_2 = loadShape("SmashMash_Campbell_2.svg");
  campbell_3 = loadShape("SmashMash_Campbell_3.svg");
  campbell_4 = loadShape("SmashMash_Campbell_4.svg");

  end = loadShape("EndGame.svg");


  // Setup the particle shapes, it is double layered (2 dimensional)
  // You first access it by the 'state' of the particle : bullet->(modrian, or drink or warhol)
  // THEN you access that by its 'variation' which would be the different particle images for each type of bullet.
  particleShapes[1] = new PShape[] { 
    modrian_1, 
    modrian_2, 
    modrian_3, 
    modrian_4
  };
  particleShapes[2] = new PShape[] { 
    penfold_1, 
    penfold_2, 
    penfold_3, 
    penfold_4,
  };
  particleShapes[3] = new PShape[] { 
    warhol_1, 
    warhol_2, 
    warhol_3, 
    warhol_4,
  };
  particleShapes[4] = new PShape[] { 
    campbell_1, 
    campbell_2, 
    campbell_3, 
    campbell_4,
  };


  // game codes
  bullets = new ArrayList();
  particles = new ArrayList();

  if ((p1Selected==true)&&(p2Selected==true)) { 
    // player positions
    p1X = new float[(width-playerWidth)]; // only defines length of array but not values
    p1Y = new float[(height-playerHeight)]; // same as above

    for (int i = 0; i < (width-playerWidth); i++) {
      p1X[i] = i;
    } // fill P1X[width] with values

    for (int j = 0; j < (height-playerHeight); j++) {
      p1Y[j] = j;
    } // fill P1Y[height] with values
  }

  restart();
}

void draw() {

  if (gameTitle == false) {
    image(grad, 0, 0);
  } else {
    image(grad, 0, 0);//background image is displayed
  }

  smashMashTitle();
  if (gameStart == true) {
    PlayerSelection();

    checkCollisions(bullets);

    if ((p1Selected==true)&&(p2Selected==true)) {
      if ((p1Score < win) && (p2Score < win)) {
        player1();//display player1
        player2();//display player2
      }

      removeOutOfBounds(bullets);
      moveAll(bullets);
      displayAll(bullets);


      if (coolDownP1 > 0) {
        coolDownP1 -= 1;
      }
      if (coolDownP2 > 0) {
        coolDownP2 -= 1;
      }
    }

    renderParticles();
    if (saveScreen) {
      savescreen();
      saveScreen = false;
    }

    livesCounter();

    if ((p1Score >= win) || (p2Score >= win)) {
      shape(end, 0, 0);
    }
  }
}

PImage generateGradient(color top, color bottom, int w, int h) {
  int tR = (top >> 16) & 0xFF;
  int tG = (top >> 8) & 0xFF;
  int tB = top & 0xFF;
  int bR = (bottom >> 16) & 0xFF;
  int bG = (bottom >> 8) & 0xFF;
  int bB = bottom & 0xFF;

  PImage bg = createImage(w, h, RGB);
  bg.loadPixels();
  for (int i=0; i < bg.pixels.length; i++) {
    int y = i/bg.width;
    float n = y/(float)bg.height;
    // for a horizontal gradient:
    // float n = x/(float)bg.width;
    bg.pixels[i] = color(
    lerp(tR, bR, n), 
    lerp(tG, bG, n), 
    lerp(tB, bB, n), 
    100);
  }
  bg.updatePixels();
  return bg;
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}

void livesCounter() {
  int x1 = 50;
  int x2 = 300;
  int y = 30;
  int scoreHeight = 3;

  if (p1Score >= 1) {
    shape(S, x1, y, 28.5/scoreHeight, 50/scoreHeight );
    x1 += 50;
  }

  if (p1Score >= 2) {
    shape(M, x1, y, 40.7/scoreHeight, 50/scoreHeight );
    x1 += 55;
  }

  if (p1Score >= 3) {
    shape(A, x1, y, 36.2/scoreHeight, 50/scoreHeight );
    x1 += 50;
  }

  if (p1Score >= 4) {
    shape(S2, x1, y, 28.5/scoreHeight, 50/scoreHeight );
    x1 += 50;
  }

  if (p1Score >= 5) {
    shape(H, x1, y, 28.5/scoreHeight, 50/scoreHeight );
    x1 += 50;
  }

  if (p2Score >= 1) {
    shape(S, width-x2, y, 28.5/scoreHeight, 50/scoreHeight );
    x2 -= 50;
  }

  if (p2Score >= 2) {
    shape(M, width-x2, y, 40.7/scoreHeight, 50/scoreHeight );
    x2 -= 55;
  }

  if (p2Score >= 3) {
    shape(A, width-x2, y, 36.2/scoreHeight, 50/scoreHeight );
    x2 -= 50;
  }

  if (p2Score >= 4) {
    shape(S2, width-x2, y, 28.5/scoreHeight, 50/scoreHeight );
    x2 -= 50;
  }

  if (p2Score >= 5) {
    shape(H, width-x2, y, 28.5/scoreHeight, 50/scoreHeight );
    x2 -= 50;
  }

  //  for (int p1S = 0; p1S < p2Score; p1S++) {
  //    shape(lives, x1, y, 20, 20);
  //    x1 += 50;
  //  } 
  //
  //  for (int p2S = 0; p2S < p1Score; p2S++) {
  //    shape(lives, width-x2, y, 20, 20);
  //    x2 += 50;
  //  }
}

void removeOutOfBounds(ArrayList<Bullet> arr) { 
  for (int i = 0; i < arr.size (); ) {
    Bullet temp = arr.get(i);
    if (temp.x < 0) {
      arr.remove(i);
      p2Score += 1;
      score.rewind();
      score.play();
      System.out.println("Scores: P1 = " + p1Score + " - P2 = " + p2Score);
    } else if (temp.x > width) {
      arr.remove(i);
      p1Score += 1;
      score.rewind();
      score.play();
      System.out.println("Scores: P1 = " + p1Score + " - P2 = " + p2Score);
    } else {
      i++;
    }
  }
}
void title() {
  int x = width - 275;
  int y = height/2 - 85;

  fill(255);
  text("void keyPressed ( ) {", x-12, y);
  fill(255);
  text("if ( key ==", x-16, y+15);
  fill(#76ff84);
  text("SPACE", x+50, y+15);
  fill(255);
  text(") {", x+92, y+15);
  fill(255);
  text("gameStart ( );", x+27, y+30);
  fill(255);
  text("}", x+100, y+45);
  fill(255);
  text("}", x+100, y+60);
}

void smashMashTitle() {
  if (gameTitle == false) {
    image (myMovie, 0, 0);
    title();
  }
}

void PlayerSelection() {

  if (p2Selected == false) {
    shape(p2Choose, width/2, 0);
  }

  if ((p1Selected == true) && (p2Selected == false)) {
    shape(p1Wait, 0, 0);
  }

  if ((p2Selected == true) && (p1Selected == false)) {
    shape(p2Wait, width/2, 0);
  }

  if (p1Selected == false) {
    shape(p1Choose, 0, 0);
  }
}

void restart() {
  p1Xpos = playerWidth / 2;
  p1Ypos = height / 2;
  p2Xpos = width - (playerWidth + playerWidth / 2);
  p2Ypos = height / 2;
  p1Selected = false;
  p2Selected = false;
  p1Score = 0;
  p2Score = 0;
  color c1 = color(random(255), random(255), random(255));//first color of the gradient background
  color c2 = color(random(255), random(255), random(255));//second color of the gradient background
  grad = generateGradient(c1, c2, width, height);
  bullets.clear();
  particles.clear();
}


//---------------------- Bullet codes

class Bullet {           //bullet class to one bullet
  float x;
  float y;
  float speed;
  float direction;
  int state;

  Bullet(float tx, float ty, int state, float direction) {
    x = tx;
    y = ty;
    this.state = state;
    this.direction = direction;
  }


  void display() {
    noStroke();

    pushMatrix();
    translate(x, y);
    if (direction < 0) {
      scale(-1, 1);
    }
    if (state==1) {
      shape (modrian, 0, 0, playerWidth, (playerHeight));
    }
    if (state==2) {
      shape(penfold, 0, 0, (playerWidth), (playerHeight));
    }
    if (state==3) {
      shape(warhol, 0, 0, (playerWidth), (playerHeight));
    }
    if (state==4) {
      shape(campbell, 0, 0, (playerWidth-30), (playerHeight));
    }
    popMatrix();
  }


  void move() {
    x += 10*direction;
  }

  boolean collides_with(Bullet other) {
    //---- debug visual
    if (DEBUG) {
      noStroke();
      fill(random(255), random(255), random(255));
      ellipse(this.x, this.y, playerHeight, playerHeight);
      ellipse(other.x, other.y, playerHeight, playerHeight);
    }

    // ball-ball collision code from: https://github.com/jeffThompson/CollisionDetectionFunctionsForProcessing
    // does this and other overlap?
    // find distance between the two objects
    float xDist = this.x-other.x;                                   // distance horiz
    float yDist = this.y-other.y;                                   // distance vert
    float distance = sqrt((xDist*xDist) + (yDist*yDist));  // diagonal distance

    // test for collision
    if (playerWidth/2 + playerWidth/2 > distance) {
      return true;    // if a hit, return true
    } else {            // if not, return false
      return false;
    }
  }
}               // end of bullet class


void moveAll(ArrayList<Bullet> arr) {
  for (Bullet temp : arr) { //temporary 
    temp.move();
  }
}

void displayAll(ArrayList<Bullet> arr) {
  // equivalent code
  // for (int i = 0; i < arr.size(); i++) {
  //  Bullet temp = arr[i];
  //  temp.display();
  //}
  for (Bullet temp : arr) { //for all 
    temp.display();
  }
} 

void player1() {
  if (p1Selection==1) {
    shape(modrian, p1Xpos, p1Ypos, (playerWidth), (playerHeight));
  }
  if (p1Selection==2) {
    shape(penfold, p1Xpos, p1Ypos, (playerWidth), (playerHeight));
  }
  if (p1Selection==3) {
    shape(warhol, p1Xpos, p1Ypos, (playerWidth), (playerHeight));
  }
  if (p1Selection==4) {
    shape(campbell, p1Xpos, p1Ypos, (playerWidth-30), (playerHeight));
  }
}

void player2() {
  if (p2Selection==1) {
    pushMatrix();
    scale (-1.0, 1.0);
    shape(modrian, -(p2Xpos + playerWidth), p2Ypos, (playerWidth), (playerHeight));
    popMatrix();
  }

  if (p2Selection==2) {
    pushMatrix();
    scale (-1.0, 1.0);
    shape (penfold, -(p2Xpos + playerWidth), p2Ypos, (playerWidth), (playerHeight));
    popMatrix();
  }

  if (p2Selection==3) {
    pushMatrix();
    scale (-1.0, 1.0);
    shape (warhol, -(p2Xpos + playerWidth), p2Ypos, (playerWidth), (playerHeight));
    popMatrix();
  }
  if (p2Selection==4) {
    pushMatrix();
    scale (-1.0, 1.0);
    shape(campbell, -(p2Xpos + playerWidth), p2Ypos, (playerWidth-30), (playerHeight));
    popMatrix();
  }
}


void keyPressed() { 

  if (gameTitle == false) {
    if (key == ' ' ) {
      gameTitle = true;
      gameStart = true;
    }
  }
  if ((p1Selected == false) && (gameTitle == true)) {
    if (key=='1') {
      p1Selected = true;
      p1Selection = 1;
    }
    if (key=='2') {
      p1Selected = true;
      p1Selection = 2;
    }
    if (key=='3') {
      p1Selected = true;
      p1Selection = 3;
    }
    if (key=='4') {
      p1Selected = true;
      p1Selection = 4;
    }
    println(p1Selection);
  }

  if ((p2Selected == false) && (gameTitle == true)) {
    if (key=='5') {
      p2Selected = true;
      p2Selection = 1;
    }
    if (key=='6') {
      p2Selected = true;
      p2Selection = 2;
    }
    if (key=='7') {
      p2Selected = true;
      p2Selection = 3;
    }
    if (key=='8') {
      p2Selected = true;
      p2Selection = 4;
    }

    println(p2Selection);

    if (p2Selected && p1Selected) {
      // Now that all the players have chosen their bullet type, we can choose their variation randomly
      p1ParticleVariation = int(random(0, particleShapes[p1Selection].length));
      p2ParticleVariation = int(random(0, particleShapes[p2Selection].length));
    }
  }

  // player1 movement & shooting
  if ((p1Selected==true)&&(p2Selected==true)&&(p1Score<win)&&(p2Score<win)) {
    if (key=='w') {
      p1Ypos -= playerHeight;
    }

    if ((key=='s') && (p1Ypos < (height-playerHeight))) {
      p1Ypos += playerHeight;
    }
    p1Ypos = constrain(p1Ypos, playerHeight, height-playerHeight);
    //keypress for bullet
    if ((key=='d') && (coolDownP1 == 0)) {
      // create bullet with state
      shoot1.rewind();
      shoot1.play();
      coolDownP1 = MAXCOOLDOWN;
      Bullet temp = new Bullet(playerWidth, p1Ypos, p1Selection, 1);
      bullets.add(temp);
    }
  }

  // player2 movement & shooting
  if ((p1Selected==true)&&(p2Selected==true)&&(p1Score<win)&&(p2Score<win)) {
    if (key=='i') {
      p2Ypos -=playerHeight;
    }

    if (key=='k') {
      p2Ypos += playerHeight;
    }
    p2Ypos = constrain(p2Ypos, playerHeight, height-playerHeight);

    //keypress for bullet
    if ((key=='j') && (coolDownP2 == 0)) {
      shoot2.rewind();
      shoot2.play();
      coolDownP2 = MAXCOOLDOWN;
      // create bullet with state
      Bullet temp = new Bullet(-(-width + playerWidth), p2Ypos, p2Selection, -1);
      bullets.add(temp);
    }
  }

  if ((key=='p') && ((p1Score >= win) || (p2Score >=win))) {
    saveScreen = true;
  }

  if ((key == 'r') && ((p1Score >=win) || (p2Score >=win))) {
    restart();
  }
}//<--- void keyPressed()

void savescreen() { 
  artwork = createImage(width, height, RGB);
  loadPixels();
  artwork.loadPixels();

  for (int i = 0; i < artwork.pixels.length; i++) {
    artwork.pixels[i] = pixels[i];
  }

  artwork.updatePixels();
  updatePixels();

  artwork.save("artwork.png");
  println("saved");
}


void checkCollisions(ArrayList<Bullet> arr) {
  for (int i = 0; i< arr.size (); i++) {
    for (int j = i + 1; j< arr.size (); j++) { //j is always bigger than i
      // does arr[i] collide with arr[j] ?
      if (arr.get(i).collides_with(arr.get(j))) {
        System.out.println(i + " collided with " + j);

        // draw explosion particles
        float x1 = arr.get(i).x;
        float x2 = arr.get(j).x;

        float midpoint = ((abs(x2 - x1)/2)+ Math.min(x1, x2));
        System.out.println("x1= " + x1 + " x2= " + x2 + " midpoint = " + midpoint);

        float pX = (midpoint + (playerWidth/2));
        float pY = (arr.get(j).y + (playerHeight/2));
        for (int k = 0; k < particlesPerCollision; k++) {
          particles.add(new Particle(pX, pY, p1Selection, 1));
          particles.add(new Particle(pX, pY, p2Selection, -1));
        }
        collide.rewind();
        collide.play();
        // remove bullets
        arr.remove(j); // need to remove j first because it is larger than i always
        arr.remove(i);
      }
    }
  }
}

void renderParticles() {  //function to display and update particles
  for (Particle p : particles) {
    p.run();
    p.display();
  }
}

//<--- Start ofParticle class

class Particle {

  float x;
  float y;
  float xspeed;
  float yspeed;
  int state;
  int variation;
  float life = MAX_FPS * 10 ;
  float direction;

  Particle(float x, float y, int state, int direction) {
    this.x = x;
    this.y = y;
    this.state = state;
    xspeed = random(-5, 5);
    yspeed = random(-5, 5);

    this.variation = int(random(0, particleShapes[state].length));
  }

  void run() {
    if (life > 0) {
      life -= 1;
      x = x + xspeed;
      y = y + yspeed;
      //      if (DEBUG) {
      //        stroke(random(255), random(255), random(255));
      //        noFill();
      //        ellipse(this.x, this.y, particleSize, particleSize);
      //      }
      if (x > width - particleSize/2 || x < particleSize/2) { //to bounce of walls
        xspeed*= -1;
      }
      if (y > height - particleSize/2 || y < particleSize/2) {
        yspeed*= -1;
      }
    }
  }

  void display() {
    noStroke();   
    pushMatrix();
    translate(x, y);
    float a = atan2(yspeed, xspeed);
    rotate(a);
    PShape s = particleShapes[state][variation];
    float scaleWidth = s.width * (particleSize/s.height);
    shape(s, 0, 0, scaleWidth, particleSize);
    popMatrix();
  }
} // <--- end of class Particle
