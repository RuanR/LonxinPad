//
//  ImproverViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-18.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "ImproverViewController.h"
#import "RHTableView.h"
#import "TableViewCell.h"
#import "NSDictionary+expanded.h"

@interface ImproverViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ImproverViewController

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
    [self setNavTitle:@"IMPROVE"];
    
    [self getImproveList];
}

-(void)getImproveList{
    NSString *urlstr = [NSString stringWithFormat:kGetImproveList,@"1",@"1",@"%@",@"%@"];
    [self.tableView loadUrl:urlstr];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource

- (CGFloat)tableView:(RHTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 275;
}

- (NSInteger)tableView:(RHTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(RHTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (!indexPath.row) {
        NSString *im_no = [tableView.dataArray[indexPath.row] valueForJSONStrKey:@"im_No"];
        [self loadWebview:im_no];
    }
    
    NSString *urlStr = [self.tableView.dataArray[indexPath.row] valueForJSONStrKey:@"im_TabletImage"];
    NSURL *url = [NSURL URLWithString:urlStr];
    [cell.imageVIew setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    return cell;
}

- (void)tableView:(RHTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *im_no = [tableView.dataArray[indexPath.row] valueForJSONStrKey:@"im_No"];
    [self loadWebview:im_no];
}

- (void)loadWebview:(NSString *)im_No
{
    //web页面数据
    NSString *url = [NSString stringWithFormat:@"http://121.199.48.115/APP_Service/GetArticle.aspx?id=%@&user=%@&edition=1", im_No, kUserid];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
