//
//  Utility.m
//  CloudTravel
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//

#import "Utility.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
//#import "JSONKit.h"
//#import "NSDictionary+expanded.h"
//#import <arpa/inet.h>
//#import "AppDelegate.h"
#define picMidWidth 200
#define picSmallWidth 100
@interface Utility (){
    UITextField *accountField,*passField;
    NSString *phoneNum;
    UIAlertView *alertview;
}
@property (nonatomic,strong) NSURL *phoneNumberURL;
//@property (nonatomic,strong) Reachability *reachability;
@property (nonatomic,copy) void (^finished)(NSString *account,NSString *pass);
@end

@implementation Utility

static Utility *_utilityinstance=nil;
static dispatch_once_t utility;

+(id)Share
{
    dispatch_once(&utility, ^ {
        _utilityinstance = [[Utility alloc] init];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(reachabilityChanged:)
//                                                     name:kReachabilityChangedNotification
//                                                   object:nil];
        
//        struct   sockaddr_in   my_addr;
//        my_addr.sin_family   =   AF_INET;
//        my_addr.sin_port   =   htons(9898);
//        my_addr.sin_addr.s_addr   =   inet_addr("192.168.0.2");
//        
//        bzero(&(my_addr.sin_zero),   8);
//        _utilityinstance.reachability =  [Reachability reachabilityForInternetConnection];
//        [Utility reachabilityChanged:nil];
//        [_utilityinstance.reachability startNotifier];
    });
	return _utilityinstance;
}
+(int)uid{
    return [[[Utility Share] userid] intValue];
}
- (NSString*)userid
{
    if (!_userid) {
    }
    return _userid;
}
- (BOOL)hasUserid
{
    return !!_userid;
}
#pragma mark - remove webview background
+ (void)removeWebViewBlackColor:(UIWebView *)webview{
    webview.backgroundColor=[UIColor clearColor];
    for (UIView *aView in [webview subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条 （水平的类似）
            
            for (UIView *shadowView in aView.subviews)
            {
                
                if ([shadowView isKindOfClass:[UIImageView class]])
                {
                    shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                }
            }
        } 
    }
}

#pragma mark - 十进制转十六进制
//将十进制转化为十六进制
+ (NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

//比较日期
+(BOOL)isEarlyByCompareDate:(NSDate *)date1 dateFormat:(NSString *)date2
{
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
      //比较准确度为“日”，如果提高比较准确度，可以在此修改时间格式
     NSString *stringDate1 = [dateFormatter stringFromDate:date1];
//     NSString *stringDate2 = [dateFormatter stringFromDate:date2];
     NSDate *dateA = [dateFormatter dateFromString:stringDate1];
     NSDate *dateB = [dateFormatter dateFromString:date2];
     NSComparisonResult result = [dateA compare:dateB];
     if (result == NSOrderedDescending) {
         return NO;  //date1 比 date2 晚
     } else if (result == NSOrderedAscending){
         return YES; //date1 比 date2 早
     } else{
         return YES; //在当前准确度下，两个时间一致
     }
    
}

#pragma mark - iOS7计算高度 对象方法,传入:字体/最大尺寸. 即可得到宽高，最大尺寸主要限制宽度，如果是一行就给个{MAXFLOAT,MAXFLOAT};如果是多行就限制X值，Y值随便给。
+ (CGSize)sizeWithContent:(NSString *)content WithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - 字符串与十六进制的相互转换
// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}

//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else 
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}

