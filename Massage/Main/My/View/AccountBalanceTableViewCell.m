//
//  AccountBalanceTableViewCell.m
//  Massage
//
//  Created by htjd_IOS on 15/11/2.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "AccountBalanceTableViewCell.h"
#import "AccountBalanceView.h"
@implementation AccountBalanceTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self _initView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)_initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor =[UIColor clearColor];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"self.listArrayData   %@",self.listArrayData);
    AccountBalanceView * abView = [[AccountBalanceView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 62*AUTO_SIZE_SCALE_X)];
    abView.backgroundColor = [UIColor clearColor];
    abView.dataDic = self.listArrayData;
    [self.contentView addSubview:abView];

}
@end
