//
//  ProductViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-18.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "ProductViewController.h"
#import "AppDelegate.h"
#import "NSDictionary+expanded.h"
#import "RHTableView.h"
#import "RHMethods.h"
#import "UIView+expanded.h"
#import "ProductDetailViewController.h"

@interface ProductViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet RHTableView *mainTableView;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation ProductViewController

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
    [self setNavTitle:@"PRODUCT"];
    
    //第一阶级数据
    self.dataArray = @[
                       @{@"photo":@"product_image1.png",@"className":@"General Dynamics"},
                       @{@"photo":@"product_image2.png",@"className":@"Generator"},
                       @{@"photo":@"product_image3.png",@"className":@"Water Pump"},
                       @{@"photo":@"product_image4.png",@"className":@"Tillers"},
                       ];
    
    //获取图片
    [self getHeaderPicture];
    //获取产品列表
    [self getProductList:@"1"];
}

//获取图片
- (void)getHeaderPicture{
    NSString *urlstr = [NSString stringWithFormat:kGetAdImage,@"Product"];
    [NetEngine createGetAction:urlstr onCompletion:^(id resData, id resString, BOOL isCache) {
        DLog(@"%@",resData);
        if (resData && !isCache) {
            NSURL *url = [NSURL URLWithString:[resData valueForJSONStrKeys:@"value",@"sp_value", nil]];
            [_headerImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
    }];
}

//获取产品列表
- (void)getProductList:(NSString *)group{
    NSString *urlstr = [NSString stringWithFormat:kGetProductList,group,@"%@",@"%@"];
    [self.tableView loadUrl:urlstr];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_mainTableView]) {
        return 55;
    } else {
        return 70;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_mainTableView]) {
        return _dataArray.count;
    }
    return self.tableView.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier;
    BOOL isMainTable = [tableView isEqual:_mainTableView];
    identifier = isMainTable ? @"Cell" : @"Cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineview = [RHMethods viewWithFrame:CGRectMake(15, isMainTable ? 43 : 68, cell.frameWidth - 15, 1) bgcolor:[UIColor redColor] alpha:1];
        [cell.contentView addSubview:lineview];
        
    }
    if (isMainTable) {
        NSDictionary *dic = _dataArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[dic valueForJSONStrKey:@"photo"]];
        cell.textLabel.text = [dic valueForJSONStrKey:@"className"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frameWidth, 70 - 2)];
        NSURL *ulr = [NSURL URLWithString:[self.tableView.dataArray[indexPath.row] valueForJSONStrKey:@"pr_TabletImage"]];
        [imageview setImageWithURL:ulr placeholderImage:[UIImage imageNamed:@""]];
        [cell.contentView addSubview:imageview];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_mainTableView]) {
        [self getProductList:[NSString stringWithFormat:@"%d",indexPath.row + 1]];
    } else {
        ProductDetailViewController *detail = [[ProductDetailViewController alloc] init];
        detail.productNo = [self.tableView.dataArray[indexPath.row] valueForJSONStrKey:@"pr_No"];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
