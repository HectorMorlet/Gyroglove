//
//  Projectile.h
//  gyroflyer
//
//  Created by Jason Chu on 9/15/14.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


#define IPAD_WIDTH 860
#define IPAD_HEIGHT 1020


typedef enum CollidableType: NSInteger {
    UNKNOWN,
    ASTEROID,
    SPACESHIP_BULLET,
    ENEMY_BULLET,
    SPACESHIP,
    ENEMYSHIP,
    PICKUP
} CollidableType;


@interface Collidable : SKSpriteNode

@property CollidableType collidableType;
@property NSInteger damageInflict;

- (BOOL)checkCollisionWith:(SKSpriteNode*) object;

@end
