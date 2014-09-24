//
//  ProductDetailViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-22.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "AppDelegate.h"

@interface ProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ProductDetailViewController

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
    
    [self setNavTitle:@"IMPROVE DETAIL"];
    [self setLeftItemWithImage:@"navigationbar_back.png" orTitle:nil sel:@selector(backButtonClicked:)];
    
    //获取产品详情
    [self getProductDetail];
}

//获取产品详情
- (void)getProductDetail{
    NSString *urlStr = [NSString stringWithFormat:kGetProductDetai,_productNo];
    [NetEngine createGetAction:urlStr onCompletion:^(id resData, id resString, BOOL isCache) {
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
