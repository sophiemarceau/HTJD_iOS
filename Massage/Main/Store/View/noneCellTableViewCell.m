//
//  noneCellTableViewCell.m
//  Massage
//
//  Created by sophiemarceau_qu on 15/11/6.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "noneCellTableViewCell.h"

@implementation noneCellTableViewCell



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
    
    // Configure the view for the selected state
}

- (void)_initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   
    self.contentView.backgroundColor =[UIColor clearColor];
    self.noneView =[UILabel new];
    [self.contentView addSubview:self.noneView];
    self.noneImageView =[UIImageView new];
    
    [self.contentView addSubview:self.noneImageView];
    self.noneImageView.backgroundColor =[UIColor clearColor];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
   
   
    
    
    [self.noneImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((kScreenWidth-103*AUTO_SIZE_SCALE_X)/2);
        make.top.mas_equalTo(38*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(103*AUTO_SIZE_SCALE_X, 103*AUTO_SIZE_SCALE_X));
    }];
    

    [self.noneView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((kScreenWidth-160*AUTO_SIZE_SCALE_X)/2);
        make.top.mas_equalTo(150*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(160*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X));
    }];
    self.noneView.font =[UIFont systemFontOfSize:12];
    self.noneView.backgroundColor =[UIColor clearColor];
    self.noneView.textAlignment = NSTextAlignmentCenter;
    self.noneView.textColor =BlackUIColorC5;
   

    
}
@end
