//
//  StoreListTableViewCell.m
//  Massage
//
//  Created by htjd_IOS on 15/11/5.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "StoreListTableViewCell.h"
#import "StoreListView.h"

@implementation StoreListTableViewCell

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
    
    self.contentView.backgroundColor =C2UIColorGray;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
//        NSLog(@"self.listArrayData   %@",self.listArrayData);
    StoreListView * abView = [[StoreListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 305*AUTO_SIZE_SCALE_X)];
    abView.backgroundColor = [UIColor clearColor];
    abView.dataDic = self.listArrayData;
    [self.contentView addSubview:abView];
    
}
@end
