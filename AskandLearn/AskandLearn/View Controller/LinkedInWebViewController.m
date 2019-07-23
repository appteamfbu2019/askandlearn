//
//  LinkedInWebViewController.m
//  AskandLearn
//
//  Created by estherb on 7/18/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "LinkedInWebViewController.h"
#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1RequestSerializer.h"
#import "AFHTTPRequestOperationManager.h"

static NSString * const baseURLString = @"https://api.linkedin.com";
static NSString * const consumerKey = @"78nu9x8lyew6e7";
static NSString * const consumerSecret = @"tjXaGh42RUdA8o8z";

@interface LinkedInWebViewController ()

@end

@implementation LinkedInWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    return self;
}


@end
