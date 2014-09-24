//
//  BaseTabViewController.h
//  LXProject
//
//  Created by 孙向前 on 14-9-19.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabViewController : UITabBarController

@property (strong, nonatomic) UIScrollView *scrollView;

-(void)selectedTab:(UIButton *)button;

// 隐藏tabbar
- (void)hideTabbar;
// 展示tabbar
- (void)showTabbar;

@end
