//
//  InteractiveViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-18.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "InteractiveViewController.h"
#import "RHTableView.h"
#import "NSString+expanded.h"

@interface InteractiveViewController ()

@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *txtUserNo;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;


@end

@implementation InteractiveViewController

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
    [self setNavTitle:@"INTERACT"];
}

- (void)initData{
    NSString *urlStr = [NSString stringWithFormat:kGetPostsListt,kUserid,kUserLevel,@"%@",@"%@"];
    [self.tableView loadUrl:urlStr];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource

- (CGFloat)tableView:(RHTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(RHTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DLog(@"%@",tableView.dataArray);
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(RHTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(RHTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//弹框
- (IBAction)loginOrOutButtonClicked:(id)sender {
    _loginView.hidden = NO;
}
//登陆
- (IBAction)loginButtonClicked:(id)sender {
    
    NSString *userNO = _txtUserNo.text;
    NSString *password = _txtPassword.text;
    if (!userNO.length || !password.length) {
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:kLogin,userNO,password.md5];
    [NetEngine createGetAction:urlStr
                  onCompletion:^(id resData, id resString, BOOL isCache) {
                      DLog(@"%@",resData);
                      
                  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
