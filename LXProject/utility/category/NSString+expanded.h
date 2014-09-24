//
//  StringRef.h
//  beta1
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//
typedef enum {
    imageSmallType,
    imageMiddlType,
    imageBigType,
}imageType;
#import <Foundation/Foundation.h>

@interface NSString(expanded)
- (int)calc_charsetNum;
-(NSString*)replaceControlString;
-(NSString*)imagePathType:(imageType)__type;
- (CGFloat)getHeightByWidth:(NSInteger)_width font:(UIFont *)_font;
//- (NSString *)indentString:(NSString*)_string font:(UIFont *)_font;
- (NSString *)indentLength:(CGFloat)_len font:(UIFont *)_font;
- (BOOL)notEmptyOrNull;
+ (NSString *)replaceEmptyOrNull:(NSString *)checkString;
-(NSString*)replaceTime;
-(NSString*)replaceStoreKey;
- (NSString*)soapMessage:(NSString *)key,...;
- (NSString *)md5;
@end
