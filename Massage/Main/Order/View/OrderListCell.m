//
//  OrderListCell.m
//  Massage
//
//  Created by 牛先 on 15/11/1.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

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
    self.contentView.backgroundColor =C2UIColorGray;
    [self.backView addSubview:self.storeBackView];
    [self.backView addSubview:self.storeNameLabel];
    [self.backView addSubview:self.waitingForLabel];
    [self.backView addSubview:self.storeImageView];
    [self.backView addSubview:self.serviceNameLabel];
    [self.backView addSubview:self.homeOrStoreImageView];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.moneyLabel];
    [self.backView addSubview:self.dizhi];
    [self.buttonBackView addSubview:self.IWantButton];
    [self.contentView addSubview:self.backView];
    [self.contentView addSubview:self.buttonBackView];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {//背景图
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top).offset(10);
//        make.height.mas_equalTo(212);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    [self.storeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(35);
    }];
    [self.storeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(10);
//        make.top.equalTo(self.backView.mas_top).offset(11);
        make.centerY.equalTo(self.storeBackView.mas_centerY).offset(10);
//        make.size.mas_equalTo(CGSizeMake(145, 13));
        make.width.mas_equalTo(145);
    }];
    //右侧箭头
    UIImageView *rightImage = [[UIImageView alloc]init];
    [rightImage setImage:[UIImage imageNamed:@"uc_menu_link"]];
    [self.backView addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.storeNameLabel.mas_centerY);
        make.left.mas_equalTo(self.storeNameLabel.mas_right).with.offset(22);
        make.size.mas_equalTo(CGSizeMake(7, 14));
    }];
    [self.waitingForLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        //计算文字宽度
        CGSize size = [self.waitingForLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        make.centerY.mas_equalTo(self.storeNameLabel.mas_centerY);
        make.right.equalTo(self.backView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), ceilf(size.height)));
    }];
    UIImageView *line1 = [[UIImageView alloc]init];
    line1.backgroundColor = C2UIColorGray;
    [self.backView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.storeNameLabel.mas_bottom).offset(9);
        make.height.mas_equalTo(1);
    }];
    [self.storeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(10);
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    [self.serviceNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        //计算文字宽度
        CGSize size = [self.serviceNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        CGFloat maxWidth = kScreenWidth - (self.storeImageView.width + 10 + 10 + 5 + 22 + 10);
        if (size.width > maxWidth) {
            size.width = maxWidth;
        }
        make.left.equalTo(self.storeImageView.mas_right).offset(10);
        make.top.equalTo(line1.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), ceilf(size.height)));
    }];
    [self.homeOrStoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.serviceNameLabel.mas_centerY);
        make.left.mas_equalTo(self.serviceNameLabel.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(22, 12));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeImageView.mas_right).offset(10);
        make.top.equalTo(self.serviceNameLabel.mas_bottom).offset(8);
        make.right.equalTo(self.backView.mas_right).offset(-10);
        make.height.mas_equalTo(11);
    }];
    [self.dizhi mas_makeConstraints:^(MASConstraintMaker *make) {
        //计算文字宽度
        CGSize size = [self.dizhi.text sizeWithAttributes:@{NSFontAttributeName:self.dizhi.font}];
        make.top.equalTo(self.timeLabel.mas_bottom).offset(8);
        make.left.equalTo(self.storeImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), 11));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dizhi.mas_right);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(6.5);
        make.right.equalTo(self.backView.mas_right).offset(-10);
