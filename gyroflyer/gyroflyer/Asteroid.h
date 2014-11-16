//
//  Asteroid.h
//  gyroflyer
//
//  Created by Jason Chu on 9/16/14.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import "Collidable.h"


#define ASTEROID_STARTING_POSITION_MIN 50

#define ASTEROID_ROTATE_DURATION_BOUNDS 10
#define ASTEROID_ROTATE_DURATION_MIN 5

#define ASTEROID_PATH_END_BUFFER 200

#define ASTEROID_MOVEMENT_DURATION_BOUNDS 5
#define ASTEROID_MOVEMENT_DURATION_MIN 2

#define ASTEROID_DEFAULT_DAMAGE_INFLICT 1


typedef enum AsteroidType: NSInteger {
    SMALL_ASTEROID,
    STANDARD_ASTEROID,
    LARGE_ASTEROID,
    HUGE_ASTEROID
}  AsteroidType;

typedef enum AsteroidTypeSize: NSInteger {
    SMALL_ASTEROID_SIZE = 40,
    STANDARD_ASTEROID_SIZE = 100,
    LARGE_ASTEROID_SIZE = 150,
    HUGE_ASTEROID_SIZE = 300
} AsteroidTypeSize;

typedef enum AsteroidTypeDamageInflict: NSInteger {
    SMALL_ASTEROID_DAMAGE_INFLICT = 1,
    STANDARD_ASTEROID_DAMAGE_INFLICT = 2,
    LARGE_ASTEROID_DAMAGE_INFLICT = 3,
    HUGE_ASTEROID_DAMAGE_INFLICT = 4
} AsteroidTypeDamageInflict;


@interface Asteroid : Collidable

@property AsteroidType asteroidType;
@property NSInteger health;


- (id)initWithAsteroidType:(AsteroidType)asteroidType;


@end
