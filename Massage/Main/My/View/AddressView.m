//
//  AddressView.m
//  Massage
//
//  Created by htjd_IOS on 15/11/2.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "AddressView.h"
#import "ProgressHUD.h"

@implementation AddressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}


-(void)_initView{

    
    
    
    
}

-(void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic!=dataDic) {
        _dataDic =dataDic;
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    //姓名
    UILabel * userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200*AUTO_SIZE_SCALE_X, 35*AUTO_SIZE_SCALE_X)];
    userNameLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"name"]];
    userNameLabel.font = [UIFont systemFontOfSize:14];
    CGSize userNameLabelSize = [userNameLabel intrinsicContentSize];
    if (userNameLabelSize.width>=165*AUTO_SIZE_SCALE_X) {
        userNameLabel.frame = CGRectMake(10, 0, 165*AUTO_SIZE_SCALE_X, 35*AUTO_SIZE_SCALE_X);
    }else{
        userNameLabel.frame = CGRectMake(10, 0, userNameLabelSize.width, 35*AUTO_SIZE_SCALE_X);
    }
    [self.contentView addSubview:userNameLabel];
    
    //性别
    UILabel * sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x+userNameLabel.frame.size.width+5*AUTO_SIZE_SCALE_X, 0, 30*AUTO_SIZE_SCALE_X, 35*AUTO_SIZE_SCALE_X)];
    if ([[self.dataDic objectForKey:@"gender"] isEqualToString:@"男"]) {
        sexLabel.text = [NSString stringWithFormat:@"%@",@"先生"];
    }else{
        sexLabel.text = [NSString stringWithFormat:@"%@",@"女士"];
     }
    sexLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:sexLabel];
    
    //电话
    UILabel * mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,35*AUTO_SIZE_SCALE_X)];
    mobileLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"mobile"]];
    mobileLabel.font = [UIFont systemFontOfSize:14];
    mobileLabel.textColor = OrangeUIColorC4;
    mobileLabel.textAlignment = NSTextAlignmentRight;
    CGSize mobileLabelSize = [mobileLabel intrinsicContentSize];
    mobileLabel.frame = CGRectMake(kScreenWidth-mobileLabelSize.width-12*AUTO_SIZE_SCALE_X, 0, mobileLabelSize.width, 35*AUTO_SIZE_SCALE_X);
    [self.contentView addSubview:mobileLabel];
    
    UIImageView * zhixianImv = [[UIImageView alloc] initWithFrame:CGRectMake(10, mobileLabel.frame.origin.y+mobileLabel.frame.size.height, kScreenWidth-20, 0.5)];
    zhixianImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [self.contentView addSubview:zhixianImv];
    
    //地址
    UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,zhixianImv.frame.origin.y+zhixianImv.frame.size.height,kScreenWidth-20,40*AUTO_SIZE_SCALE_X)];
    addressLabel.text = [NSString stringWithFormat:@"%@%@",[self.dataDic objectForKey:@"userArea"],[self.dataDic objectForKey:@"address"]];
