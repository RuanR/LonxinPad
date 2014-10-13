//
//  AnswerDetailViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-27.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "AnswerDetailViewController.h"
#import "AppDelegate.h"
#import "NSDictionary+expanded.h"
#import "QuestionListViewController.h"

@interface AnswerDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *txtView;

@end

@implementation AnswerDetailViewController

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
    
    [self setNavTitle:[_infoDic valueForJSONStrKey:@"qi_Titel"]];
    [self setLeftItemWithImage:@"navigationbar_back.png" orTitle:nil sel:@selector(backButtonClicked:)];
    
    _txtView.text = [_infoDic valueForJSONStrKey:@"qi_descript"];
}

- (IBAction)submitButtonClicked:(id)sender {
    QuestionListViewController *answerDetail = [[QuestionListViewController alloc] init];
    answerDetail.qi_id = [_infoDic valueForJSONStrKey:@"qi_id"];
    [self.navigationController pushViewController:answerDetail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
