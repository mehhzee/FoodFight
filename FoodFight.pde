import gifAnimation.*;

ArrayList <Bullet> bullets;//where our bullets will be stored Bullet (with the capital 'B' = class) & bullets = all the bullets 0,1,2..9,10.. the states
//Bullets bullets;

PImage[] P1;
PImage[] P2;

Gif player;

int playerSize = 100;

int P1State = 0;
int P2State = 0;

float[] P1X;
float[] P1Y;

float[] P1BulletX;
float[] P1BulletY;

int P1Ypos;


void setup() {
  size(1280,800);
  smooth();
  frameRate(60);
  bullets = new ArrayList();
//  bullets = new Bullets();
  
  P1X = new float[(width-playerSize)]; // only defines length of array but not values
  P1Y = new float[(height-playerSize)]; // same as above
  
  for (int i = 0; i < (width-playerSize); i++) {
    P1X[i] = i;
  } // fill P1X[width] with values
  
  for (int j = 0; j < (height-playerSize); j++) {
    P1Y[j] = j;
  } // fill P1Y[height] with values
  
  player = new Gif(this, "FoodFight_Test.gif");
  P1 = Gif.getPImages(this, "FoodFight_Test.gif");
  
  P1Ypos = 0;
}

void draw(){
  background(230);
  
//  bullets.removeToLimit(10);
  removeToLimit(bullets, 10); //not in bullet class, 'global' specify bullets into 'removeToLimit'
  
  moveAll(bullets);
  
  displayAll(bullets);
  
  player1();//display player1
}

//---------------------- Bullet codes

class Bullet {           //bullet class to one bullet
  float x;
  float y;
  float speed;
  color c;
  Bullet(float tx, float ty, int state){
    x = tx;
    y = ty;
    if (state == 0) {
      c = color(#ff0000);
    } else if (state == 1) {
      c = color(#00ff00);
    } else if (state == 2) {
      c = color(#0000ff);
    } else {
     c = color(0); 
    }
  }
  
  //don't need to allocate to type of bullet because they share same values
  
void display(){
    noStroke();
    fill(this.c);
    ellipse (x, y, 50, 50);
  }
  
  void move(){
    x += 5;
  }
}               // end of bullet class

//class Bullets {
//   ArrayList<Bullet> data;
//   int maxSize = 10;
//   Bullet() {
//     data = new ArrayList();
//   } 
//   
//   void removeToLimit(int maxLength) {
//     while(this.data.size() > maxLength){
//        this.data.remove(0);
//     }
//   }
//}

// input arrraylist<Bullet> to removeToLimit named 'arr' to parameters

// instead of using the global variables(e.g. bullets0, bullets1), we take an input parameter(i.e. arr)
// so that this function can be used with different arrays, instead of a unique function for 
// each global array
void removeToLimit(ArrayList<Bullet> arr, int maxLength) {
   while(arr.size() > maxLength){
      arr.remove(0);
  }
}

void moveAll(ArrayList<Bullet> arr){
  for(Bullet temp : arr){
    temp.move();
  }
}

void displayAll(ArrayList<Bullet> arr){
  for(Bullet temp : arr){
    temp.display();
  } 
} 

void player1() {
  image(P1[P1State], P1X[0], P1Y[P1Ypos], playerSize, playerSize);
}


void keyPressed(){
  if ((key=='d') && (P1State < 2)){
    P1State += 1;
    println(P1State);
  }
  
  if ((key=='a') && (P1State > 0)){
    P1State -= 1;
    println(P1State);
  }
  
  if ((key=='w') && (P1Ypos >= playerSize)){
    P1Ypos -=playerSize;
  }
  
  if ((key=='s') && (P1Ypos < ((height-playerSize)-playerSize))){
    P1Ypos += playerSize;
  }
  
  //keypress for bullet
  if (key=='x'){
    // create bullet with state
    Bullet temp = new Bullet(120, P1Ypos + playerSize/2, P1State);
    bullets.add(temp);
  }
}
