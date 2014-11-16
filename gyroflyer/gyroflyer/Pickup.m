//
//  Pickup.m
//  gyroflyer
//
//  Created by Jason Chu on 9/25/14.
//  Copyright (c) 2014 HamLann. All rights reserved.
//

#import "Pickup.h"

@implementation Pickup

- (Pickup *)initWithType:(PickupType)type {
    self = [super init];
    if (self) {
        self.collidableType = PICKUP;
        self.pickupType = type;
        
        SKAction *removeFromScene = [SKAction removeFromParent];
        SKAction *move;
        
        if (self.pickupType == PICKUP_DUAL_BULLETS) {
            // Set the texture
            self.texture = [SKTexture textureWithImageNamed:@"PickupDualBullets"];
            self.size = CGSizeMake(100, 100);
            
            float xPosition = (arc4random() % IPAD_WIDTH) + ASTEROID_STARTING_POSITION_MIN;
            self.position = CGPointMake(xPosition, IPAD_HEIGHT);

            self.pickupAction = ^void(GameScene* scene) {
                scene.spaceship.bulletType = DUAL_BULLETS;
                scene.spaceship.upgradedBulletTypeExpiry = scene.lastCurrentTime + 8;
            };
            
            move = [SKAction moveByX:0 y:-1*IPAD_HEIGHT duration:4];
        } else if (self.pickupType == PICKUP_HEALTH) {
            self.texture = [SKTexture textureWithImageNamed:@"PickupHealth"];
            self.size = CGSizeMake(100, 100);
            
            float xPosition = (arc4random() % IPAD_WIDTH) + ASTEROID_STARTING_POSITION_MIN;
            self.position = CGPointMake(xPosition, IPAD_HEIGHT);
            
            self.pickupAction = ^void(GameScene* scene) {
                scene.spaceship.health += 5;
            };
            
            move = [SKAction moveByX:0 y:-1*IPAD_HEIGHT duration:4];
        } else if (self.pickupType == PICKUP_ONE_SHOT_KILL) {
            self.texture = [SKTexture textureWithImageNamed:@"PickupOneShotKill"];
            self.size = CGSizeMake(100, 100);
            
            float xPosition = (arc4random() % IPAD_WIDTH) + ASTEROID_STARTING_POSITION_MIN;
            self.position = CGPointMake(xPosition, IPAD_HEIGHT);
            
            self.pickupAction = ^void(GameScene* scene) {
                scene.spaceship.bulletDamageInflict += 1000;
            };
            
            move = [SKAction moveByX:0 y:-1*IPAD_HEIGHT duration:4];
        }
        
        [self runAction:[SKAction sequence:@[move, removeFromScene]]];
    }
    return self;
}

@end
