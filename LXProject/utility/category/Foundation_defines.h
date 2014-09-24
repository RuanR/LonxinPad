//
//  NetEngine.h
//  Stev_Framework
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//

#ifdef _foundation_defines
#else
#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif

#define docPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define docDataPath [docPath stringByAppendingPathComponent:@"Data"]
//#define docDataInfoPath [docPath stringByAppendingPathComponent:@"Data/info"]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define W(obj)   (!obj?0:(obj).frame.size.width)
#define H(obj)   (!obj?0:(obj).frame.size.height)
#define X(obj)   (!obj?0:(obj).frame.origin.x)
#define Y(obj)   (!obj?0:(obj).frame.origin.y)
#define XW(obj) (X(obj)+W(obj))
#define YH(obj) (Y(obj)+H(obj))
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]
#define Font(x) [UIFont systemFontOfSize:x]

#define CGRectMakeXY(x,y,size) CGRectMake(x,y,size.width,size.height)

#define S2N(x) [NSNumber numberWithInt:[x intValue]]
#define I2N(x) [NSNumber numberWithInt:x]
#define F2N(x) [NSNumber numberWithFloat:x]

#define RAND(obj) arc4random() % obj

#define kToken [[NSUserDefaults standardUserDefaults] valueForKey:@"tokenid"]

#define default_PageSize 10
#define default_StartPage 0

#define kUserid [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]
#define kUserLevel [[NSUserDefaults standardUserDefaults] valueForKey:@"userlevel"]

#define kVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
#define k4Inch kScreenHeight - 480

#define kShareApp ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define CN 1
#define UI_language(cn,us) CN?cn:us

#define UI_btn_back CN?@"返回":@"back"

#define UI_btn_search CN?@"搜索":@"Search"

#define UI_btn_upload CN?@"上传":@"Upload"
#define UI_btn_submit CN?@"提交":@"Submit"
#define UI_btn_cancel CN?@"取消":@"cancel"
#define UI_btn_confirm CN?@"确定":@"OK"
#define UI_btn_delete CN?@"删除":@"Delete"
#define UI_tips_load CN?@"正在加载...":@"Loading..."

#endif