#pragma mark -
#pragma mark makeCall
- (NSString*) cleanPhoneNumber:(NSString*)phoneNumber
{
    return [[[[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]
									stringByReplacingOccurrencesOfString:@"-" withString:@""]
										stringByReplacingOccurrencesOfString:@"(" withString:@""] 
											stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    //return number1;    
}
- (void) makeCall:(NSString *)phoneNumber
{
	if (!phoneNumber||[phoneNumber isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:UI_language(@"错误", @"error")
														message:UI_language(@"号码有误", @"Error Number")
													   delegate:self
											  cancelButtonTitle:UI_language(@"确定", @"OK")
											  otherButtonTitles:nil];
		[alert show];
		//[alert release];
		
		return;
	}
    NSString* numberAfterClear = [self cleanPhoneNumber:phoneNumber];
    
    self.phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:phoneNumber
												   delegate:self
										  cancelButtonTitle:UI_btn_cancel
										  otherButtonTitles:UI_language(@"拨打", @"Call"),nil];
	[alert show];
	//[alert release];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertview.title.length>0) {
        UINavigationController *nav = (UINavigationController*) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        if(![nav.visibleViewController isKindOfClass:NSClassFromString(@"ScanViewController")]){
            if([nav.visibleViewController isKindOfClass:NSClassFromString(@"ViewController")]){
                [nav.visibleViewController performSelector:@selector(scanButtonClicked:) withObject:nil];
            }
        }
    }else{
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:self.phoneNumberURL];
        }
    }
}
#pragma mark -
#pragma mark Reachability related

//+(void) reachabilityChanged:(NSNotification*) notification
//{
//    if([_utilityinstance.reachability currentReachabilityStatus] == NotReachable)
//    {
//        _utilityinstance.offline = YES;
//    }else{
//        if (_utilityinstance.offline) {
////            if (![[Utility Share] sync]) {
////                [[Utility Share] setSync:YES];
////                [[Utility Share] updateInfo];
////            }
//        }
//        _utilityinstance.offline = NO;
//    }
//}
#pragma mark -
#pragma mark getAddressBy
-(NSString *)getAddressBy:(NSString *)description{
	NSArray *strArray = [description componentsSeparatedByString:@" "];
	
	return [strArray objectAtIndex:1];
}

#pragma mark -
#pragma mark validateEmail
+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
#pragma mark validateTel
+ (BOOL) validateTel: (NSString *) candidate {
    NSString *telRegex = @"^1[3578]\\d{9}$";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
	
    return [telTest evaluateWithObject:candidate];
//    if (candidate.length>=5) {
//        NSString *str = [NSString stringWithFormat:@"%.0f",candidate.doubleValue];
//        return [str isEqualToString:candidate];
//    }else{
//        return NO;
//    }
}
#pragma ImagePeSize
-(CGFloat)percentage:(NSString*)per width:(NSInteger)width
{
    if (per) { 
        NSArray *stringArray = [per componentsSeparatedByString:@"*"];
        
        if ([stringArray count]==2) {
            CGFloat w=[[stringArray objectAtIndex:0] floatValue];
            CGFloat h=[[stringArray objectAtIndex:1] floatValue];
            if (w>=width) {
                return h*width/w;
            }else{
                return  h;
            }
        }
    }
    return width;
}

//判断ios版本AVAILABLE
- (BOOL)isAvailableIOS:(CGFloat)availableVersion
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=availableVersion) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark TimeTravel
- (NSString*)timeToNow:(NSString*)theDate
{
    if (!theDate) {
        return nil;
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *d=[dateFormatter dateFromString:theDate];
    if (!d) {
        return theDate;
    }
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=(now-late)>0 ? (now-late) : 0;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 分前", timeString];
        
    }else if (cha/3600>1 && cha/3600<24) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 小时前", timeString];
    }
    else
    {
       /* if (needYear) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        else
        {
            [dateFormatter setDateFormat:@"MM-dd"];
        }
        timeString=[dateFormatter stringFromDate:d];*/
        timeString = [NSString stringWithFormat:@"%.0f 天前",cha/3600/24];
    }
    
    return timeString;
}
+ (void)alertError:(NSString*)content
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:content];
    });
}
+ (void)alertSuccess:(NSString*)content
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:content];
    });
}
- (void)alert:(NSString*)content
{
    [self alert:content delegate:nil];
}
- (void)alertContentCancel:(NSString*)content delegate:(id)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (alertview) {
            [alertview dismissWithClickedButtonIndex:-1 animated:NO];
        }
        alertview =  [[UIAlertView alloc] initWithTitle:UI_language(@"提示", @"tips") message:content delegate:delegate cancelButtonTitle:UI_language(@"取消", @"Cancel") otherButtonTitles:UI_language(@"确定", @"OK"), nil] ;[alertview show];
    });
}
- (void)alert:(NSString*)content delegate:(id)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (alertview) {
            [alertview dismissWithClickedButtonIndex:-1 animated:NO];
        }
        alertview =  [[UIAlertView alloc] initWithTitle:UI_language(@"提示", @"tips") message:content delegate:delegate cancelButtonTitle:nil otherButtonTitles:UI_language(@"确定", @"OK"), nil] ;[alertview show];
    });
}
/**
 *	保存obj的array到本地，如果已经存在会替换本地。
 *
 *	@param	obj	待保存的obj
 *	@param	key	保存的key
 */
