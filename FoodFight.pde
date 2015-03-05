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

ArrayList particles;

PImage[] p1;
PImage[] p2;

int playerSize = 100;

float[] p1X;
float[] p1Y;

int p1Xpos = 0;
int p1Ypos = 0;
int p2Xpos = 1280-playerSize;
int p2Ypos = 0;

int p1Score = 0;
int p2Score = 0;

int coolDownP1 = 0;
int coolDownP2 = 0;
int SHOTS_PER_SECOND = 3;
int MAXCOOLDOWN = MAX_FPS / SHOTS_PER_SECOND; //captials to show that values will never change

void setup() {
  size(1280, 800);
  smooth();
  frameRate (MAX_FPS);
  ellipseMode(CORNER);

  // player selection
  p1Choose = loadImage("P1Selection.v1.jpg");
  p2Choose = loadImage("P2Selection.v1.jpg"); 

  // game codes
  bullets = new ArrayList();
  particles = new ArrayList();


  if ((p1Selected==true)&&(p2Selected==true)) { 
    // player positions
    p1X = new float[(width-playerSize)]; // only defines length of array but not values
    p1Y = new float[(height-playerSize)]; // same as above

    for (int i = 0; i < (width-playerSize); i++) {
      p1X[i] = i;
    } // fill P1X[width] with values

    for (int j = 0; j < (height-playerSize); j++) {
      p1Y[j] = j;
    } // fill P1Y[height] with values
  }
}

void draw() {
  background(0);
  PlayerSelection();
  checkCollisions(bullets);

  if ((p1Selected==true)&&(p2Selected==true)) {

    removeOutOfBounds(bullets);
    moveAll(bullets);
    displayAll(bullets);
    player1();//display player1
    player2();//display player2

      if (coolDownP1 > 0) {
      coolDownP1 -= 1;
    }
    if (coolDownP2 > 0) {
      coolDownP2 -= 1;
    }
  }

  renderParticles();
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

    fill(c);
    // display player 1 bullets
    if (state==1) {
      ellipse (x+25, y+25, 50, 50);
    }
    if (state==2) {
      rect (x+25, y+25, 50, 50);
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
    ellipse(this.x, this.y, playerSize, playerSize);
    ellipse(other.x, other.y, playerSize, playerSize);

    // ball-ball collision code from: https://github.com/jeffThompson/CollisionDetectionFunctionsForProcessing
    // does this and other overlap?
    // find distance between the two objects
    float xDist = this.x-other.x;                                   // distance horiz
    float yDist = this.y-other.y;                                   // distance vert
    float distance = sqrt((xDist*xDist) + (yDist*yDist));  // diagonal distance

    // test for collision
    if (playerSize/2 + playerSize/2 > distance) {
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
    fill(#ff0000);
    ellipse(p1Xpos, p1Ypos, playerSize, playerSize);
  }
  if (p1Selection==2) {
    fill(#00ff00);
    rect(p1Xpos, p1Ypos, playerSize, playerSize);
  }
  if (p1Selection==3) {
    fill(#0000ff);
    triangle(p1Xpos, p1Ypos+playerSize, p1Xpos+(playerSize/2), p1Ypos, p1Xpos+playerSize, p1Ypos+playerSize);
  }
}

void player2() {
  if (p2Selection==1) {
    fill(#ff0000);
    ellipse(p2Xpos, p2Ypos, playerSize, playerSize);
  }

  if (p2Selection==2) {
    fill(#00ff00);
    rect(p2Xpos, p2Ypos, playerSize, playerSize);
  }

  if (p2Selection==3) {
    fill(#0000ff);
    triangle(p2Xpos, p2Ypos+playerSize, p2Xpos+(playerSize/2), p2Ypos, p2Xpos+playerSize, p2Ypos+playerSize);
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
  if ((p1Selected==true)&&(p2Selected==true)) {
    if ((key=='w') && (p1Ypos >= playerSize)) {
      p1Ypos -=playerSize;
    }

    if ((key=='s') && (p1Ypos < ((height-playerSize)-playerSize))) {
      p1Ypos += playerSize;
    }

    //keypress for bullet
    if ((key=='d') && (coolDownP1 == 0)) {
      // create bullet with state
      coolDownP1 = MAXCOOLDOWN;
      Bullet temp = new Bullet(playerSize, p1Ypos, p1Selection, 1);
      bullets.add(temp);
    }
  }

  // player2 movement & shooting
  if ((p1Selected==true)&&(p2Selected==true)) {
    if ((key=='i') && (p2Ypos >= playerSize)) {
      p2Ypos -=playerSize;
    }

    if ((key=='k') && (p2Ypos < ((height-playerSize)-playerSize))) {
      p2Ypos += playerSize;
    }

    //keypress for bullet
    if ((key=='j') && (coolDownP2 == 0)) {
      coolDownP2 = MAXCOOLDOWN;
      // create bullet with state
      Bullet temp = new Bullet(width-playerSize, p2Ypos, p2Selection, -1);
      bullets.add(temp);
    }
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

        float pX = (midpoint + (playerSize/2));
        float pY = (arr.get(j).y + (playerSize/2));

        for (int k = 0; k < 5; k++) {
          particles.add(new Particle(pX, pY));
        }

        // remove bullets
        arr.remove(j); // need to remove j first because it is larger than i always
        arr.remove(i);
      }
    }
  }
}

void renderParticles() {  //function to display particles
  for (int k = 0; k < particles.size (); k++) {
    Particle p = (Particle) particles.get(k);
    p.run();
    // p.gravity();
    p.display();
  }
}

class Particle {

  float x;
  float y;
  float xspeed;
  float yspeed;
  float life = MAX_FPS * 10 ;
  //  float pX;
  //  float pY;

  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    xspeed = random(-3, 3);
    yspeed = random(-3, 3);
  }

  void run() {
    if (life >0) { //to make particles stop moving
      life -= 1;

      if (x > width || x < 0) { //to bounce of walls
        xspeed*= -1;
      }
      if (y > height || y < 0) {
        yspeed*= -1;
      }

      x = x + xspeed;
      y = y + yspeed;
    }
  }

  void gravity() {
    yspeed += 0.1;
  }

  void display() {
    stroke(255);
    fill(255, 75);
    ellipse(x, y, 20, 20);
  }
}
