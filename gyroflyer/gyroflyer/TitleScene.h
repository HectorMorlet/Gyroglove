//
//  TitleScene.h
//  gyroflyer
//
//  Created by Hector Morlet on 24/09/2014.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"


#define TITLE_SCREEN_R 0.06
#define TITLE_SCREEN_G 0.27
#define TITLE_SCREEN_B 0.4

#define START_SCREEN_FONT_SIZE 60
#define SCORE_FONT_SIZE 180

#define START_SCREEN_FRACTION_FROM_BOTTOM 5

#define START_SCREEN_Z 100

#define GAME_OVER_SCREEN_TEXT @"Game Over! Tap to Restart"
#define START_SCREEN_TEXT @"Tap to Start"


@interface TitleScene : SKScene

@property CGPoint gyrogloveTilt;
@property bool firstTime;

- (id)initWithSize:(CGSize)size score:(NSInteger)score;

@end
