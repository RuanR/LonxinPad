//
//  AboutViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-18.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "AboutViewController.h"
#import "NSDictionary+expanded.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"ABOUT"];
    
    [self initData:@"6"];
}

- (void)initData:(NSString *)AticleNo
{
    NSString *urlstr = [NSString stringWithFormat:kGetAbout,kUserid,AticleNo];
    [NetEngine createGetAction:urlstr onCompletion:^(id resData, id resString, BOOL isCache) {
        if (resString && !isCache) {
            [self.webView loadHTMLString:resString baseURL:nil];
        }
    }];
}

- (IBAction)changeInfoClicked:(UIButton *)sender {
    [self initData:[NSString stringWithFormat:@"%d",sender.tag]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
