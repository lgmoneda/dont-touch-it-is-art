import gifAnimation.*;
int screen_x, screen_y;
int n_balls;
int max_balls;
int base_r, base_g, base_b;
int delta, deltaColor;
ArrayList<Ball> balls = new ArrayList<Ball>();
GifMaker gifExport;

Ball createBall(){
  return new Ball((int) random(screen_x), (int) random(screen_y), (int) random(5, 40));
}

void setup() {
  screen_x = 500;
  screen_y = 320;
  max_balls = 200;
  base_r = 53;
  base_g = 122;
  base_b = 65;
  delta = 7;
  deltaColor = 30;
  smooth();
  frameRate(120);
  size(500, 320);
  balls.add(createBall());
  gifExport = new GifMaker(this, "balls1.gif", 15);
  gifExport.setRepeat(0);
}

void draw() {
  gifExport.setDelay(1);
  gifExport.addFrame();
  n_balls = balls.size();
  for(int i = 0; i < n_balls; i++){
    balls.get(i).update((int) random(-delta, delta), (int) random(-delta, delta), (int) random(255));
  }

  float new_ball = random(10);
  if(new_ball <= 9 && n_balls <= max_balls){
    balls.add(createBall());
  }

}

class Ball {
  int ball_x, ball_y, radius, max_moviments, moviments;
  int ball_r, ball_g, ball_b;

  Ball(int x, int y, int r) {
    ball_x = x;
    ball_y = y;
    radius = r;
    max_moviments = 100;
    moviments = 0;
    ball_r = (int) (base_r + random(-deltaColor, deltaColor));
    ball_g = (int) (base_g + random(-deltaColor, deltaColor));
    ball_b = (int) (base_b + random(-deltaColor, deltaColor));
  }

  void update(int delta_x, int delta_y, int fillColor) {
    moviments = moviments + 1;
    ball_x = ball_x + delta_x;
    ball_y = ball_y + delta_y;
    if(moviments <= max_moviments){
      fill(ball_r, ball_g, ball_b);
      ellipse(ball_x, ball_y, radius, radius);
    }
  }

}

void mousePressed() {
    gifExport.finish();
}
