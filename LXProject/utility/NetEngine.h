//
//  NetEngine.h
//  Stev_Framework
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "SVProgressHUD.h"

typedef enum {
    NETypeHttpGet = 1,//return JSON   get
    NETypeDownFile, //return DATA     get
    NETypeHttpPost,//return JSON      post
    NETypeUploadFile, //return JSON   post
    NETypeSoap // return XML          post
}NEType;

@interface NetEngine : AFHTTPClient

typedef void (^ResponseBlock)(id resData,id resString,BOOL isCache);
typedef void (^ErrorBlock)(NSError* error);

+ (id)Share;
+ (void)cancel;

#pragma mark - http get请求
+ (AFHTTPRequestOperation *)createGetAction:(NSString*) path
                               onCompletion:(ResponseBlock)completionBlock;

+ (AFHTTPRequestOperation *)createGetAction:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                   withMask:(SVProgressHUDMaskType)mask
                                  withCache:(BOOL)usecache
                               onCompletion:(ResponseBlock)completionBlock
                                    onError:(ErrorBlock)errorBlock;

#pragma mark - http post请求
+ (AFHTTPRequestOperation *)createPostAction:(NSString*) path
                                  parameters:(NSDictionary *)parameters
                                onCompletion:(ResponseBlock)completionBlock;
+ (AFHTTPRequestOperation *)createPostAction:(NSString *)path
                                  parameters:(NSDictionary *)parameters
                                    withMask:(SVProgressHUDMaskType)mask
                                   withCache:(BOOL)usecache
                                onCompletion:(ResponseBlock)completionBlock
                                  errorBlock:(ErrorBlock)errorBlock;

#pragma mark - http 上传图片
+ (AFHTTPRequestOperation *)createUploadImageAction:(NSString*)path
                                 ImagesAndImageKeys:(NSArray*)imagesAndKeys
                                             params:(NSDictionary *)parameters
                                           withMask:(SVProgressHUDMaskType)mask
                                       onCompletion:(ResponseBlock)completionBlock
                                            onError:(ErrorBlock)errorBlock;
#pragma mark - http 上传文件
+(AFHTTPRequestOperation *) createUploadFileAction:(NSString*)path
                                     withFile:(id)fileInfo
                                   withParams:(NSDictionary*)params
                                 onCompletion:(ResponseBlock) completionBlock;
//#pragma mark - http 下载文件
//+(AFHTTPRequestOperation *) createUploadFileAction:(NSString*)path
//                                        withParams:(NSDictionary*)params
//                                      onCompletion:(ResponseBlock) completionBlock;

@end
