//
//  GameScene
//  gyroflyer
//
//  Created by Hector Morlet on 16/09/2014.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import "GameScene.h"


@interface GameScene()

@property NSInteger lastAsteroidSpawnTime;
@property NSInteger lastEnemyShipSpawnTime;
@property NSInteger lastBulletSpawnTime;
@property NSInteger lastPickupSpawnTime;
@property NSInteger startTime;

@property BOOL doUpdateSpaceship;
@property NSMutableArray* collidedObjects;

@property SKSpriteNode *healthBar;
@property BOOL gameOver;

@property SKLabelNode *scoreLabel;


- (void)spawnAsteroid:(NSInteger)currentTimeDeciSeconds;
- (void)spawnEnemyShip:(NSInteger)currentTimeDeciSeconds;

- (void)enemyShipsShoot:(NSInteger)currentTimeDeciSeconds;
- (void)spaceshipShoot:(NSInteger)currentTimeDeciSeconds;

- (void)applyCollisionAnimation:(SKSpriteNode*)object;
- (void)processBulletCollisions:(Collidable*)object currentObjects:(NSMutableArray*)currentObjects;
- (void)getAllCollisions;

- (void)healthCheck;

@end


@implementation GameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // Setting background color
        [self setBackgroundColor:[UIColor colorWithRed:(BACKGROUND_R)
                                                 green:(BACKGROUND_G)
                                                  blue:(BACKGROUND_B)
                                                 alpha:1.0f]];
        
        // Adding health bar
        self.healthBar = [[SKSpriteNode alloc] init];
        self.healthBar = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:HEALTH_BAR_R
																		   green:HEALTH_BAR_G
																			blue:HEALTH_BAR_B
																		   alpha:1.0]
													  size:CGSizeMake(self.spaceship.health * (IPAD_WIDTH / SPACESHIP_DEFAULT_HEALTH), HEALTH_BAR_HEIGHT)];
        self.healthBar.position = CGPointMake(CGRectGetMidX(self.frame), IPAD_HEIGHT - HEALTH_BAR_HEIGHT / 2);
		[self addChild:self.healthBar];

        // Adding main spaceship
        self.spaceship = [[Spaceship alloc] init];
        [self addChild:self.spaceship];
        
        // Setting start time as default
        self.startTime = 0;
        
        self.collidedObjects = [[NSMutableArray alloc] init];
        
        self.gameOver = false;
        
        self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        self.scoreLabel.fontSize = START_SCREEN_FONT_SIZE;
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
        self.scoreLabel.position = CGPointMake(SCORE_LABEL_OFFSET, self.size.height - SCORE_LABEL_OFFSET);
        self.scoreLabel.zPosition = SCORE_Z;
        [self addChild:self.scoreLabel];
    }
    
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.doUpdateSpaceship = true;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // Getting touch
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    // Setting spaceship velocity in proportion to how far the touch is from the spaceship
    self.spaceship.xVelocity = (NSInteger)(touchLocation.x - self.spaceship.position.x);
    self.spaceship.yVelocity = (NSInteger)(touchLocation.y - self.spaceship.position.y);
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.doUpdateSpaceship = false;
}


- (void)spawnAsteroid:(NSInteger)currentTimeDeciSeconds {
    if (currentTimeDeciSeconds % ASTEROID_SPAWN_INTERVAL == 0 &&
        self.lastAsteroidSpawnTime != currentTimeDeciSeconds) {
        AsteroidType randomAsteroidType = (AsteroidType)(arc4random() % (int)HUGE_ASTEROID);
        if (arc4random() % 100 < HUGE_ASTEROID_SPAWN_CHANCE_PERCENT) {
            randomAsteroidType = HUGE_ASTEROID;
        }
        
        [self addChild:[[Asteroid alloc] initWithAsteroidType:randomAsteroidType]];
        self.lastAsteroidSpawnTime = currentTimeDeciSeconds;
    }
}


