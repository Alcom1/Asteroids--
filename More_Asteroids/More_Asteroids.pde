HandlerRand rand;                      //Random handler to provide random position and direction vectors for asteroid spawning.
Ship player;                           //The player's ship.
ArrayList<Projectile> projectiles;     //Array List of fired projectiles.
ArrayList<RockSubtracting> asteroids;  //Array List of asteroids.

//Boolean states for key presses.
Boolean keyW;
Boolean keyD;
Boolean keyS;
Boolean keyA;

//Other boolean.
Boolean menu;         //True if currently in menu. I wish Processing had enums. :(
Boolean gameOver;     //Boolean state for game over display.

int timerProjectile;  //Timer that tracks projectile interval.
int timerKill;        //Timer that tracks respawn delay after the player is killed.
int timerBonus;       //Timer for bonus display.
int score;            //Incrementing integer for score.
int level;            //Incrementing integer for level.
int bonusDisplay;     //Display of the bonus added to the score.
int highScore;        //Current high score.

//Setup
void setup()
{
  //Setup the window.
  size(800, 800, P2D);
  background(4, 0, 0);
  noCursor();
  
  //All timers and increments start at zero.
  timerProjectile = 0;
  timerKill = 0;
  timerBonus = 0;
  score = 0;
  level = 0;
  bonusDisplay = -1; //Except for this one. -1 indicates that the bonus will not be displayed.
  highScore = 0;
  
  //Initialize all objects.
  rand = new HandlerRand();
  player = new Ship();
  projectiles = new ArrayList<Projectile>();
  asteroids = new ArrayList<RockSubtracting>();
  
  //Key stats start as false;
  keyW = false;
  keyD = false;
  keyS = false;
  keyA = false;
  
  gameOver = false;
  
  //Start game with a menu swap.
  menu = false;
  this.menuSwitch();
}

