//
//  PayView.m
//  Massage
//
//  Created by htjd_IOS on 15/11/16.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "PayView.h"

@implementation PayView
{
    UIImageView * balanceSelectImv;
    UIImageView * alipaySelectImv;
    UIImageView * tenpaySelectImv;
    
    float moneyPrice;
    float balancePrice;
    
    NSString * isPaidByDeposit;
    NSString * payChannelCode;
}
@synthesize money,balanceStr;
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

-(void)layoutSubviews{
    self.fromController = @"";
    NSLog(@"self.money-->%@ self.balanceStr-->%@ fromController-->%@",self.money,self.balanceStr,self.fromController);

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth), 203*AUTO_SIZE_SCALE_X)];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, kScreenWidth-20*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X)];
    titleLabel.text = @"支付方式";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    
#pragma mark 余额支付
    
    UIView * BalancePay = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height, kScreenWidth, 50*AUTO_SIZE_SCALE_X)];
    BalancePay.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:BalancePay];
    UITapGestureRecognizer * balanceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(balanceTaped:)];
    [BalancePay addGestureRecognizer:balanceTap];
    
    UIImageView * balanceImv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, (50-33)/2*AUTO_SIZE_SCALE_X , 33*AUTO_SIZE_SCALE_X, 33*AUTO_SIZE_SCALE_X)];
    balanceImv.image = [UIImage imageNamed:@"icon_order_paybalance"];
    [BalancePay addSubview:balanceImv];
    
    balanceSelectImv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-12*AUTO_SIZE_SCALE_X-12*AUTO_SIZE_SCALE_X, (50-8)/2*AUTO_SIZE_SCALE_X , 12*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X)];
    balanceSelectImv.image = [UIImage imageNamed:@"icon_order_pay"];
    [BalancePay addSubview:balanceSelectImv];
    
    NSString * balanceS = [NSString stringWithFormat:@"%@",self.balanceStr];
    CGFloat balance = [[NSString stringWithFormat:@"%@",self.balanceStr] floatValue];
    NSString * mybalanceStr = [NSString stringWithFormat:@"账户支付:  %0.2f元",balance];
    NSMutableAttributedString * balanceAttStr = [[NSMutableAttributedString alloc] initWithString:mybalanceStr];
    [balanceAttStr addAttribute:NSForegroundColorAttributeName value:C6UIColorGray range:NSMakeRange(0, mybalanceStr.length-balanceS.length-1)];
    [balanceAttStr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(mybalanceStr.length-balanceS.length-1, balanceS.length)];
    [balanceAttStr addAttribute:NSForegroundColorAttributeName value:C6UIColorGray range:NSMakeRange(mybalanceStr.length-1, 1)];
    [balanceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, mybalanceStr.length)];
    UILabel * balanceName = [[UILabel alloc] initWithFrame:CGRectMake(balanceImv.frame.origin.x+balanceImv.frame.size.width+12*AUTO_SIZE_SCALE_X, 0, 225*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X)];
//    balanceName.text = [NSString stringWithFormat:@"账户支付: %@ 元",self.balanceStr];//self.balanceStr
    balanceName.attributedText = balanceAttStr;
    [BalancePay addSubview:balanceName];
    
    UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
    line1.image = [UIImage imageNamed:@"icon_zhixian"];
    [BalancePay addSubview:line1];

    if ([self.balanceStr isEqualToString:@"0.00"]||[self.balanceStr isEqualToString:@"0"]) {
        BalancePay.frame = CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height, kScreenWidth, 0);
        isPaidByDeposit = @"";

    }
    else{
        isPaidByDeposit = @"1";
    }
#pragma mark 支付宝支付
    
    UIView * AlipayPay = [[UIView alloc] initWithFrame:CGRectMake(0, BalancePay.frame.origin.y+BalancePay.frame.size.height, kScreenWidth, 50*AUTO_SIZE_SCALE_X)];
    AlipayPay.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:AlipayPay];
    UITapGestureRecognizer * alipayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alipayTaped:)];
    [AlipayPay addGestureRecognizer:alipayTap];
    
    UIImageView * alipayImv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, (50-33)/2*AUTO_SIZE_SCALE_X , 33*AUTO_SIZE_SCALE_X, 33*AUTO_SIZE_SCALE_X)];
    alipayImv.image = [UIImage imageNamed:@"icon_order_payalipay"];
    [AlipayPay addSubview:alipayImv];
    
    alipaySelectImv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-12*AUTO_SIZE_SCALE_X-12*AUTO_SIZE_SCALE_X, (50-8)/2*AUTO_SIZE_SCALE_X , 12*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X)];
    alipaySelectImv.image = [UIImage imageNamed:@"icon_order_pay"];
    alipaySelectImv.hidden = YES;
    [AlipayPay addSubview:alipaySelectImv];
    
    UILabel * alipayName = [[UILabel alloc] initWithFrame:CGRectMake(alipayImv.frame.origin.x+alipayImv.frame.size.width+12*AUTO_SIZE_SCALE_X, 0, 225*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X)];
    alipayName.text = @"支付宝支付";
    alipayName.textColor = C6UIColorGray;
    alipayName.font = [UIFont systemFontOfSize:12];
    [AlipayPay addSubview:alipayName];
    
    UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
    line2.image = [UIImage imageNamed:@"icon_zhixian"];
    [AlipayPay addSubview:line2];
    
