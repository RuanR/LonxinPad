//
//  Utility.h
//  CloudTravel
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//

#import <Foundation/Foundation.h>

#define showProgressIndicator_width 250

@interface Utility : NSObject
//启用缓存
@property (nonatomic,assign) BOOL offline;
//关闭本次广告
@property (nonatomic,assign) BOOL offhome;
//userid
@property (nonatomic,strong) NSString  *userid,*userName,*userLevel,*userStatus,*userImage,*userSex;
+(id)Share;
//+(int)uid;
+ (void)alertError:(NSString*)content;
+ (void)alertSuccess:(NSString*)content;
- (void)alert:(NSString*)content;
- (void)alertContentCancel:(NSString*)content delegate:(id)delegate;
- (void)alert:(NSString*)content delegate:(id)delegate;
/*-(NSString *)getAddressBy:(NSString *)description;*/
- (NSString*)timeToNow:(NSString*)theDate;
/*- (BOOL)isFocusSession:(NSString*)sid;
- (BOOL)isFocusSpeak:(NSString*)sid;*/
+ (BOOL) validateEmail: (NSString *) candidate ;
+ (BOOL) validateTel: (NSString *) candidate ;
//- (void)refreshData;
- (BOOL)hasUserid;
- (void) makeCall:(NSString *)phoneNumber;

+ (BOOL)removeForArrayObj:(id)obj forKey:(NSString*)key;
+ (void)saveToDefaults:(id)obj forKey:(NSString*)key;
+ (void)saveToArrayDefaults:(id)obj forKey:(NSString*)key;
+ (void)saveToArrayDefaults:(id)obj replace:(id)oldobj forKey:(NSString*)key;

+ (id)defaultsForKey:(NSString*)key;
+ (void)removeForKey:(NSString*)key;

//比较日期
+(BOOL)isEarlyByCompareDate:(NSDate *)date1 dateFormat:(NSString *)date2;
//iOS7计算高度
+ (CGSize)sizeWithContent:(NSString *)content WithFont:(UIFont *)font maxSize:(CGSize)maxSize;
//将十进制转化为十六进制
+ (NSString *)ToHex:(long long int)tmpid;
// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString;
//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string;
//清除webview的背景
+ (void)removeWebViewBlackColor:(UIWebView *)webview;
//圆角图片
+ (UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size roundRadius:(CGFloat)radius;
//清除searchbar的背景
+ (void) removeSearchBg:(UISearchBar *)searchbar;
//类似系统自带的拍照动画
+ (void)takePhotoAnimation:(UIView *)view;
//动态获取 Label 显示高度
+ (CGFloat)heightOfText:(NSString *)text theWidth:(float)width theFont:(UIFont*)aFont;
//图片模糊处理
+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
//对字数的统计计算
+ (int)countWord:(NSString*)s;
+(NSUInteger) unicodeLengthOfString: (NSString *) text;
//gb2312格式转成utf8
+(NSString *) gb2312toutf8:(NSData *) data;
@end
