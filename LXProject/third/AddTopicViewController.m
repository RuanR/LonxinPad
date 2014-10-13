//
//  AddTopicViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-26.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "AddTopicViewController.h"
#import "AppDelegate.h"
#import "UIView+expanded.h"
#import "UIImage+expanded.h"

@interface AddTopicViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImage *pickImage;
}

@property (weak, nonatomic) IBOutlet UITextField *postTitle;
@property (weak, nonatomic) IBOutlet UITextField *postContent;

@end

@implementation AddTopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [kShareApp.baseTabbar hideTabbar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [kShareApp.baseTabbar showTabbar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"NEWS DETAIL"];
    [self setLeftItemWithImage:@"navigationbar_back.png" orTitle:nil sel:@selector(backButtonClicked:)];
    
    [_postContent roundCorner];
    [_postContent.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}


- (IBAction)submit:(id)sender{
    NSString *content = _postContent.text;
    NSString *title = _postTitle.text;
    if (!content.length || !title.length) return;
    
    NSString *urlStr = [NSString stringWithFormat:kAdd,kUserid,content,title];
    [NetEngine createGetAction:urlStr onCompletion:^(id resData, id resString, BOOL isCache) {
        DLog(@"%@",resData);
        [SVProgressHUD showSuccessWithStatus:[resData valueForKey:@"message"]];
        if (resData && !isCache) {
            _postTitle.text = @"";
            _postContent.text = @"";
            [self.view endEditing:YES];
        }
    }];
}

- (IBAction)photo:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@""
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相机拍摄", @"从相册选择",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}

#pragma mark - actionshet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerControllerSourceType sourceType = buttonIndex ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
    //判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
    
}

#pragma mark - imagepickerviewcontroller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    pickImage = [image imageByScalingProportionallyToMinimumSize:CGSizeMake(kScreenWidth, kScreenHeight)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
