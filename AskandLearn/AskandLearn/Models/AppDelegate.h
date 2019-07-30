//
//  AppDelegate.h
//  AskandLearn
//
//  Created by estherb on 7/15/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PubNub/PubNub.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, PNObjectEventListener>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) PubNub *pubnub;


@end