+ (void)saveToArrayDefaults:(id)obj forKey:(NSString*)key
{
    [self saveToArrayDefaults:obj replace:obj forKey:key];
}
+ (void)saveToArrayDefaults:(id)obj replace:(id)oldobj forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults valueForKey:key];
    
    NSMutableArray *marray = [NSMutableArray array];
    if (!oldobj) {
        oldobj = obj;
    }
    if (array) {
        [marray addObjectsFromArray:array];
        if ([marray containsObject:oldobj]) {
            [marray replaceObjectAtIndex:[marray indexOfObject:oldobj] withObject:obj];
        }else{
            [marray addObject:obj];
        }
    }else{
      [marray addObject:obj];  
    }
    [defaults setValue:marray forKey:key];
    [defaults synchronize];
}

+ (BOOL)removeForArrayObj:(id)obj forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults valueForKey:key];
    
    NSMutableArray *marray = [NSMutableArray array];
    if (array) {
        [marray addObjectsFromArray:array];
        if ([marray containsObject:obj]) {
            [marray removeObject:obj];
        }
    }
    if (marray.count) {
        [defaults setValue:marray forKey:key];
    }else{
        [defaults removeObjectForKey:key];
    }
    [defaults synchronize];
    return marray.count;
}
/**
 *	保存obj到本地
 *
 *	@param	obj	数据
 *	@param	key	键
 */
+ (void)saveToDefaults:(id)obj forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:obj forKey:key];
    [defaults synchronize];
}

+ (id)defaultsForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
+ (void)removeForKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

//gb2312格式转成utf8
+(NSString *) gb2312toutf8:(NSData *) data{
    
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    
    return retStr;
}

