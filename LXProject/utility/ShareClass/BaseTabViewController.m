//
//  BaseTabViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-19.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "BaseTabViewController.h"
#import "BaseNavigationViewController.h"

#import "NewsViewController.h"
#import "ProductViewController.h"
#import "ImproverViewController.h"
#import "InteractiveViewController.h"
#import "AfterSalesViewController.h"
#import "StoryViewController.h"
#import "AboutViewController.h"

#import "UIView+expanded.h"

@interface BaseTabViewController (){
    UIImageView *notify;
    UIImageView *selectBackgroud;
}

@end

@implementation BaseTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setHidden:YES];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    self.tabBar.frameHeight = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initViewController];
    [self _initTabbarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化子控制器
-(void)_initViewController
{
    NewsViewController *oneCtrl = [[NewsViewController alloc]init];
    ProductViewController *twoCtrl = [[ProductViewController alloc]init];
    ImproverViewController *threeCtrl = [[ImproverViewController alloc]init];
    StoryViewController *fourCtrl = [[StoryViewController alloc]init];
    AboutViewController *fiveCtrl = [[AboutViewController alloc]init];
    InteractiveViewController *sixCtrl = [[InteractiveViewController alloc]init];
    AfterSalesViewController *sevenCtrl = [[AfterSalesViewController alloc]init];
    
    NSArray *views = @[oneCtrl, twoCtrl, threeCtrl, sixCtrl, sevenCtrl, fourCtrl, fiveCtrl];
    NSMutableArray *viewConrollers=[NSMutableArray arrayWithCapacity:7];
    for (UIViewController *viewController in views) {
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:viewController];
        [viewConrollers addObject:nav];
    }
    
    self.viewControllers = viewConrollers;
}

//自定义tabBarView
-(void)_initTabbarView
{
    //选中背景
    double btnHight = 112, btnWidth = 138;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreenWidth-btnWidth, kVersion7 ? 64 : 44, btnWidth, kScreenHeight - (kVersion7 ? 64 : 44))];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad主菜单渐变底色.png"]];
    [self.view addSubview:_scrollView];
    
    //添加通知提示
//    notify = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 + 10, 7, 8, 8)];
//    [notify setBackgroundColor:[UIColor redColor]];
    
    //添加按钮
    NSArray *titles = @[@"NEWS", @"PRODUCT", @"IMPROVE", @"INTERACT", @"SALES", @"STORY", @"ABOUT"];
    
    
    for (int i = 1; i<=titles.count; i++) {
        
        NSString *title = titles[i - 1];
        UIButton *button = [[UIButton alloc]init];
        button.frame = CGRectMake(0, (i-1) * btnHight, btnWidth, btnHight);
        button.tag=i;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:button];
        
        //间隔线
        UIImageView *space = [[UIImageView alloc] initWithFrame:CGRectMake(18, i * btnHight, 120, 1)];
//        [space setImage:[UIImage imageNamed:@"ipad分割线.png"]];
        [space setBackgroundColor:[UIColor redColor]];
        [_scrollView addSubview:space];
        
    }
    
    selectBackgroud = [[UIImageView alloc] initWithFrame:CGRectMake(btnWidth - 50, 5, 50, 102)];
    selectBackgroud.image = [UIImage imageNamed:@"ipad点中.png"];
    selectBackgroud.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:selectBackgroud];
    
    _scrollView.contentSize = CGSizeMake(btnWidth, 112 * titles.count);
    
    [self addConstraints];

}

- (void)addConstraints{
    NSArray *hArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[scrollView]-|"
                                                             options:0
                                                             metrics:nil
                                                               views:@{@"scrollView":self.scrollView}];
    NSArray *vArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[scrollView]-|"
                                                              options:0
                                                              metrics:nil
                                                                views:@{@"scrollView":self.scrollView}];
    [self.view addConstraints:hArray];
    [self.view addConstraints:vArray];
    
}

-(void)selectedTab:(UIButton *)button
{
    for (UIButton *btn in self.scrollView.subviews) {
        if (btn.tag >= 1 && btn.tag <= 7) {
            btn.selected = NO;
        }
    }
    self.selectedIndex = button.tag - 1;
    selectBackgroud.frameY = button.frameY + 5;
}


// 隐藏tabbar
- (void)hideTabbar
{
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.frameX = kScreenWidth;
    }];
}

// 展示tabbar
- (void)showTabbar
{
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.frameX = kScreenWidth - _scrollView.frameWidth;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
