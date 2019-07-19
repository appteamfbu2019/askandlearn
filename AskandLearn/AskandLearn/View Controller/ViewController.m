//
//  ViewController.m
//  AskandLearn
//
//  Created by estherb on 7/15/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "ViewController.h"
#import "Parse/Parse.h"
//have FeedViewController

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userNameTextField.text = @"myUsername";
    self.passwordTextField.text = @"myPassword";
    //self.emailTextField.text = @"myEmail@email.com";
}

@end
