//
//  viewCategory.m
//  cloud
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//

#import "UIView+expanded.h"
#import <QuartzCore/QuartzCore.h>
#import "SDDataCache.h"
#import "NSString+expanded.h"
#import "UIImage+expanded.h"
//#import "NetEngine.h"
#define showProgressIndicator_width 250

static tapGestureBlock _tapBlock;
@implementation UIView(Addition)

-(BOOL) containsSubView:(UIView *)subView
{
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}
//-(BOOL) isKindOfClass: classObj 判断是否是这个类，包括这个类的子类和父类的实例；
//-(BOOL) isMemberOfClass: classObj 判断是否是这个类的实例,不包括子类或者父类；
-(BOOL) containsSubViewOfClassType:(Class)class {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:class]) {
            return YES;
        }
    }
    return NO;
}

- (CGPoint)frameOrigin {
	return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
	self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
	return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							newSize.width, newSize.height);
}

- (CGFloat)frameX {
	return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
	self.frame = CGRectMake(newX, self.frame.origin.y,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
	return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
	self.frame = CGRectMake(self.frame.origin.x, newY,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameRight {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)newRight {
	self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)newBottom {
	self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth {
	return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight {
	return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							self.frame.size.width, newHeight);
}

-(void)roundCorner
{
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.cornerRadius = 3.0;
    self.layer.borderWidth = 1.0;
}

-(void)allRoundCorner{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frameWidth/2;
    self.layer.borderWidth = 0.0;
}

-(void)rotateViewStart;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI ];
    rotationAnimation.duration = 2;
//    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
-(void)rotateViewStop
{
    //CFTimeInterval pausedTime=[self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
//    self.layer.speed=0.0;
//    self.layer.timeOffset=pausedTime;
    //self.layer.timeOffset = 0.0;  
    //self.layer.beginTime = 0.0; 
//    CFTimeInterval timeSincePause =4+ (pausedTime - (int)pausedTime);
//    NSLog(@".....%f",timeSincePause);
//    self.layer.timeOffset=timeSincePause;
//    self.layer.beginTime = 0.0;
//    [NSTimer timerWithTimeInterval:timeSincePause target:self selector:@selector(removeAnimation:) userInfo:nil repeats:NO];
    [self.layer removeAllAnimations];
}
- (void)removeAnimation:(id)obj
{
    [self.layer removeAllAnimations];
}
-(void)addSubviews:(UIView *)view,...
{
    [self addSubview:view];
    va_list ap;
    va_start(ap, view);
    UIView *akey=va_arg(ap,id);
    while (akey) {
        [self addSubview:akey];
        akey=va_arg(ap,id);
    }
    va_end(ap);
}

- (void)addTapGesture:(tapGestureBlock)tapBlock
{
    _tapBlock = [tapBlock copy];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:recognizer];
}

- (void)viewTap
{
    _tapBlock(self);
}

/*
//-(void)imageWithURL:(NSString *)url
//{
////    if (!url) {
////        return;
////    }
//    if (self.frame.size.width > showProgressIndicator_width) {
//        [self imageWithURL:url useProgress:YES];
//    }
//    else
//    {
//        [self imageWithURL:url useProgress:NO];
//    }
//}
-(void)imageWithURL:(NSString *)url size:(CGSize)size def:(NSString*)def
{
    if (!url.length) {
        return;
    }
//    if([self isKindOfClass:[UIImageView class]]){
//        ((UIImageView*)self).image = [UIImage imageNamed:def.length?def:@"loading_round_bg.png"];
//    }else if([self isKindOfClass:[UIButton class]]){
//        [((UIButton *)self) setBackgroundImage:[UIImage imageNamed:def.length?def:@"loading_round_bg.png"] forState:UIControlStateNormal];
//    }else{
//    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        //[[SDDataCache sharedDataCache] clearMemory];
        NSData *data = [[SDDataCache sharedDataCache] dataFromKey:url.md5 fromDisk:YES];
        if (!data.length) {
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if (data.length)[[SDDataCache sharedDataCache] storeData:data forKey:url.md5 toDisk:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            if (data.length) {
                UIImage *image = [UIImage imageWithData:data];
                if (!CGSizeEqualToSize(size, CGSizeZero)) {
                    //image = [image resizeImageWithNewSize:size];
                    CGRect frame = self.frame;
                    if (size.width<0.00001) {
                        frame.size.height = size.height;
                        frame.size.width = image.size.width*frame.size.height/image.size.height;
                    }else if(size.height<0.00001){
                        frame.size.width = size.width;
                        frame.size.height = image.size.height*frame.size.width/image.size.width;
                    }else{
                        frame.size.width = size.width;
                        frame.size.height = size.height;
                    }
                    [self setFrame:frame];
                }
                if([self isKindOfClass:[UIImageView class]]){
                    ((UIImageView*)self).image = image;
                }else if([self isKindOfClass:[UIButton class]]){
                    [((UIButton *)self) setBackgroundImage:image forState:UIControlStateNormal];
                }else{
                    return;
                }
            }
        });
    });
}
//-(void)imageWithURL:(NSString *)url
//{
//    [self imageWithURL:url size:CGSizeZero def:nil];
//}

-(void)imageWithURL:(NSString *)url
{
    if (!url) {
        return;
    }
    if (self.frame.size.width > showProgressIndicator_width) {
        [self imageWithURL:url useProgress:YES];
    }
    else
    {
        [self imageWithURL:url useProgress:NO];
    }
}

-(void)imageWithURL:(NSString *)url useProgress:(BOOL)useProgress
{
    UIView *tempView = nil;
    UIImageView *imgView = [self isKindOfClass:[UIImageView class]]?(UIImageView *)self:((UIButton *)self).imageView;
//    UIImage *def = [UIImage imageNamed:@"loading_picture.png"];
//    ([self isKindOfClass:[UIImageView class]])?imgView.image = def :[((UIButton *)self) setBackgroundImage:def forState:UIControlStateNormal];
    if (useProgress) {
        CGFloat width = self.frame.size.width *0.8;
        CGFloat fX = (self.frame.size.width - width)/2.0;
        CGFloat fY = self.frame.size.height/2.0 - 10;
        UIProgressView *progressIndicator = [[UIProgressView alloc] initWithFrame:CGRectMake(fX, fY, width, 20)];
        [progressIndicator setProgressViewStyle:UIProgressViewStyleBar];
        if ([progressIndicator respondsToSelector:@selector(setProgressTintColor:)]) {
            [progressIndicator setProgressTintColor:[UIColor grayColor]];
        }
        tempView = progressIndicator;
    }
    else
    {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicatorView setCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0)];
        [activityIndicatorView startAnimating];
        tempView = activityIndicatorView;
    }
    tempView.userInteractionEnabled = NO;
    [self addSubview:tempView];
    
    MKNetworkOperation *op = [[NetEngine Share] imageAtURL:[NSURL URLWithString:url] onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        if([self isKindOfClass:[UIImageView class]]){
            imgView.image = fetchedImage;
        }else{
            [((UIButton *)self) setBackgroundImage:fetchedImage forState:UIControlStateNormal];
        }
        [tempView removeFromSuperview];
    }];
    
    if (useProgress) {
        UIProgressView *progressIndicator = (UIProgressView *)tempView;
        [op onDownloadProgressChanged:^(double progress) {
            [progressIndicator setProgress:progress];
        }];
    }
    [op addCompletionHandler:nil errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if([self isKindOfClass:[UIImageView class]]){
            if(!imgView.image)imgView.image = [UIImage imageNamed:@"image_default.png"];
        }else{
            if(![(UIButton *)self currentBackgroundImage])[((UIButton *)self) setBackgroundImage:[UIImage imageNamed:@"image_default.png"] forState:UIControlStateNormal];
        }
        [tempView removeFromSuperview];
    }];
}
 */
@end
