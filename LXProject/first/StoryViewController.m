//
//  StoryViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-18.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "StoryViewController.h"
#import "RHTableView.h"
#import "TableViewCell.h"
#import "NSDictionary+expanded.h"

@interface StoryViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblVt;
@property (weak, nonatomic) IBOutlet UILabel *lblVl;
@property (weak, nonatomic) IBOutlet UILabel *lblSignature;
@property (weak, nonatomic) IBOutlet UIWebView *webView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageHeader;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *web_scConstraint;

@end

@implementation StoryViewController

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
    [self setNavTitle:@"STORY"];
    
    [self initData];

    _webView1.delegate = self;
}

- (void)initData{
    NSString *urlstr = [NSString stringWithFormat:kGetImproveList,@"2",@"4",@"%@",@"%@"];
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
    DLog(@"%@",self.tableView.dataArray);
    if (!indexPath.row) {
        [self loadScrollviewData:indexPath.row];
    }
    
    NSString *urlStr = [self.tableView.dataArray[indexPath.row] valueForJSONStrKey:@"im_TabletImage"];
    NSURL *url = [NSURL URLWithString:urlStr];
    [cell.imageVIew setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    return cell;
}

- (void)tableView:(RHTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadScrollviewData:indexPath.row];
}

- (void)loadScrollviewData:(NSInteger)row{
    NSString *im_no = [self.tableView.dataArray[row] valueForJSONStrKey:@"im_ArticleID"];
    NSString *urlstr = [NSString stringWithFormat:kGetArtDetail,im_no,kUserid];
    [NetEngine createGetAction:urlstr onCompletion:^(id resData, id resString, BOOL isCache) {
        DLog(@"%@",resData);
        if (resData && !isCache) {
            NSDictionary *dic = [resData valueForJSONKey:@"value"];
            _lblTitle.text = [dic valueForJSONStrKey:@"st_Title"];
            _lblPosition.text = [dic valueForJSONStrKey:@"st_Position"];
            _lblVt.text = [dic valueForJSONStrKey:@"st_InterviewTime"];
            _lblVl.text = [dic valueForJSONStrKey:@"st_interviewLocation"];
            _lblSignature.text = [dic valueForJSONStrKey:@"st_Signature"];
            
            NSURL *url = [NSURL URLWithString:[dic valueForJSONStrKey:@"st_InterviewsHead"]];
            [_imageHeader setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
            [self loadWebview:[dic valueForJSONStrKey:@"st_Picture"]];
            NSString *htmlstr = [dic valueForJSONStrKey:@"st_Content"];
            [_webView1 loadHTMLString:htmlstr baseURL:nil];
        }
        
    }];
}

- (void)loadWebview:(NSString *)url
{
    //web页面数据
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    webView.userInteractionEnabled = NO;
    [_mainScrollview setContentSize:CGSizeMake(_mainScrollview.frame.size.width, webView.frame.origin.y + newFrame.size.height + 6.f)];

    [_web_scConstraint setConstant:-newFrame.size.height];
    DLog(@"%@",_web_scConstraint);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