//处理圆角图片
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
+ (UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size roundRadius:(CGFloat)radius {
    if (!radius)
        radius = 8;
    // the size of CGContextRef
    int w = image.size.width;
    int h = image.size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}
//清楚searchbar的背景（透明）
+ (void) removeSearchBg:(UISearchBar *)searchbar{
    if (kVersion7) {
        [searchbar setBackgroundImage:[UIImage new]];
        [searchbar setTranslucent:YES];
    } else {
        for (UIView *view in searchbar.subviews)
        {
            if (![view isKindOfClass:[UITextField class]])
                [view removeFromSuperview];
        }
    }
}
//类似系统自带的拍照动画
+ (void)takePhotoAnimation:(UIView *)view
{
    CATransition *shutterAnimation = [CATransition animation];
    shutterAnimation.delegate = self;
    shutterAnimation.duration = 0.5f;
    shutterAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shutterAnimation.type = @"cameraIris";
    shutterAnimation.subtype = @"cameraIris";
    [view.layer addAnimation:shutterAnimation forKey:@"cameraIris"];
}
//动态获取 Label 显示高度
+ (CGFloat)heightOfText:(NSString *)text theWidth:(float)width theFont:(UIFont*)aFont {
    CGFloat result;
    CGSize textSize = { width, 20000.0f };
    
//    CGSize size = [text sizeWithFont:aFont constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize size = CGSizeZero;
    
    if(!kVersion7)
    {
        size = [text sizeWithFont:aFont constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    }
    else
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSDictionary *attributes = @{NSFontAttributeName:aFont, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        size = [text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        size.height = ceil(size.height);
        
        size.width = ceil(size.width);
        
    }
    
    result = size.height;
    return result;
}
//图片模糊化处理
+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    
    return unicodeLength;
}

//对字数的统计计算
+ (int)countWord:(NSString *)s
{
    int i,n=[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

/*
// ios 距离传感器
 [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 
 selector:@selector(sensorStateChange:)
 
 name:@"UIDeviceProximityStateDidChangeNotification"
 
 object:nil];
 
 -(void)sensorStateChange:(NSNotificationCenter *)notification;
 
 {
 
 if ([[UIDevice currentDevice] proximityState] == YES) {
 
 NSLog(@"Device is close to user");
 
 //在此写接近时，要做的操作逻辑代码
 
 }else{
 
 NSLog(@"Device is not close to user");
 
 }
 
 }
 
//来自端
- (NSString *)platformWithType:(NSString *)type;
{
    if ([type isEqual:@"1"]) {
        return @"来自iPhone";
    }
    else if([type isEqual:@"2"])
    {
        return @"来自Android";
    }
    else if([type isEqual:@"3"])
    {
        return @"来自网页";
    }
    else
        return @"来自火星";
}


-(void)showLoginAlert:(void(^)(NSString *account,NSString *pass))afinished
{
    self.finished=afinished;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"登陆"
                                                  message:@"\n\n\n"
                                                 delegate:self
                                        cancelButtonTitle:@"注册"
                                        otherButtonTitles:@"登陆", nil];
    UIButton *close=[[UIButton alloc] initWithFrame:CGRectMake(230, 5, 30, 30)];
    [close addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [close setTitle:@"X" forState:UIControlStateNormal];
    
    
    accountField=[[UITextField alloc] initWithFrame:CGRectMake(20, 40, 240, 31)];
    accountField.borderStyle=UITextBorderStyleRoundedRect;
    accountField.keyboardType=UIKeyboardTypeNumberPad;
    accountField.placeholder=@"手机号码";
    [accountField becomeFirstResponder];
    passField=[[UITextField alloc] initWithFrame:CGRectMake(20, 73, 240, 31)];  
    passField.borderStyle=UITextBorderStyleRoundedRect;
    passField.placeholder=@"密码";
    passField.keyboardType=UIKeyboardTypeDefault;
    passField.secureTextEntry=YES;
    
    //passField.autoresizingMask  = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;//accountField.autoresizingMask = logo.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [alert addSubview:passField];
    [alert addSubview:accountField];
    [alert addSubview:close];
    [close release];
    [accountField release];
    [passField release];
    
    [alert show];
    [alert release];
    
}
-(IBAction)closeButtonClicked:(id)sender
{
    [(UIAlertView*)[sender superview] dismissWithClickedButtonIndex:10 animated:YES];
}
- (BOOL)isFocusSession:(NSString*)sid
{
    if (!sid) {
        return NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults valueForKey:@"focusSession"];
    for (NSString *key in dict.allKeys) {
        for (NSDictionary *item in [dict valueForKey:key]) {
            if ([[item valueForKey:@"sessionGroupId"] intValue] == sid.intValue) {
                DLog(@"%@",sid);
                return YES;
            }
        }
    }
    return NO;
}
- (BOOL)isFocusSpeak:(NSString*)sid
{
    if (!sid) {
        return NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults valueForKey:@"focusSpeak"];
    for (NSDictionary *item in array) {
        if([[item valueForKey:@"meetingId"] intValue]==sid.intValue){
            return YES;
        }
    }
    return NO;
}*/
@end
