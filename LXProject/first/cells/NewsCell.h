//
//  NewsCell.h
//  LXProject
//
//  Created by 孙向前 on 14-9-19.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;

@end
