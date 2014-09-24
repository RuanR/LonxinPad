//
//  NetEngine.h
//  Stev_Framework
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//
#import "Foundation_defines.h"

#define baseDomain  @"121.199.48.115"   //公共路径121.199.46.107
#define basePort     @""  //端口
#define basePath     @"APP_Service"  //公共路径

#define BaseDomain @"192.168.0.2:9898"//图片域名端口

//获取单个文章
#define kSingalArticle @"ArticleHandler.ashx?func=Get&ar_No=%@"
//获取文章列表
#define kArticleList @"ArticleHandler.ashx?func=GetList&ar_Category=%@&startIndex=%@&endIndex=%@"
//广告详情
#define kAdsDetail @"GetArticle.aspx?id=%@&user=%@&edition=2"
//登陆
#define kLogin @"CustomerInfoHandler.ashx?func=Login&ci_No=%@&ci_Password=%@"
//修改密码
#define kChangePwd @"CustomerInfoHandler.ashx?func=EditPassWord&ci_No=%@&oldPassWord=%@&newPassword=%@"
//获取单个广告图
#define kGetAdImage @"GetTitleImgHandler.ashx?func=Get&sp_key=%@"
//获取图片列表
#define kGetImageList @"GetTitleImgHandler.ashx?func=GetList&startIndex=%@&endIndex=%@"
//获取故事文章
#define kGetStory @"ImproveHandler.ashx?func=GetStory&st_id=%@"
//组图获取接口
#define kGetList @"PicturesHandler.ashx?func=GetList&pc_Group=%@&startIndex=%@&endIndex=10"
//信息返馈接口
#define kAddMassage @"MessageFeedbackHandler.ashx?func=Add&mf_Title=%@&mf_Message=%@&mf_Customer=%@"
//获取帖子列表
#define kGetPostsListt @"PostslistHandler.ashx?func=GetList&CustomerNo=%@&CustomerLevel=%@&startIndex=%@&endIndex=%@"
//获取产品列表
#define kGetProductList @"ProductsHandler.ashx?func=GetList&pc_Group=%@&startIndex=%@&endIndex=%@"
//产品详情
#define kGetProductDetai @"GetArticle.aspx?id=%@"
//获取广告图片列表（改善/故事接口）
#define kGetImproveList @"ImproveHandler.ashx?func=GetList&im_Type=%@&ar_Category=%@&startIndex=%@&endIndex=%@"
//about
#define kGetAbout @"GetArticle.aspx?id=%@&category=%@&edition=2"

#define kGetArtDetail @"ImproveHandler.ashx?func=GetStory&st_id=%@&user=%@"