#pragma mark 微信支付

    UIView * TenpayPay = [[UIView alloc] initWithFrame:CGRectMake(0, AlipayPay.frame.origin.y+AlipayPay.frame.size.height, kScreenWidth, 50*AUTO_SIZE_SCALE_X)];
    TenpayPay.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:TenpayPay];
    UITapGestureRecognizer * tenpayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tenpayTaped:)];
    [TenpayPay addGestureRecognizer:tenpayTap];
    
    UIImageView * tenpayImv = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, (50-33)/2*AUTO_SIZE_SCALE_X , 33*AUTO_SIZE_SCALE_X, 33*AUTO_SIZE_SCALE_X)];
    tenpayImv.image = [UIImage imageNamed:@"icon_order_payweixin"];
    [TenpayPay addSubview:tenpayImv];
    
    tenpaySelectImv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-12*AUTO_SIZE_SCALE_X-12*AUTO_SIZE_SCALE_X, (50-8)/2*AUTO_SIZE_SCALE_X , 12*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X)];
    tenpaySelectImv.image = [UIImage imageNamed:@"icon_order_pay"];
    tenpaySelectImv.hidden = YES;
    [TenpayPay addSubview:tenpaySelectImv];
    
    UILabel * tenpayName = [[UILabel alloc] initWithFrame:CGRectMake(tenpayImv.frame.origin.x+tenpayImv.frame.size.width+12*AUTO_SIZE_SCALE_X, 0, 225*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X)];
    tenpayName.text = @"微信支付";
    tenpayName.textColor = C6UIColorGray;
    tenpayName.font = [UIFont systemFontOfSize:12];
    [TenpayPay addSubview:tenpayName];
}

#pragma mark 手势点击

