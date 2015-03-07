// Bens version
// player selection
boolean p1Selected = false;
boolean p2Selected = false;

int p1Selection;
int p2Selection;

int p1Selectionx;
int p1Selectiony;
int p2Selectionx;
int p2Selectiony;
int MAX_FPS = 60;

PImage p1Choose;
PImage p2Choose;

// game components

ArrayList <Bullet> bullets;//where our bullets will be stored Bullet (with the capital 'B' = class) & bullets = all the bullets 0,1,2..9,10.. the states
//Bullets bullets;

ArrayList p1particles;
ArrayList p2particles;

PImage[] p1;
PImage[] p2;
PImage end;

PShape burger;
PShape burger_tomato;
PShape burger_bacon;

PShape soda;


int playerWidth = 120;
int playerHeight = 120;

float[] p1X;
float[] p1Y;

int p1Xpos = 0;
int p1Ypos = 0;
int p2Xpos = 1280-playerWidth;
int p2Ypos = 0;

int p1Score = 0;
int p2Score = 0;

int coolDownP1 = 0;
int coolDownP2 = 0;
int SHOTS_PER_SECOND = 3;
int MAXCOOLDOWN = MAX_FPS / SHOTS_PER_SECOND; //captials to show that values will never change

// save final art
float transparency = 255;
PImage artwork;


void setup() {
  size(1280, 800, P3D);
  smooth();
  frameRate (MAX_FPS);
  //  //  ellipseMode(CORNER);

  // player selection
  p1Choose = loadImage("P1Selection.v1.jpg");
  p2Choose = loadImage("P2Selection.v1.jpg"); 

  burger = loadShape("SmashMash_Burger_Icon.svg");
  burger_tomato = loadShape("Burger_Tomato.svg");
  burger_bacon = loadShape("Burger_Bacon.svg");


  soda = loadShape("SmashMash_Soda_Icon.svg");


  end = loadImage("EndOfGame.png");

  // game codes
  bullets = new ArrayList();
  p1particles = new ArrayList();
  p2particles = new ArrayList();



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
}

