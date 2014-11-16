//
//  Projectile.m
//  gyroflyer
//
//  Created by Jason Chu on 9/15/14.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import "Collidable.h"


@interface Collidable ()

@property CGSize altSize;

@end


@implementation Collidable

- (id)init {
    self = [super init];
    
    if (self) {
        self.collidableType = UNKNOWN;
    }
    
    return self;
}


- (BOOL)checkCollisionWith:(SKSpriteNode*) object {
    
    float objectLeft = object.position.x - (object.size.width / 2);
    float objectBottom = object.position.y - (object.size.height / 2);
    float objectRight = object.position.x + (object.size.width / 2);
    float objectTop = object.position.y + (object.size.height / 2);
    
    float selfLeft = self.position.x - (self.size.width / 3);
    float selfBottom = self.position.y - (self.size.height / 3);
    float selfRight = self.position.x + (self.size.width / 3);
    float selfTop = self.position.y + (self.size.height / 3);
    
    return !(objectLeft >= selfRight || objectRight <= selfLeft || objectTop <= selfBottom || objectBottom >= selfTop);
}

@end
