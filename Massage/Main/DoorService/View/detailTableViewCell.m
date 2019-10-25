//
//  detailTableViewCell.m
//  Massage
//
//  Created by 屈小波 on 15/12/15.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "detailTableViewCell.h"

@implementation detailTableViewCell
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
    

    
    [self.contentView addSubview:self.ClientView];
    [self.ClientView addSubview:self.ClientSayView];
    [self.ClientSayView addSubview:self.ClientImageview];
    [self.ClientSayView addSubview:self.ClientLabel];
    [self.ClientSayView addSubview:self.ClientArrow3];
    [self.ClientSayView addSubview: self.ClientCountLabel];
    [self.ClientSayView addSubview:self.line1ImageView];
    [self.ClientView addSubview:self.ServiceView];
    [self.ServiceView addSubview:self.ServiceImageView];
    [self.ServiceView addSubview:self.ServiceDistrictLabel];
    [self.ServiceView addSubview:self.ServiceZoneLabel];
    [self.ClientView addSubview:self.ServiceUIView];
    [self.ServiceUIView addSubview: self.ServiceLabel];
    
    [self.ClientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 415/2*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ClientSayView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45*AUTO_SIZE_SCALE_X));
    }];
    
    
    [self.ClientImageview  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ClientLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ClientArrow3  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(7*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ClientCountLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ClientArrow3.mas_left).offset(-10);
        make.bottom.mas_equalTo(-15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
    }];
    [self.line1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.ClientSayView.mas_bottom).offset(-0.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5
                                         ));
    }];
    
    [self.ServiceView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.ClientSayView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, (112)*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ServiceImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(13*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ServiceDistrictLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ServiceZoneLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(self.ServiceDistrictLabel.mas_bottom).offset(8*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-40-10, 65*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ServiceUIView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.ClientView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 40*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ServiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.ServiceUIView.mas_centerX);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    
    self.ServiceZoneLabel.text =[self.listArrayData objectForKey:@"serviceArea"];
    
   
    if ([[NSString stringWithFormat:@"%@",[self.listArrayData objectForKey:@"commentCount"]] isEqualToString:@"0"]) {
        self.ClientCountLabel.text =@"暂无评论";
    }else{
        self.ClientCountLabel.text =[NSString stringWithFormat:@"%@条",[self.listArrayData objectForKey:@"commentCount"]];
    }

}

-(UIView *)ClientView{
    if (!_ClientView) {
        _ClientView =[UIView new];
        _ClientView.backgroundColor = C2UIColorGray;
        _ClientView.frame = CGRectMake(0, 0, kScreenWidth, 435/2);
    }
    return _ClientView;
    
}


-(UILabel *)ClientLabel{
    if (!_ClientLabel) {
        _ClientLabel =[UILabel new];
        _ClientLabel.font = [UIFont systemFontOfSize:14];
        _ClientLabel.textColor =BlackUIColorC5;
        _ClientLabel.text = @"用户评论";
        
    }
    return _ClientLabel;
    
}

-(UIView *)ClientCountLabel{
    if (!_ClientCountLabel) {
        _ClientCountLabel =[UILabel new];
        _ClientCountLabel.textColor =C7UIColorGray;
        _ClientCountLabel.textAlignment =NSTextAlignmentRight;
        _ClientCountLabel.font =[UIFont systemFontOfSize:12];
    }
    return _ClientCountLabel;
    
}

-(UIView *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel =[UILabel new];
        _distanceLabel.textColor =C7UIColorGray;
        _distanceLabel.font =[UIFont systemFontOfSize:12];
        
    }
    return _distanceLabel;
    
}

-(UIImageView *)line1ImageView{
    if (!_line1ImageView) {
        _line1ImageView =[UIImageView new];
        _line1ImageView.image = [UIImage imageNamed:@""];
        _line1ImageView.backgroundColor =C2UIColorGray;
        
    }
    return _line1ImageView;
}

-(UIImageView *)ServiceImageView{
    if (!_ServiceImageView) {
        _ServiceImageView =[UIImageView new];
        _ServiceImageView.image = [UIImage imageNamed:@"icon_sd_awayfrom"];
        
    }
    return _ServiceImageView;
    
}





