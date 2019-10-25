//
//  FlashDealState.m
//  Massage
//
//  Created by 牛先 on 16/2/24.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "FlashDealState.h"
#import "UIImageView+WebCache.h"

@implementation FlashDealState

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        [self initView];
    }
    return self;
}
- (void)setData:(NSDictionary *)data {
    //订单状态部分
    if ([[data objectForKey:@"status"]isEqualToString:@"1"]) {
        self.orderStateLabel.text = @"订单状态：待付款";
        //文字变色
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.orderStateLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:OrangeUIColorC4 range:NSMakeRange(5, self.orderStateLabel.text.length-5)];
        self.orderStateLabel.attributedText = str;
    }else if ([[data objectForKey:@"status"]isEqualToString:@"2"]) {
        if ([[data objectForKey:@"orderClass"]isEqualToString:@"1"]) {
            self.orderStateLabel.text = @"订单状态：待服务";
            //文字变色
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.orderStateLabel.text];
            [str addAttribute:NSForegroundColorAttributeName value:OrangeUIColorC4 range:NSMakeRange(5, self.orderStateLabel.text.length-5)];
            self.orderStateLabel.attributedText = str;
        }
    }else if ([[data objectForKey:@"status"]isEqualToString:@"5"]) {
        self.orderStateLabel.text = @"订单状态：待评论";
        //文字变色
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.orderStateLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:OrangeUIColorC4 range:NSMakeRange(5, self.orderStateLabel.text.length-5)];
        self.orderStateLabel.attributedText = str;
    }else if ([[data objectForKey:@"status"]isEqualToString:@"6"]) {
        self.orderStateLabel.text = @"订单状态：已完成";
        //文字变色
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.orderStateLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:OrangeUIColorC4 range:NSMakeRange(5, self.orderStateLabel.text.length-5)];
        self.orderStateLabel.attributedText = str;
    }
    [self addSubview:self.orderStateLabel];
    
    [self addSubview:self.orderNumImageView];
    
    self.orderNumLabel.text = [data objectForKey:@"orderID"];
    [self addSubview:self.orderNumLabel];
    
    [self addSubview:self.orderDateImageView];
    
    self.orderDateLabel.text = [data objectForKey:@"orderTime"];
    [self addSubview:self.orderDateLabel];
    
    [self.serviceImageView setImageWithURL:[NSURL URLWithString:[data objectForKey:@"serviceIcon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    [self addSubview:self.serviceImageView];
    
    self.serviceNameLabel.text = [NSString stringWithFormat:@"项目名称：%@",[data objectForKey:@"serviceName"]];
    [self addSubview:self.serviceNameLabel];
//    self.servicePriceLabel.text = [NSString stringWithFormat:@"价格：￥%.2f",[[data objectForKey:@"price"] doubleValue]/100];
//    [self addSubview:self.servicePriceLabel];
    //约束
    [self.orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {//订单状态
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(13);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
    UIImageView *line1 = [[UIImageView alloc]init];
    line1.image = [UIImage imageNamed:@"img_dottedline1"];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.orderStateLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
    }];
    [self.orderNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {//订单号图标
        make.centerY.equalTo(self.orderNumLabel.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(12, 16));
    }];
    [self.orderNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {//订单号
        //计算文字宽度
        CGSize size = [self.orderNumLabel.text sizeWithAttributes:@{NSFontAttributeName:self.orderNumLabel.font}];
        make.top.equalTo(line1.mas_bottom).offset(12);
        make.left.equalTo(self.orderNumImageView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), ceilf(size.height)));
    }];
    [self.orderDateLabel mas_updateConstraints:^(MASConstraintMaker *make) {//订单日期
        //计算文字宽度
        CGSize size = [self.orderDateLabel.text sizeWithAttributes:@{NSFontAttributeName:self.orderDateLabel.font}];
        make.top.equalTo(line1.mas_bottom).offset(12);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), ceilf(size.height)));
    }];
    [self.orderDateImageView mas_makeConstraints:^(MASConstraintMaker *make) {//订单日期图标
        make.centerY.equalTo(self.orderDateLabel.mas_centerY);
        make.right.equalTo(self.orderDateLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    UIImageView *line2 = [[UIImageView alloc]init];
    line2.backgroundColor = C2UIColorGray;
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.orderDateLabel.mas_bottom).offset(11);
        make.height.mas_equalTo(1);
    }];
    
    [self.serviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {//项目图标
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(line2.mas_bottom).offset(11);
        make.size.mas_equalTo(CGSizeMake(58, 58));
    }];
    [self.serviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {//项目名称
        make.left.equalTo(self.serviceImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.serviceImageView.mas_centerY);
//        make.top.equalTo(self.serviceImageView.mas_top).offset(10);
//        make.height.mas_equalTo(14);
    }];
}
- (void)initView {
    [self addSubview:self.orderStateLabel];
    
    [self addSubview:self.orderNumImageView];
    
    [self addSubview:self.orderNumLabel];
    
    [self addSubview:self.orderDateImageView];
    
    [self addSubview:self.orderDateLabel];
    
    [self addSubview:self.serviceImageView];
    
    [self addSubview:self.serviceNameLabel];
    
    //约束
    [self.orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {//订单状态
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(13);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
    UIImageView *line1 = [[UIImageView alloc]init];
    line1.image = [UIImage imageNamed:@"img_dottedline1"];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.orderStateLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
    }];
    [self.orderNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {//订单号图标
        make.centerY.equalTo(self.orderNumLabel.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(12, 16));
    }];
    [self.orderNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {//订单号
        //计算文字宽度
        CGSize size = [self.orderNumLabel.text sizeWithAttributes:@{NSFontAttributeName:self.orderNumLabel.font}];
        make.top.equalTo(line1.mas_bottom).offset(12);
        make.left.equalTo(self.orderNumImageView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), ceilf(size.height)));
    }];
    [self.orderDateLabel mas_updateConstraints:^(MASConstraintMaker *make) {//订单日期
        //计算文字宽度
        CGSize size = [self.orderDateLabel.text sizeWithAttributes:@{NSFontAttributeName:self.orderDateLabel.font}];
        make.top.equalTo(line1.mas_bottom).offset(12);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), ceilf(size.height)));
    }];
    [self.orderDateImageView mas_makeConstraints:^(MASConstraintMaker *make) {//订单日期图标
        make.centerY.equalTo(self.orderDateLabel.mas_centerY);
        make.right.equalTo(self.orderDateLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    UIImageView *line2 = [[UIImageView alloc]init];
    line2.backgroundColor = C2UIColorGray;
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.orderDateLabel.mas_bottom).offset(11);
        make.height.mas_equalTo(1);
    }];
    
    [self.serviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {//项目图标
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(line2.mas_bottom).offset(11);
        make.size.mas_equalTo(CGSizeMake(58, 58));
    }];
    [self.serviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {//项目名称
        make.left.equalTo(self.serviceImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.serviceImageView.mas_centerY);
        //        make.top.equalTo(self.serviceImageView.mas_top).offset(10);
        //        make.height.mas_equalTo(14);
    }];
    
}
#pragma mark - 懒加载
- (UILabel *)orderStateLabel {
    if (_orderStateLabel == nil) {
        self.orderStateLabel = [CommentMethod initLabelWithText:@"订单状态：待某某" textAlignment:NSTextAlignmentLeft font:14];
        //文字变色
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.orderStateLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:OrangeUIColorC4 range:NSMakeRange(5, self.orderStateLabel.text.length-5)];
        self.orderStateLabel.attributedText = str;
    }
    return _orderStateLabel;
}
- (UIImageView *)orderNumImageView {
    if (_orderNumImageView == nil) {
        self.orderNumImageView = [UIImageView new];
        [self.orderNumImageView setImage:[UIImage imageNamed:@"icon_order_ordernum"]];
    }
    return _orderNumImageView;
}
- (UILabel *)orderNumLabel {
    if (_orderNumLabel == nil) {
        self.orderNumLabel = [CommentMethod initLabelWithText:@"241241515214" textAlignment:NSTextAlignmentLeft font:12];
        self.orderNumLabel.textColor = C7UIColorGray;
    }
    return _orderNumLabel;
}
- (UIImageView *)orderDateImageView {
    if (_orderDateImageView == nil) {
        self.orderDateImageView = [UIImageView new];
        [self.orderDateImageView setImage:[UIImage imageNamed:@"icon_order_orderdate"]];
    }
    return _orderDateImageView;
}
- (UILabel *)orderDateLabel {
    if (_orderDateLabel == nil) {
        self.orderDateLabel = [CommentMethod initLabelWithText:@"2014-12-22 22:12:14" textAlignment:NSTextAlignmentLeft font:12];
        self.orderDateLabel.textColor = C7UIColorGray;
    }
    return _orderDateLabel;
}
- (UIImageView *)serviceImageView {
    if (_serviceImageView == nil) {
        self.serviceImageView = [UIImageView new];
        self.serviceImageView.backgroundColor = [UIColor greenColor];
        self.serviceImageView.layer.cornerRadius = 5.0;
        self.serviceImageView.layer.masksToBounds = YES;
    }
    return _serviceImageView;
}
- (UILabel *)serviceNameLabel {
    if (_serviceNameLabel == nil) {
        self.serviceNameLabel = [CommentMethod initLabelWithText:@"项目名称：推拿按摩" textAlignment:NSTextAlignmentLeft font:14];
    }
    return _serviceNameLabel;
}
//- (UILabel *)servicePriceLabel {
//    if (_servicePriceLabel == nil) {
//        self.servicePriceLabel = [CommentMethod initLabelWithText:@"价格：￥415154" textAlignment:NSTextAlignmentLeft font:14];
//    }
//    return _servicePriceLabel;
//}

@end
