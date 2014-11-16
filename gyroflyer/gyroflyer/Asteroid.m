//
//  Asteroid.m
//  gyroflyer
//
//  Created by Jason Chu on 9/16/14.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import "Asteroid.h"


@implementation Asteroid

- (id)init {
    self = [super init];
    
    if (self) {
        self.collidableType = ASTEROID;
        self.health = 3;
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


- (id)initWithAsteroidType:(AsteroidType)asteroidType {
    self = [self init];
    
    if (self) {
        self.asteroidType = asteroidType;
        
        // Setting position
        float xPosition = (arc4random() % IPAD_WIDTH) + ASTEROID_STARTING_POSITION_MIN;
        self.position = CGPointMake(xPosition, IPAD_HEIGHT);
        
        // Getting rotate
        float rotateAngle;
        if ([Asteroid randomBinary]) {
            rotateAngle = M_PI;
        } else {
            rotateAngle = -1 * M_PI;
        }
        
        // Setting rotate
        CGFloat rotateDuration = (float)((arc4random() % ASTEROID_ROTATE_DURATION_BOUNDS) + ASTEROID_ROTATE_DURATION_MIN) / ASTEROID_ROTATE_DURATION_BOUNDS;
        SKAction *rotate = [SKAction rotateByAngle:rotateAngle duration:rotateDuration];
        [self runAction:[SKAction repeatActionForever:rotate]];
        
        // Setting shift
        float shiftAmount = 0;
        if ([Asteroid randomBinary]) {
            shiftAmount = -1 * (float)(arc4random() % IPAD_WIDTH / 2);
        } else {
            shiftAmount = (float)(arc4random() % IPAD_WIDTH / 2);
        }
        
        // Move downward
        CGFloat moveDuration = arc4random() % ASTEROID_MOVEMENT_DURATION_BOUNDS + ASTEROID_MOVEMENT_DURATION_MIN;
        SKAction *move = [SKAction moveByX:shiftAmount y:-IPAD_HEIGHT - ASTEROID_PATH_END_BUFFER duration:moveDuration];
        
        // Remove from scene
        SKAction *removeFromScene = [SKAction removeFromParent];
        
        // Image
        self.texture = [SKTexture textureWithImageNamed:@"Asteroid"];
        
        // Asteroid type specific specifications
        if (self.asteroidType == STANDARD_ASTEROID) {
            self.size = CGSizeMake(STANDARD_ASTEROID_SIZE, STANDARD_ASTEROID_SIZE);
            self.damageInflict = STANDARD_ASTEROID_DAMAGE_INFLICT;
        } else if (self.asteroidType == SMALL_ASTEROID) {
            self.size = CGSizeMake(SMALL_ASTEROID_SIZE, SMALL_ASTEROID_SIZE);
            self.damageInflict = SMALL_ASTEROID_DAMAGE_INFLICT;
        } else if (self.asteroidType == LARGE_ASTEROID) {
            self.size = CGSizeMake(LARGE_ASTEROID_SIZE, LARGE_ASTEROID_SIZE);
            self.damageInflict = LARGE_ASTEROID_DAMAGE_INFLICT;
        } else if (self.asteroidType == HUGE_ASTEROID) {
            self.size = CGSizeMake(HUGE_ASTEROID_SIZE, HUGE_ASTEROID_SIZE);
            self.damageInflict = HUGE_ASTEROID_DAMAGE_INFLICT;
        }
        
        [self runAction:[SKAction sequence:@[move, removeFromScene]]];
    }
    
    return self;
}

@end
