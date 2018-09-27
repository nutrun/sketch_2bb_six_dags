Visual[] visuals = new Visual[] {
  new InAndOut(), 
  new BoardsInLine(),
  new BezierLissajus(),
  new WanderingInSpace(),
  new Wiggle(), 
  new WavesOnSphere(),
  new TriangleTimesTriangle(),
  new Kolam(),
  new MemorySnake(), 
  new ColorSmoke(), 
  new PerlinNoise(), 
  new SpiroRose(), 
  new FoliageScroll(),   
  new SurfsUpBlue(), 
  new DeformedLines(), 
  new PerlinRainbow()
};

int visualIndex = 0;
PImage pointer = createImage(2,2,RGB);
Visual visual = visuals[0];

void setup() {
  fullScreen();
  // Try and restore defaults.
  translate(width, height);
  strokeWeight(1);
  colorMode(RGB, 255);
  rectMode(CORNER);
  
  // setup a subtle pointer
  pointer.loadPixels();
  for (int i = 0; i < pointer.pixels.length; i++) {
    pointer.pixels[i] = color(127,127,127); 
  }
  cursor(pointer);
  
  visual.setup();
}

void draw() {
  visual.draw();
}

void mousePressed() {
  visual.mousePressed();
}

void mouseReleased() {
  visual.mouseReleased();
}

// Circle around the visuals with the arrow keys.
void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      if (visualIndex == 0) {
        visualIndex = visuals.length - 1;
      } else {
        visualIndex--;
      }
      visual = visuals[visualIndex];
      setup();
    } else if (keyCode == RIGHT) {
      if (visualIndex == visuals.length - 1) {
        visualIndex = 0;
      } else {
        visualIndex++;
      }
      visual = visuals[visualIndex];
      setup();
    }
  }
}

abstract class Visual {
  abstract void setup();
  abstract void draw();
  abstract void mousePressed();
  abstract void mouseReleased();
}

// Black and white

//https://www.openprocessing.org/sketch/434617
class InAndOut extends Visual {
  float t=0.001;
  void setup()
  {
    strokeWeight(3);
    stroke(0);
  }
  
  void draw()
  {
    background(240);
    harom(1000, 920, 40, 460, 6, (sin(0.0005*millis()%(2*PI))+1)/2);
  }

  void harom(float ax, float ay, float bx, float by, int level, float ratio)
  {
    if (level!=0) {
      float vx, vy, nx, ny, cx, cy;
      vx=bx-ax;
      vy=by-ay;
      nx=cos(PI/3)*vx-sin(PI/3)*vy; 
      ny=sin(PI/3)*vx+cos(PI/3)*vy; 
      cx=ax+nx;
      cy=ay+ny;
      line(ax, ay, bx, by);
      line(ax, ay, cx, cy);
      line(cx, cy, bx, by);
      harom(ax*ratio+cx*(1-ratio), ay*ratio+cy*(1-ratio), ax*(1-ratio)+bx*ratio, ay*(1-ratio)+by*ratio, level-1, ratio);
    }
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }
}

//https://www.openprocessing.org/sketch/400636
class BoardsInLine extends Visual {
  /**
   * boards in line
   *
   * @author aadebdeb
   * @date 2017/01/26
   */

  void setup() {
    rectMode(CENTER);
    fill(255);
    stroke(0);
    strokeWeight(4);
  }

  void draw() {
    background(0);
    translate(width / 2, height / 2);
    int num = 10;
    float intervalX = map(mouseX, 0, width, 40, -40);
    float intervalY = map(abs(mouseX - width / 2), 0, width / 2, 0, -20);
    float rectX = 100;
    float rectY = 200;
    float tilt = map(mouseX, 0, width, -20, 20);
    for (int i = num - 1; i > 0; i--) {
      pushMatrix();
      float rhytm = map(pow(abs(sin(frameCount * 0.03 - i * 0.3)), 50), 0, 1, 0, -50)
        * map(abs(mouseX - width / 2), 0, width / 2, 0, 1);
      translate(intervalX * (i - num / 2.0), intervalY * (i - num / 2.0) + rhytm);
      beginShape();
      vertex(-rectX / 2.0, -rectY / 2.0 + tilt);
      vertex(rectX / 2.0, -rectY / 2.0 - tilt);
      vertex(rectX / 2.0, rectY / 2.0 - tilt);
      vertex(-rectX / 2.0, rectY / 2.0 + tilt);
      endShape(CLOSE);
      popMatrix();
    }
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }
}

//https://www.openprocessing.org/sketch/445137
class BezierLissajus extends Visual {
  // Forked from Lali Barriere (openprocessing user 1075). Not my original work.
  float  xA, yA, xB, yB, x1, y1, x2, y2;

  float sx, sy;

  float angle;
  float speed;
  float radi;

  float c, s;

  void setup() {
    background(255);
    smooth();

    sx = random(5.0);
    sy = random(5.0);

    angle = 0.0;
    speed = 0.01;
    radi = 300.0;
    xA = 20;
    yA = height/2;
    xB = width-20;
    yB = height/2;
  }

