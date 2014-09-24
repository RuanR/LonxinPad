//
//  AfterSalesViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-18.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "AfterSalesViewController.h"
#import "UIView+expanded.h"
#import "RHTableView.h"
#import "NSDictionary+expanded.h"
#import "NewsCell.h"
#import "Utility.h"
#import "NewsDetailViewController.h"

@interface AfterSalesViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblSex;
@property (weak, nonatomic) IBOutlet UILabel *lblContry;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;

@property (weak, nonatomic) IBOutlet UIView *userView;
@end

@implementation AfterSalesViewController

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
    [self setNavTitle:@"SALES"];
    
    [_btnOk roundCorner];
    [_txtContent roundCorner];
    [_txtTitle roundCorner];
    
    [self initData];
    
}

- (void)initData{
    NSString *urlStr = [NSString stringWithFormat:kArticleList,@"4",@"%@",@"%@"];
    [self.tableView loadUrl:urlStr];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource

- (CGFloat)tableView:(RHTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (NSInteger)tableView:(RHTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(RHTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lblTitle.text = [tableView.dataArray[indexPath.row] valueForJSONStrKey:@"ar_Title"];
    NSString *dateStr = [tableView.dataArray[indexPath.row] valueForJSONStrKey:@"ar_ReleaseTime"];
    cell.lblSubtitle.text = dateStr;
    NSDate *historyDate = [Utility defaultsForKey:@"historyAr_Date"];
    BOOL isEarly = [Utility isEarlyByCompareDate:historyDate dateFormat:dateStr];
    cell.btnImage.hidden = !isEarly;
    
    if (indexPath.row == tableView.dataArray.count - 1) {
        [Utility saveToDefaults:[NSDate date] forKey:@"historyAr_Date"];
    }
    return cell;
}

- (void)tableView:(RHTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailViewController *newsdetail = [[NewsDetailViewController alloc] init];
    newsdetail.newsModelNo = [tableView.dataArray[indexPath.row] valueForJSONStrKey:@"ar_No"];
    [self.navigationController pushViewController:newsdetail animated:YES];
}

- (IBAction)okButtonClicked:(id)sender {
    [self.view endEditing:YES];
    NSString *title = _txtTitle.text;
    NSString *content = _txtContent.text;
    if (!title.length || !content.length) {
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:kAddMassage,title,content,kUserid];
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