//        make.height.mas_equalTo(36);
    }];
    UIImageView *line2 = [[UIImageView alloc]init];
    line2.backgroundColor = C2UIColorGray;
    [self.backView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.storeImageView.mas_bottom).offset(9);
        make.height.mas_equalTo(1);
    }];
    
    [self.storeTelPhoneView addSubview:self.storeTelPhoneLabel];
    [self.storeTelPhoneView addSubview:self.storeTelPhoneImage];
    [self.backView addSubview:self.storeTelPhoneView];
    
    UIImageView *xuXian1 = [[UIImageView alloc]init];
    xuXian1.image = [UIImage imageNamed:@"img_dottedline1"];
    [self.storeTelPhoneView addSubview:xuXian1];
    
    UIImageView *xuXian2 = [[UIImageView alloc]init];
    xuXian2.image = [UIImage imageNamed:@"img_dottedline1"];
    [self.storeTelPhoneView addSubview:xuXian2];
    
    UIImageView *xuXian3 = [[UIImageView alloc]init];
    xuXian3.image = [UIImage imageNamed:@"img_dottedline2"];
    [self.storeTelPhoneView addSubview:xuXian3];
    
    [xuXian1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeTelPhoneView.mas_left).offset(10);
        make.right.equalTo(self.storeTelPhoneView.mas_right);
        make.top.equalTo(self.storeTelPhoneView.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    [xuXian2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeTelPhoneView.mas_left).offset(10);
        make.right.equalTo(self.storeTelPhoneView.mas_right);
        make.bottom.equalTo(self.storeTelPhoneView.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
    }];
    
    [xuXian3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.storeTelPhoneImage.mas_left).offset(-20);
        make.top.equalTo(self.storeTelPhoneView.mas_top).offset(8);
        make.bottom.equalTo(self.storeTelPhoneView.mas_bottom).offset(-8);
        make.width.mas_equalTo(1);
    }];
    
    [self.storeTelPhoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.storeTelPhoneView.mas_right).offset(-28);
        make.centerY.equalTo(self.storeTelPhoneView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.storeTelPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeTelPhoneView.mas_left).offset(10);
        make.right.equalTo(xuXian3.mas_left).offset(-20);
        make.centerY.equalTo(self.storeTelPhoneView.mas_centerY);
        make.height.mas_equalTo(11);
    }];
    
    [self.storeTelPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.storeImageView.mas_bottom).offset(9);
        make.height.mas_equalTo(42);
    }];
    
    if (self.storeTelPhoneView.hidden == YES) {
        [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView.mas_right).offset(-10);
            make.top.equalTo(self.storeImageView.mas_bottom).offset(22);
            make.size.mas_equalTo(CGSizeMake(200, 14));
            make.bottom.equalTo(self.backView.mas_bottom).offset(-12);
        }];
    }else {
        [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView.mas_right).offset(-10);
            make.top.equalTo(self.storeTelPhoneView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(200, 14));
            make.bottom.equalTo(self.backView.mas_bottom).offset(-12);
        }];
    }
//    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.backView.mas_right).offset(-10);
//        make.top.equalTo(self.storeImageView.mas_bottom).offset(22);
//        make.size.mas_equalTo(CGSizeMake(200, 14));
//        make.bottom.equalTo(self.backView.mas_bottom).offset(-12);
//    }];
    
//    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.backView.mas_right).offset(-10);
//        make.top.equalTo(self.storeTelPhoneView.mas_bottom).offset(12);
//        make.size.mas_equalTo(CGSizeMake(200, 14));
//        make.bottom.equalTo(self.backView.mas_bottom).offset(-12);
//    }];
    [self.buttonBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(60);
    }];
    UIImageView *line3 = [[UIImageView alloc]init];
    line3.backgroundColor = C2UIColorGray;
    [self.buttonBackView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.buttonBackView.mas_top);
        make.height.mas_equalTo(1);
    }];
    [self.IWantButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line3.mas_bottom).offset(12);
        make.right.equalTo(self.buttonBackView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(90, 35));
    }];
}