- (void)spawnEnemyShip:(NSInteger)currentTimeDeciSeconds {
    if (currentTimeDeciSeconds >= self.startTime + ENEMY_SHIP_SPAWN_DELAY &&
        currentTimeDeciSeconds % ENEMY_SHIP_SPAWN_INTERVAL == 0 &&
        self.lastEnemyShipSpawnTime != currentTimeDeciSeconds) {
        EnemyShipType randomAsteroidType = (EnemyShipType)(arc4random() % (int)IMPOSSIBLE_ENEMY_SHIP);
        if (arc4random() % 100 < IMPOSSIBLE_ENEMY_SHIP_SPAWN_CHANCE_PERCENT) {
            randomAsteroidType = IMPOSSIBLE_ENEMY_SHIP;
        }
        
        [self addChild:[[EnemyShip alloc] initWithEnemyShipType:randomAsteroidType]];
        self.lastEnemyShipSpawnTime = currentTimeDeciSeconds;
    }
}


- (void)enemyShipsShoot:(NSInteger)currentTimeDeciSeconds {
    for (EnemyShip* currentEnemyShip in self.children) {
        if ([currentEnemyShip respondsToSelector:@selector(collidableType)] && currentEnemyShip.collidableType == ENEMYSHIP) {
            if (currentTimeDeciSeconds % ENEMY_SHIP_SHOOT_INTERVAL == 0 &&
                currentEnemyShip.lastBulletSpawnTime != currentTimeDeciSeconds && currentEnemyShip.isAlive) {
                [self addChild:[currentEnemyShip shootBullet]];
                currentEnemyShip.lastBulletSpawnTime = currentTimeDeciSeconds;
            }
        }
    }
}


- (void)spaceshipShoot:(NSInteger)currentTimeDeciSeconds {
    if (currentTimeDeciSeconds % SPACESHIP_SHOOT_INTERVAL == 0 &&
        self.lastBulletSpawnTime != currentTimeDeciSeconds) {
        for (SKSpriteNode* bullet in [self.spaceship shootBulletWithType:self.spaceship.bulletType]) {
            [self addChild:bullet];
        }
        self.lastBulletSpawnTime = currentTimeDeciSeconds;
    }
}


- (void)applyCollisionAnimation:(SKSpriteNode*)object {
    SKAction* colorize = [SKAction colorizeWithColor:[UIColor blackColor]
                                    colorBlendFactor:0.3
                                            duration:FEEDBACK_ANIMATION_DURATION/2];
    
    SKAction* deColorize = [SKAction colorizeWithColorBlendFactor:0.0 duration:FEEDBACK_ANIMATION_DURATION/2];
    
    [object runAction:[SKAction sequence:@[colorize, deColorize]]];
}


- (void)processBulletCollisions:(Collidable*)object currentObjects:(NSMutableArray*)currentObjects {
    for (Collidable* enemy in self.children) {
        if ([enemy respondsToSelector:@selector(collidableType)]) {
            if (enemy.collidableType == ENEMY_BULLET &&
                [enemy checkCollisionWith:object]) {
                [currentObjects addObject:enemy];
                [currentObjects addObject:object];
                [object removeFromParent];
                [enemy removeFromParent];
            } else if (enemy.collidableType == ASTEROID &&
                       [enemy checkCollisionWith:object]) {
                Asteroid* asteroid = (Asteroid*)enemy;
                asteroid.health -= object.damageInflict;
                
                [currentObjects addObject:enemy];
                [currentObjects addObject:object];
                
                [object removeFromParent];
                
                if (asteroid.health <= 0) {
                    [asteroid removeFromParent];
                    self.score += SCORE_PER_ASTEROID_SHOT;
                    break;
                } else {
                    [self applyCollisionAnimation:asteroid];
                }
            } else if (enemy.collidableType == ENEMYSHIP &&
                       [enemy checkCollisionWith:object]) {
                EnemyShip* enemyShip = (EnemyShip*)enemy;
                enemyShip.health -= object.damageInflict;
                
                [currentObjects addObject:enemy];
                [currentObjects addObject:object];
                
                [object removeFromParent];
                
                if (enemyShip.health <= 0) {
                    enemyShip.isAlive = NO;
                    [enemyShip removeFromParent];
                    self.score += SCORE_PER_ENEMY_SHIP_SHOT;
                    break;
                } else {
                    [self applyCollisionAnimation:enemyShip];
                }
            }
        }
    }
}


