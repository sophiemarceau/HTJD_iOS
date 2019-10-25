//
//  FlashDealDetail.m
//  Massage
//
//  Created by 牛先 on 16/2/24.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "FlashDealDetail.h"

@implementation FlashDealDetail


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setData:(NSDictionary *)data {
    //订单详情部分
    self.storeNameLabel.text = [data objectForKey:@"storeName"];
    [self addSubview:self.storeNameLabel];
    
    self.serviceTimeLabel.text = [NSString stringWithFormat:@"%@分钟/钟",[data objectForKey:@"singleTimeLong"]];
    [self addSubview:self.serviceTimeLabel];
    
    self.addressLabel.text = [data objectForKey:@"storeAddress"];
    [self addSubview:self.addressLabel];
    
    double payment = [[data objectForKey:@"payment"]doubleValue];
    payment = payment/100;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计：￥%.2f",payment];
    //对小字体进行处理
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.totalPriceLabel.text];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,4)];
    self.totalPriceLabel.attributedText = str;
    [self addSubview:self.totalPriceLabel];
    //约束
    UILabel *shiChang = [CommentMethod initLabelWithText:@"单钟时长" textAlignment:NSTextAlignmentLeft font:14];
    shiChang.textColor = C6UIColorGray;
    [self addSubview:shiChang];
    [shiChang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {//时长
        make.left.equalTo(shiChang.mas_right).offset(10);
        //        make.top.equalTo(self.storeNameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(14);
        make.centerY.equalTo(shiChang.mas_centerY);
    }];
    
    UILabel *menDian = [CommentMethod initLabelWithText:@"门店名称" textAlignment:NSTextAlignmentLeft font:14];
    menDian.textColor = C6UIColorGray;
    [self addSubview:menDian];
    [menDian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(shiChang.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.storeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {//门店名称
        make.left.equalTo(menDian.mas_right).offset(10);
        //        make.top.equalTo(self.mas_top).offset(15);
        make.right.equalTo(self.mas_right).offset(-10);
        //        make.height.mas_equalTo(14);
        make.centerY.equalTo(menDian.mas_centerY);
    }];
    
    UILabel *diZhi = [CommentMethod initLabelWithText:@"门店地址" textAlignment:NSTextAlignmentLeft font:14];
    diZhi.textColor = C6UIColorGray;
    [self addSubview:diZhi];
    [diZhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(menDian.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {//服务地址
        make.left.equalTo(diZhi.mas_right).offset(10);
        make.top.equalTo(menDian.mas_bottom).offset(8.5);
        make.right.equalTo(self.mas_right).offset(-28);
        //        make.height.mas_equalTo(34);
    }];
    UIImageView *jianTou = [[UIImageView alloc]init];
    [jianTou setImage:[UIImage imageNamed:@"uc_menu_link"]];
    [self addSubview:jianTou];
    [jianTou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.addressLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    UIImageView *line4 = [[UIImageView alloc]init];
    line4.backgroundColor = C2UIColorGray;
    [self addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(14);
        make.height.mas_equalTo(1);
    }];
    
    NSMutableArray *reminderArray = [[NSMutableArray alloc]initWithCapacity:0];
//    [reminderArray addObjectsFromArray:@[@{@"content":@"说明一爱的方式发大水发撒打发"},@{@"content":@"说明二阿斯顿发空间大发啦"},@{@"content":@"说明三发狂了手机发"}]];
    [reminderArray addObjectsFromArray:[data objectForKey:@"remindList"]];
    if (reminderArray.count>0) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.addressLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(1);
        }];
//        CGFloat height = 10;
        for (NSDictionary * dic in reminderArray) {
            UILabel *dian = [[UILabel alloc]init];
            dian.text = @"·";
            dian.textColor = C6UIColorGray;
            dian.font = [UIFont systemFontOfSize:12];
            [self addSubview:dian];
            
            UILabel *contentLabel = [[UILabel alloc]init];
            contentLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"remindContext"]];
            contentLabel.font = [UIFont systemFontOfSize:12];
            contentLabel.textColor = C6UIColorGray;
            contentLabel.numberOfLines = 0;
            [self addSubview:contentLabel];
            
            [dian mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label.mas_bottom).offset(4);
                make.left.equalTo(self.mas_left).offset(10);
                make.height.equalTo(contentLabel.mas_height);
                make.width.mas_equalTo(10);
            }];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label.mas_bottom).offset(4);
                make.left.equalTo(dian.mas_right);
                make.right.equalTo(self.mas_right).offset(-10);
            }];
//            height = height + contentLabel.frame.size.height+20;
            label = contentLabel;
        }
        UIImageView *line5 = [[UIImageView alloc]init];
        line5.backgroundColor = C2UIColorGray;
        [self addSubview:line5];
        [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right);
