//
//  FlashDealPayViewController.h
//  Massage
//
//  Created by 牛先 on 16/2/24.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "nxUILabel.h"
#import "FlashDealState.h"
#import "FlashDealDetail.h"
#import "PayView.h"

@interface FlashDealPayViewController : BaseViewController

@property (strong, nonatomic) UIScrollView *payScrollView;//整个背景图
/**
 *  取消订单提示
 */
@property (strong, nonatomic) UIView *cancleSignView;//订单取消背景
@property (strong, nonatomic) UIImageView *cancleImageView;//订单取消警告框
@property (strong, nonatomic) UILabel *cancleLabel;//订单取消提示
/**
 *  订单状态
 */
@property (strong, nonatomic) FlashDealState *orderStateView;//订单状态背景
/**
 *  订单详情
 */
@property (strong, nonatomic) FlashDealDetail *orderDetailView;
/**
 *  支付方式
 */
@property (strong, nonatomic) PayView *payModeView;//支付方式背景
/**
 *  确认付款
 */
@property (strong, nonatomic) UIView *confirmView;//确认背景
@property (strong, nonatomic) UIButton *cancleButton;//取消订单
@property (strong, nonatomic) UIButton *confirmButton;//确认支付

@property (copy, nonatomic) NSString *orderID;//订单号

@property (copy, nonatomic) NSString *isNotFromOrderList;
@end