  void draw() {

    // dues corbes de lissajus serveixen de punts de control
    c = cos(angle);
    s = sin(angle/sy);
    // c=0;s=0;

    x1 = width/3+c*radi;
    y1 = height/2+s*radi;

    x2 = 2*width/3 + cos(angle/sx)*radi;
    y2 = height/2 + sin(angle)*radi;
    //  y2 = y1 + tan(angle*sy)*radi;

    // pintem la corba de bezier
    noFill();
    stroke(0, 10);
    bezier(xA, yA, x1, y1, x2, y2, xB, yB);

    // fem un pas
    angle+=speed;
  }

  void neteja() {
    background(255);
  }

  void keyPressed() {
    switch(key) {
      case('1'):
      neteja();
      sx=5.0;
      sy=random(1);
      break;
      case('2'):
      neteja();
      sx=random(1);
      sy=2.0;
      break;
    default:
      neteja();
      sx = random(5.0);
      sy=random(5.0);
    }
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }
}

// https://www.openprocessing.org/sketch/299679
class Wiggle extends Visual {
  int cols = 10, rows = cols, w, h, frms = 120;
  Square[] squares = new Square[rows*cols];
  float theta;
  PVector v;

  void setup() {
    w = width/cols;
    h = height/rows;
    int i=0;
    for (int x=0; x<rows; x++) {
      for (int y=0; y<cols; y++) {
        squares[i] = new Square(x*w, y*h);
        i++;
      }
    }
  }

  void draw() {
    randomSeed(1234);
    background(255);
    v = new PVector(width/2+sin(theta)*200, height/2+cos(theta)*200);
    for (int i=0; i<cols*rows; i++) {
      squares[i].update();
      squares[i].display();
    }
    theta += TWO_PI/frms;
  }

  class Square {
    PGraphics square;
    float x, y;

    Square(float _x, float _y) {
      x = _x;
      y = _y;
      square = createGraphics(w, h);
    }

    void update() {
      float distance = dist(v.x, v.y, x+w/2, y+h/2);
      float r = map(distance, 0, sqrt(sq(width/2)+sq(height/2)), 0, HALF_PI);
      square.beginDraw();
      square.rectMode(CENTER);
      square.background(255);
      square.pushMatrix();
      square.translate(w/2, h/2);
      square.rotate(r);
      square.fill(0);
      square.rect(0, 0, 200, h/2);
      square.popMatrix();
      square.endDraw();
    }

    void display() {
      image(square, x, y);
    }
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }
}

// https://www.openprocessing.org/sketch/492680
class WanderingInSpace extends Visual {
  Particle[] p = new Particle[800];
  int diagonal;
  float rotation = 0;

  void setup() {
    for (int i = 0; i<p.length; i++) {
      p[i] = new Particle();
      p[i].o = random(1, random(1, width/p[i].n));
    }
    diagonal = (int)sqrt(width*width + height * height)/2;
    background(0);
    noStroke();
    fill(255);
    frameRate(30);
  }

  void draw() {
    if (!mousePressed) {
      background(0);
    }

    translate(width/2, height/2);
    rotation-=0.002;
    rotate(rotation);

    for (int i = 0; i<p.length; i++) {
      p[i].draw();
      if (p[i].drawDist()>diagonal) {
        p[i] = new Particle();
      }
    }
  }

  class Particle {
    float n;
    float r;
    float o;
    int l;
    Particle() {
      l = 1;
      n = random(1, width/2);
      r = random(0, TWO_PI);
      o = random(1, random(1, width/n));
    }

    void draw() {
      l++;
      pushMatrix();
      rotate(r);
      translate(drawDist(), 0);
      fill(255, min(l, 255));
      ellipse(0, 0, width/o/8, width/o/8);
      popMatrix();

      o-=0.07;
    }

    float drawDist() {
      return atan(n/o)*width/HALF_PI;
    }
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }
}

// https://www.openprocessing.org/sketch/402629
class WavesOnSphere extends Visual {
  int Nmax = 1000 ; 
  float M = 50 ; 
  float H = 0.99 ; 
  float HH = 0.01 ;

  float X[] = new float[Nmax+1] ; 
  float Y[] = new float[Nmax+1] ; 
  float Z[] = new float[Nmax+1] ;
  float V[] = new float[Nmax+1] ; 
  float dV[] = new float[Nmax+1] ; 
  float L ; 
  float R = 2*sqrt((4*PI*(200*200)/Nmax)/(2*sqrt(3))) ;
  float Lmin ; 
  int N ; 
  int NN ; 
  float KX ; 
  float KY ; 
  float KZ ; 
  float KV ; 
  float KdV ; 
  int K ;

  void setup() {
    background(0, 0, 0) ;
    strokeWeight(0.75);
    noSmooth() ;
    stroke(255, 255, 255) ;
    fill(50, 50, 50) ;

    for ( N = 0; N <= Nmax; N++ ) {
      X[N] = random(-300, +300) ;
      Y[N] = random(-300, +300) ;
      Z[N] = random(-300, +300) ;
    }
  }

