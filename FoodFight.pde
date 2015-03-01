/*
  TODOS:
  - 
  - 
*/

import gifAnimation.*;

ArrayList <Bullet0> bullets0;//where our bullets will be stored
ArrayList <Bullet1> bullets1;//where our bullets will be stored
ArrayList <Bullet2> bullets2;//where our bullets will be stored

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
  bullets0 = new ArrayList();
  bullets1 = new ArrayList();
  bullets2 = new ArrayList();
  
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
   
  removeToLimit0(10);//some other code that removes bullets if there are too many on screen
  moveAll0();//move all the bullets
  displayAll0();//display all the bullets
  
    removeToLimit1(10);//some other code that removes bullets if there are too many on screen
  moveAll1();//move all the bullets
  displayAll1();//display all the bullets
  
    removeToLimit2(10);//some other code that removes bullets if there are too many on screen
  moveAll2();//move all the bullets
  displayAll2();//display all the bullets
  
  player1();//display player1
}

//---------------------- Bullet codes
class Bullet0{ //bullet class
  float x;
  float y;
  float speed;
  Bullet0(float tx, float ty){
    x = tx;
    y = ty;
  }
  
void display0(){
    noStroke();
    fill(#ff0000);
  ellipse (x, y, 50, 50);
  }
  
  void move0(){
    x += 5;
  }
}

void removeToLimit0(int maxLength){ 
  while(bullets0.size() > maxLength){
    bullets0.remove(0);
  }
}

void moveAll0(){
  for(Bullet0 temp : bullets0){
    temp.move0();
  }
}

void displayAll0(){
  for(Bullet0 temp : bullets0){
    temp.display0();
  } 
} // Bullet0

class Bullet1{ //bullet class
  float x;
  float y;
  float speed;
  Bullet1(float tx, float ty){
    x = tx;
    y = ty;
  }
  
void display1(){
    noStroke();
    fill(#00ff00);
  ellipse (x, y, 50, 50);
  }
  
  void move1(){
    x += 5;
  }
}

void removeToLimit1(int maxLength){ 
  while(bullets1.size() > maxLength){
    bullets1.remove(0);
  }
}

void moveAll1(){
  for(Bullet1 temp : bullets1){
    temp.move1();
  }
}

void displayAll1(){
  for(Bullet1 temp : bullets1){
    temp.display1();
  } 
} //Bullet1

class Bullet2{ //bullet class
  float x;
  float y;
  float speed;
  Bullet2(float tx, float ty){
    x = tx;
    y = ty;
  }
  
void display2(){
    noStroke();
    fill(#0000ff);
  ellipse (x, y, 50, 50);
  }
  
  void move2(){
    x += 5;
  }
}

void removeToLimit2(int maxLength){ 
  while(bullets2.size() > maxLength){
    bullets2.remove(0);
  }
}

void moveAll2(){
  for(Bullet2 temp : bullets2){
    temp.move2();
  }
}

void displayAll2(){
  for(Bullet2 temp : bullets2){
    temp.display2();
  } 
} //Bullet2
//--------------------------- End of bullet 

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
  if ((key=='x') && (P1State == 0)){
    Bullet0 temp = new Bullet0(120,P1Ypos + playerSize/2);
    bullets0.add(temp);
  }
  
  if ((key=='x') && (P1State == 1)){
    Bullet1 temp = new Bullet1(120,P1Ypos + playerSize/2);
    bullets1.add(temp);
  }
  
  if ((key=='x') && (P1State == 2)){
    Bullet2 temp = new Bullet2(120,P1Ypos + playerSize/2);
    bullets2.add(temp);
  }
}
