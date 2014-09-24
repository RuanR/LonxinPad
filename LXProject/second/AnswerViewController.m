//
//  AnswerViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-20.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "AnswerViewController.h"
#import "AppDelegate.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [kShareApp.baseTabbar hideTabbar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [kShareApp.baseTabbar showTabbar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"ANSWER"];
    [self setLeftItemWithImage:@"navigationbar_back.png" orTitle:nil sel:@selector(backButtonClicked:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
