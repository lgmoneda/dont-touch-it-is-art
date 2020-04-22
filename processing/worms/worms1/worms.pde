import gifAnimation.*;
int screen_x, screen_y;
int n_balls;
int max_balls;
int base_r, base_g, base_b;
int delta, deltaColor;
int delta_x, delta_y;
int radius;
int head_x, head_y;
ArrayList<Ball> balls = new ArrayList<Ball>();
GifMaker gifExport;
int counter=1;
int keep_direction;


Ball createBall(int x, int y, int radius){
  return new Ball(x, y, radius);
}

void setup() {
  ellipseMode(CENTER);
  screen_x = 500;
  screen_y = 320;
  max_balls = 200;
  base_r = 249;
  base_g = 90;
  base_b = 130;
  delta = 10;
  delta_x = 5;
  delta_y = 1;
  deltaColor = 3;
  keep_direction = 10;
  smooth();
  frameRate(60);
  size(600, 600);
  gifExport = new GifMaker(this, "worms.gif", 15);
  gifExport.setRepeat(0);
  head_x = 300;
  head_y = 300;
  radius = 40;
  for(int i = 0; i < 40; i++){
    balls.add(new Ball(head_x, head_y, radius - i));
  }
}

void draw() {
  gifExport.setDelay(1);
  gifExport.addFrame();
  n_balls = balls.size();
  counter += 1;
  background(50, 0, 200);
  if (counter % keep_direction == 0){
    keep_direction = (int) random(1, 15);
    delta_x = (int) random(-delta, delta);
    delta_y = (int) random(-delta, delta);
  };
  balls.get(0).update(delta_x, delta_y, (int) random(255));
  if (balls.get(0).ball_x < 0){delta_x = delta;}
  if (balls.get(0).ball_x > screen_x){delta_x = -delta;}
  if (balls.get(0).ball_y < 0){delta_y = delta;}
  if (balls.get(0).ball_y > screen_y){delta_y = -delta;}
  for(int i = 1; i < n_balls; i++){
    balls.get(i).move(balls.get(i-1).last_x,
                      balls.get(i-1).last_y,
                      (int) random(255));
  };

}

class Ball {
  int ball_x, ball_y, radius, max_moviments, moviments;
  int ball_r, ball_g, ball_b;
  int last_x, last_y;

  Ball(int x, int y, int r) {
    ball_x = x;
    ball_y = y;
    radius = r;
    max_moviments = 10000;
    moviments = 0;
    ball_r = (int) (base_r + random(-deltaColor, deltaColor));
    ball_g = (int) (base_g + random(-deltaColor, deltaColor));
    ball_b = (int) (base_b + random(-deltaColor, deltaColor));
  }

  void update(int delta_x, int delta_y, int fillColor) {
    moviments = moviments + 1;
    last_x = ball_x;
    last_y = ball_y;
    ball_x = ball_x + delta_x;
    ball_y = ball_y + delta_y;
    if(moviments <= max_moviments){
      fill(ball_r, ball_g, ball_b);
      ellipse(ball_x, ball_y, radius, radius);
    }
  }

  void move(int x, int y, int fillColor) {
    if (last_x != ball_x){
      last_x = ball_x;
    };
    if (last_y != ball_y){
      last_y = ball_y;
    };

    ball_x = x;
    ball_y = y;
    if(moviments <= max_moviments){
      fill(ball_r, ball_g, ball_b);
      stroke(ball_r, ball_g, ball_b);
      ellipse(ball_x, ball_y, radius, radius);
    }
  }

}
