//
//  ServiceDetailCell.m
//  Massage
//
//  Created by 屈小波 on 15/10/28.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "ServiceDetailCell.h"

@implementation ServiceDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}
- (void)awakeFromNib
{
    
    [self _initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)_initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //    self.contentView.backgroundColor =[UIColor clearColor];
    
    self.contentView.backgroundColor =[UIColor yellowColor];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
}

@end