void draw() {
  background(#003958);
  PlayerSelection();
  checkCollisions(bullets);

  if ((p1Selected==true)&&(p2Selected==true)) {
    if ((p1Score < 5) && (p2Score < 5)) {
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

  //  if (savescreen == true) {
  savescreen();
  //  }
}

void removeOutOfBounds(ArrayList<Bullet> arr) { 
  for (int i = 0; i < arr.size (); ) {
    Bullet temp = arr.get(i);
    if (temp.x < 0) {
      arr.remove(i);
      p2Score += 1;
      System.out.println("Scores: P1 = " + p1Score + " - P2 = " + p2Score);
    } else if (temp.x > width) {
      arr.remove(i);
      p1Score += 1;
      System.out.println("Scores: P1 = " + p1Score + " - P2 = " + p2Score);
    } else {
      i++;
    }
  }
}

void PlayerSelection() {
  if (p2Selected == false) {
    image(p2Choose, 0, 0);
  }

  if (p1Selected == false) {
    image(p1Choose, 0, 0);
  }
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
    color c;
    if (state == 1) {
      c = color(#ff0000);
    } else if (state == 2) {
      c = color(#00ff00);
    } else if (state == 3) {
      c = color(#0000ff);
    } else {
      c = color(0);
    }

    //    fill(c);
    // display player 1 bullets
    if (state==1) {
      shape (burger, x, y, playerWidth, (playerHeight*0.81));
    }
    if (state==2) {
      shape(soda, x, y+20, (playerWidth*0.68), (playerHeight*1.1));
    }
    if (state==3) {
      triangle (x+25, y+75, x+50, y+25, x+75, y+75);
    }
  }

  void move() {
    x += 10*direction;
  }

  boolean collides_with(Bullet other) {

    //---- debug visual
    stroke(#ff0000);
    noFill();
    ellipse(this.x, this.y, playerHeight, playerHeight);
    ellipse(other.x, other.y, playerHeight, playerHeight);

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
    shape(burger, p1Xpos, p1Ypos, (playerWidth), (playerHeight*0.81));
  }
  if (p1Selection==2) {
    translate(0, 20);
    shape(soda, p1Xpos, p1Ypos, (playerWidth*0.68), (playerHeight*1.1));
  }
  if (p1Selection==3) {
    fill(#0000ff);
    triangle(p1Xpos, p1Ypos+playerWidth, p1Xpos+(playerWidth/2), p1Ypos, p1Xpos+playerWidth, p1Ypos+playerWidth);
  }
}

void player2() {
  if (p2Selection==1) {
    pushMatrix();
    scale (-1.0, 1.0);
    shape(burger, -(p2Xpos + playerWidth), p2Ypos, (playerWidth), (playerHeight*0.81));
    popMatrix();
  }

  if (p2Selection==2) {
    pushMatrix();
    translate(0, 20);
    scale (-1.0, 1.0);
    shape (soda, -(p2Xpos + playerWidth), p2Ypos, (playerWidth*0.68), (playerHeight*1.1));
    popMatrix();
  }

  if (p2Selection==3) {
    fill(#0000ff);
    triangle(p2Xpos, p2Ypos+playerWidth, p2Xpos+(playerWidth/2), p2Ypos, p2Xpos+playerWidth, p2Ypos+playerWidth);
  }
}


void keyPressed() {
  if (p1Selected == false) {
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
    println(p1Selection);
  }

  if ((p1Selected == true) && (p2Selected == false)) {
    if (key=='4') {
      p2Selected = true;
      p2Selection = 1;
    }
    if (key=='5') {
      p2Selected = true;
      p2Selection = 2;
    }
    if (key=='6') {
      p2Selected = true;
      p2Selection = 3;
    }
    println(p2Selection);
  }

  // player1 movement & shooting
  if ((p1Selected==true)&&(p2Selected==true)&&(p1Score<5)&&(p2Score<5)) {
    if ((key=='w') && (p1Ypos >= playerHeight)) {
      p1Ypos -=playerHeight;
    }

    if ((key=='s') && (p1Ypos < ((height-playerHeight)-playerHeight))) {
      p1Ypos += playerHeight;
    }

    //keypress for bullet
    if ((key=='d') && (coolDownP1 == 0)) {
      // create bullet with state
      coolDownP1 = MAXCOOLDOWN;
      Bullet temp = new Bullet(playerWidth, p1Ypos, p1Selection, 1);
      bullets.add(temp);
    }
  }

  // player2 movement & shooting
  if ((p1Selected==true)&&(p2Selected==true)&&(p1Score<5)&&(p2Score<5)) {
    if ((key=='i') && (p2Ypos >= playerHeight)) {
      p2Ypos -=playerHeight;
    }

    if ((key=='k') && (p2Ypos < ((height-playerHeight)-playerHeight))) {
      p2Ypos += playerHeight;
    }

    //keypress for bullet
    if ((key=='j') && (coolDownP2 == 0)) {
      coolDownP2 = MAXCOOLDOWN;
      // create bullet with state
      pushMatrix();
      scale(-1.0, 1.0);
      Bullet temp = new Bullet(-(-width + playerWidth), p2Ypos, p2Selection, -1);
      bullets.add(temp);
      popMatrix();
    }
  }

  if ((key=='p') && ((p1Score >= 5) || (p2Score >=5))) {

    if (artwork != null) {
      artwork.save("artwork.jpg");
    }
    println("saved");
  }
}//<--- void keyPressed()

void savescreen() { 
  if ((p1Score >=5) || (p2Score >=5)) {
    artwork = createImage(width, height, RGB);

    loadPixels();
    artwork.loadPixels();

    for (int i = 0; i < artwork.pixels.length; i++) {
      artwork.pixels[i] = pixels[i];
    }

    artwork.updatePixels();
    updatePixels();

    tint(255, transparency);
    image(end, 0, 0);
  }
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
        for (int k = 0; k < 1; k++) {
          p1particles.add(new Particle(pX, pY, p1Selection));
          p2particles.add(new Particle(pX, pY, p2Selection));
        }

        // remove bullets
        arr.remove(j); // need to remove j first because it is larger than i always
        arr.remove(i);
      }
    }
  }
}

void renderParticles() {  //function to display particles
  for (int k = 0; k < p1particles.size (); k++) {
    //    if (int(random(0, 2))==0) {
    //      Particle p1 = (CrazyParticle) p1particles.get(k);
    //      Particle p2 = (CrazyParticle) p2particles.get(k);
    //    } else {
    Particle p1 = (Particle) p1particles.get(k);
    Particle p2 = (Particle) p2particles.get(k);
    //    }

    p1.run();
    p1.gravity();
    p1.display();

    p2.run();
    p2.gravity();
    p2.display();
  }
}

class Particle {

  float x;
  float y;
  float xspeed;
  float yspeed;
  int state;
  float life = 50;

  Particle(float x, float y, int state) {
    this.x = x;
    this.y = y;
    this.state = state;
    xspeed = random(-5, 5);
    yspeed = random(-5, 5);
  }

  void run() {
    //  if (life > 0) {
    //    life -= 1;
    x = x + xspeed;
    y = y + yspeed;
    //    }
  }

  void gravity() {
    if (yspeed > 0) {
      yspeed -= 0.05;
    }

    if (yspeed < 0) {
      yspeed += 0.05;
    }

    if (xspeed > 0) {
      xspeed -= 0.05;
    }

    if (xspeed < 0) {
      xspeed += 0.05;
    }
  }

  void display() {
    noStroke();
    color c;
    if (state == 1) {
      c = color(#ff0000);
    } else if (state == 2) {
      c = color(#00ff00);
    } else if (state == 3) {
      c = color(#0000ff);
    } else {
      c = color(0);
    }

    //    fill(c);
    if (state==1) {
      shape(burger_tomato, x, y, 50, 50);
      shape(burger_bacon, x, y, 50, 50);
      //      ellipse(x, y, 20, 20);
    }
    if (state==2) {
      rect (x, y, 20, 20);
    }
    if (state==3) {
      triangle (x-10, y+10, x, y-10, x+10, y+10);
    }
  }
} // <--- end of class Particle
