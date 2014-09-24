//
//  NewsViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-18.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "NewsViewController.h"
#import "AppDelegate.h"
#import "NewsCell.h"
#import "NetEngine.h"
#import "NSDictionary+expanded.h"
#import "EScrollerView.h"
#import "NewsDetailViewController.h"
#import "AnswerViewController.h"
#import "Utility.h"
#import "RHTableView.h"

@interface NewsViewController ()<EScrollerViewDelegate>{
    NSMutableArray *images;
    NSMutableArray *titles;
}

@property (weak, nonatomic) IBOutlet UIImageView *leftTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *letBottomImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIImageView *middleLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleRightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImageView;

@end

@implementation NewsViewController

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
    [self setNavTitle:@"NEWS"];
    
    images = [[NSMutableArray alloc] init];
    titles = [[NSMutableArray alloc] init];
    self.otherInfo = [NSMutableArray arrayWithCapacity:5];
    
    //广告轮播图片
    [self getAdsPicture];
    //xib剩下的imageview
    [self getScreenPicture];
    //文章列表
    [self getNewsList];
}

//获取新闻列表
- (void)getNewsList{
    NSString *urlStr = [NSString stringWithFormat:kArticleList,@"1",@"%@",@"%@"];
    [self.tableView loadUrl:urlStr];
}

//获取广告数据
- (void)getAdsPicture{
    NSString *urlStr = [NSString stringWithFormat:kGetImageList,@"1",@"5"];
    [NetEngine createGetAction:urlStr onCompletion:^(id resData, id resString, BOOL isCache) {
        DLog(@"%@",resData);
        if (resData && !isCache) {
            self.userInfo = [resData valueForJSONKey:@"value"];
            for (NSDictionary *dic in self.userInfo) {
                [images addObject:[dic valueForJSONKey:@"sp_value"]];
                [titles addObject:[dic valueForKey:@"sp_descript"]];
            }
            [self createScrolPicture];
        }
    }];
}

#pragma mark - EScrollerViewDelegate

- (void)EScrollerViewDidClicked:(NSUInteger)index{
    NewsDetailViewController *newsdetail = [[NewsDetailViewController alloc] init];
    newsdetail.newsModelNo = [self.userInfo[index - 1] valueForJSONStrKey:@"sp_value1"];
    [self.navigationController pushViewController:newsdetail animated:YES];
}

//获取另外5张图片
- (void)getScreenPicture{
    NSArray *keys = @[@"News1", @"News2", @"News3", @"News4", @"News5"];
    NSString *urlstr = [NSString stringWithFormat:kGetAdImage,keys[0]];
    [NetEngine createGetAction:urlstr onCompletion:^(id resData, id resString, BOOL isCache) {
        DLog(@"%@",resData);
        if (resData && !isCache) {
            [self.otherInfo addObject:[resData valueForJSONKey:@"value"]];
            NSURL *url = [NSURL URLWithString:[resData valueForJSONStrKeys:@"value",@"sp_value", nil]];
            [_leftTopImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
    }];
    
    urlstr = [NSString stringWithFormat:kGetAdImage,keys[1]];
    [NetEngine createGetAction:urlstr onCompletion:^(id resData, id resString, BOOL isCache) {
        DLog(@"%@",resData);
        if (resData && !isCache) {
            [self.otherInfo addObject:[resData valueForJSONKey:@"value"]];
            NSURL *url = [NSURL URLWithString:[resData valueForJSONStrKeys:@"value",@"sp_value", nil]];
            [_letBottomImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
    }];

    urlstr = [NSString stringWithFormat:kGetAdImage,keys[2]];
    [NetEngine createGetAction:urlstr onCompletion:^(id resData, id resString, BOOL isCache) {
        DLog(@"%@",resData);
        if (resData && !isCache) {
            [self.otherInfo addObject:[resData valueForJSONKey:@"value"]];
            NSURL *url = [NSURL URLWithString:[resData valueForJSONStrKeys:@"value",@"sp_value", nil]];
            [_middleRightImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
    }];

    urlstr = [NSString stringWithFormat:kGetAdImage,keys[3]];
    [NetEngine createGetAction:urlstr onCompletion:^(id resData, id resString, BOOL isCache) {
        DLog(@"%@",resData);
        if (resData && !isCache) {
            [self.otherInfo addObject:[resData valueForJSONKey:@"value"]];
            NSURL *url = [NSURL URLWithString:[resData valueForJSONStrKeys:@"value",@"sp_value", nil]];
            [_middleLeftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
    }];

    urlstr = [NSString stringWithFormat:kGetAdImage,keys[4]];
    [NetEngine createGetAction:urlstr onCompletion:^(id resData, id resString, BOOL isCache) {
        DLog(@"%@",resData);
        if (resData && !isCache) {
            [self.otherInfo addObject:[resData valueForJSONKey:@"value"]];
            NSURL *url = [NSURL URLWithString:[resData valueForJSONStrKeys:@"value",@"sp_value", nil]];
            [_rightBottomImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
    }];
}

- (IBAction)imageViewClicked:(UITapGestureRecognizer *)sender {
    DLog(@"%@",self.otherInfo);
    switch (sender.view.tag) {
        case 13:
        {
            AnswerViewController *answer = [[AnswerViewController alloc] init];
            [self.navigationController pushViewController:answer animated:YES];
        }
            break;
        case 12:
        {
            UIButton *btn = (UIButton *)[kShareApp.baseTabbar.scrollView viewWithTag:3];
            [kShareApp.baseTabbar selectedTab:btn];
        }
            break;
        default:
        {
            NewsDetailViewController *detailCtrl = [[NewsDetailViewController alloc] init];
            detailCtrl.newsModelNo = [self.otherInfo[sender.view.tag - 10] valueForJSONStrKey:@"sp_value1"];
            [self.navigationController pushViewController:detailCtrl animated:YES];
        }
            break;
    }
}


#pragma mark - EScrollerViewDelegate
- (void)createScrolPicture{
    EScrollerView *escroll = [[EScrollerView alloc] initWithFrameRect:CGRectMake(146, 14, 484, 285) ImageArray:images TitleArray:titles];
    escroll.delegate = self;
    [escroll autoScroll];
    [self.view addSubview:escroll];
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
    NSDate *historyDate = [Utility defaultsForKey:@"historyDate"];
    BOOL isEarly = [Utility isEarlyByCompareDate:historyDate dateFormat:dateStr];
    cell.btnImage.hidden = !isEarly;
    
    if (indexPath.row == tableView.dataArray.count - 1) {
        [Utility saveToDefaults:[NSDate date] forKey:@"historyDate"];
    }
    return cell;
}

- (void)tableView:(RHTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailViewController *detailCtrl = [[NewsDetailViewController alloc] init];
    detailCtrl.newsModelNo = [tableView.dataArray[indexPath.row] valueForJSONStrKey:@"ar_No"];
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
