//
//  PayForFlashDealViewController.h
//  Massage
//
//  Created by 牛先 on 16/3/1.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "PayView.h"

@interface PayForFlashDealViewController : BaseViewController
@property (strong, nonatomic) UIScrollView *payScrollView;//整个背景图
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