void draw()
{
  //Draw background.
  background(4, 0, 0);
  
  if(menu)
  {
    //Draw keys, mouse, and button.
    fill(0, 0, 0, 0);
    stroke(255, 255, 255);
    strokeWeight(5);
    rect(100, 300, 50, 50);
    rect(160, 300, 50, 50);
    rect(220, 300, 50, 50);
    rect(160, 240, 50, 50);
    ellipse(590, 320, 180, 250);
    line(505, 280, 675, 280);
    line(590, 280, 590, 195);
    if(
      mouseX > 250 &&
      mouseX < 550 &&
      mouseY > 600 &&
      mouseY < 680)
    {
      fill(100, 100, 100); //Highlight upon mouse over.
    }
    rect(250, 600, 300, 80);
    fill(0, 0, 0, 0);
    
    //Draw text
    fill(255, 255, 255);
    strokeWeight(0);
    textSize(64);
    text("MORE ASTEROIDS", 400, 40);
    textSize(42);
    text("START", 400, 635);
    text("A", 125, 320);
    text("S", 185, 320);
    text("D", 245, 320);
    text("W", 185, 260);
    text("MOVE", 185, 200);
    text("AIM & FIRE", 590, 150);
    text("High Score: " + highScore, 400, 720);
    
    //Press the start button to begin game.
    if(
      mousePressed && 
      mouseX > 250 &&
      mouseX < 550 &&
      mouseY > 600 &&
      mouseY < 680)
    {
      this.menuSwitch();
    }
    
    //Update asteroids
    for(int i = 0; i < asteroids.size(); i++)
    {
      asteroids.get(i).update();
    }
  }
  else
  { 
    //Increment timers
    timerProjectile++;
    timerBonus++;
    if(!player.active)
    {
      timerKill++; 
    }
    
    //Movement Input
    if(keyPressed)
    {
      //Accelerate North.
      if(keyW)
        player.velocity.y -= 0.15;
      
      //Accelerate West.
      if(keyD)
        player.velocity.x += 0.15;
      
      //Accelerate South.
      if(keyS)
        player.velocity.y += 0.15;
      
      //Accelerate East.
      if(keyA)
        player.velocity.x -= 0.15;
    }
    
    //Firing input. Fires if projectile timer is above a limit.
    //As the ship moves faster, projectile rate, speed, duration, and radius increases.
    if(mousePressed && timerProjectile > 18 - 2 * player.velocity.mag() && player.active)
    {
      timerProjectile = 0;             //Reset projectile timer.
      projectiles.add(new Projectile(  //Spawn a new projectile.
        player.getFiringPoint(),
        player.direction,
        5 + 0.5 * player.velocity.mag(),
        300 + 15 * player.velocity.mag(),
        5 + 1.2 * player.velocity.mag()));
    }
    
    //Update asteroids
    for(int i = 0; i < asteroids.size(); i++)
    {
      asteroids.get(i).update();
    }
    
    //Check for asteroid-projectile collisions.
    for(int i = 0; i < projectiles.size(); ++i)
    {
      if(
        this.allCollisionsProjectile(projectiles.get(i).position.x, projectiles.get(i).position.y, (int)projectiles.get(i).radius - 7) ||
        projectiles.get(i).update())
      {
        projectiles.remove(i);
      }
    }
    
    //Check for asteroid-player collisions
    for(int i = 0; i < player.geometry.mesh.getVertexCount(); ++i)
    {
      if(this.allCollisionsShip(
        player.geometry.mesh.getVertex(i).x + player.geometry.position.x,
        player.geometry.mesh.getVertex(i).y + player.geometry.position.y))
      {
        if(player.kill())
        {
          gameOver = true;
        }
      }
    }
    
    //Respawn the player.
    if(
      (timerKill > 180 && this.allCollisionSpawn() && !gameOver) ||  //Non game over wait lasts 3 seconds plus additional collision wait.
      (timerKill > 300))                                             //Game over wait lasts 5 seconds.
    {
      //If the player reset returns a true, indiciating game over.
      if(player.reset())
      {
        this.menuSwitch();
      }
      timerKill = 0;  //Reset kill timer.
    }
    
    //Remove destroyed asteroids. Generate new asteroids if all asteroids are destroyed.
    for(int i = 0; i < asteroids.size(); i++)
    {
      //If asteroid area is below threshold
      if(asteroids.get(i).geometry.area < 1200)
      {
        asteroids.remove(i);
      }
    }
    
    //Spawn more asteroids if there are no asteroids.
    if(asteroids.size() < 1)
    {
      this.spawn();
    }
    
    //update player
    player.update();
    
    //Display score.
    textAlign(RIGHT, TOP);
    fill(255, 255, 255);
    strokeWeight(0);
    textSize(48);
    text(score, width - 20, 0);
    
    //Displays any bonus added to the score.
    //Bonus display lasts for some seconds. After that, bonus is set to -1, so it won't display.
    if(timerBonus < 90 && bonusDisplay > 0)
    {
       fill(64, 200, 64);
       strokeWeight(0);
       textSize(30);
       text("+" + bonusDisplay, width - 20, 48);
    }
    else
    {
       bonusDisplay = -1;
    }
    
    //Display game over
    if(gameOver)
    {
       textAlign(CENTER, CENTER);
       fill(255, 255, 255);
       textSize(64);
       text("GAME OVER", 400, 400);
    }
    
    //Display high score
    if(gameOver && highScore < score)
    {
      textSize(42);
      text("NEW HIGH SCORE!", 400, 450);
    }
  }
  
  //Draw cursor
  fill(0, 0, 0, 0);
  stroke(255, 0, 0);
  strokeWeight(3);
  ellipse(mouseX, mouseY, 20, 20);
  line(mouseX + 5, mouseY, mouseX + 15, mouseY);
  line(mouseX - 5, mouseY, mouseX - 15, mouseY);
  line(mouseX, mouseY + 5, mouseX, mouseY + 15);
  line(mouseX, mouseY - 5, mouseX, mouseY - 15);
}

//Sets key presses to true when the keys are pressed.
void keyPressed()
{
  //Accelerate North.
  if(key == 'w' || key == 'W')
    keyW = true;
    
  //Accelerate West.
  if(key == 'd' || key == 'D')
    keyD = true;
    
  //Accelerate South.
  if(key == 's' || key == 'S')
    keyS = true;
    
  //Accelerate East.
  if(key == 'a' || key == 'A')
    keyA = true;
}

