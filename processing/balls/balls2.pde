import gifAnimation.*;
int screen_x, screen_y;
int n_balls;
int max_balls;
int base_r, base_g, base_b;
int delta, deltaColor;
ArrayList<Ball> balls = new ArrayList<Ball>();
GifMaker gifExport;
int radius;

color [] color_palette = {color(254, 74, 233),
                          color(222, 179, 233),
                          color(147, 112, 219)};

Ball createBall(){
  return new Ball((int) random(screen_x),
                  (int) screen_y + 2 * radius,
                  radius,
                  color_palette[(int) random(0, 3)],
                  - (int) random(1, delta));
}

void setup() {
  screen_x = 1000;
  screen_y = 1000;
  max_balls = 2000;
  base_r = 53;
  base_g = 122;
  base_b = 65;
  delta = 5;
  radius = 30;

  smooth();
  frameRate(120);
  size(1000, 1000);
  balls.add(createBall());
}

void draw() {
  background(50, 0, 200);
  n_balls = balls.size();
  for(int i = 0; i < n_balls; i++){
    balls.get(i).update();
  }

  float new_ball = random(10);
  if(new_ball <= 8 && n_balls <= max_balls){
    balls.add(createBall());
  }

}

class Ball {
  int ball_x, ball_y, radius, max_moviments, moviments;
  int ball_r, ball_g, ball_b;
  int speed, decay_threshold;
  color ball_color;
  int opacity;

  Ball(int x, int y, int r, color c, int s) {
    ball_x = x;
    ball_y = y;
    radius = r;
    max_moviments = 10000;
    moviments = 0;
    ball_color = c;
    opacity = 255;
    speed = s;
    decay_threshold = (int) random(255 + 2 * radius, screen_y - 2 * radius);
  }

  void update() {
    moviments = moviments + 1;
    ball_y = ball_y + speed;
    if(moviments <= max_moviments){
      if(ball_y < decay_threshold){
        opacity = opacity - 2;
        stroke(0, opacity);
        stroke(ball_color, opacity);
        fill(ball_color, opacity);
      }
      else {
        stroke(0);
        stroke(ball_color);
        fill(ball_color);
      }

      ellipse(ball_x, ball_y, radius, radius);
    }
  }

}
