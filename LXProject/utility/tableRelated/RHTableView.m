//
//  RHTableView.m
//  Stev_Framework
//
//  Created by 孙向前 on 14-5-20.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//

#import "RHTableView.h"
#import "MessageInterceptor.h"
#import "NetEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "Utility.h"
#import "NSDictionary+expanded.h"

@interface RHTableView()<EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate>{
    BOOL refreshing;
}
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, strong) NSDictionary *postParams;

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshView;
@property (nonatomic, strong) LoadMoreTableFooterView *loadMoreView;

@property (nonatomic, strong) AFHTTPRequestOperation *networkOperation;
@property (nonatomic, assign) SVProgressHUDMaskType progressHUDMask;
@property (nonatomic, strong) MessageInterceptor *delegateInterceptor;

@property (nonatomic,copy) RHTableDataBlock bk_data;
@property (nonatomic,copy) RHTableDataOfflineBlock bk_offline;
@property (nonatomic,copy) RHTableLoadedDataBlock bk_loaded;

@property (nonatomic,strong) NSMutableArray *serverarray;
@property (nonatomic,strong) NSMutableArray *cachearray;

@end

@implementation RHTableView
@synthesize refreshView = _refreshView,loadMoreView = _loadMoreView,delegateInterceptor = _delegateInterceptor,curPage,dataCount,urlString = _urlString,dataArray = _dataArray,networkOperation= _networkOperation,progressHUDMask;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initComponents];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initComponents];
    }
    
    return self;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    if(_delegateInterceptor) {
        super.delegate = nil;
        _delegateInterceptor.receiver = delegate;
        super.delegate = (id)_delegateInterceptor;
    } else {
        super.delegate = delegate;
    }
}

- (void)setDataCount:(NSInteger)t_dataCount
{
    dataCount = t_dataCount;
    if (dataCount < default_PageSize) {
        _loadMoreView.delegate?[_loadMoreView setHidden:YES]:nil;
    }
    else
        _loadMoreView.delegate?[_loadMoreView setHidden:NO]:nil;
}

- (void)dealloc
{
    self.bk_data = nil;
    [self cancelDownload];
}

- (void)initComponents
{
    progressHUDMask = SVProgressHUDMaskTypeClear;
    
    _delegateInterceptor = [[MessageInterceptor alloc] init];
    _delegateInterceptor.middleMan = self;
    _delegateInterceptor.receiver = self.delegate;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat visibleTableDiffBoundsHeight = (self.bounds.size.height - MIN(self.bounds.size.height, self.contentSize.height));
    CGRect loadMoreFrame = _loadMoreView.frame;
    loadMoreFrame.origin.y = self.contentSize.height + visibleTableDiffBoundsHeight;
    DLog(@"%f",loadMoreFrame.origin.y);
    _loadMoreView.frame = loadMoreFrame;
}
- (void)showRefreshHeader
{
    _refreshView.hidden = NO;
    _refreshView.delegate = self;
}
- (void)hiddenRefreshHeader
{
    _refreshView.hidden = YES;
    _refreshView.delegate = nil;
}
- (void)showLoadmoreFooter
{
    _loadMoreView.hidden = NO;
    _loadMoreView.delegate = self;
}
- (void)hiddenLoadmoreFooter
{
    _loadMoreView.hidden = YES;
    _loadMoreView.delegate = nil;
}