  void draw() {
    background(0, 0, 0) ;

    for ( N = 0; N <= Nmax; N++ ) {
      for ( NN = N+1; NN <= Nmax; NN++ ) {
        L = sqrt(((X[N]-X[NN])*(X[N]-X[NN]))+((Y[N]-Y[NN])*(Y[N]-Y[NN]))) ;
        L = sqrt(((Z[N]-Z[NN])*(Z[N]-Z[NN]))+(L*L)) ;
        if ( L < R ) {
          X[N] = X[N] - ((X[NN]-X[N])*((R-L)/(2*L))) ;
          Y[N] = Y[N] - ((Y[NN]-Y[N])*((R-L)/(2*L))) ;
          Z[N] = Z[N] - ((Z[NN]-Z[N])*((R-L)/(2*L))) ;
          X[NN] = X[NN] + ((X[NN]-X[N])*((R-L)/(2*L))) ;
          Y[NN] = Y[NN] + ((Y[NN]-Y[N])*((R-L)/(2*L))) ;
          Z[NN] = Z[NN] + ((Z[NN]-Z[N])*((R-L)/(2*L))) ;
          dV[N] = dV[N] + ((V[NN]-V[N])/M) ;
          dV[NN] = dV[NN] - ((V[NN]-V[N])/M) ;
          stroke(125+(Z[N]/2), 125+(Z[N]/2), 125+(Z[N]/2)) ; 
          line(X[N]*1.2*(200+V[N])/200+300, Y[N]*1.2*(200+V[N])/200+300, X[NN]*1.2*(200+V[NN])/200+300, Y[NN]*1.2*(200+V[NN])/200+300) ;
        }
        if ( Z[N] > Z[NN] ) {
          KX = X[N] ; 
          KY = Y[N] ; 
          KZ = Z[N] ; 
          KV = V[N] ; 
          KdV = dV[N] ; 
          X[N] = X[NN] ; 
          Y[N] = Y[NN] ; 
          Z[N] = Z[NN] ; 
          V[N] = V[NN] ; 
          dV[N] = dV[NN] ;  
          X[NN] = KX ; 
          Y[NN] = KY ; 
          Z[NN] = KZ ; 
          V[NN] = KV ; 
          dV[NN] = KdV ;
        }
      }
      L = sqrt((X[N]*X[N])+(Y[N]*Y[N])) ;
      L = sqrt((Z[N]*Z[N])+(L*L)) ;
      X[N] = X[N] + (X[N]*(200-L)/(2*L)) ;
      Y[N] = Y[N] + (Y[N]*(200-L)/(2*L)) ;
      Z[N] = Z[N] + (Z[N]*(200-L)/(2*L)) ;
      KZ = Z[N] ; 
      KX = X[N] ;
      Z[N] = (KZ*cos(float(300-mouseX)/10000))-(KX*sin(float(300-mouseX)/10000)) ;
      X[N] = (KZ*sin(float(300-mouseX)/10000))+(KX*cos(float(300-mouseX)/10000)) ;
      KZ = Z[N] ; 
      KY = Y[N] ;
      Z[N] = (KZ*cos(float(300-mouseY)/10000))-(KY*sin(float(300-mouseY)/10000)) ;
      Y[N] = (KZ*sin(float(300-mouseY)/10000))+(KY*cos(float(300-mouseY)/10000)) ;
      dV[N] = dV[N] - (V[N]*HH) ; 
      V[N] = V[N] + dV[N] ; 
      dV[N] = dV[N] * H ;
    }
  }

  void mousePressed() {
    Lmin = 600 ; 
    NN = 0 ;
    for ( N = 0; N <= Nmax; N++ ) {
      L = sqrt(((mouseX-(300+X[N]))*(mouseX-(300+X[N])))+((mouseY-(300+Y[N]))*(mouseY-(300+Y[N])))) ;
      if ( Z[N] > 0 && L < Lmin ) { 
        NN = N ; 
        Lmin = L ;
      }
    }

    if ( K == 0 ) { 
      dV[NN] = -200 ; 
      K = 1 ;
    } else { 
      dV[NN] = +200 ; 
      K = 0 ;
    }
  }

  void mouseReleased() {
  }
}

// Color

// https://www.openprocessing.org/sketch/492286
class MemorySnake extends Visual {
  int size = 512;
  int siz = size-1;

  float tension = 0.5;
  float sympathy = 0.05;
  float damp = 0.999;

  int draggedNode = -1;

  color[] colorray = new color[16];

  float[] px = new float[size];
  float[] py = new float[size];
  float[] vx = new float[size];
  float[] vy = new float[size];
  float[] ax = new float[size];
  float[] ay = new float[size];

  void setup() {
    ellipseMode(RADIUS);
    fill(255, 128);

    for (int i = 1; i < siz; i++) {
      px[i] = width * i / size;
      py[i] = height/2 + randomGaussian() * 16;
    }

    px[0] = 16;
    py[0] = height/2;
    px[siz] = width - 64;
    py[siz] = height/2;

    changeColors();
  }

