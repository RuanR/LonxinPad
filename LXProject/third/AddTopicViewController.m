//
//  AddTopicViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-26.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "AddTopicViewController.h"
#import "AppDelegate.h"

@interface AddTopicViewController ()

@property (weak, nonatomic) IBOutlet UITextField *postTitle;
@property (weak, nonatomic) IBOutlet UITextField *postContent;

@end

@implementation AddTopicViewController

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
    
    [self setNavTitle:@"NEWS DETAIL"];
    [self setLeftItemWithImage:@"navigationbar_back.png" orTitle:nil sel:@selector(backButtonClicked:)];
}


- (IBAction)submit:(id)sender{

}

- (IBAction)photo:(id)sender{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
