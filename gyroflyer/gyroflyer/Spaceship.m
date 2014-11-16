//
//  Spaceship.m
//  gyroflyer
//
//  Created by Hector Morlet on 16/09/2014.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import "Spaceship.h"


@implementation Spaceship

- (Spaceship *)init {
    self = [super init];
    
    if (self) {
        // Setting collidable type
        self.collidableType = SPACESHIP;
        
        // Setting to default spaceship pic, position, health and size
        self.texture = [SKTexture textureWithImageNamed:@"Spaceship"];
        self.size = CGSizeMake(SPACESHIP_WIDTH, SPACESHIP_HEIGHT);
        self.position = CGPointMake(IPAD_WIDTH / 2, SPACESHIP_STARTING_DISTANCE_FROM_BOTTOM);
        self.zPosition = 10;
        self.health = SPACESHIP_DEFAULT_HEALTH;
        self.bulletType = SINGLE_BULLET;
        self.upgradedBulletTypeExpiry = -1;
        
        self.bulletDamageInflict = SPACESHIP_DEFAULT_BULLET_DAMAGE_INFLICT;
    }
    
    return self;
}


- (void)update {
    // New x and y adds proportional velocity to position
    NSInteger newX = self.position.x + self.xVelocity * SPACESHIP_VELOCITY_MULTIPLYER;
    NSInteger newY = self.position.y + self.yVelocity * SPACESHIP_VELOCITY_MULTIPLYER;
    
    // X and y to set to
    NSInteger setX;
    NSInteger setY;
    
    // Making sure x is within bounds
    if (newX > 0 && newX < IPAD_WIDTH) {
        setX = newX;
    } else {
        setX = self.position.x;
    }
    
    // Making sure y is within bounds
    if (newY > 0 && newY < IPAD_HEIGHT) {
        setY = newY;
    } else {
        setY = self.position.y;
    }
    
    // Setting position
    self.position = CGPointMake(setX, setY);
}


- (NSArray *)shootBulletWithType:(SpaceshipBulletType)bulletType {
    if (bulletType == SINGLE_BULLET) {
        Bullet *newBullet;
        
        CGPoint startingPosition = CGPointMake(self.position.x, self.position.y + SPACESHIP_HEIGHT / 2);
        CGPoint target = CGPointMake(self.position.x, self.position.y + IPAD_HEIGHT);
        newBullet = [[Bullet alloc] initWithType:SPACESHIP_STANDARD_BULLET
                                startingPosition:startingPosition
                                          target:target
                                   damageInflict:self.bulletDamageInflict];
        
        return @[newBullet];
    } else if (bulletType == DUAL_BULLETS) {
        Bullet *leftBullet;
        Bullet *rightBullet;
        
        CGPoint leftStartPosition = CGPointMake(self.position.x - SPACESHIP_WIDTH/4.5, self.position.y);
        CGPoint rightStartPosition = CGPointMake(self.position.x + SPACESHIP_WIDTH/4.5, self.position.y);
        
        CGPoint leftTarget = CGPointMake(self.position.x - SPACESHIP_WIDTH/4.5, self.position.y + IPAD_HEIGHT);
        CGPoint rightTarget = CGPointMake(self.position.x + SPACESHIP_WIDTH/4.5, self.position.y + IPAD_HEIGHT);
        
        leftBullet = [[Bullet alloc] initWithType:SPACESHIP_STANDARD_BULLET
                                 startingPosition:leftStartPosition
                                           target:leftTarget
                                    damageInflict:self.bulletDamageInflict];
        rightBullet = [[Bullet alloc] initWithType:SPACESHIP_STANDARD_BULLET
                                  startingPosition:rightStartPosition
                                            target:rightTarget
                                     damageInflict:self.bulletDamageInflict];
        
        return @[leftBullet, rightBullet];
    } else {
        return nil;
    }
}

@end
