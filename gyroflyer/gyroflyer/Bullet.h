//
//  Bullet.h
//  gyroflyer
//
//  Created by Hector Morlet on 20/09/2014.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import "Collidable.h"


#define BULLET_MOVEMENT_DURATION_BOUNDS 5
#define BULLET_MOVEMENT_DURATION_MIN 2

#define BULLET_PATH_END_BUFFER 50

#define BULLET_MOVEMENT_DURATION 2


typedef enum BulletType {
    SPACESHIP_STANDARD_BULLET,
    ENEMY_SHIP_EASY_BULLET,
    ENEMY_SHIP_STANDARD_BULLET,
    ENEMY_SHIP_HARD_BULLET,
    ENEMY_SHIP_IMPOSSIBLE_BULLET
} BulletType;

typedef enum BulletTypeDamageInflict: NSInteger {
    SPACESHIP_STANDARD_BULLET_DAMAGE_INFLICT = 2,
    ENEMY_SHIP_EASY_BULLET_DAMAGE_INFLICT = 1,
    ENEMY_SHIP_STANDARD_BULLET_DAMAGE_INFLICT = 2,
    ENEMY_SHIP_HARD_BULLET_DAMAGE_INFLICT = 3,
    ENEMY_SHIP_IMPOSSIBLE_BULLET_DAMAGE_INFLICT = 8
} BulletTypeDamageInflict;

typedef enum BulletTypeWidth: NSInteger {
    MINI_BULLET_WIDTH = 12,
    LONG_BULLET_WIDTH = 12,
    IMPOSSIBLE_BULLET_WIDTH = 18
} BulletTypeWidth;

typedef enum BulletTypeLength: NSInteger {
    MINI_BULLET_LENGTH = 16,
    STANDARD_BULLET_LENGTH = 30,
    HARD_BULLET_LENGTH = 50,
    IMPOSSIBLE_BULLET_LENGTH = 35
} BulletTypeLength;


@interface Bullet : Collidable

@property BulletType bulletType;


- (id)initWithType:(BulletType)type
  startingPosition:(CGPoint)startingPosition
            target:(CGPoint)target
     damageInflict:(NSInteger)damageInflict;

@end
