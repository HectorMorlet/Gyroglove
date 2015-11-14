//
//  ViewController.m
//  gyroflyer
//
//  Created by Hector Morlet on 16/09/2014.
//  Copyright (c) 2014 HamLann. All rights reserved.
//


#import "ViewController.h"
#import "GameScene.h"
#import "TitleScene.h"


@interface ViewController ()

@property UIAlertView *shownAlert;
@property TitleScene* titleScene;
@property DFBlunoManager *bluetoothDevice;

@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    self.titleScene = [[TitleScene alloc] initWithSize:skView.bounds.size score:-1];
    self.titleScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:self.titleScene];
    
    self.shownAlert = [[UIAlertView alloc] initWithTitle:@"Initialising Bluetooth"
                                                    message:@"One moment..."
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [self.shownAlert show];
    
    self.bluetoothDevice = [DFBlunoManager sharedInstance];
    self.bluetoothDevice.delegate = self;
}

- (void)didDiscoverDevice:(DFBlunoDevice *)dev {
    NSLog(@"Trying to connect");
    NSLog(@"I found: %@", dev.identifier);
    if ([dev.identifier isEqualToString:@"BC072AB6-F061-37D1-2802-D547A9CCAFF1"]) {
        NSLog(@"Found target");
        [self.bluetoothDevice connectToDevice:dev];
    }
}


- (void)didDisconnectDevice:(DFBlunoDevice *)dev {
    NSLog(@"Uhhhh crud");
    [self.shownAlert dismissWithClickedButtonIndex:0 animated:YES];
        self.shownAlert = [[UIAlertView alloc] initWithTitle:@"Connction lost!"
                                                     message:@"Hang on a moment, reconnecting..."
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil];
        [self.shownAlert show];
    
    [self.bluetoothDevice stop];
    [self.bluetoothDevice scan];
}

- (void)readyToCommunicate:(DFBlunoDevice *)dev {
    [self.shownAlert dismissWithClickedButtonIndex:0 animated:YES];
    
//    self.shownAlert = [[UIAlertView alloc] initWithTitle:@"SUCCESS!"
//                                                 message:@"YEAHHHHHHHHHH!!11111"
//                                                delegate:self
//                                       cancelButtonTitle:@"lolwut ok"
//                                       otherButtonTitles:nil];
//    [self.shownAlert show];
//    NSString* msg = @"THIS IS A TEST";
//    NSLog(@"Sending msg");
    
//    [self.bluetoothDevice writeDataToDevice:[msg dataUsingEncoding:NSASCIIStringEncoding] Device:dev];
}

- (void)didReceiveData:(NSData *)data Device:(DFBlunoDevice *)dev {
    NSString *coordinateRegex = @"\\-?[0-9]+\\.?[0-9]+";
    NSError* error = nil;
    NSRegularExpression *coordinatePattern = [NSRegularExpression regularExpressionWithPattern:coordinateRegex options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"%@", error.description);
    }
    
//    const unsigned char *buf = data.bytes;
//    NSInteger i;
//    NSLog(@"START BYTE");
//    for (i=0; i<data.length; ++i) {
//        NSLog(@"%c", buf[i]);
//    }
//    NSLog(@"END BYTE");

    
    
    NSString* receivedData = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSArray *results = [coordinatePattern matchesInString:receivedData options:0 range:NSMakeRange(0, receivedData.length)];
    
    float y = 0;
    float x = 0;
    
    BOOL hasX = false;
    
    for (NSUInteger matchIdx = 0; matchIdx < results.count; matchIdx++) {
        NSTextCheckingResult *match = [results objectAtIndex:matchIdx];
        NSRange matchRange = [match range];
        NSString *result = [receivedData substringWithRange:matchRange];
        
        if ([result floatValue] < -1000 || [result floatValue] > 1000) {
            hasX = false;
            NSLog(@"Corrupted data, dropping.");
            break;
        }
        
        if (!hasX) {
            x = [result floatValue];
            hasX = true;
        } else {
            y = [result floatValue];
            break;
        }
    }
    
    if (hasX) {
        
        if (x > 100.0) {
            x = 100.0;
        }
        if (x < -100.0) {
            x = -100.0;
        }
        
        if (y > 100.0) {
            y = 100.0;
        }
        if (y < -100.0) {
            y = -100.0;
        }
        
        self.titleScene.gyrogloveTilt = CGPointMake(x * -2, (y * -2));
    }\
}

- (void)bleDidUpdateState:(BOOL)bleSupported {
    if (bleSupported) {
        [self.shownAlert dismissWithClickedButtonIndex:-1 animated:YES];
        self.shownAlert = [[UIAlertView alloc] initWithTitle:@"Connecting to Gyroglove..."
                                                     message:@"Please make sure the Arduino is powered on and running"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
        [self.shownAlert show];
        
        [self.bluetoothDevice scan];
        
    } else {
        [self.shownAlert dismissWithClickedButtonIndex:-1 animated:YES];
        self.shownAlert = [[UIAlertView alloc] initWithTitle:@"Bluetooth is not turned on!"
                                                     message:@"Bluetooth is currently not turned on or is unavailable"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
        [self.shownAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

}


- (BOOL)shouldAutorotate {
    return NO;
}


- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
