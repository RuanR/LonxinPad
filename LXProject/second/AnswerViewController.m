//
//  AnswerViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-20.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "AnswerViewController.h"
#import "AppDelegate.h"
#import "RHTableView.h"
#import "QuestionListCell.h"
#import "NSDictionary+expanded.h"
#import "AnswerDetailViewController.h"

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
    [self setNavTitle:@"Question"];
    [self setLeftItemWithImage:@"navigationbar_back.png" orTitle:nil sel:@selector(backButtonClicked:)];
    
    [self initData];
}

- (void)initData{
    NSString *urlStr = [NSString stringWithFormat:kGetQuestionnaireList,@"GetQuestionnaireList",nil,nil,nil,@"%@",@"%@"];
    [self.tableView loadUrl:urlStr];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource

- (CGFloat)tableView:(RHTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(RHTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(RHTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    QuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionListCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = tableView.dataArray[indexPath.row];
    cell.lblTitle.text = [dic valueForJSONStrKey:@"qi_Titel"];
    cell.lblTime.text = [dic valueForJSONStrKey:@"qi_IssueTime"];
    return cell;
}

- (void)tableView:(RHTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerDetailViewController *answerDetail = [[AnswerDetailViewController alloc] init];
    answerDetail.infoDic = tableView.dataArray[indexPath.row];
    [self.navigationController pushViewController:answerDetail animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
