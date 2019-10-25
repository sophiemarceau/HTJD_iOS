//
//  PayViewController.h
//  Massage
//
//  Created by 牛先 on 15/11/29.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "PayView.h"

@interface PayViewController : BaseViewController
/**
 *  取消订单提示
 */
@property (strong, nonatomic) UIView *cancleSignView;//订单取消背景
@property (strong, nonatomic) UIImageView *cancleImageView;//订单取消警告框
@property (strong, nonatomic) UILabel *cancleLabel;//订单取消提示
/**
 *  订单状态
 */
@property (strong, nonatomic) UIView *orderStateView;//订单状态背景
@property (strong, nonatomic) UIImageView *serviceImageView;//项目图标
@property (strong, nonatomic) UILabel *serviceNameLabel;//项目名称
@property (strong, nonatomic) UILabel *servicePriceLabel;//项目价格
/**
 *  支付方式
 */
@property (strong, nonatomic) PayView *payModeView;//支付方式背景
/**
 *  确认付款
 */
@property (strong, nonatomic) UIView *confirmView;//确认背景
@property (strong, nonatomic) UIButton *confirmButton;//确认支付

@property (copy, nonatomic) NSString *orderID;//订单号
@end
