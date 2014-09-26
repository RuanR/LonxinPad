//
//  InteractiveCell.h
//  LXProject
//
//  Created by 孙向前 on 14-9-24.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@end
