import processing.sound.*;

PVector last;
float r = 450;

FFT fft;
int bands = 512;
float[] spectrum = new float[bands];
float[] spectrumSmoothed;

SoundFile[] file;
Amplitude[] amp;
int numsounds = 26;
float snareSmoothed;
float kick1Smoothed;
float kick2Smoothed;
float kick2Smoothed2;
float keySmoothed;
float keySmoothed2;
float padSmoothed;
float ambpadSmoothed;
float voxSmoothed;
float splashSmoothed;



/* ----------- */

//call files, analyze them, play them 
void setup(){
  size(800,800,FX2D);
  
  fft = new FFT(this,bands);
  
  file = new SoundFile[numsounds];
  amp = new Amplitude[numsounds];
  for (int i = 0; i < numsounds; i++) {
    file[i] = new SoundFile(this, (i+1) + ".wav");
    amp[i] = new Amplitude(this);
    amp[i].input(file[i]);
  }
  
  for (int i = 0; i < numsounds; i++) {
    file[i].play();
  } 
  
  fft.input(file[23]);
}

/* ----------- */

void draw()  {
  background(0,0,0);
  
  if(amp[14].analyze() > 0.15){
  splashSmoothed = splashSmoothed * 0.8 + amp[14].analyze()*0.2;  
  background(0,0,splashSmoothed*115);
  }
  if(amp[15].analyze() > 0.025){
  background(amp[15].analyze()*1000);
  }
  
  //start CENTER CIRCLE 1
   kick2Smoothed = kick2Smoothed * 0.99 + amp[1].analyze()*0.15;
   kick2Smoothed2 = kick2Smoothed2 * 0.90 + amp[1].analyze()*0.1;
   padSmoothed = padSmoothed * 0.93 + amp[4].analyze()*0.1;
   noFill();
   stroke(0,0,150,padSmoothed*1500);
   strokeWeight(4+padSmoothed*100);
   pushMatrix();
   translate(width/2,height/2);
   rotate(frameCount/200.0);
   polygon(0,0,150+400*kick2Smoothed,25);
   popMatrix();
   
   //start CENTER CIRCLE 2(end)
   noFill();
   ambpadSmoothed = ambpadSmoothed * 0.90 + amp[6].analyze()*0.1;
   stroke(200,0,100,ambpadSmoothed*1500);
   strokeWeight(4+ambpadSmoothed*100);
   pushMatrix();
   translate(width/2,height/2);
   rotate(frameCount/200.0);
   polygon(0,0,150+400*ambpadSmoothed,25);
   popMatrix();
  
  
  //start PERIOD
  pushMatrix();
  keySmoothed = keySmoothed * 0.90 + amp[3].analyze()*0.1;
  keySmoothed2 = keySmoothed2 * 0.97 + amp[3].analyze()*0.1;
  stroke(255,keySmoothed*175);
  if(amp[15].analyze() > 0.06){
  splashSmoothed = splashSmoothed * 0.9 + amp[15].analyze()*0.1;  
  stroke(255-splashSmoothed*1000);
  }
  strokeWeight(2+100*keySmoothed2);
  translate(width/2, height/2);
  float inc = TWO_PI / width;
  float x, y, x1, y1, x2, y2;
  float lerpFrac = 0.5 * (1 + sin(radians(frameCount * 0.7)));
  for (int i = 0; i < width; i++) {
    x1 = i - width/2;
    y1 = height/2 * sin(i * inc + radians(frameCount));
    x2 = i - width/2;
    y2 = x2 * x2 / (width/2);
    //x2 = r * cos(i * inc);
    //y2 = r * sin(i * inc);
    x = lerp(x1, x2, lerpFrac);
    y = lerp(y1, y2, lerpFrac);
    if (last != null) {
      line(x, y, last.x, last.y);
    }
    last = new PVector(x, y);
  }
  last = null;
  popMatrix();
  
  
   

  //start VOCAL CIRCLE FFT
   if(millis() < 144000){
   pushMatrix();
   strokeWeight(2+ voxSmoothed*7);
   fft.analyze(spectrum);
   float[] spectrum2 = fft.analyze(spectrum);
   translate(width/2,height/2);
   rotate(frameCount/200.0);
  
  for(int i = 0; i < bands; i++){
    voxSmoothed = voxSmoothed * 0.70 + amp[23].analyze() * 0.3;
    float mr = 150 + 400*kick2Smoothed; //+ voxSmoothed * 100;
    stroke(0,10,150,10+voxSmoothed*500);
    float[] spectrumSmoothed = new float[bands]; 
    spectrumSmoothed[i] = spectrum2[i]*1000000; 
    float angle = map(i,0,bands,0,360);
    float ampl = spectrum2[i];
    //if(spectrumSmoothed[i] > 20000){
    //spectrumSmoothed[i] = 9000;
    //}
    float r = map(ampl, 0, bands, mr, spectrumSmoothed[i]);
    float e = r * cos(angle);
    float f = r * sin(angle);
    float r2 = map(ampl,0,bands,mr,mr);
    float c = r2 * cos(angle);
    float d = r2 * sin(angle);
    //setup some kind of moving x,y point that traces the circumference of a circle
    line(c,d,e,f);
    } 
  popMatrix();
   }
 
   
   
  //start STATIC NOISE 3?
   if(amp[6].analyze() > 0.07) {
     noStroke();
     fill(255);
     circle(random(800),random(800),7); 
   }
   //start COLORED STATIC
   /*
   if(amp[5].analyze() > 0.06) {
     noStroke();
     fill(random(255),10,random(100,255));
     circle(random(50,750),random(50,750),5+amp[5].analyze()*100); 
   }
   */
   
   
   //start HEXAGONS
   for(int i = 0; i <  20; i++){
    float xorig = 400;
    float yorig = 400;
    float radius = 100 + i * 10;
    float angle = millis()/50 * map(i, 0 , 20, 0.05, 0.1);
    float a = xorig + radius * cos(angle*1.3);
    float b = yorig + radius  * sin(angle);
    
    noFill();
    snareSmoothed = 0.99*snareSmoothed + amp[2].analyze()*0.01;
    stroke(snareSmoothed*1500, i*20, 200-snareSmoothed*100);
    kick1Smoothed = 0.96*kick1Smoothed + amp[0].analyze()*0.04;
    strokeWeight(4 + (kick1Smoothed * 100));
    
    polygon(a, b, i*5, 6);  // Hexagon    
    
    
    //println(spectrum);
    //println(amp[15].analyze());
    //println(frameRate);
   }
   
  
  //saveFrame("output/wave-viz_#####.png");
  rec();
  println(frameRate);
} //end draw(){}




/*-------*/

//Polygon Function
void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
