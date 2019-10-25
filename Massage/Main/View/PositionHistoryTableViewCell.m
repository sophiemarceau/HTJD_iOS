//
//  PositionHistoryTableViewCell.m
//  Massage
//
//  Created by htjd_IOS on 16/1/13.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "PositionHistoryTableViewCell.h"

@implementation PositionHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

-(void)_initView
{
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}
@end
