//
//  BaseViewController.h
//  LXProject
//
//  Created by 孙向前 on 14-9-18.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RHTableView;

@interface BaseViewController : UIViewController

@property (nonatomic,strong) id  userInfo;
@property (nonatomic,strong) id  otherInfo;

@property (nonatomic,strong) IBOutlet RHTableView *tableView;

- (IBAction)backButtonClicked:(id)sender;

- (void)setNavTitle:(NSString *)title;
- (void)setLeftItemWithImage:(NSString *)image orTitle:(NSString *)title sel:(SEL)selector;
- (void)setRightItemWithImage:(NSString *)image orTitle:(NSString *)title sel:(SEL)selector;

- (void)pushController:(Class)controller withInfo:(id)info;
- (void)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title;
- (void)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other;

- (BOOL)popController:(NSString*)controller withSel:(NSString*)sel withObj:(id)info;

@end