  void draw() {
    for (int i = 1; i < siz; i++) {
      ax[i] = (px[i-1] + px[i+1] - px[i] - px[i]) * tension + (vx[i-1] + vx[i+1] - vx[i] - vx[i]) * sympathy;
      ay[i] = (py[i-1] + py[i+1] - py[i] - py[i]) * tension + (vy[i-1] + vy[i+1] - vy[i] - vy[i]) * sympathy;
    }

    for (int i = 1; i < siz; i++) {
      vx[i] = vx[i] * damp + ax[i];
      vy[i] = vy[i] * damp + ay[i];
      px[i] += vx[i];
      py[i] += vy[i];
    }

    if (draggedNode != -1) {
      px[draggedNode] = mouseX;
      py[draggedNode] = mouseY;
    }


    background(32);
    noStroke();

    ellipse(px[0], py[0], 16, 16);
    ellipse(px[siz], py[siz], 16, 16);


    for (int i = 1; i < colorray.length + 1; i++) {
      stroke(colorray[i-1]);

      for (int node = 0; node < size-i; node++) {
        line(px[node], py[node], px[node+i], py[node+i]);
      }
    }
  }

  void mousePressed() {
    changeColors();

    draggedNode = -1;

    if (abs(mouseX - px[0]) < 16    &&    abs(mouseY - py[0]) < 16) {
      draggedNode = 0;
    } else if (abs(mouseX - px[siz]) < 16    &&    abs(mouseY - py[siz]) < 16) {
      draggedNode = siz;
    }
  }

  void mouseReleased() {
    draggedNode = -1;
  }

  void changeColors() {
    float r = random(256);
    float g = random(256);
    float b = random(256);  

    for (int i = 0; i < colorray.length; i++) {
      colorray[i] = color(r + gauss(64), g + gauss(64), b + gauss(64), 128);
    }
  }

  float gauss(float n) {
    return randomGaussian() * n;
  }
}

// https://www.openprocessing.org/sketch/498435
class ColorSmoke extends Visual {
  int size = 1024;
  int siz = size-1;
  int si = size-2;

  float halfWidth, halfHeight;

  float r = 192, g = 192, b = 192;
  float vr, vg, vb;

  float tension = 0.5;
  float sympathy = 0.25;

  float[] px = new float[size];
  float[] py = new float[size];
  float[] vx = new float[size];
  float[] vy = new float[size];
  float[] ax = new float[size];
  float[] ay = new float[size];

  void setup() {
    background(0);
    noFill();
    strokeWeight(0.05);

    halfWidth = width/2;
    halfHeight = height/2;

    for (int i = 0; i < size; i++) {
      float angle = TAU * i / size;
      px[i] = halfWidth + cos(angle) * halfHeight;
      py[i] = halfHeight + sin(angle) * halfHeight;
    }
  }

  void draw() {
    for (int i = 1; i < siz; i++) {
      ax[i] = (px[i-1] + px[i+1] - px[i] - px[i]) * tension + (vx[i-1] + vx[i+1] - vx[i] - vx[i]) * sympathy;
      ay[i] = (py[i-1] + py[i+1] - py[i] - py[i]) * tension + (vy[i-1] + vy[i+1] - vy[i] - vy[i]) * sympathy;
    }

    ax[0] = (px[siz] + px[1] - px[0] - px[0]) * tension + (vx[siz] + vx[1] - vx[0] - vx[0]) * sympathy;
    ay[0] = (py[siz] + py[1] - py[0] - py[0]) * tension + (vy[siz] + vy[1] - vy[0] - vy[0]) * sympathy;

    ax[siz] = (px[si] + px[0] - px[siz] - px[siz]) * tension + (vx[si] + vx[0] - vx[siz] - vx[siz]) * sympathy;
    ay[siz] = (py[si] + py[0] - py[siz] - py[siz]) * tension + (vy[si] + vy[0] - vy[siz] - vy[siz]) * sympathy;

    int randomNode = int(random(size));
    ax[randomNode] = (halfWidth - px[randomNode]) * 0.001 + randomGaussian() * 5;
    ay[randomNode] = (halfHeight - py[randomNode]) * 0.001 + randomGaussian() * 5;

    for (int i = 0; i < size; i++) {
      vx[i] += ax[i];
      vy[i] += ay[i];
      px[i] += vx[i];
      py[i] += vy[i];
      px[i] = constrain(px[i], 0, width);
      py[i] = constrain(py[i], 0, height);
    }

    vr = vr * 0.995 + randomGaussian() * 0.04;
    vg = vg * 0.995 + randomGaussian() * 0.04;
    vb = vb * 0.995 + randomGaussian() * 0.04;

    r += vr;
    g += vg;
    b += vb;

    if ((r < 128 && vr < 0) || (r > 255 && vr > 0))    vr = -vr;
    if ((g < 128 && vg < 0) || (g > 255 && vg > 0))    vg = -vg;
    if ((b < 128 && vb < 0) || (b > 255 && vb > 0))    vb = -vb;

    stroke(r, g, b);

    beginShape();
    for (int i = 0; i < size; i++) {
      vertex(px[i], py[i]);
    }
    endShape();
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }
}

