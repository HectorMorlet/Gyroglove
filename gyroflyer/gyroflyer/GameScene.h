//
//  GameScene.h
//  gyroflyer
//

//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import <SpriteKit/SpriteKit.h>
#import "Asteroid.h"
#import "Spaceship.h"
#import "EnemyShip.h"
#import "Pickup.h"
#import "TitleScene.h"


#define BACKGROUND_R 0.05
#define BACKGROUND_G 0.27
#define BACKGROUND_B 0.4

#define DECI_SECONDS_PER_SECOND 10

//#define ASTEROID_SPAWN_INTERVAL self.asteroidSpawnInterval
//#define ENEMY_SHIP_SPAWN_INTERVAL self.enemyShipSpawnInterval
//#define SPACESHIP_SHOOT_INTERVAL self.spaceshipSpawnInterval
//#define ENEMY_SHIP_SHOOT_INTERVAL self.enemyShipShootInterval

//#define ASTEROID_SPAWN_INTERVAL 4
//#define ENEMY_SHIP_SPAWN_INTERVAL 15
//#define SPACESHIP_SHOOT_INTERVAL 3
//#define ENEMY_SHIP_SHOOT_INTERVAL 8

#define ASTEROID_SPAWN_INTERVAL 5
#define ENEMY_SHIP_SPAWN_INTERVAL 20
#define SPACESHIP_SHOOT_INTERVAL 3
#define ENEMY_SHIP_SHOOT_INTERVAL 8


#define ENEMY_SHIP_SPAWN_DELAY 2

#define HEALTH_BAR_R 0.16
#define HEALTH_BAR_G 0.37
#define HEALTH_BAR_B 0.5
#define HEALTH_BAR_HEIGHT 100

#define FEEDBACK_ANIMATION_DURATION 0.2

#define HUGE_ASTEROID_SPAWN_CHANCE_PERCENT 5
#define IMPOSSIBLE_ENEMY_SHIP_SPAWN_CHANCE_PERCENT 5

#define SCORE_Z 10
#define SCORE_LABEL_OFFSET 80
#define SCORE_PER_ENEMY_SHIP_SHOT 5
#define SCORE_PER_ASTEROID_SHOT 1


@interface GameScene : SKScene

@property Spaceship *spaceship;
@property float lastCurrentTime;
@property NSInteger score;
@property CGPoint gyrogloveTilt;
@property SKScene* parentScene;

@end

