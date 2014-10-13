//
//  QuestionListViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-27.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "QuestionListViewController.h"
#import "AppDelegate.h"
#import "QuestionSingleCell.h"
#import "RHTableView.h"
#import "NSDictionary+expanded.h"

@interface QuestionListViewController ()

@end

@implementation QuestionListViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"NEWS DETAIL"];
    [self setLeftItemWithImage:@"navigationbar_back.png" orTitle:nil sel:@selector(backButtonClicked:)];
    
    [self initData];
    
}

- (void)initData{
    NSString *urlStr = [NSString stringWithFormat:kGetQuestionnaireList,@"GetQuestionsList",_qi_id,nil,nil,@"0",@"30"];
    [NetEngine createGetAction:urlStr onCompletion:^(id resData, id resString, BOOL isCache) {
        if (resData && !isCache) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[resData valueForJSONKey:@"value"]];
            
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource

- (CGFloat)tableView:(RHTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(RHTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
