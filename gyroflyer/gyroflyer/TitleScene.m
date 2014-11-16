//
//  TitleScene.m
//  gyroflyer
//
//  Created by Hector Morlet on 24/09/2014.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import "TitleScene.h"


@interface TitleScene()

@property NSInteger startTime;

@property NSInteger lastAsteroidSpawnTime;
@property NSInteger lastEnemyShipSpawnTime;
@property CGPoint internalGyrogloveTilt;
@property GameScene* gameScene;

@property CGSize screenSize;


- (void)spawnEnemyShip:(NSInteger)currentTimeDeciSeconds;
- (void)spawnAsteroid:(NSInteger)currentTimeDeciSeconds;

@property SKLabelNode* startLabel;
@property SKLabelNode* scoreLabel;

@end


@implementation TitleScene

- (id)initWithSize:(CGSize)size score:(NSInteger)score {
    if (self = [super initWithSize:size]) {
        self.screenSize = size;
        
        [self setBackgroundColor:[UIColor colorWithRed:(TITLE_SCREEN_R)
                                                 green:(TITLE_SCREEN_G)
                                                  blue:(TITLE_SCREEN_B)
                                                 alpha:1.0f]];
        
        self.startLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        self.startLabel.fontSize = START_SCREEN_FONT_SIZE;
        self.startLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                         CGRectGetMidY(self.frame) / START_SCREEN_FRACTION_FROM_BOTTOM);
        self.startLabel.zPosition = START_SCREEN_Z;
        
        if (score > 0) {
            NSLog(@"Not -1 score");
            
            self.startLabel.text = GAME_OVER_SCREEN_TEXT;
            
            self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
            self.scoreLabel.fontSize = SCORE_FONT_SIZE;
            self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                             CGRectGetMidY(self.frame));
            self.scoreLabel.zPosition = START_SCREEN_Z;
            self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
            [self addChild:self.scoreLabel];
        } else {
            self.startLabel.text = START_SCREEN_TEXT;
        }
        
        [self addChild:self.startLabel];
    }
    
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.gameScene = [[GameScene alloc] initWithSize:self.screenSize];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    self.gameScene.parentScene = self;
    [self.view presentScene:self.gameScene transition:reveal];
}


- (void)update:(NSTimeInterval)currentTime {
    NSInteger currentTimeDeciSeconds = floor(currentTime * DECI_SECONDS_PER_SECOND);
    
    if (self.startTime == 0) {
        self.startTime = currentTimeDeciSeconds;
    }
    
    [self spawnAsteroid:currentTimeDeciSeconds];
    [self spawnEnemyShip:currentTimeDeciSeconds];
    
    if (self.gameScene.score > 0) {
        if (!self.scoreLabel) {
            self.startLabel.text = GAME_OVER_SCREEN_TEXT;
            
            self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
            self.scoreLabel.fontSize = SCORE_FONT_SIZE;
            self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                                   CGRectGetMidY(self.frame));
            self.scoreLabel.zPosition = START_SCREEN_Z;
            self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gameScene.score];
            [self addChild:self.scoreLabel];
        } else {
            self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gameScene.score];
        }
    }
    
    
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

            
- (void)setGyrogloveTilt:(CGPoint)gyrogloveTilt {
    self.internalGyrogloveTilt = gyrogloveTilt;
    self.gameScene.gyrogloveTilt = gyrogloveTilt;
}

- (CGPoint)gyrogloveTilt {
    return self.internalGyrogloveTilt;
}

@end
