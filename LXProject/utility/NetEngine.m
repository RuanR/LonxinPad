//
//  NetEngine.m
//  Stev_Framework
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//

#import "NetEngine.h"
#import "Utility.h"
#import "SDDataCache.h"
#import "NSString+expanded.h"
#import <JSONKit.h>

@interface NetEngine(){
    
}
@property (copy, nonatomic) NSString *hostName;
@property (strong, nonatomic) Reachability *reachability;
@end

@implementation NetEngine

+(id)Share {
    static NetEngine *_NetEngineinstance=nil;
    static dispatch_once_t netEngine;
    dispatch_once(&netEngine, ^ {
        NSString *baseDomainUrl = [NSString stringWithFormat:@"http://%@/",baseDomain];
        NSString *basePortUrl = [baseDomainUrl stringByAppendingString:(basePort.length ? [NSString stringWithFormat:@":%@/",basePort] : @"")];
        NSString *url = [basePortUrl stringByAppendingString:(basePath.length ? [NSString stringWithFormat:@"%@/",basePath] : @"")];
        _NetEngineinstance = [[NetEngine alloc] initWithBaseURL:[NSURL URLWithString:url]];
    });
	return _NetEngineinstance;
}
+ (void)cancel{
    [[self Share] cancel];
}
+(NSString*)IMGname:(NSDate*)date
{

    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"YYYYMMddkkmmssA"];
    return  [NSString stringWithFormat:@"%@.jpg",[format stringFromDate:date]];
    
}
#pragma mark - http get请求
+(AFHTTPRequestOperation *) createGetAction:(NSString*) path
            onCompletion:(ResponseBlock)completionBlock{
    return [[self Share] createGetAction:path parameters:nil withNetType:NETypeHttpGet withMask:SVProgressHUDMaskTypeClear withFile:nil withCache:YES onCompletion:completionBlock onError:nil];
}
+ (AFHTTPRequestOperation *)createGetAction:(NSString *)path
             parameters:(NSDictionary *)parameters
               withMask:(SVProgressHUDMaskType)mask
              withCache:(BOOL)usecache
           onCompletion:(ResponseBlock)completionBlock
                onError:(ErrorBlock)errorBlock{
    return [[self Share] createGetAction:path parameters:parameters withNetType:NETypeHttpGet withMask:mask withFile:nil withCache:usecache onCompletion:completionBlock onError:errorBlock];
}
#pragma mark - http post请求
+(AFHTTPRequestOperation *) createPostAction:(NSString*) path
              parameters:(NSDictionary *)parameters
            onCompletion:(ResponseBlock)completionBlock{
    return [[self Share] createGetAction:path parameters:parameters withNetType:NETypeHttpPost withMask:SVProgressHUDMaskTypeClear withFile:nil withCache:YES onCompletion:completionBlock onError:nil];
}
+ (AFHTTPRequestOperation *)createPostAction:(NSString *)path
              parameters:(NSDictionary *)parameters
                withMask:(SVProgressHUDMaskType)mask
               withCache:(BOOL)usecache
            onCompletion:(ResponseBlock)completionBlock
              errorBlock:(ErrorBlock)errorBlock{
    return [[self Share] createGetAction:path parameters:parameters withNetType:NETypeHttpPost withMask:mask withFile:nil withCache:usecache onCompletion:completionBlock onError:errorBlock];
}

#pragma mark - http post and get
- (AFHTTPRequestOperation *)createGetAction:(NSString *)path
             parameters:(NSDictionary *)parameters
            withNetType:(NEType)netType
               withMask:(SVProgressHUDMaskType)mask
               withFile:(NSDictionary*)fileInfo
              withCache:(BOOL)usecache
           onCompletion:(ResponseBlock)completionBlock
                onError:(ErrorBlock)errorBlock{
    
    NSString *storeKey=[path md5];
    if (usecache&&storeKey) {
        id storedata=[[SDDataCache sharedDataCache] dataFromKey:storeKey fromDisk:YES];
        NSString *datastring=[[NSString alloc] initWithData:storedata encoding:NSUTF8StringEncoding];
        completionBlock([datastring objectFromJSONString],datastring,YES);
    }
    if ([[Utility Share] offline]) {
        if (errorBlock) {
            errorBlock(nil);
        }else{
            if(mask)[SVProgressHUD showErrorWithStatus:@"您已经处于离线"];
        }
        return nil;
    } else {
        if(mask!=SVProgressHUDMaskTypeNil){[SVProgressHUD showWithStatus:@"正在加载..." maskType:mask];}
        
        //设置请求的解析器为AFJSONRequestOperation（用于解析JSON），默认为AFHTTPRequestOperation（用于直接解析数据NSData）
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        //添加JSON的数据类型，本Demo已在AFNetworking的源代码添加此数据类型，在AFJSONRequestOperation.m文件的第105行-第107行添加
        //    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        
        //设置转换的JSON格式，必须设置setDefaultHeader的值Accept以对应AFHTTPRequestOperation.m中的第322行的返回值中的Accept，系统才能获取请求，并返回JSON格式的文件
        [self setDefaultHeader:@"Accept" value:@"text/html"];
        [self setDefaultHeader:@"Token" value:kToken];
        [self setDefaultHeader:@"ClientKey" value:@"1"];
        [self setDefaultHeader:@"Accept-Encoding" value:@"GZip,Deflate"];
        
        //设置接口，并发送GET请求
        NSMutableURLRequest *request = [self requestWithMethod:(netType == NETypeHttpGet || netType == NETypeDownFile) ? @"GET" : @"POST"  path:path parameters:parameters];
        request.timeoutInterval = 30;
        
        AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (netType == NETypeDownFile) {
//                completionBlock(operation.responseData,nil,NO);
            } else {
                //请求成功（当解析器为AFJSONRequestOperation时）
                NSLog(@"success:%@", responseObject);
                //http请求
                NSString *responseString=operation.responseString;
                //数据为空，清除缓存KEY
                if (!responseString.length) {
                    if(storeKey)[[SDDataCache sharedDataCache] removeDataForKey:storeKey];
                }else{
                    completionBlock([responseString objectFromJSONString],responseString,NO);
                    if (usecache && storeKey) {
                        [[SDDataCache sharedDataCache] storeData:[responseString dataUsingEncoding:NSUTF8StringEncoding] forKey:storeKey toDisk:YES];
                    }
                }
            }
            
            NSString *tokenid = [[operation.response allHeaderFields] valueForKey:@"Token"];
            if (tokenid.length) {
                [[NSUserDefaults standardUserDefaults] setValue:tokenid forKey:@"tokenid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [SVProgressHUD dismiss];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"failure:%@", error);
            if (errorBlock) {
                errorBlock(error);
            }else{
                if(mask)[SVProgressHUD showErrorWithStatus:@"暂无数据"];
            }
            
        }];
        
        [self enqueueHTTPRequestOperation:operation];
        [operation start];
//        [self getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            //请求失败
//            
//        }];
//        [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            DLog(@"%@",[operation.request valueForHTTPHeaderField:@"Token"]);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
        
        return operation;
    }
}