- (void)stopRefresh
{
    refreshing = NO;
    [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
     //endRefresh];
}

- (void)stopLoadmore
{
    [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

- (void)cancelDownload
{
    self.bk_data = nil;
    //[self.networkOperation cancel];
    [SVProgressHUD dismiss];
}
- (void)loadData:(int)page
{
    curPage = page;
    SVProgressHUDMaskType masktype = self.progressHUDMask;
//    if(masktype)[SVProgressHUD showWithStatus:@"正在加载..." maskType:masktype];
    
    //离线、刷新、加载更多数据加载完成处理。
    void(^block)(NSArray* array, BOOL isCache) = ^(NSArray* array, BOOL isCache){
        DLog(@"\n__________\n%@:\n%@\n__________\n",isCache?@"Cache":@"Sever",array)
        if (array.count) {
//            [SVProgressHUD dismiss];
            if (curPage <= default_StartPage) {
                if (isCache) {
                    _cachearray = [NSMutableArray arrayWithArray:array];
                } else {
                    _serverarray = [NSMutableArray arrayWithArray:array];
                }
//                self.dataArray = [NSMutableArray arrayWithArray:array];
            }else{
                if (isCache) {
                    [_cachearray addObjectsFromArray:array];
                } else {
                    [_serverarray addObjectsFromArray:array];
                }
//                [self.dataArray addObjectsFromArray:array];
            }
        }else{
            if ((!isCache)&&curPage == default_StartPage) {
                [self.dataArray removeAllObjects];
            }else if (curPage > default_StartPage+1&&!isCache) {
                curPage --;
            }
            if(masktype)[SVProgressHUD showErrorWithStatus:@"暂无数据"];
        }
        if (isCache) {
            self.dataArray = self.cachearray;
        } else {
            self.dataArray = self.serverarray;
        }

        if (self.dataArray.count >= default_PageSize) {
            [self showLoadmoreFooter];
        }else{
            [self hiddenLoadmoreFooter];
        }
        //数据加载成功
        if (self.bk_loaded) {
            self.bk_loaded(self.dataArray,isCache);
        }
        [self reloadData];
        [self stopLoadmore];
        isCache?nil:[self stopRefresh];
    };
    if ([[Utility Share] offline]&&self.bk_offline) {
        block(self.bk_offline(curPage),NO);
        return;
    }
    //数据加载器：离线、同步（例如：hessian）、异步（NKNetwork）、test
    if (self.bk_data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSArray *array = [[Utility Share] offline]?(self.bk_offline?self.bk_offline(curPage):nil):self.bk_data(curPage);
            dispatch_async(dispatch_get_main_queue(), ^{
                block(array,NO);
            });
        });
    }else if(self.urlString.length){
        
        [NetEngine createGetAction:[NSString stringWithFormat:self.urlString,[NSNumber numberWithInteger:curPage*10],[NSNumber numberWithInteger:(curPage+1)*10]]
                        parameters:self.postParams
                          withMask:self.progressHUDMask
                         withCache:YES
                      onCompletion:^(id resData, id resString, BOOL isCache) {
                          NSArray *array = [resData valueForJSONKey:@"value"];
                          if (array.count) {
                              block(array,isCache);
                          }else{
                              block(nil,isCache);
                          }

                      }
                           onError:^(NSError *error) {
                               if (curPage > default_StartPage+1) {
                                   curPage --;
                               }
                               [self stopRefresh];
                               [self stopLoadmore];
                           }];
        
    }
    else{
        //JUST for test
        block([NSArray array],YES);
    }
}
- (void)refresh
{
    refreshing = YES;
    [self stopLoadmore];
    [self showRefresh:YES LoadMore:YES];
    [self loadData:default_StartPage];
    
}

- (void)loadmore
{
    curPage ++;
    [self stopRefresh];
    [self loadData:curPage];
}

#pragma mark - scrollView delegate
//this is dataSource!!
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if ([_delegateInterceptor.receiver respondsToSelector:_cmd]) {
//       return [_delegateInterceptor.receiver tableView:tableView numberOfRowsInSection:section];
//    }
//    return self.dataArray.count;
//}
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_delegateInterceptor.receiver respondsToSelector:_cmd]) {
//        return [_delegateInterceptor.receiver tableView:tableView cellForRowAtIndexPath:indexPath];
//    }else{        
//        static NSString *identify = @"cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
//        }
//        cell.textLabel.text = [[self.dataArray[indexPath.row] allValues] componentsJoinedByString:@","];
//        return cell;
//    }
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _refreshView.delegate?[_refreshView egoRefreshScrollViewDidScroll:self]:nil;
    _loadMoreView.delegate?[_loadMoreView egoRefreshScrollViewDidScroll:scrollView]:nil;
    if ([_delegateInterceptor.receiver
         respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegateInterceptor.receiver scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _refreshView.delegate?[_refreshView egoRefreshScrollViewDidEndDragging:scrollView]:nil;
    _loadMoreView.delegate?[_loadMoreView egoRefreshScrollViewDidEndDragging:scrollView]:nil;
    if ([_delegateInterceptor.receiver
         respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_delegateInterceptor.receiver scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate];
    }
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self performSelector:@selector(refresh) withObject:nil afterDelay:.1];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return refreshing; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
#pragma mark - slimeRefresh delegate

/*- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    //    [_refreshView performSelector:@selector(endRefresh)
    //                     withObject:nil afterDelay:3
    //                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        [self refresh];
}*/

#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    [_loadMoreView performSelector:@selector(egoRefreshScrollViewDataSourceDidFinishedLoading:)
                     withObject:self afterDelay:3
                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    if (self.dataArray.count >= default_PageSize) {
        [self loadmore];
    }
}
#pragma mark - Extends

- (void)loadUrl:(NSString*)url
{
    [self loadWithRefresh:YES withLoadmore:YES withMask:self.progressHUDMask Url:url withParam:nil data:nil offline:nil loaded:nil];
}
- (void)loadUrl:(NSString*)url withMask:(SVProgressHUDMaskType)mask
{
    [self loadWithRefresh:YES withLoadmore:YES withMask:mask Url:url withParam:nil data:nil offline:nil loaded:nil];
}

- (void)loadUrl:(NSString*)url withParam:(NSDictionary*)params withMask:(SVProgressHUDMaskType)mask
{
    [self loadWithRefresh:YES withLoadmore:YES withMask:mask Url:url withParam:params data:nil offline:nil loaded:nil];
}

- (void)loadBlock:(RHTableDataBlock)data_bk
{
    [self loadWithRefresh:YES withLoadmore:YES withMask:self.progressHUDMask Url:nil withParam:nil data:data_bk offline:nil loaded:nil];
}
- (void)loadBlock:(RHTableDataBlock)data_bk offline:(RHTableDataOfflineBlock)offline_bk withMask:(SVProgressHUDMaskType)mask
{
    [self loadWithRefresh:YES withLoadmore:YES withMask:mask Url:nil withParam:nil data:data_bk offline:offline_bk loaded:nil];
}
- (void)loadBlock:(RHTableDataBlock)data_bk withMask:(SVProgressHUDMaskType)mask
{
    [self loadWithRefresh:YES withLoadmore:YES withMask:mask Url:nil withParam:nil data:data_bk offline:nil loaded:nil];
}
- (void)showRefresh:(BOOL)showRefresh LoadMore:(BOOL)showLoadmore
{
    if (showRefresh) {
        if (!_refreshView) {
            _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -50, self.frame.size.width, 50)];
            _refreshView.delegate = self;
            [self addSubview:_refreshView];
            [_refreshView refreshLastUpdatedDate];
        }
        [self showRefreshHeader];
    }else{
        [self hiddenRefreshHeader];
    }
    if (showLoadmore) {
        if (!_loadMoreView) {
            _loadMoreView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
            _loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            _loadMoreView.delegate = self;
            [_loadMoreView setBackgroundColor:[UIColor clearColor] textColor:nil arrowImage:nil];
            [self addSubview:_loadMoreView];
        }
        [self showLoadmoreFooter];
    }else{
        [self hiddenLoadmoreFooter];
    }
}
/**
 @method
 @abstract 表格数据加载模型
 @discussion 通过url 以及参数 params
 @param url 数据来源  params 参数列表
 @result JSON数组
 */

- (void)loadWithRefresh:(BOOL)showRefresh withLoadmore:(BOOL)showLoadmore withMask:(SVProgressHUDMaskType)mask   Url:(NSString*)url withParam:(NSDictionary*)params data:(RHTableDataBlock)data_bk offline:(RHTableDataOfflineBlock)offline_bk loaded:(RHTableLoadedDataBlock)loaded_bk
{
    [self showRefresh:showRefresh LoadMore:showLoadmore];
    self.progressHUDMask = mask;
    self.urlString = url;
    self.postParams = params;
    self.bk_data = data_bk;
    self.bk_offline = offline_bk;
    self.bk_loaded = loaded_bk;
    [self refresh];
}
@end
