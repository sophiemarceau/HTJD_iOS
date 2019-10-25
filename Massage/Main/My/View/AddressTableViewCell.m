//
//  AddressTableViewCell.m
//  Massage
//
//  Created by htjd_IOS on 15/11/2.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "AddressView.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self _initView];

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

- (void)_initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor =[UIColor clearColor];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //    NSLog(@"self.listArrayData   %@",self.listArrayData);
    AddressView * abView = [[AddressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110*AUTO_SIZE_SCALE_X)];
    abView.backgroundColor = [UIColor clearColor];
    abView.dataDic = self.listArrayData;
    abView.isFromAppointment = self.isFromAppointment;
    [self.contentView addSubview:abView];
    
}
@end
