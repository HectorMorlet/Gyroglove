//
//  Bullet.m
//  gyroflyer
//
//  Created by Hector Morlet on 20/09/2014.
//  Copyright (c) 2014 HamLann. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet

- (id)init
{
    self = [super init];
    if (self) {
        self.collidableType = SPACESHIP_BULLET;
    }
    return self;
}


- (id)initWithType:(BulletType)type
  startingPosition:(CGPoint)startingPosition
            target:(CGPoint)target
     damageInflict:(NSInteger)damageInflict {
    self = [self init];
    
    // Setting position and type to given values
    self.bulletType = type;
    self.position = startingPosition;
    
    // Making actions
    SKAction *move = [SKAction moveTo:target duration:BULLET_MOVEMENT_DURATION];
    SKAction *removeFromScene = [SKAction removeFromParent];
    
    // Default as enemy bullet
    self.collidableType = ENEMY_BULLET;
    
    if (self.bulletType == SPACESHIP_STANDARD_BULLET) {
        // Spaceship standard
        self.texture = [SKTexture textureWithImageNamed:@"StandardBullet.png"];
        self.size = CGSizeMake(MINI_BULLET_WIDTH, MINI_BULLET_LENGTH);
        self.collidableType = SPACESHIP_BULLET;
        self.damageInflict = damageInflict;
    } else if (self.bulletType == ENEMY_SHIP_STANDARD_BULLET) {
        // Enemy ship standard
        self.texture = [SKTexture textureWithImageNamed:@"EnemyStandardBullet.png"];
        self.size = CGSizeMake(LONG_BULLET_WIDTH, STANDARD_BULLET_LENGTH);
        self.damageInflict = ENEMY_SHIP_STANDARD_BULLET_DAMAGE_INFLICT;
    } else if (self.bulletType == ENEMY_SHIP_EASY_BULLET) {
        // Enemy ship easy
        self.texture = [SKTexture textureWithImageNamed:@"EnemyEasyBullet.png"];
        self.size = CGSizeMake(LONG_BULLET_WIDTH, STANDARD_BULLET_LENGTH);
        self.damageInflict = ENEMY_SHIP_EASY_BULLET_DAMAGE_INFLICT;
    } else if (self.bulletType == ENEMY_SHIP_HARD_BULLET) {
        // Enemy ship hard
        self.texture = [SKTexture textureWithImageNamed:@"EnemyHardBullet.png"];
        self.size = CGSizeMake(LONG_BULLET_WIDTH, HARD_BULLET_LENGTH);
        self.damageInflict = ENEMY_SHIP_HARD_BULLET_DAMAGE_INFLICT;
    } else if (self.bulletType == ENEMY_SHIP_IMPOSSIBLE_BULLET) {
        // Enemy ship impossible
        self.texture = [SKTexture textureWithImageNamed:@"EnemyImpossibleBullet.png"];
        self.size = CGSizeMake(IMPOSSIBLE_BULLET_WIDTH, IMPOSSIBLE_BULLET_LENGTH);
        self.damageInflict = ENEMY_SHIP_IMPOSSIBLE_BULLET_DAMAGE_INFLICT;
    }
    
    // Running actions
    [self runAction:[SKAction sequence:@[move, removeFromScene]]];
    
    return self;
}

@end