//            make.top.equalTo(line4.mas_bottom).offset(height+5);
            make.top.equalTo(label.mas_bottom).offset(10);
            make.height.mas_equalTo(1);
        }];
        [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(line5.mas_bottom).offset(15);
            make.height.mas_equalTo(16);
        }];
    }else {
        [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(line4.mas_bottom).offset(15);
            make.height.mas_equalTo(16);
        }];
    }
}
- (void)initView {
    [self addSubview:self.storeNameLabel];
    
    [self addSubview:self.serviceTimeLabel];
    
    [self addSubview:self.addressLabel];
    
    [self addSubview:self.totalPriceLabel];
    //约束
    UILabel *shiChang = [CommentMethod initLabelWithText:@"单钟时长" textAlignment:NSTextAlignmentLeft font:14];
    shiChang.textColor = C6UIColorGray;
    [self addSubview:shiChang];
    [shiChang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {//时长
        make.left.equalTo(shiChang.mas_right).offset(10);
        //        make.top.equalTo(self.storeNameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(14);
        make.centerY.equalTo(shiChang.mas_centerY);
    }];
    
    UILabel *menDian = [CommentMethod initLabelWithText:@"门店名称" textAlignment:NSTextAlignmentLeft font:14];
    menDian.textColor = C6UIColorGray;
    [self addSubview:menDian];
    [menDian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(shiChang.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.storeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {//门店名称
        make.left.equalTo(menDian.mas_right).offset(10);
        //        make.top.equalTo(self.mas_top).offset(15);
        make.right.equalTo(self.mas_right).offset(-10);
//        make.height.mas_equalTo(14);
        make.centerY.equalTo(menDian.mas_centerY);
    }];
    
    UILabel *diZhi = [CommentMethod initLabelWithText:@"门店地址" textAlignment:NSTextAlignmentLeft font:14];
    diZhi.textColor = C6UIColorGray;
    [self addSubview:diZhi];
    [diZhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(menDian.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {//服务地址
        make.left.equalTo(diZhi.mas_right).offset(10);
        make.top.equalTo(menDian.mas_bottom).offset(8.5);
        make.right.equalTo(self.mas_right).offset(-28);
        //        make.height.mas_equalTo(34);
    }];
    UIImageView *jianTou = [[UIImageView alloc]init];
    [jianTou setImage:[UIImage imageNamed:@"uc_menu_link"]];
    [self addSubview:jianTou];
    [jianTou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.addressLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    UIImageView *line4 = [[UIImageView alloc]init];
    line4.backgroundColor = C2UIColorGray;
    [self addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(14);
        make.height.mas_equalTo(1);
    }];
    
    NSMutableArray *reminderArray = [[NSMutableArray alloc]initWithCapacity:0];
    [reminderArray addObjectsFromArray:@[@{@"content":@"说明一爱的方式发大水发撒打发"},@{@"content":@"说明二阿斯顿发空间大发啦"},@{@"content":@"说明三发狂了手机发"}]];
    if (reminderArray.count>0) {
        CGFloat height = 10;
        for (NSDictionary * dic in reminderArray) {
            UILabel * contentLabel = [[UILabel alloc]init];
            contentLabel.text = [NSString stringWithFormat:@"· %@",[dic objectForKey:@"content"]];
            contentLabel.font = [UIFont systemFontOfSize:12];
            contentLabel.textColor = C6UIColorGray;
            contentLabel.numberOfLines = 0;
            [self addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line4.mas_bottom).offset(height);
                make.left.equalTo(self.mas_left).offset(10);
                make.right.equalTo(self.mas_right).offset(-10);
            }];
            height = height + contentLabel.frame.size.height+20;
        }
        UIImageView *line5 = [[UIImageView alloc]init];
        line5.backgroundColor = C2UIColorGray;
        [self addSubview:line5];
        [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(line4.mas_bottom).offset(height+5);
            make.height.mas_equalTo(1);
        }];
        [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(line5.mas_bottom).offset(15);
            make.height.mas_equalTo(16);
        }];
    }else {
        [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(line4.mas_bottom).offset(15);
            make.height.mas_equalTo(16);
        }];
    }
}
#pragma mark - 懒加载
- (UILabel *)storeNameLabel {
    if (_storeNameLabel == nil) {
        self.storeNameLabel = [CommentMethod initLabelWithText:@"华夏良子（广安门店）" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _storeNameLabel;
}
- (UILabel *)serviceTimeLabel {
    if (_serviceTimeLabel == nil) {
        self.serviceTimeLabel = [CommentMethod initLabelWithText:@"888分钟/钟" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _serviceTimeLabel;
}
- (nxUILabel *)addressLabel {
    if (_addressLabel == nil) {
        self.addressLabel = [nxUILabel new];
        self.addressLabel.text = @"朝阳区光华路soho一期二单元8888朝阳区光华路soho一期二单元8888朝阳区光华路soho一期二单元8888朝阳区光华路soho一期二单元8888朝阳区光华路soho一期二单元8888朝阳区光华路soho一期二单元8888";
        self.addressLabel.textAlignment = NSTextAlignmentLeft;
        self.addressLabel.font = [UIFont systemFontOfSize:14];
        self.addressLabel.numberOfLines = 2;
        [self.addressLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _addressLabel;
}
- (UILabel *)totalPriceLabel {
    if (_totalPriceLabel == nil) {
        self.totalPriceLabel = [CommentMethod initLabelWithText:@"总计：￥523.0" textAlignment:NSTextAlignmentRight font:16];
        self.totalPriceLabel.textColor = RedUIColorC1;
        //对小字体进行处理
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.totalPriceLabel.text];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,4)];
        self.totalPriceLabel.attributedText = str;
    }
    return _totalPriceLabel;
}

@end
