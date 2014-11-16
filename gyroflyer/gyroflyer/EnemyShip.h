//
//  EnemyShip.h
//  gyroflyer
//
//  Created by Hector Morlet on 19/09/2014.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import "Collidable.h"
#import "Bullet.h"


#define ENEMY_SHIP_STARTING_POSITION_MIN 50

#define ENEMY_SHIP_PATH_END_BUFFER 100

#define ENEMY_SHIP_MOVEMENT_DURATION_BOUNDS 5
#define ENEMY_SHIP_MOVEMENT_DURATION_MIN 2

#define ENEMY_SHIP_MOVE_DURATION 10


typedef enum EnemyShipType: NSInteger {
    EASY_ENEMY_SHIP,
    STANDARD_ENEMY_SHIP,
    HARD_ENEMY_SHIP,
    IMPOSSIBLE_ENEMY_SHIP
}  EnemyShipType;

typedef enum EnemyShipTypeSize: NSInteger {
    EASY_ENEMY_SHIP_SIZE = 40,
    STANDARD_ENEMY_SHIP_SIZE = 100,
    HARD_ENEMY_SHIP_SIZE = 150,
    IMPOSSIBLE_ENEMY_SHIP_SIZE = 300
} EnemyShipTypeSize;

typedef enum EnemyShipTypeHealth: NSInteger {
    EASY_ENEMY_SHIP_HEALTH = 6,
    STANDARD_ENEMY_SHIP_HEALTH = 8,
    HARD_ENEMY_SHIP_HEALTH = 14,
    IMPOSSIBLE_ENEMY_SHIP_HEALTH = 20
} EnemyShipTypeHealth;

typedef enum EnemyShipTypeDamageInflict: NSInteger {
    EASY_ENEMY_SHIP_DAMAGE_INFLICT = 3,
    STANDARD_ENEMY_SHIP_DAMAGE_INFLICT = 4,
    HARD_ENEMY_SHIP_DAMAGE_INFLICT = 5,
    IMPOSSIBLE_ENEMY_SHIP_DAMAGE_INFLICT = 10
} EnemyShipTypeDamageInflict;



@interface EnemyShip : Collidable

- (id)initWithEnemyShipType:(EnemyShipType)enemyShipType;
- (Bullet *)shootBullet;


@property EnemyShipType enemyShipType;

@property NSInteger lastBulletSpawnTime;
@property BOOL isAlive;
@property NSInteger health;

@property BulletType bulletType;

@end
