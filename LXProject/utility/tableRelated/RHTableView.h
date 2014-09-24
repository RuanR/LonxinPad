//
//  RHTableView.m
//  Stev_Framework
//
//  Created by 孙向前 on 14-5-20.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

typedef id (^RHTableDataBlock)(int page);
typedef id (^RHTableDataOfflineBlock)(int page);
typedef void (^RHTableLoadedDataBlock)(NSArray *array,BOOL cache);

@interface RHTableView : UITableView

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)refresh;
- (void)loadmore;
- (void)stopRefresh;
- (void)stopLoadmore;
- (void)cancelDownload;

- (void)showRefreshHeader;
- (void)hiddenRefreshHeader;
- (void)showLoadmoreFooter;
- (void)hiddenLoadmoreFooter;

- (void)loadUrl:(NSString*)url;
- (void)loadUrl:(NSString*)url withParam:(NSDictionary*)params withMask:(SVProgressHUDMaskType)mask;
- (void)loadBlock:(RHTableDataBlock)data_bk;
- (void)loadBlock:(RHTableDataBlock)data_bk offline:(RHTableDataOfflineBlock)offline_bk withMask:(SVProgressHUDMaskType)mask;

- (void)loadWithRefresh:(BOOL)showRefresh withLoadmore:(BOOL)showLoadmore withMask:(SVProgressHUDMaskType)mask   Url:(NSString*)url withParam:(NSDictionary*)params data:(RHTableDataBlock)data_bk offline:(RHTableDataOfflineBlock)offline_bk loaded:(RHTableLoadedDataBlock)loaded_bk;

- (void)loadUrl:(NSString*)url withMask:(SVProgressHUDMaskType)mask;
- (void)loadBlock:(RHTableDataBlock)data_bk withMask:(SVProgressHUDMaskType)mask;
@end
