//
//  Spaceship.h
//  gyroflyer
//
//  Created by Jason Chu on 9/16/14.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import "Collidable.h"
#import "Bullet.h"


#define SPACESHIP_STARTING_DISTANCE_FROM_BOTTOM 100

#define SPACESHIP_WIDTH 100
#define SPACESHIP_HEIGHT 100

#define SPACESHIP_VELOCITY_MULTIPLYER 0.15

#define SPACESHIP_DEFAULT_HEALTH 10

#define SPACESHIP_DEFAULT_BULLET_DAMAGE_INFLICT 2

typedef enum SpaceshipBulletType: NSInteger {
    SINGLE_BULLET,
    BONUS_DAMAGE,
    MINI_GUN,
    BIG_BULLETS,
    DUAL_BULLETS
} SpaceshipBulletType;

@interface Spaceship : Collidable

- (void)update;

- (NSArray *)shootBulletWithType:(SpaceshipBulletType)bulletType;


@property NSInteger xVelocity;
@property NSInteger yVelocity;

@property NSInteger health;

@property SpaceshipBulletType bulletType;
@property NSInteger upgradedBulletTypeExpiry;

@property NSInteger bulletDamageInflict;

@end
