//
//  InteractiveCell.m
//  LXProject
//
//  Created by 孙向前 on 14-9-24.
//  Copyright (c) 2014年 sunxq_xiaoruan. All rights reserved.
//

#import "InteractiveCell.h"

@implementation InteractiveCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
