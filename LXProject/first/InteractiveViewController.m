//
//  InteractiveViewController.m
//  LXProject
//
//  Created by 孙向前 on 14-9-18.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "InteractiveViewController.h"
#import "RHTableView.h"
#import "NSString+expanded.h"
#import "NSDictionary+expanded.h"
#import "UIView+expanded.h"
#import "InteractiveCell.h"
#import "Utility.h"
#import "AddTopicViewController.h"
#import "UIImage+expanded.h"
#import "ReplyListCell.h"

@interface InteractiveViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIImage *pickImage;
}

@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblSex;
@property (weak, nonatomic) IBOutlet UILabel *lblArea;
@property (weak, nonatomic) IBOutlet UIImageView *imageHeader;

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *txtUserNo;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginOut;

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *txtSendText;
@property (weak, nonatomic) IBOutlet UITextField *txtContent;

@property (weak, nonatomic) IBOutlet RHTableView *topicDetaiTableview;

@property (nonatomic, copy) NSString *pl_id;

@end

@implementation InteractiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"INTERACT"];
 
    [_imageHeader allRoundCorner];
    
    [self initData];
    
    _txtSendText.inputAccessoryView = _inputView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow{
    [_txtContent becomeFirstResponder];
}

- (void)initData{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:@"userinfo"];
    if (dic.count) {
        [self showUserinfo:dic];
    }
    
    [self loadTableData];
}

- (void)loadTableData{
    
    NSString *urlStr = [NSString stringWithFormat:kGetPostsListt,kUserid,kUserLevel,@"%@",@"%@"];
    [self.tableView loadUrl:urlStr];
    
}

- (void)loadReplyList:(NSString *)pl_id{
    NSString *urlStr = [NSString stringWithFormat:kGetPostReplyList,pl_id,@"%@",@"%@"];
    [_topicDetaiTableview loadUrl:urlStr];
}

#pragma mark - UITableViewDelegate/UITableViewDatasource

- (CGFloat)tableView:(RHTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 139;
}

- (NSInteger)tableView:(RHTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DLog(@"%@",tableView.dataArray);
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(RHTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier;
    BOOL isTableView = [tableView isEqual:self.tableView];
    identifier = isTableView ? @"Cell" : @"ReplyCell";
    
    if (isTableView) {
        
        InteractiveCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InteractiveCell" owner:self options:nil] firstObject];
        }
        if (indexPath.row == 0) {
            [self loadReplyList:[tableView.dataArray[indexPath.row] valueForJSONStrKey:@"pl_id"]];
        }
        NSDictionary *dic = tableView.dataArray[indexPath.row];
        cell.lblTitle.text = [dic valueForJSONStrKey:@"pl_Theme"];
        cell.lblTime.text = [dic valueForJSONStrKey:@"pl_PostTime"];
        cell.lblCompany.text = [dic valueForJSONStrKey:@"pl_publisher"];
        cell.lblDetail.text = [dic valueForJSONStrKey:@"pl_Content"];
        
        return cell;
        
    } else {
        
        ReplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyListCell" owner:self options:nil] firstObject];
        }
        return cell;
        
    }
    
    
    
}

- (void)tableView:(RHTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.pl_id = [tableView.dataArray[indexPath.row] valueForJSONStrKey:@"pl_id"];
    [self loadReplyList:self.pl_id];
}


//弹框
- (IBAction)loginOrOutButtonClicked:(UIButton *)sender {
    
    if ([sender isEqual:_btnLogin]) {
        _loginView.hidden = NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:@{} forKey:@"userinfo"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"userlevel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _userView.hidden = YES;
        _btnLoginOut.hidden = YES;
        _btnLogin.hidden = NO;
    }
    
}
//登陆
- (IBAction)loginButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    NSString *userNO = _txtUserNo.text;
    NSString *password = _txtPassword.text;
    if (!userNO.length || !password.length) {
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:kLogin,userNO,password.md5];
    [NetEngine createGetAction:urlStr
                  onCompletion:^(id resData, id resString, BOOL isCache) {
                      DLog(@"%@",resData);
                      if (resData && !isCache) {
                          NSDictionary *dic = [resData valueForJSONKey:@"value"];
                          [self saveUserInfo:dic];
                          [self showUserinfo:dic];
                      }
                      
                  }];
    
    
}

- (void)showUserinfo:(NSDictionary *)dic{
    _loginView.hidden = YES;
    _userView.hidden = NO;
    _btnLoginOut.hidden = NO;
    _btnLogin.hidden = YES;
    _lblUserName.text = [dic valueForJSONStrKey:@"ci_Nickname"];
    _lblSex.text = [[dic valueForJSONStrKey:@"ci_Sex"] intValue] ? @"男" : @"女";
    _lblArea.text = [dic valueForJSONStrKey:@"ci_Area"];
    
    NSString *headerUrlStr = [dic valueForJSONStrKey:@"ci_Head"];
    NSURL *url = [NSURL URLWithString:headerUrlStr];
    [_imageHeader setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];

}

- (void)saveUserInfo:(NSDictionary *)dic{
    
    [[NSUserDefaults standardUserDefaults] setValue:dic forKey:@"userinfo"];
    NSString *userId = [dic valueForJSONStrKey:@"ci_Id"];
    [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"userid"];
    NSString *userLevel = [dic valueForJSONStrKey:@"ci_level"];
    [[NSUserDefaults standardUserDefaults] setValue:userLevel forKey:@"userlevel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self loadTableData];
}

#pragma mark - send actions
//选择照片
- (IBAction)takePhotoButtonClicked:(id)sender {
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

//发送
- (IBAction)sendButtonClicked:(id)sender {
    
    NSString *content = _txtContent.text;
    if (!content.length) return;
    
    NSString *urlStr = [NSString stringWithFormat:kAddPostReply,kUserid,_pl_id,content];
    [NetEngine createGetAction:urlStr onCompletion:^(id resData, id resString, BOOL isCache) {
        DLog(@"%@",resData);
        if (resData && !isCache) {
            self.txtContent.text = @"";
            [self.view endEditing:YES];
        }
    }];
}
//添加新的topic
- (IBAction)addNewTopicClicked:(id)sender {
    if (![kUserid length]) {
        _loginView.hidden = NO;
    } else {
        AddTopicViewController *addtopic = [[AddTopicViewController alloc] init];
        [self.navigationController pushViewController:addtopic animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