- (void)getAllCollisions {
    NSMutableArray *currentObjects = [[NSMutableArray alloc] init];
    
    for (Collidable* object in self.children) {
        if ([self.collidedObjects containsObject:object]) {
            [currentObjects addObject:object];
        } else {
            if ([object respondsToSelector:@selector(collidableType)]) {
                if (object.collidableType == ASTEROID &&
                    [self.spaceship checkCollisionWith:object]) {
                    [currentObjects addObject:object];
                    self.spaceship.health -= object.damageInflict;
                    [object removeFromParent];
                } else if (object.collidableType == SPACESHIP_BULLET) {
                    [self processBulletCollisions:object currentObjects:currentObjects];
                } else if (object.collidableType == ENEMY_BULLET &&
                           [self.spaceship checkCollisionWith:object]) {
                    [currentObjects addObject:object];
                    [object removeFromParent];
                    self.spaceship.health -= object.damageInflict;
                    [self applyCollisionAnimation:self.spaceship];
                } else if (object.collidableType == PICKUP &&
                           [self.spaceship checkCollisionWith:object]) {
                    Pickup *pickup = (Pickup *)object;
                    pickup.pickupAction(self);
                    [currentObjects addObject:object];
                    [object removeFromParent];
                }
            }
        }
    }
    
    self.collidedObjects = [currentObjects copy];
}


- (void)updateScore {
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
}


- (void)checkUpgrades:(float)currentTime currentTimeDeciSeconds:(NSInteger)currentTimeDeciSeconds {
    if (self.spaceship.upgradedBulletTypeExpiry <= currentTime) {
        self.spaceship.upgradedBulletTypeExpiry = -1;
        self.spaceship.bulletType = SINGLE_BULLET;
    }
    
    if (currentTimeDeciSeconds % 50 == 0 &&
        currentTimeDeciSeconds != self.lastPickupSpawnTime) {

        PickupType randomPickupType = (PickupType)(arc4random() % (int)(PICKUP_ONE_SHOT_KILL + 1));
        
        self.lastPickupSpawnTime = currentTimeDeciSeconds;
        [self addChild:[[Pickup alloc] initWithType:randomPickupType]];
    }
}


- (void)healthCheck {
    if (self.spaceship.health <= 0) {
        self.gameOver = true;

        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        [self.view presentScene:self.parentScene transition:reveal];
    }
    
    self.healthBar.size = CGSizeMake(self.spaceship.health * (IPAD_WIDTH / SPACESHIP_DEFAULT_HEALTH), HEALTH_BAR_HEIGHT);
}


- (void)update:(CFTimeInterval)currentTime {
    self.lastCurrentTime = currentTime;
    NSInteger currentTimeDeciSeconds = floor(currentTime * DECI_SECONDS_PER_SECOND);
    
    if (self.startTime == 0) {
        self.startTime = currentTimeDeciSeconds;
    }
    
    [self spawnAsteroid:currentTimeDeciSeconds];
    [self spawnEnemyShip:currentTimeDeciSeconds];
    [self enemyShipsShoot:currentTimeDeciSeconds];
    [self spaceshipShoot:currentTimeDeciSeconds];
    [self checkUpgrades:currentTime currentTimeDeciSeconds:currentTimeDeciSeconds];
    [self getAllCollisions];
    [self updateScore];
    
    if (self.gameOver == false) {
        [self healthCheck];
    }
    
    self.spaceship.xVelocity = self.gyrogloveTilt.x;
    self.spaceship.yVelocity = self.gyrogloveTilt.y;
    
    [self.spaceship update];
}
@end