//
//  EnemyShip.m
//  gyroflyer
//
//  Created by Hector Morlet on 19/09/2014.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import "EnemyShip.h"


@implementation EnemyShip

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.collidableType = ENEMYSHIP;
        self.isAlive = YES;
    }
    return self;
}


+ (BOOL)randomBinary {
    // Choosing random either TRUE or FALSE
    float num = (arc4random() % 2);
    
    if (num > 0.5) {
        return YES;
    } else {
        return NO;
    }
}


- (id)initWithEnemyShipType:(EnemyShipType)enemyShipType {
    self = [self init];
    
    if (self) {
        self.enemyShipType = enemyShipType;
        
        // Setting position
        float xPosition = (arc4random() % IPAD_WIDTH) + ENEMY_SHIP_STARTING_POSITION_MIN;
        self.position = CGPointMake(xPosition, IPAD_HEIGHT);
        
        // Making actions
        SKAction *removeFromScene = [SKAction removeFromParent];
        SKAction *move = [SKAction moveByX:0 y:-IPAD_HEIGHT - ENEMY_SHIP_PATH_END_BUFFER duration:ENEMY_SHIP_MOVE_DURATION];
        
        // Running actions
        [self runAction:[SKAction sequence:@[move, removeFromScene]]];
        
        // Adding image
        self.texture = [SKTexture textureWithImageNamed:@"EnemyShip"];
        
        if (self.enemyShipType == STANDARD_ENEMY_SHIP) {
            // Standard
            self.size = CGSizeMake(STANDARD_ENEMY_SHIP_SIZE, STANDARD_ENEMY_SHIP_SIZE);
            self.health = STANDARD_ENEMY_SHIP_HEALTH;
            self.damageInflict = STANDARD_ENEMY_SHIP_DAMAGE_INFLICT;
            self.bulletType = ENEMY_SHIP_STANDARD_BULLET;
//            self.texture = [SKTexture textureWithImageNamed:@"StandardEnemyShip"];
        } else if (self.enemyShipType == EASY_ENEMY_SHIP) {
            // Easy
            self.size = CGSizeMake(EASY_ENEMY_SHIP_SIZE, EASY_ENEMY_SHIP_SIZE);
            self.health = EASY_ENEMY_SHIP_HEALTH;
            self.damageInflict = EASY_ENEMY_SHIP_DAMAGE_INFLICT;
            self.bulletType = ENEMY_SHIP_EASY_BULLET;
//            self.texture = [SKTexture textureWithImageNamed:@"EasyEnemyShip"];
        } else if (self.enemyShipType == HARD_ENEMY_SHIP) {
            // Hard
            self.size = CGSizeMake(HARD_ENEMY_SHIP_SIZE, HARD_ENEMY_SHIP_SIZE);
            self.health = HARD_ENEMY_SHIP_HEALTH;
            self.damageInflict = HARD_ENEMY_SHIP_DAMAGE_INFLICT;
            self.bulletType = ENEMY_SHIP_HARD_BULLET;
//            self.texture = [SKTexture textureWithImageNamed:@"HardEnemyShip"];
        } else if (self.enemyShipType == IMPOSSIBLE_ENEMY_SHIP) {
            // Impossible
            self.size = CGSizeMake(IMPOSSIBLE_ENEMY_SHIP_SIZE, IMPOSSIBLE_ENEMY_SHIP_SIZE);
            self.health = IMPOSSIBLE_ENEMY_SHIP_HEALTH;
            self.damageInflict = IMPOSSIBLE_ENEMY_SHIP_DAMAGE_INFLICT;
            self.bulletType = ENEMY_SHIP_IMPOSSIBLE_BULLET;
//            self.texture = [SKTexture textureWithImageNamed:@"ImpossibleEnemyShip"];
        }
    }
    
    return self;
}


- (Bullet *)shootBullet {
    Bullet *newBullet;

    CGPoint startingPosition = CGPointMake(self.position.x, self.position.y - self.size.width / 2);
    CGPoint target = CGPointMake(self.position.x, self.position.y - IPAD_HEIGHT);
    newBullet = [[Bullet alloc] initWithType:self.bulletType startingPosition:startingPosition target:target damageInflict:-1];

    return newBullet;
}

@end