#pragma mark - http upload 图片

+ (AFHTTPRequestOperation *)createUploadImageAction:(NSString*)path
                                  ImagesAndImageKeys:(NSArray*)imagesAndKeys
                                             params:(NSDictionary *)parameters
                                           withMask:(SVProgressHUDMaskType)mask
                                       onCompletion:(ResponseBlock)completionBlock
                                            onError:(ErrorBlock)errorBlock{
    return [[self Share] createUploadImageAction:path ImagesAndImageKeys:imagesAndKeys params:parameters withMask:mask onCompletion:completionBlock onError:errorBlock];
}

- (AFHTTPRequestOperation *)createUploadImageAction:(NSString*)path
                                 ImagesAndImageKeys:(NSArray*)imagesAndKeys
                                             params:(NSDictionary *)parameters
                                           withMask:(SVProgressHUDMaskType)mask
                                       onCompletion:(ResponseBlock)completionBlock
                                            onError:(ErrorBlock)errorBlock{
    
     path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //设置请求的解析器为AFJSONRequestOperation（用于解析JSON），默认为AFHTTPRequestOperation（用于直接解析数据NSData）
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    //设置转换的JSON格式，必须设置setDefaultHeader的值Accept以对应AFHTTPRequestOperation.m中的第322行的返回值中的Accept，系统才能获取请求，并返回JSON格式的文件
    [self setDefaultHeader:@"Accept" value:@"text/html"];
    [self setDefaultHeader:@"Token" value:kToken];
    
    //设置接口，发送POST请求，添加需要发送的文件，此处为图片
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imagesAndKeys.count) {
            for (int i = 0;i < imagesAndKeys.count;i++) {
                //添加图片，并对其进行压缩（0.0为最大压缩率，1.0为最小压缩率）
                NSData *imageData = UIImageJPEGRepresentation([imagesAndKeys[i] allValues][0], 0.5);
                NSString *imagename = [[self class] IMGname:[NSDate date]];
                //添加要上传的文件，此处为图片
                [formData appendPartWithFileData:imageData name:[imagesAndKeys[i] allValues][0] fileName:imagename mimeType:@"image/jpeg"];
            }
        }
        
    }];
    request.timeoutInterval = 30;
    //创建请求管理
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //请求管理判断请求结果
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //请求成功（当解析器为AFJSONRequestOperation时）
        NSLog(@"success:%@", responseObject);
        
        NSString *responseStr = operation.responseString;
        NSLog(@" createUploadImageAction responseStr:%@",responseStr);
        if (!responseStr) {
            [SVProgressHUD showErrorWithStatus:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
            if ([[responseStr JSONString] isEqual:[NSNull null]]) {
                completionBlock(responseStr, responseStr, NO);
                
            }else{
                completionBlock([responseStr JSONString],responseStr,NO);
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //请求失败
        NSLog(@"failure:%@", error);
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@",path);
        errorBlock?errorBlock(nil):nil;
        
    }];
    
    //请求开始
    [operation start];
    
    return operation;

}

#pragma mark - 上传文件
+(AFHTTPRequestOperation *) createUploadFileAction:(NSString*)path
                                          withFile:(id)fileInfo
                                        withParams:(NSDictionary*)params
                                      onCompletion:(ResponseBlock) completionBlock{
    return [[self Share] createGetAction:path parameters:params withNetType:NETypeHttpPost withMask:SVProgressHUDMaskTypeClear withFile:fileInfo withCache:YES onCompletion:completionBlock onError:nil];
}
//#pragma mark - 文件下载
//+(AFHTTPRequestOperation *) createUploadFileAction:(NSString*)path
//                                        withParams:(NSDictionary*)params
//                                      onCompletion:(ResponseBlock) completionBlock{
//    
//}

@end