#pragma mark - 懒加载
- (UIView *)backView {
    if (_backView == nil) {
        self.backView = [[UIView alloc]init];
        self.backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
- (UILabel *)storeNameLabel {
    if (_storeNameLabel == nil) {
        self.storeNameLabel = [[UILabel alloc]init];
        self.storeNameLabel.text = @"测试：店名";
        self.storeNameLabel.textAlignment = NSTextAlignmentLeft;
        self.storeNameLabel.font = [UIFont systemFontOfSize:13];
        self.storeNameLabel.textColor = BlackUIColorC5;
    }
    return _storeNameLabel;
}
- (UILabel *)waitingForLabel {
    if (_waitingForLabel == nil) {
        self.waitingForLabel = [[UILabel alloc]init];
        self.waitingForLabel.text = @"测试中";
        self.waitingForLabel.textAlignment = NSTextAlignmentRight;
        self.waitingForLabel.font = [UIFont systemFontOfSize:14];
        self.waitingForLabel.textColor = UIColorFromRGB(0xea9120);
    }
    return _waitingForLabel;
}
- (UIImageView *)storeImageView {
    if (_storeImageView == nil) {
        self.storeImageView = [[UIImageView alloc]init];
        self.storeImageView.layer.cornerRadius = 3.0;
        self.storeImageView.layer.masksToBounds = YES;
        self.storeImageView.backgroundColor = [UIColor redColor];
    }
    return _storeImageView;
}
- (UILabel *)serviceNameLabel {
    if (_serviceNameLabel == nil) {
        self.serviceNameLabel = [[UILabel alloc]init];
        self.serviceNameLabel.text = @"测试服务名称";
        self.serviceNameLabel.textAlignment = NSTextAlignmentLeft;
        self.serviceNameLabel.font = [UIFont systemFontOfSize:14];
        self.serviceNameLabel.textColor = BlackUIColorC5;
    }
    return _serviceNameLabel;
}
- (UIImageView *)homeOrStoreImageView {
    if (_homeOrStoreImageView == nil) {
        self.homeOrStoreImageView = [[UIImageView alloc]init];
        self.homeOrStoreImageView.layer.cornerRadius = 1.0;
        self.homeOrStoreImageView.layer.masksToBounds = YES;
    }
    return _homeOrStoreImageView;
}
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.text = @"测试时间：2015-11-11 11:11";
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        self.timeLabel.textColor = C6UIColorGray;
        
    }
    return _timeLabel;
}
- (nxUILabel *)addressLabel {
    if (_addressLabel == nil) {
        self.addressLabel = [[nxUILabel alloc]init];
        self.addressLabel.numberOfLines = 2;
        self.addressLabel.text = @"测试地址：北京市朝阳区光华路SOHO一起二单元1705111111111111111111111111111";
        self.addressLabel.textAlignment = NSTextAlignmentLeft;
        self.addressLabel.font = [UIFont systemFontOfSize:11];
        self.addressLabel.textColor = C6UIColorGray;
        [self.addressLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _addressLabel;
}
- (nxUILabel *)dizhi {
    if (_dizhi == nil) {
        //服务地址
        self.dizhi = [[nxUILabel alloc]init];
        self.dizhi.text = @"服务地址：";
        self.dizhi.font = [UIFont systemFontOfSize:11];
        self.dizhi.textColor = C6UIColorGray;
        [self.dizhi setVerticalAlignment:VerticalAlignmentTop];
    }
    return _dizhi;
}
- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        self.moneyLabel = [[UILabel alloc]init];
        self.moneyLabel.text = @"测试金额：￥888";
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        self.moneyLabel.font = [UIFont systemFontOfSize:14];
        self.moneyLabel.textColor = C6UIColorGray;
        //对小字体进行处理
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.moneyLabel.text];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(5,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:15] range:NSMakeRange(6,self.moneyLabel.text.length-6)];
        [str addAttribute:NSForegroundColorAttributeName value:BlackUIColorC5 range:NSMakeRange(5, self.moneyLabel.text.length-5)];
        self.moneyLabel.attributedText = str;
    }
    return _moneyLabel;
}
- (UIButton *)IWantButton {
    if (_IWantButton == nil) {
        self.IWantButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.IWantButton setTitle:@"我要干啥" forState:UIControlStateNormal];
        [self.IWantButton setTitleColor:BlackUIColorC5 forState:UIControlStateNormal];
        self.IWantButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.IWantButton.layer.cornerRadius = 3.0;
        self.IWantButton.layer.borderWidth = 1.0;
        self.IWantButton.layer.borderColor = [C7UIColorGray CGColor];
    }
    return _IWantButton;
}
- (UIView *)buttonBackView {
    if (_buttonBackView == nil) {
        self.buttonBackView = [[UIView alloc]init];
        self.buttonBackView.backgroundColor = [UIColor whiteColor];
    }
    return _buttonBackView;
}
- (UIView *)storeBackView {
    if (_storeBackView == nil) {
        self.storeBackView = [[UIView alloc]init];
        self.storeBackView.userInteractionEnabled = YES;
        self.storeBackView.backgroundColor = [UIColor clearColor];
    }
    return _storeBackView;
}
- (UIView *)storeTelPhoneView {
    if (_storeTelPhoneView == nil) {
        self.storeTelPhoneView = [[UIView alloc]init];
        self.storeTelPhoneView.userInteractionEnabled = YES;
        self.storeTelPhoneView.backgroundColor = [UIColor whiteColor];
    }
    return _storeTelPhoneView;
}
- (UILabel *)storeTelPhoneLabel {
    if (_storeTelPhoneLabel == nil) {
        self.storeTelPhoneLabel = [CommentMethod initLabelWithText:@"测试电话：13888888888" textAlignment:NSTextAlignmentRight font:11];
        self.storeTelPhoneLabel.textColor = C6UIColorGray;
    }
    return _storeTelPhoneLabel;
}
- (UIImageView *)storeTelPhoneImage {
    if (_storeTelPhoneImage == nil) {
        self.storeTelPhoneImage = [[UIImageView alloc]init];
        self.storeTelPhoneImage.image = [UIImage imageNamed:@"icon_phone"];
    }
    return _storeTelPhoneImage;
}
@end
