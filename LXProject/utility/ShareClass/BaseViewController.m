//
//  BaseViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-18.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

#pragma mark - kReachabilityChangedNotification
-(void) reachabilityChanged:(NSNotification*) notification
{
    //if ([(Reachability*)[notification object] currentReachabilityStatus] == ReachableViaWiFi) {
    DLog(@"baseview  net changes.");
    //do some refresh
    //}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (kVersion7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
    
}

#pragma mark - navigationbar
- (void)setNavTitle:(NSString *)title{
    if (title.length) {
        self.navigationItem.title = title;
    }
}
- (void)setBackButton{
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setImage:[UIImage imageNamed:@"navigationbar_back.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.backBarButtonItem.customView = backbutton;
}
- (void)setLeftItemWithImage:(NSString *)image orTitle:(NSString *)title sel:(SEL)selector{
    
    UIButton *navLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    if(image)[navLeftButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if(title){
        [navLeftButton setTitle:title forState:UIControlStateNormal];
        [navLeftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -70, 0, 0)];
        navLeftButton.titleLabel.font = Font(19);
    }
    if(selector)[navLeftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:navLeftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)setRightItemWithImage:(NSString *)image orTitle:(NSString *)title sel:(SEL)selector{
    UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    if(image){
        [navRightButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [navRightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    }
    if(title){
        [navRightButton setTitle:title forState:UIControlStateNormal];
        if (image) {
            [navRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            [navRightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 100-[UIImage imageNamed:image].size.width, 0, 0)];
        }else{
            [navRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -70, 0, 0)];
        }
        navRightButton.titleLabel.font = Font(18);
    }
    navRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:navRightButton];
    if(selector)[navRightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (IBAction)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma navigation pop
- (void)pushController:(Class)controller withInfo:(id)info
{
    return [self pushController:controller withInfo:info withTitle:nil withOther:nil];
}
- (void)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title
{
    return [self pushController:controller withInfo:info withTitle:title withOther:nil];
}

/**
 *	自动配置次级controller头部并跳转
 *  次级controller为base的基类的时候，参数生效，否则无效
 *
 *	@param	controller	次级controller
 *	@param	info	主参数
 *	@param	title	次级顶部title（次级设置优先）
 *	@param	other	附加参数
 *
 *	@return	次级controller实体
 */
- (void)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other{
    BaseViewController *base = [[controller alloc] init];
    if ([(NSObject*)base respondsToSelector:@selector(setUserInfo:)]) {
        base.userInfo = info;
        base.otherInfo = other;
        base.title = title;
    }
    [self.navigationController pushViewController:base animated:YES];
    if ([(NSObject*)base respondsToSelector:@selector(setUserInfo:)]) {
        //如果次级controller自定义了title优先展示
        [self.navigationItem setTitle:base.title?base.title:title];
    }

}

- (void)popController:(id)controller
{
    //Class cls = NSClassFromString(controller);
    if ([controller isKindOfClass:[UIViewController class]]) {
        [self.navigationController popToViewController:controller animated:YES];
    }else{
        DLog(@"popToController NOT FOUND.");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (BOOL)popController:(NSString*)controllerstr withSel:(NSString*)sel withObj:(id)info
{
    BOOL pop = NO;
    for (id controller in self.navigationController.viewControllers) {
        if ([NSStringFromClass([controller class]) isEqualToString:controllerstr]) {
            if ([(NSObject*)controller respondsToSelector:NSSelectorFromString(sel)]) {
                [controller performSelector:NSSelectorFromString(sel) withObject:info afterDelay:0.01];
            }
            [self popController:controller];
            pop = YES;
            break;
        }
    }
    return pop;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
