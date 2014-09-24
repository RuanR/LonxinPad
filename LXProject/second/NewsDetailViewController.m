//
//  NewsDetailViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-20.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "AppDelegate.h"

@interface NewsDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NewsDetailViewController

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
    
    [self initData];
}

//web页面数据
- (void)initData{
    NSString *urlStr = [NSString stringWithFormat:kAdsDetail,_newsModelNo,kUserid];
    [NetEngine createGetAction:urlStr onCompletion:^(id resData, id resString, BOOL isCache) {
        DLog(@"%@___%@",resData,resString);
        if ([(NSString *)resString length]) {
            [_webView loadHTMLString:resString baseURL:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
