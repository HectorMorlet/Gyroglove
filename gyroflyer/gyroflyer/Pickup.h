//
//  Pickup.h
//  gyroflyer
//
//  Created by Jason Chu on 9/25/14.
//  Copyright (c) 2014 HamLann. All rights reserved.
//

#import "Collidable.h"
#import "GameScene.h"

@class GameScene;

typedef enum PickupType: NSInteger {
    PICKUP_DUAL_BULLETS,
    PICKUP_HEALTH,
    PICKUP_ONE_SHOT_KILL
} PickupType;


@interface Pickup : Collidable

@property PickupType pickupType;
@property (nonatomic, copy) void (^pickupAction)(GameScene *);

- (Pickup*)initWithType:(PickupType)type;

@end
