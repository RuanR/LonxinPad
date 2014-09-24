//
//  viewCategory.h
//  cloud
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^tapGestureBlock)(UIView *view);

@interface UIView(Addition)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

-(BOOL) containsSubView:(UIView *)subView;
-(BOOL) containsSubViewOfClassType:(Class)class;


-(void)roundCorner;
-(void)rotateViewStart;
-(void)rotateViewStop;
-(void)addSubviews:(UIView *)view,...NS_REQUIRES_NIL_TERMINATION;

- (void)addTapGesture:(tapGestureBlock)tapBlock;
//for UIImageView & UIButton.backgroudImage
//-(void)imageWithURL:(NSString *)url size:(CGSize)size def:(NSString*)def;
//-(void)imageWithURL:(NSString *)url;
@end
