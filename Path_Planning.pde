

import processing.opengl.*;
import processing.core.*;
import processing.video.*;
import peasy.*;

PeasyCam cam; 
PFont font;
int x=70;
int y=-400;
int sizeX, sizeY ;
int gridSizeX, gridSizeY;  
PVector start,goal,obs;
PVector lambda,temp,temp2;
PVector y1,y2,x1,x2,r,norm,G;
PVector[] objects = new PVector[5];
boolean flag;
Grid grid;


boolean RESET = false;

void setup(){
  if(! RESET){
    //size(800, 600, OPENGL);
    size(800, 800, P3D); 
    sizeX = width; sizeY = height;
    gridSizeX = int((sizeX)) ;
    gridSizeY = int((sizeY));
    //------------------------------------------------------------------------------------------

    
    
    // initialize camera ---> needed library: import peasy.*;
    cam = new PeasyCam(this, sizeX/2 , sizeY/2, 0, 1000);  // default settings on double click
    cam.setMinimumDistance(.001);
    cam.setMaximumDistance(50000);
    cam.setRotations( -0.4301672, -0.274728, 0.30156484); 
  } // end if(! RESET)
  
  //------------------------------------------------------------------------------------------
  // initialize Grid
  int res = 5;
  int gridPointsX = gridSizeX / res;
  int gridPointsY = gridSizeY / res;
  grid = new Grid(gridPointsX, gridPointsY);
  float s = 1; // scale Grid
  for(int i = 0; i < gridPointsY; i++){
    for(int j = 0; j < gridPointsX; j++){
      int index = i*gridPointsX + j;
      float x = j * res * s + (sizeX - gridSizeX*s) / 2;
      float y = i * res * s + (sizeY - gridSizeY*s) / 2;
      float z = 0;
      grid.setGridPoint(index, x, y, z);
    } // end for j
  } // end for i
 
  int border = 0;
  //------------------------------------------------------------------------------------------ 
  
  //------------------------------------------------------------------------------------------
   start = new PVector(0,10);
   goal = new PVector(800,800);
   //obs = new PVector(400,400);
   flag=false;
   objects[0] = new PVector(400,400);
   objects[1] = new PVector(650,550);
   objects[2] = new PVector(450,600);
   objects[3] = new PVector(190,330);
   objects[4] = new PVector(500,200);
   //obs=objects[1];
   lambda = new PVector(3,3);
   G = new PVector();

 // println(start.dist(goal));  // Prints "78.10249"
    //temp2=PVector.sub(start,lambda);
   //println(temp2);  // Prints "78.10249"
  frameRate(60);
} // end void setup
  


void draw(){
  //println(frameRate);
  background(0); noLights();
  grid.drawGrid();
  lights();
  noStroke();
  drawAllCylinders();
  if ((start.x>goal.x+1 || start.x>goal.x-1) && (start.y>goal.y+1 || start.y>goal.y-1)){
  flag=true;
  println("okkkk");
  }
  if(!flag){
  //drawline((int)start.x,(int)start.y);
  temp=grad(start,goal,obs);
  println(start);
  temp2=PVector.mult(temp,5);
  start=PVector.sub(start,(temp2));}
  translate(start.x,start.y,10);
  fill(100, 100, 255);
  box(20, 20, 20);
  
 
  //println(start);
     
   delay(10);
} // end void draw


void keyReleased(){
  if(key == 't'){
  }  
  if(key == 'r') {
    RESET = true;
    setup();
  }
} // end void keyReleased()


void drawCylinder(float topRadius, float bottomRadius, float tall, int sides) {
  float angle = 0;
  float angleIncrement = TWO_PI / sides;
  beginShape(QUAD_STRIP);
  for (int i = 0; i < sides + 1; ++i) {
    vertex(topRadius*cos(angle), 0, topRadius*sin(angle));
    vertex(bottomRadius*cos(angle), tall, bottomRadius*sin(angle));
    angle += angleIncrement;
  }
  endShape();
  
  // If it is not a cone, draw the circular top cap
  if (topRadius != 0) {
    angle = 0;
    beginShape(TRIANGLE_FAN);
    // Center point
    vertex(0, 0, 0);
    for (int i = 0; i < sides + 1; i++) {
      vertex(topRadius * cos(angle), 0, topRadius * sin(angle));
      angle += angleIncrement;
    }
    endShape();
  }

  // If it is not a cone, draw the circular bottom cap
  if (bottomRadius != 0) {
    angle = 0;
    beginShape(TRIANGLE_FAN);    
    // Center point
    vertex(0, tall, 0);
    for (int i = 0; i < sides + 1; i++) {
      vertex(bottomRadius * cos(angle), tall, bottomRadius * sin(angle));
      angle += angleIncrement;
    }
    endShape();
  }
}


void drawAllCylinders()
{
  fill(255, 100, 255); 
 
  pushMatrix();
  translate(190,330,0);
  rotateX(PI/2);
  drawCylinder(40, 40, 120, 64); // Draw a cylinder
  popMatrix();
  
  pushMatrix();
  translate(400,400,0);
  rotateX(PI/2);
  drawCylinder(40, 40, 120, 64); // Draw a cylinder
  popMatrix();
  
  
  pushMatrix();
  translate(650,550,0);
  rotateX(PI/2);
  drawCylinder(40, 40, 120, 64); // Draw a cylinder
  popMatrix();
  
  
  pushMatrix();
  translate(450,600,0);
  rotateX(PI/2);
  drawCylinder(40, 40, 120, 64); // Draw a cylinder
  popMatrix();

  pushMatrix();
  translate(500,200,0);
  rotateX(PI/2);
  drawCylinder(40, 40, 120, 64); // Draw a cylinder
  popMatrix();  
  
 
}

void drawline(int x,int y)
{
  pushMatrix();
  noStroke();
  //lights();
  translate(x, y, 0);
  sphere(10);
  popMatrix(); 
}


PVector grad(PVector p,PVector q,PVector o){
  y1 =new PVector(p.x,p.y+1);
  y2 =new PVector(p.x,p.y-1); 
  x1 =new PVector(p.x+1,p.y); 
  x2 =new PVector(p.x-1,p.y);
  //Calculate the components of the gradient vector
  float cx = Cpathplan( x1, q, o ) - Cpathplan( x2, q, o ); 
  float cy = Cpathplan( y1, q, o ) - Cpathplan( y2, q, o ); 
  //Resultant vector formed by cost's x and y components
  
  r = new PVector(cx,cy); 
  //println(r);
  //Calculate the direction vector, i.e., direction of the gradient vector
  float norm = sqrt(pow(r.x,2)+pow(r.y,2));
  G = new PVector();
  PVector.div(r,norm,G); 
  //println(G);
  return G;
}

float Cpathplan(PVector p,PVector q,PVector o){
 double c1=PVector.dist(p,q)*0.02;
 double c2=0;
 double temp=0;
  for (int i = 0; i < 5; i++) { 
     float d=PVector.dist(p,objects[i]);
     
     if (d>150) {
        temp=0;
     }  
     else if(d<=150 && d>0){
        temp=log(150/d); 
        //println("now");
     }
     c2=c2+temp;
  }
 return (float)(c1+c2);
}