// https://www.openprocessing.org/sketch/576489
class PerlinNoise extends Visual {
  void setup() {
    background(0);
  }

  int ofs =0;
  int ofs_v =1;

  void draw() {
    translate(0, -200);
    ofs+=ofs_v;
    if ((ofs==offset) || (ofs==0))
    {
      ofs_v=0-ofs_v;
    }

    strokeWeight(6);
    drawLine(212+ofs, #DB028C, #FFAE34);
    drawLine(215+ofs, #FF6A7E, #FFFA6A);//color
    strokeWeight(1);
    drawLine(210+ofs, 100, 100);
  }

  int step = 80;
  float noiseScale = 0.02;
  int offset = 300;


  void drawLine(int y0, color to, color from) {

    fill(255, 4);
    beginShape();
    curveVertex(-50, y0);
    for (int i =0; i<width/step+3; i+=1) {
      float noiseVal = noise(i*noiseScale*(y0*0.06), frameCount*noiseScale); 
      stroke(lerpColor(from, to, noiseVal));
      curveVertex(i*step-10, y0+noiseVal*offset);
    }
    curveVertex(width+10, height+200);
    curveVertex(0, height+210);
    curveVertex(0, height+210);
    endShape();
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }
}

// https://www.openprocessing.org/sketch/567151
class TriangleTimesTriangle extends Visual {
  void setup() {
    noFill();
    noStroke();
    // TODO: this line breaks the colors
    colorMode(HSB, 100);
  }

  float boxWidth = 900;
  float boxHeight= 750;
  float divisions = 0.9;
  float colour = 1;

  void draw() {
    background(0, 0, 90);
    for (float i = 0; i < divisions; i++) {
      for (float j = 0; j <= i; j++) {
        float boxWidth2 = boxWidth - (boxWidth/divisions) * i;
        float boxHeight2 = boxHeight - (boxHeight/divisions) * i;
        float x = width/2  - (boxWidth/divisions/2)*i + j*(boxWidth/divisions);
        float y = height/2 + (boxHeight/divisions/2)*i;
        fill(colour, 100, 20, 10);
        triangle(x, y - boxHeight2/2, x - boxWidth2/2, y + boxHeight2/2, x + boxWidth2/2, y + boxHeight2/2);
      }
    }
    colour += 0.5;
    if (colour >= 100) {
      colour = 0;
    }
    divisions += 0.02;
    if (divisions >= 8) {
      divisions = 8;
    }
    noise();
  }

  void noise() {
    noStroke();
    strokeWeight(1);
    for (int i = 0; i < width - 1; i += 5) {
      for (int j = 0; j < height - 1; j += 5) {
        fill(random(0, 150), random(0, 20));
        rect(random(i - 5, i), random(j - 5, j), 1, 1);
      }
    }
    for (int i = 0; i < 10; i++) {
      fill(random(0, 255), random(0, 200));
      rect(random(0, width), random(0, height), random(1, 3), random(1, 3));
    }
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }
}

// https://www.openprocessing.org/sketch/571812
class FoliageScroll extends Visual {
  // FoliageScroll_8.0

  int Nmax = 3000 ; 
  float P = 1.5 ; 
  float RR = 0.01 ; 
  float A = 0.5 ; 
  float LR = 20 ;

  float X[] = new float[Nmax] ; 
  float Y[] = new float[Nmax] ; 
  int R[] = new int[Nmax] ;
  int B[] = new int[Nmax] ; 
  int K[] = new int[Nmax] ; 
  float GR[] = new float[2] ;
  int N ; 
  int I ; 
  int II ; 
  float L ; 
  float Lmax ; 
  float dX ; 
  float dY ; 
  float CX ; 
  float CY ; 
  int Q ; 



  void setup() {
    noSmooth() ;
    strokeWeight(2) ;

    N = 2 ; 
    GR[0] = 500 ; 
    GR[1] = 15000 ;  
    CX = 300 ; 
    CY = 300 ; 
    Lmax = 0 ;
    X[0] = 300 ; 
    Y[0] = 300 ; 
    X[1] = 300 ; 
    Y[1] = 290 ; 
    X[2] = 300 ; 
    Y[2] = 310 ;  
    R[0] = 0 ; 
    R[1] = 0 ; 
    R[2] = 0 ; 
    K[0] = 0 ; 
    K[1] = 0 ; 
    K[2] = 0 ; 
    B[0] = 0 ; 
    B[1] = 0 ; 
    B[2] = 0 ;
  } // setup()



  void draw() {

    background(0, 0, 0) ;

    for ( Q = 0; Q < 10; Q++ ) {

      for ( I = 0; I <= N; I++ ) {
        for ( II = 0; II < I; II++ ) {
          L = sqrt(((X[I]-X[II])*(X[I]-X[II]))+((Y[I]-Y[II])*(Y[I]-Y[II]))) ;
          if ( L < LR || II == B[I] ) {
            dX = ((LR-L)*(X[I]-X[II])/L/P) ; 
            dY = ((LR-L)*(Y[I]-Y[II])/L/P) ; 
            X[I] = X[I] + dX ; 
            Y[I] = Y[I] + dY ; 
            X[II] = X[II] - dX ; 
            Y[II] = Y[II] - dY ;
          }
        } // II
        L = sqrt(((X[I]-CX)*(X[I]-CX))+((Y[I]-CY)*(Y[I]-CY))) ;
        if ( L > Lmax ) { 
          Lmax = L ;
        }
        if ( K[I] == 0 && R[I] >= GR[0] && I != 0 && N < Nmax-1 ) {
          N = N + 1 ;
          dX = (X[I]-X[B[I]])/10 ;
          dY = (Y[I]-Y[B[I]])/10 ;
          X[N] = X[I] + (dX*cos(A)) - (dY*sin(A)) ;
          Y[N] = Y[I] + (dX*sin(A)) + (dY*cos(A)) ;
          R[N] = 0 ; 
          B[N] = I ; 
          K[N] = K[I] ;
          K[I] = K[I] + 10 ;
        }
        if ( K[I] == 10 && R[I] > GR[1] && I != 0 && random(0, 10000) > 9999 && N < Nmax-2 ) {
          N = N + 1 ;
          X[N] = X[I] - ((Y[I]-Y[B[I]])*(R[I]/(R[I]+R[B[I]]))) ;
          Y[N] = Y[I] - ((X[I]-X[B[I]])*(R[I]/(R[I]+R[B[I]]))) ;
          R[N] = 0 ; 
          B[N] = I ; 
          K[N] = 0 ; 
          K[I] = 20 ;
        }
        R[I] = R[I] + 1 ;
      } // I
    } // Q

    for ( I = 0; I <= N; I++ ) {
      strokeWeight(LR/2*300/Lmax) ;
      stroke(0, 255, 0) ;
      line((X[I]-300)*300/Lmax+300, (Y[I]-300)*300/Lmax+300, (X[B[I]]-300)*300/Lmax+300, (Y[B[I]]-300)*300/Lmax+300) ;
    }
    Lmax = 0 ;
  } // draw()



  void mousePressed() { 
    setup();
  }

  void mouseReleased() {
  }
}

// https://www.openprocessing.org/sketch/521143
class SpiroRose extends Visual {
  final float ELLIPSE_MULT_MIN = 1; // min size multiplier for ellipse
  final float ELLIPSE_MULT_MAX = 200; // max size multiplier for ellipse
  final float ELLIPSE_BASE_W = 3; // ellipse base width
  final float ELLIPSE_BASE_H = 1; // ellipse base height
  final int ELLIPSE_XOFF = -60; // ellipse x-offset from centre of sketch
  final int ELLIPSE_YOFF = -60; // ellipse y-offset from centre of sketch
  final float ELLIPSE_PERIOD = TWO_PI / 1080; // period of sine wave governing ellipse size
  final float SKETCH_ROT = TWO_PI / 600; // speed at which sketch canvas rotates
  final int BACKLIGHT = 16; // background brightness value

  boolean drawMe = true; // for pause/resume
  int drawFrame = 0; // pause/resume ability means we can't use frameCount

  void setup() {
    frameRate(60);
    colorMode(HSB, 360, 100, 100);
    background(0, 0, BACKLIGHT, 100);
    noFill();
    strokeWeight(1);
  }

  void draw() {
    if (drawMe) {
      float x = drawFrame * ELLIPSE_PERIOD;
      x -= HALF_PI; // start at sin(x) = 0
      float amplitude = ELLIPSE_MULT_MAX - ELLIPSE_MULT_MIN;
      float ellipseMult = (sin(x) * amplitude) / 2; // sine wave to control size of ellipse
      ellipseMult += amplitude/2 + ELLIPSE_MULT_MIN; // ELLIPSE_MULT_MIN <= sine values <= ELLIPSE_MULT_MAX
      float w = ELLIPSE_BASE_W * ellipseMult;
      float h = ELLIPSE_BASE_H * ellipseMult;

      pushMatrix();
      translate(width/2, height/2);
      rotate(drawFrame * SKETCH_ROT);
      stroke(drawFrame % 360, 100, 100, 100); //stroke(200, 65, 80, 100); // use this for blue similar to https://gfycat.com/JointRealisticGrouper
      ellipse(ELLIPSE_XOFF, ELLIPSE_YOFF, w, h);
      popMatrix();

      drawFrame++;
    }
  }

  // press space to pause/resume
  void mousePressed() {
    drawMe = false;
  }

  void mouseReleased() {
    drawMe = true;
  }
}

// https://www.openprocessing.org/sketch/298646
class SurfsUpBlue extends Visual {
  // Pixel-sized particles version, of 'surfs_up'.
  // Particles are now directly noise driven omitting the flow field.
  // Array[], particle, pixel, noise()
  // Mouse click to reset, mouseX adjusts background clear.

  Particle[] particles;
  float alpha;

  void setup() {
    background(0);
    noStroke();
    setParticles();
  }

  void draw() {
    frameRate(20);
    alpha = map(mouseX, 0, width, 5, 35);
    fill(0, alpha);
    rect(0, 0, width, height);

    loadPixels();
    for (Particle p : particles) {
      p.move();
    }
    updatePixels();
  }

  void setParticles() {
    particles = new Particle[6000];
    for (int i = 0; i < 6000; i++) { 
      float x = random(width);
      float y = random(height);
      float adj = map(y, 0, height, 255, 0);
      int c = color(40, adj, 255);
      particles[i]= new Particle(x, y, c);
    }
  }

  void mousePressed() {
    setParticles();
  }

  void mouseReleased() {
  }

  class Particle {
    float posX, posY, incr, theta;
    color  c;

    Particle(float xIn, float yIn, color cIn) {
      posX = xIn;
      posY = yIn;
      c = cIn;
    }

    public void move() {
      update();
      wrap();
      display();
    }

    void update() {
      incr +=  .008;
      theta = noise(posX * .006, posY * .004, incr) * TWO_PI;
      posX += 2 * cos(theta);
      posY += 2 * sin(theta);
    }

    void display() {
      if (posX > 0 && posX < width && posY > 0  && posY < height) {
        pixels[(int)posX + (int)posY * width] =  c;
      }
    }

    void wrap() {
      if (posX < 0) posX = width;
      if (posX > width ) posX =  0;
      if (posY < 0 ) posY = height;
      if (posY > height) posY =  0;
    }
  }
}

// https://www.openprocessing.org/sketch/296103
class Kolam extends Visual {
  int tsize = 41, // tile size
    margin = 5, // margin size
    tnumber = 9;  // number of points (lager row) 

  int[][] link, // connections
    nlink;  // next connections

  float idx;  // index used to interpolate between old and new connections

  PGraphics pg;  // PGraphics used to draw the kolam
  color bgcolor;  // background color


  /*===========================*/


  void setup() {
    bgcolor = color(random(50), random(50), random(50));

    pg = createGraphics(tsize*tnumber + 2*margin, tsize*tnumber + 2*margin);

    link = new int[tnumber + 1][tnumber + 1];
    nlink = new int[tnumber + 1][tnumber + 1]; 

    for (int i = 0; i < link.length; i++) {
      for (int j = 0; j < link[0].length; j++) {
        link[i][j] = nlink[i][j] = 1;
      }
    }

    configTile();

    background(bgcolor);
  }


  /*===========================*/


  void draw() {

    if (idx <= 1)  drawTile();  //draw a new tile each frame while it's not entirely updated 

    translate(width/2, height/2);
    rotate(QUARTER_PI);  

    imageMode(CENTER);
    image(pg, 0, 0);
  }


  /*===========================*/


  void mousePressed() {
    configTile();
  }

  void mouseReleased() {
  }

  /*===========================*/


  void configTile() {

    idx = 0;  // reset index

    // update ancient links
    for (int i = 0; i < link.length; i++) {
      for (int j = 0; j < link[0].length; j++) {
        link[i][j] = nlink[i][j];
      }
    }


    // create new links
    float limit = random(0.4, 0.7);  // choose frequency of conections randomly

    for (int i = 0; i < nlink.length; i++) {
      for (int j = i; j < nlink[0].length/2; j++) {

        int l = 0;      
        if (random(1) > limit)  l = 1;

        nlink[i][j] = l;  // left-top
        nlink[i][nlink[0].length - j - 1] = l;  // left-bottom

        nlink[j][i] = l;  // top-left
        nlink[nlink[0].length - j - 1][i]  = l;  // top-right

        nlink[nlink.length - 1 - i][j] = l;  // right-top
        nlink[nlink.length - 1 - i][nlink[0].length - j - 1] = l;  // right-top

        nlink[j][nlink.length - 1 - i] = l;  // bottom-left
        nlink[nlink[0].length - 1 - j][nlink.length - 1 - i] = l;  // bottom-right
      }
    }
  }


  /*===========================*/


  void drawTile() {
    pg.beginDraw();

    pg.background(bgcolor);
    pg.noFill();
    pg.stroke(255);
    pg.strokeWeight(5);

    for (int i = 0; i < tnumber; i++) {
      for (int j = 0; j < tnumber; j++) {
        if ((i+j)%2 == 0) {

          float top_left = tsize/2 * lerp(link[i][j], nlink[i][j], idx);
          float top_right = tsize/2 * lerp(link[i + 1][j], nlink[i + 1][j], idx);
          float bottom_right = tsize/2 * lerp(link[i + 1][j + 1], nlink[i + 1][j + 1], idx);
          float bottom_left = tsize/2 * lerp(link[i][j + 1], nlink[i][j + 1], idx);

          pg.rect(i*tsize + margin, j*tsize + margin, tsize, tsize, top_left, top_right, bottom_right, bottom_left);          
          pg.point(i*tsize + tsize/2 + margin, j*tsize+tsize/2 + margin);
        }
      }
    }

    pg.endDraw();

    // update index
    idx += 0.02;
    idx = constrain(idx, 0, 1);
  }
}

// https://www.openprocessing.org/sketch/376645
class DeformedLines extends Visual {
  int nLines = 50;
  Line[] l;
  Particle[] attractors;


  /*=======================*/


  void setup() {
    colorMode(HSB); 
    strokeWeight(1.5);
    noFill();

    initialize();
  }


  /*=======================*/


  void draw() {
    background(0);

    // move attractors
    attractors[0].update();  
    attractors[1].update();

    // interact lines with attractors
    float radius = 75*cos(frameCount/150.);
    for (int i = 0; i < l.length; i++) {
      l[i].interact(radius, attractors[0].pos.x, attractors[0].pos.y);
      l[i].interact(-radius, attractors[1].pos.x, attractors[1].pos.y);
      l[i].display();  // display lines
    }
  }


  /*=======================*/

  void initialize() {
    // Create Lines
    float c0 = random(255);
    float c1 = random(255);
    l = new Line[nLines];
    for (int i = 0; i < l.length; i++) {
      float col = lerp(c0, c1, float(i)/l.length);
      l[i] = new Line(5 + 10*i, col);
    }

    // Create Attractors
    attractors = new Particle[2];
    for (int i = 0; i < attractors.length; i++) {
      attractors[i] = new Particle(random(width), random(height));
      float angle = random(TWO_PI);
      attractors[i].vel.set(cos(angle), sin(angle), 0);
    }
  }


  /*=======================*/


  void mousePressed() {
    initialize();
  }

  void mouseReleased() {
  }

  /*=======================*/


  class Line {
    ArrayList<Particle> p;
    color col;
    int nPoints = 100;

    Line(int y, float c) {
      p = new ArrayList<Particle>();
      for (int i = 0; i < nPoints; i++) {
        p.add(new Particle(2+5*i, y));
      }

      col = color(c, 100, 255);
    }

    /*-------*/

    void display() {  // display line
      stroke(col);
      beginShape();
      for (int i = 0; i < p.size(); i++) {
        curveVertex(p.get(i).pos.x, p.get(i).pos.y);
      }
      endShape();
    }

    /*-------*/

    void interact(float radius, float mx, float my) {  // interact line with attractor
      for (int i = 0; i < p.size(); i++) {
        p.get(i).interact(radius, mx, my);
      }

      //change size of the line when necessary
      for (int i = 0; i < p.size()-1; i++) {
        float d = dist(p.get(i).pos.x, p.get(i).pos.y, p.get(i+1).pos.x, p.get(i+1).pos.y);
        if (d > 5) {  // add a new point when two neighbor points are too far apart
          float x = (p.get(i).pos.x + p.get(i+1).pos.x) / 2;
          float y = (p.get(i).pos.y + p.get(i+1).pos.y) / 2;
          p.add(i+1, new Particle(x, y));
        } else if (d < 1) {  // remove a point when 2 neighbor points are too close
          p.remove(i);
        }
      }
    }
  }


  /*=======================*/


  class Particle {
    PVector pos, vel, acc;

    Particle(float x, float y) {
      pos = new PVector(x, y, 0);
      vel = new PVector(0, 0, 0);
      acc = new PVector(0, 0, 0);
    }

    /*-------*/

    void interact(float r0, float x, float y) {  // interact points with attractors
      float sign = r0/abs(r0);
      r0 = abs(r0);

      float r = dist(pos.x, pos.y, x, y);
      float angle = atan2(pos.y-y, pos.x-x);

      if (r <= r0) {
        float radius = 0.5*sign*(r0-r)/r0;
        vel.set(radius*cos(angle), radius*sin(angle));
      } else {
        vel.set(0, 0);
      }

      pos.add(vel);
    }

    /*-------*/

    void update() {  // move attractors
      //change direction sometimes
      if (random(1) > 0.97) {
        float angle = random(-PI, PI);
        acc.set(cos(angle), sin(angle), 0);

        float mod = PVector.angleBetween(acc, vel);
        mod = map(mod, 0, PI, 0.1, 0.001);
        acc.mult(mod);
      }

      // update
      vel.add(acc);
      vel.limit(1.5); 
      pos.add(vel);

      // check edges
      pos.x = (pos.x + width)%width;
      pos.y = (pos.y + height)%height;
    }
  }
}

// https://www.openprocessing.org/sketch/493205
class PerlinRainbow extends Visual {
  int N_THREADS = 50;

  void setup() {
    //size(600, 600);
    fullScreen();

    background(255);
    noFill();
    stroke(255);
    colorMode(HSB, 360, 100, 100);
  }

  void draw() {
    fill(270, 0, 100, 8);
    noStroke();
    rect(0, 0, width, height);
    noFill();
    strokeWeight(2);

    for (int i = 0; i < N_THREADS; i++) {
      float hue = map(i, 0, N_THREADS, 0, 360);
      stroke(hue, 100, 100, 128);

      beginShape();
      for (int x = -10; x < width + 11; x += 10) {
        float n = noise(x * 0.001, frameCount * 0.01, i * 0.02);
        float y = map(n, 0, 1, 0, height);
        curveVertex(x, y);
      }
      endShape();
    }
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }
}