//    addressLabel.text = [NSString stringWithFormat:@"啊啊啊啊啊 啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊 "];
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.numberOfLines = 0;
//    addressLabel.textColor = OrangeUIColorC4;
//    addressLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:addressLabel];
    
    //设置默认
    UIView * setDefaultView = [[UIView alloc] initWithFrame:CGRectMake(0, addressLabel.frame.origin.y+addressLabel.frame.size.height+5,kScreenWidth/2, 16*AUTO_SIZE_SCALE_X)];
    setDefaultView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer * setDefaultViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setDefaultViewTaped:)];
    [setDefaultView addGestureRecognizer:setDefaultViewTap];
    [self.contentView addSubview:setDefaultView];

    //对勾样式
    UIImageView * isDefaultImv = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, 16*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X)];
    isDefaultImv.image = [UIImage imageNamed:@"icon_address_nodef"];
    [setDefaultView addSubview:isDefaultImv];
    isDefaultImv.userInteractionEnabled = YES;
   
    
    //默认字样式
    UILabel * amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(isDefaultImv.frame.origin.x+isDefaultImv.frame.size.width+8*AUTO_SIZE_SCALE_X,0,kScreenWidth/2-(isDefaultImv.frame.origin.x+isDefaultImv.frame.size.width+8*AUTO_SIZE_SCALE_X),16*AUTO_SIZE_SCALE_X)];
    if ([[self.dataDic objectForKey:@"isDefault"]  isEqualToString:@"1"] ) {
        amountLabel.text = [NSString stringWithFormat:@"默认地址"];
        amountLabel.textColor = OrangeUIColorC4;
        isDefaultImv.image = [UIImage imageNamed:@"icon_address_def"];
    }else{
        amountLabel.text = [NSString stringWithFormat:@"设为默认地址"];
        amountLabel.textColor = C6UIColorGray;
        isDefaultImv.image = [UIImage imageNamed:@"icon_address_nodef"];
    }
    amountLabel.font = [UIFont systemFontOfSize:12];
    amountLabel.textAlignment = NSTextAlignmentLeft;
    [setDefaultView addSubview:amountLabel];
    
    //编辑图片
    UIImageView * bjImv = [[UIImageView alloc] initWithFrame:CGRectMake(183*AUTO_SIZE_SCALE_X, addressLabel.frame.origin.y+addressLabel.frame.size.height+5, 16*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
    bjImv.image = [UIImage imageNamed:@"icon_address_edit"];
    [self.contentView addSubview:bjImv];
    
    //编辑文字
    UILabel * bjLabel = [[UILabel alloc] initWithFrame:CGRectMake(bjImv.frame.origin.x+bjImv.frame.size.width+6*AUTO_SIZE_SCALE_X, addressLabel.frame.origin.y+addressLabel.frame.size.height+5, 40, 18*AUTO_SIZE_SCALE_X)];
    bjLabel.text = @"编辑";
    bjLabel.textColor = C6UIColorGray;
    bjLabel.font = [UIFont systemFontOfSize:12];
    CGSize bjLabelSize = [bjLabel intrinsicContentSize];
    bjLabel.frame = CGRectMake(bjLabel.frame.origin.x, bjLabel.frame.origin.y, bjLabelSize.width, bjLabel.frame.size.height);
    [self.contentView addSubview:bjLabel];
    
    //删除背景
    UIView * deleteView = [[UIView alloc] initWithFrame:CGRectMake(bjLabel.frame.origin.x+bjLabel.frame.size.width+24*AUTO_SIZE_SCALE_X, addressLabel.frame.origin.y+addressLabel.frame.size.height+5, kScreenWidth-(bjLabel.frame.origin.x+bjLabel.frame.size.width+24*AUTO_SIZE_SCALE_X)-12*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
//    deleteView.backgroundColor = [UIColor   redColor];
    [self.contentView addSubview:deleteView];
    UITapGestureRecognizer * deleteViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteViewTaped:)];
    [deleteView addGestureRecognizer:deleteViewTap];
    
    //删除图片
    UIImageView * deleteImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
    deleteImv.image = [UIImage imageNamed:@"icon_address_del"];
    [deleteView addSubview:deleteImv];
    
    //删除文字
    UILabel * deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(deleteImv.frame.origin.x+deleteImv.frame.size.width+6*AUTO_SIZE_SCALE_X, 0, 100, 18*AUTO_SIZE_SCALE_X)];
    deleteLabel.text = @"删除";
    deleteLabel.textColor = C6UIColorGray;
    deleteLabel.font = [UIFont systemFontOfSize:12];
    CGSize deleteLabelSize = [deleteLabel intrinsicContentSize];
    deleteLabel.frame = CGRectMake(deleteLabel.frame.origin.x, deleteLabel.frame.origin.y, deleteLabelSize.width, deleteLabel.frame.size.height);
    [deleteView addSubview:deleteLabel];
    
    if (self.isFromAppointment) {
        bjImv.hidden = YES;
        bjLabel.hidden = YES;
        deleteView.hidden = YES;
        deleteImv.hidden = YES;
        deleteLabel.hidden = YES;
    }
}

-(void)setDefaultViewTaped:(UITapGestureRecognizer *)sender
{
    NSLog(@"设置为默认地址");
    if ([[self.dataDic objectForKey:@"isDefault"]  isEqualToString:@"1"]) {
        return;
    }
   [[NSNotificationCenter defaultCenter] postNotificationName:@"resetDefaultAddress" object:[self.dataDic objectForKey:@"ID"]];
    
}

-(void)deleteViewTaped:(UITapGestureRecognizer *)sender
{
    NSLog(@"删除地址");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAddress" object:[self.dataDic objectForKey:@"ID"]];

}

@end
