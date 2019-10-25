//
//  HissotyTableViewCell.m
//  Massage
//
//  Created by sophiemarceau_qu on 15/11/10.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "HissotyTableViewCell.h"

@implementation HissotyTableViewCell
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
    
    self.contentView.backgroundColor =[UIColor clearColor];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    UILabel *noneView =[UILabel new];
    
    [self.contentView addSubview:noneView];
    
    UIImageView *lineImageView =[UIImageView new];
    lineImageView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineImageView];

        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
              make.size.mas_equalTo(CGSizeMake((kScreenWidth), 0.5));

        }];


    
}
@end