-(UILabel *)ServiceDistrictLabel{
    if (!_ServiceDistrictLabel) {
        _ServiceDistrictLabel =[UILabel new];
        _ServiceDistrictLabel.font = [UIFont systemFontOfSize:14];
        _ServiceDistrictLabel.textColor =BlackUIColorC5;
        _ServiceDistrictLabel.text =@"服务商圈";
        
    }
    return _ServiceDistrictLabel;
}

-(UIView *)StoreNameView{
    if (!_StoreNameView) {
        _StoreNameView =[UIView new];
        _StoreNameView.backgroundColor =[UIColor whiteColor];        
    }
    return _StoreNameView;
    
}

-(UILabel *)StoreNameLabel{
    if (!_StoreNameLabel) {
        _StoreNameLabel =[UILabel new];
        _StoreNameLabel.textColor =BlackUIColorC5;
        _StoreNameLabel.font =[UIFont systemFontOfSize:14];
    }
    return _StoreNameLabel;
    
}

-(UIImageView *)phoneView{
    if (!_phoneView) {
        _phoneView = [UIImageView new];
        _phoneView.image =[UIImage imageNamed:@"icon_sd_tel"];
        
    }
    
    return _phoneView;
}


-(UIImageView *)line2ImageView{
    if (!_line2ImageView) {
        _line2ImageView = [UIImageView new];
        _line2ImageView.backgroundColor =C2UIColorGray;
    }
    
    return _line2ImageView;
}

-(UIView *)ServiceView{
    if (!_ServiceView) {
        _ServiceView =[UIView new];
        _ServiceView.backgroundColor =[UIColor whiteColor];
        
        //        UITapGestureRecognizer * setDefaultViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickView:)];
        //        [_ServiceView addGestureRecognizer:setDefaultViewTap];
        //        UIView *singleTapView = [setDefaultViewTap view];
        //        singleTapView.tag = 11001;
        //        _ServiceLabel.text = @"服务商圈";
        
    }
    return _ServiceView;
    
}

-(UIView *)ClientSayView{
    if (!_ClientSayView) {
        _ClientSayView =[UIView new];
        _ClientSayView.backgroundColor =[UIColor whiteColor];
        
        
       
        //        _ServiceLabel.text = @"服务商圈";
        
    }
    return _ClientSayView;
    
}

-(UIImageView *)ClientImageview{
    if (!_ClientImageview) {
        _ClientImageview = [UIImageView new];
        _ClientImageview.image = [UIImage imageNamed:@"icon_sd_comment"];
    }
    
    return _ClientImageview;
}

-(UIImageView *)ClientArrow1{
    if (!_ClientArrow1) {
        _ClientArrow1 = [UIImageView new];
        _ClientArrow1.image = [UIImage imageNamed:@"icon_sd_next"];
        
    }
    
    return _ClientArrow1;
}

-(UIImageView *)ClientArrow2{
    if (!_ClientArrow2) {
        _ClientArrow2 = [UIImageView new];
        _ClientArrow2.image = [UIImage imageNamed:@"icon_sd_next"];
    }
    
    return _ClientArrow2;
}

-(UIImageView *)ClientArrow3{
    if (!_ClientArrow3) {
        _ClientArrow3 = [UIImageView new];
        
        _ClientArrow3.image = [UIImage imageNamed:@"icon_sd_next"];
    }
    
    return _ClientArrow3;
}

-(UIView *)ServiceUIView{
    if (!_ServiceUIView) {
        _ServiceUIView =[UIView new];
        _ServiceUIView.backgroundColor =[UIColor whiteColor];
        //        _ServiceLabel.text = @"服务商圈";
        
    }
    return _ServiceUIView;
    
}

-(UILabel *)ServiceLabel{
    if (!_ServiceLabel) {
        _ServiceLabel =[UILabel new];
        _ServiceLabel.textColor =RedUIColorC1;
        _ServiceLabel.text =@"服务列表";
        _ServiceLabel.font =[UIFont systemFontOfSize:14];
    }
    return _ServiceLabel;
    
}
-(UILabel *)ServiceZoneLabel{
    if (!_ServiceZoneLabel) {
        _ServiceZoneLabel =[UILabel new];
        _ServiceZoneLabel.font = [UIFont systemFontOfSize:14];
        _ServiceZoneLabel.textColor =BlackUIColorC5;
        _ServiceZoneLabel.numberOfLines =0;
        

    }
    return _ServiceZoneLabel;
}

@end