#pragma 选择余额
-(void)balanceTaped:(UITapGestureRecognizer *)sender
{
    NDLog(@"==================%@",self.fromController);
    if ([self.fromController isEqualToString:@"door"]) {
        [MobClick event:DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_ACCOUNT];
    }else if ([self.fromController isEqualToString:@"store"]) {
        [MobClick event:STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_ACCOUNT];
    }
    moneyPrice = [self.money floatValue];
    balancePrice = [self.balanceStr floatValue];
    
    if (balancePrice<moneyPrice) {
        return;
    }
    
    NSLog(@"moneyPrice  %f",moneyPrice);
    NSLog(@"balancePrice  %f",balancePrice);
    NSLog(@"self.money-->%@ self.balanceStr-->%@",self.money,self.balanceStr);

    if(moneyPrice == 0){
        return;
    }
    
    //余额大于支付金额
    if (balancePrice>=moneyPrice) {
        if (balanceSelectImv.hidden == NO) {
            balanceSelectImv.hidden = YES;
            
            //取消余额支付 全部为空
            isPaidByDeposit = @"";
            payChannelCode = @"";
        }else{
            balanceSelectImv.hidden = NO;
            alipaySelectImv.hidden = YES;
            tenpaySelectImv.hidden = YES;
            
            //选择为余额支付 isPaidByDeposit为1,payChannelCode为空
            isPaidByDeposit = @"1";
            payChannelCode = @"";
        }
    }
    //余额小于支付金额
    else{
        if (balanceSelectImv.hidden == NO) {
            balanceSelectImv.hidden = YES;
            
            //取消余额支付 余额为空 payChannelCode不做处理
            isPaidByDeposit = @"";
        }else{
            balanceSelectImv.hidden = NO;

            //选择为余额支付 isPaidByDeposit为1,payChannelCode不做处理
            isPaidByDeposit = @"1";
        }
        
    }
    
    NSDictionary * dic = @{
                           @"isPaidByDeposit":isPaidByDeposit,
                           @"payChannelCode":payChannelCode,
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePayWay" object:dic];
}

#pragma 选择支付宝
-(void)alipayTaped:(UITapGestureRecognizer *)sender
{
//    NDLog(@"==================%@",self.fromController);
    if ([self.fromController isEqualToString:@"door"]) {
        [MobClick event:DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_ZHIFUBAO];
    }else if ([self.fromController isEqualToString:@"store"]) {
        [MobClick event:STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_ZHIFUBAO];
    }
    moneyPrice = [self.money floatValue];
    balancePrice = [self.balanceStr floatValue];
    NSLog(@"moneyPrice  %f",moneyPrice);
    NSLog(@"balancePrice  %f",balancePrice);
    NSLog(@"self.money-->%@ self.balanceStr-->%@",self.money,self.balanceStr);

    if(moneyPrice == 0){
        return;
    }
    
    //余额大于支付金额
    if (balancePrice>=moneyPrice) {
        if (alipaySelectImv.hidden == NO) {
            alipaySelectImv.hidden = YES;
            //取消支付宝支付 全部为空
            isPaidByDeposit = @"";
            payChannelCode = @"";
        }else{
            balanceSelectImv.hidden = YES;
            alipaySelectImv.hidden = NO;
            tenpaySelectImv.hidden = YES;
            //选择支付宝支付 isPaidByDeposit为空,payChannelCode为支付宝方式
            isPaidByDeposit = @"";
            payChannelCode = @"alipay_sdk";
        }
    }
    //余额小于支付金额
    else{
        if (alipaySelectImv.hidden == NO) {
            alipaySelectImv.hidden = YES;
            
            //取消支付宝支付 isPaidByDeposit不做处理,payChannelCode为空
            payChannelCode = @"";
        }else{
//            balanceSelectImv.hidden = YES;
            alipaySelectImv.hidden = NO;
            tenpaySelectImv.hidden = YES;
            
            //选择支付宝支付 isPaidByDeposit不做处理,payChannelCode为支付宝方式
            payChannelCode = @"alipay_sdk";

        }
    }
    NSDictionary * dic = @{
                           @"isPaidByDeposit":isPaidByDeposit,
                           @"payChannelCode":payChannelCode,
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePayWay" object:dic];
}

#pragma 选择微信
-(void)tenpayTaped:(UITapGestureRecognizer *)sender
{
//    NDLog(@"==================%@",self.fromController);
    if ([self.fromController isEqualToString:@"door"]) {
        [MobClick event:DOOR_TICHNICIANDETAIL_PROJECTDETAIL_PLACEORDER_WEIXIN];
    }else if ([self.fromController isEqualToString:@"store"]) {
        [MobClick event:STORE_STOREDETAIL_PROJECTDETAIL_PLACEORDER_WEIXIN];
    }
    moneyPrice = [self.money floatValue];
    balancePrice = [self.balanceStr floatValue];
    NSLog(@"moneyPrice  %f",moneyPrice);
    NSLog(@"balancePrice  %f",balancePrice);
    NSLog(@"self.money-->%@ self.balanceStr-->%@",self.money,self.balanceStr);

    if(moneyPrice == 0){
        return;
    }
    //余额大于支付金额
    if (balancePrice>=moneyPrice) {
        if (tenpaySelectImv.hidden == NO) {
            tenpaySelectImv.hidden = YES;
            //取消微信支付 全部为空
            isPaidByDeposit = @"";
            payChannelCode = @"";
        }else{
            balanceSelectImv.hidden = YES;
            alipaySelectImv.hidden = YES;
            tenpaySelectImv.hidden = NO;
            //选择微信支付 isPaidByDeposit为空,payChannelCode为微信方式
            isPaidByDeposit = @"";
            payChannelCode = @"tenpay_app";
        }
    }
    //余额小于支付金额
    else{
        if (tenpaySelectImv.hidden == NO) {
            tenpaySelectImv.hidden = YES;
            
            //取消微信支付 isPaidByDeposit不做处理,payChannelCode为空
            payChannelCode = @"";
        }else{
//            balanceSelectImv.hidden = YES;
            alipaySelectImv.hidden = YES;
            tenpaySelectImv.hidden = NO;
            
            //选择微信支付 isPaidByDeposit不做处理,payChannelCode为支付宝方式
            payChannelCode = @"tenpay_app";

        }
    }
    NSDictionary * dic = @{
                           @"isPaidByDeposit":isPaidByDeposit,
                           @"payChannelCode":payChannelCode,
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePayWay" object:dic];
}

#pragma mark 金额变动，恢复初始的 支付方式
-(void)setDefaultMode
{
    balanceSelectImv.hidden = NO;
    alipaySelectImv.hidden = YES;
    tenpaySelectImv.hidden = YES;
    //选择为余额支付 isPaidByDeposit为1,payChannelCode为空
    if ([self.balanceStr isEqualToString:@"0.00"]||[self.balanceStr isEqualToString:@"0"]) {
        isPaidByDeposit = @"";
    }
    else{
        isPaidByDeposit = @"1";
    }
    payChannelCode = @"";
    NSDictionary * dic = @{
                           @"isPaidByDeposit":isPaidByDeposit,
                           @"payChannelCode":payChannelCode,
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePayWay" object:dic];
}


@end