//Sets key presses to false when the keys are unpressed.
void keyReleased()
{
  //Accelerate North.
  if(key == 'w' || key == 'W')
    keyW = false;
    
  //Accelerate West.
  if(key == 'd' || key == 'D')
    keyD = false;
    
  //Accelerate South.
  if(key == 's' || key == 'S')
    keyS = false;
    
  //Accelerate East.
  if(key == 'a' || key == 'A')
    keyA = false;
} 

//Spwans asteroids based on level.
void spawn()
{
  //Increment level.
  //As level increases
  //* Number of large asteroids increases logarithmically.
  //* Size of large asteroids increases linearly.
  //* Speed of all asteroids increases linearly.
  level++;
  if(level > 3)
  {
    level++;  //Doubles level progression past level 3. Higher difficulty curve, less boredom. 
  }
  
  //Spawns large asteroids.
  for(int i = 0; i < (int)(1.8 * log(level) / log(1.8)); i++)
  {
    //Get a random PosDir for spawn parameters.
    PosDir spawn = rand.getSpawn();
    
    //Add an asteroid.
    asteroids.add(new RockSubtracting(
      spawn.position,
      spawn.direction,
      0.8 + .12 * level,
      20,
      50 + 1 * level));
  }
  
  //Spawn two small asteroids.
  for(int i = 0; i < 2; ++i)
  {
    //Get a random PosDir for spawn parameters.
    PosDir spawn = rand.getSpawn();
    
    //Add an asteroid.    
    asteroids.add(new RockSubtracting(
      spawn.position,
      spawn.direction,
      0.8 + .12 * level,
      10,
      20));
  }
}

//Returns true and increments the score if an asteroid collides with a point.
//Used for projectile collision.
boolean allCollisionsProjectile(float x, float y, int bonus)
{
  for(int i = 0; i < asteroids.size(); i++)
  {
    if(asteroids.get(i).collisionProjectile(x, y))
    {
      score += 10 + bonus;        //Increment score.
      timerBonus = 0;             //Reset bonus display timer.
      bonusDisplay = 10 + bonus;  //Set bonus so that it displays.
      return true;
    }
  }
  
  return false;
}

//Returns true if an asteroid collides with a point.
//Used for ship collision.
boolean allCollisionsShip(float x, float y)
{
  for(int i = 0; i < asteroids.size(); i++)
  {
    if(asteroids.get(i).collisionShip(x, y))
      return true;
  }
  return false;
}

//Returns true if asteroids are in the spawn area.
boolean allCollisionSpawn()
{
  for(int i = 0; i < asteroids.size(); i++)
  {
    //If any asteroid is within three radii of the spawn.
    //It's three radii for some reason. I don't know why it's three radii,
    //It doesn't look like three radii,
    //but that gets the best results.
    if(sqrt(
      sq(asteroids.get(i).geometry.position.x - width / 2) +
      sq(asteroids.get(i).geometry.position.y - height / 2)) < asteroids.get(i).geometry.radius * 3)
    {
      return false;
    }
  }
  return true;
}

void menuSwitch()
{
  //Switch to game.
  if(menu)
  {
    menu = false;
    gameOver = false;  //reset game over.
    asteroids = new ArrayList<RockSubtracting>();  //Reset asteroid array.
  }
  
  //Switch to menu.
  else
  {
    //Record new high score.
    if(highScore < score)
    {
      highScore = score;  //Set high score to equal the new score.
    }
    
    menu = true;
    textAlign(CENTER, CENTER);  //Text alignment for menu.
    score = 0;    //Reset score.
    level = 0;    //Reset level.
    asteroids = new ArrayList<RockSubtracting>();  //Reset asteroid array.
    
    //Add asteroids that appear in the menu.
    for(int i = 0; i < 5; ++i)
    {    
      //Get a random PosDir for spawn parameters.
      PosDir spawn = rand.getSpawn();
      
      //add an asteroid.
      asteroids.add(new RockSubtracting(
        spawn.position,
        spawn.direction,
        0.8 + .12 * level,
        10,
        20));
    }
  }
}
