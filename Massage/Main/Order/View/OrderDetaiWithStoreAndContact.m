//
//  OrderDetaiWithStoreAndContact.m
//  Massage
//
//  Created by 牛先 on 15/11/6.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "OrderDetaiWithStoreAndContact.h"

@implementation OrderDetaiWithStoreAndContact

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
    
    self.serviceTimeLabel.text = [NSString stringWithFormat:@"%@分钟",[data objectForKey:@"duration"]];
    [self addSubview:self.serviceTimeLabel];
    
    self.beltLabel.text = [NSString stringWithFormat:@"%@钟",[data objectForKey:@"amount"]];
    [self addSubview:self.beltLabel];
    
    self.dateTime.text = [data objectForKey:@"serviceStartTime"];
    [self addSubview:self.dateTime];
    
    if ([[data objectForKey:@"workerName"]isEqualToString:@""]) {
        self.dateWorker.text = @"推荐技师";
    }else {
        self.dateWorker.text = [NSString stringWithFormat:@"%@  %@  %@",[data objectForKey:@"workerName"],[data objectForKey:@"workerGrade"],[data objectForKey:@"workerGender"]];
    }
    [self addSubview:self.dateWorker];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",[data objectForKey:@"clientArea"],[data objectForKey:@"clientAddress"]];
    [self addSubview:self.addressLabel];
    
    if ([[data objectForKey:@"clientGender"]isEqualToString:@"女"]) {
        self.contactName.text = [NSString stringWithFormat:@"%@  女士",[data objectForKey:@"clientName"]];
    }else {
        self.contactName.text = [NSString stringWithFormat:@"%@  先生",[data objectForKey:@"clientName"]];
    }
    [self addSubview:self.contactName];
    
    self.phoneNumber.text = [data objectForKey:@"clientMobile"];
    [self addSubview:self.phoneNumber];
    
    self.remarkLabel.text = [data objectForKey:@"memo"];
    [self addSubview:self.remarkLabel];
    
    NSString *couString = [NSString stringWithFormat:@"%@",[data objectForKey:@"couponpay"]];
    if ([couString isEqualToString:@"0"]) {
        self.priceDetailLabel.text = [NSString stringWithFormat:@"￥%.2f×%.1f=￥%.2f",[[data objectForKey:@"price"] doubleValue]/100,[[data objectForKey:@"amount"] doubleValue],[[data objectForKey:@"price"] doubleValue]/100*[[data objectForKey:@"amount"] doubleValue]];
    }else {
        self.priceDetailLabel.text = [NSString stringWithFormat:@"￥%.2f×%.1f=￥%.2f  优惠券-￥%.2f",[[data objectForKey:@"price"] doubleValue]/100,[[data objectForKey:@"amount"] doubleValue],[[data objectForKey:@"price"] doubleValue]/100*[[data objectForKey:@"amount"] doubleValue],[[data objectForKey:@"couponpay"]doubleValue]/100];
    }
    [self addSubview:self.priceDetailLabel];
    
    self.totalTimeLabel.text = [NSString stringWithFormat:@"总时长：%.1f分钟",[[data objectForKey:@"duration"] intValue]*[[data objectForKey:@"amount"] doubleValue]];
    [self addSubview:self.totalTimeLabel];
    
    double payment = [[data objectForKey:@"payment"]doubleValue];
    payment = payment/100;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计：￥%.2f",payment];
    //对小字体进行处理
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.totalPriceLabel.text];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,4)];
    self.totalPriceLabel.attributedText = str;
    [self addSubview:self.totalPriceLabel];
    //约束
    UILabel *menDian = [CommentMethod initLabelWithText:@"预约门店" textAlignment:NSTextAlignmentLeft font:14];
    menDian.textColor = C6UIColorGray;
    [self addSubview:menDian];
    [menDian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.storeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {//门店名称
        make.left.equalTo(menDian.mas_right).offset(10);
//        make.top.equalTo(self.mas_top).offset(15);
        make.right.equalTo(self.mas_right).offset(-10);
//        make.height.mas_equalTo(14);
        make.centerY.equalTo(menDian.mas_centerY);
    }];
    UILabel *shiChang = [CommentMethod initLabelWithText:@"单钟时长" textAlignment:NSTextAlignmentLeft font:14];
    shiChang.textColor = C6UIColorGray;
    [self addSubview:shiChang];
    [shiChang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(menDian.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {//时长
        make.left.equalTo(shiChang.mas_right).offset(10);
//        make.top.equalTo(self.storeNameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(14);
        make.centerY.equalTo(shiChang.mas_centerY);
    }];
    UILabel *zhongShu = [CommentMethod initLabelWithText:@"钟       数" textAlignment:NSTextAlignmentLeft font:14];
    zhongShu.textColor = C6UIColorGray;
    [self addSubview:zhongShu];
    [zhongShu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(shiChang.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.beltLabel mas_makeConstraints:^(MASConstraintMaker *make) {//钟数
        make.left.equalTo(zhongShu.mas_right).offset(10);
//        make.top.equalTo(self.serviceTimeLabel.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(14);
        make.centerY.equalTo(zhongShu.mas_centerY);
    }];
    UILabel *shiJian = [CommentMethod initLabelWithText:@"预约时间" textAlignment:NSTextAlignmentLeft font:14];
    shiJian.textColor = C6UIColorGray;
    [self addSubview:shiJian];
    [shiJian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(zhongShu.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.dateTime mas_makeConstraints:^(MASConstraintMaker *make) {//预约时间
        make.left.equalTo(shiJian.mas_right).offset(10);
//        make.top.equalTo(self.beltLabel.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(14);
        make.centerY.equalTo(shiJian.mas_centerY);
    }];
    UIImageView *line3 = [[UIImageView alloc]init];
    line3.backgroundColor = C2UIColorGray;
    [self addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.dateTime.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    UILabel *jiShi = [CommentMethod initLabelWithText:@"预约技师" textAlignment:NSTextAlignmentLeft font:14];
    jiShi.textColor = C6UIColorGray;
    [self addSubview:jiShi];
    [jiShi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(line3.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.dateWorker mas_makeConstraints:^(MASConstraintMaker *make) {//预约技师
        make.left.equalTo(jiShi.mas_right).offset(10);
        make.top.equalTo(line3.mas_bottom).offset(15);
        make.right.equalTo(self.mas_right).offset(-28);
        make.height.mas_equalTo(14);
    }];
    UIImageView *jianTou1 = [[UIImageView alloc]init];
    [jianTou1 setImage:[UIImage imageNamed:@"uc_menu_link"]];
    
    if ([[data objectForKey:@"workerName"]isEqualToString:@""]) {
        jianTou1.hidden = YES;
    }else {
        jianTou1.hidden = NO;
    }
    
    [self addSubview:jianTou1];
    [jianTou1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.dateWorker.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
    UILabel *diZhi = [CommentMethod initLabelWithText:@"服务地址" textAlignment:NSTextAlignmentLeft font:14];
    diZhi.textColor = C6UIColorGray;
    [self addSubview:diZhi];
    [diZhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(jiShi.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {//服务地址
        make.left.equalTo(diZhi.mas_right).offset(10);
        make.top.equalTo(self.dateWorker.mas_bottom).offset(8.5);
        make.right.equalTo(self.mas_right).offset(-28);
//        make.height.mas_equalTo(34);
    }];
//    UIImageView *jianTou = [[UIImageView alloc]init];
//    [jianTou setImage:[UIImage imageNamed:@"uc_menu_link"]];
//    [self addSubview:jianTou];
//    [jianTou mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.centerY.equalTo(self.addressLabel.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(8, 15));
//    }];
    
    UILabel *lianXiRen = [CommentMethod initLabelWithText:@"联系人" textAlignment:NSTextAlignmentLeft font:14];
    lianXiRen.textColor = C6UIColorGray;
    [self addSubview:lianXiRen];
    [lianXiRen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.contactName mas_makeConstraints:^(MASConstraintMaker *make) {//联系人
        make.left.equalTo(lianXiRen.mas_right).offset(10);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(14);
    }];
    UILabel *dianHua = [CommentMethod initLabelWithText:@"联系电话" textAlignment:NSTextAlignmentLeft font:14];
    dianHua.textColor = C6UIColorGray;
    [self addSubview:dianHua];
    [dianHua mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(lianXiRen.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {//联系电话
        make.left.equalTo(dianHua.mas_right).offset(10);
        make.top.equalTo(self.contactName.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(14);
    }];
    UIImageView *line4 = [[UIImageView alloc]init];
    line4.backgroundColor = C2UIColorGray;
    [self addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.phoneNumber.mas_bottom).offset(14);
        make.height.mas_equalTo(1);
    }];
    UILabel *beiZhu = [CommentMethod initLabelWithText:@"备       注" textAlignment:NSTextAlignmentLeft font:14];
    beiZhu.textColor = C6UIColorGray;
    [self addSubview:beiZhu];
    [beiZhu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(line4.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {//备注
        make.left.equalTo(beiZhu.mas_right).offset(10);
        make.top.equalTo(beiZhu.mas_top).offset(-1.5);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    UIImageView *line5 = [[UIImageView alloc]init];
    line5.backgroundColor = C2UIColorGray;
    [self addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.remarkLabel.mas_bottom).offset(14);
        make.height.mas_equalTo(1);
    }];
    [self.priceDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(line5.mas_bottom).offset(15);
        make.height.mas_equalTo(14);
    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.priceDetailLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(14);
    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.totalTimeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(16);
    }];
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
- (UILabel *)beltLabel {
    if (_beltLabel == nil) {
        self.beltLabel = [CommentMethod initLabelWithText:@"3钟" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _beltLabel;
}
- (UILabel *)dateTime {
    if (_dateTime == nil) {
        self.dateTime = [CommentMethod initLabelWithText:@"2015-05-12  21:42" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _dateTime;
}
- (UILabel *)dateWorker {
    if (_dateWorker == nil) {
        self.dateWorker = [CommentMethod initLabelWithText:@"牛大仙儿  巨匠级  男" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _dateWorker;
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
- (UILabel *)contactName {
    if (_contactName == nil) {
        self.contactName = [CommentMethod initLabelWithText:@"狗剩儿" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _contactName;
}
- (UILabel *)phoneNumber {
    if (_phoneNumber == nil) {
        self.phoneNumber = [CommentMethod initLabelWithText:@"13888888888" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _phoneNumber;
}
- (nxUILabel *)remarkLabel {
    if (_remarkLabel == nil) {
        self.remarkLabel = [nxUILabel new];
        self.remarkLabel.text = @"备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 备注多说点儿 ";
        self.remarkLabel.textAlignment = NSTextAlignmentLeft;
        self.remarkLabel.font = [UIFont systemFontOfSize:14];
        self.remarkLabel.numberOfLines = 0;
        self.remarkLabel.textColor = C6UIColorGray;
        [self.remarkLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _remarkLabel;
}
- (UILabel *)priceDetailLabel {
    if (_priceDetailLabel == nil) {
        self.priceDetailLabel = [CommentMethod initLabelWithText:@"￥143×4=￥572  优惠券-￥49" textAlignment:NSTextAlignmentRight font:14];
    }
    return _priceDetailLabel;
}
- (UILabel *)totalTimeLabel {
    if (_totalTimeLabel == nil) {
        self.totalTimeLabel = [CommentMethod initLabelWithText:@"总时长：100分钟" textAlignment:NSTextAlignmentRight font:14];
    }
    return _totalTimeLabel;
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
