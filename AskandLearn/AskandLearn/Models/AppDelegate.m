//
//  AppDelegate.m
//  AskandLearn
//
//  Created by estherb on 7/15/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"askandlearn";
        configuration.server = @"http://askandlearn.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    
    if (PFUser.currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    }
    
    return YES;
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
////This method will handle all the callbacks from the LinkedIn API call to your iOS application.
//{
//    if ([LISDKCallbackHandler shouldHandleUrl:url])
//    {
//        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//    }
//    return YES;
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
