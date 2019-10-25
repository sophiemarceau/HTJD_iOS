//
//  PayBackStoreViewController.h
//  Massage
//
//  Created by 牛先 on 15/11/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderStateView.h"
#import "OrderDetaiWithStore.h"
@interface PayBackStoreViewController : BaseViewController
@property (strong, nonatomic) UIScrollView *payScrollView;//整个背景图
//订单状态
@property (strong, nonatomic) OrderStateView *orderStateView;
//消费码
@property (strong, nonatomic) UIView *payCodeView;//消费码背景
@property (strong, nonatomic) UILabel *payCodeLabel;//消费码
@property (strong, nonatomic) UILabel *payBackLabel;//退款金额
@property (strong, nonatomic) UILabel *payBackTimeLabel;//退款时间
//提示框
@property (strong, nonatomic) UIView *signView;//提示背景
@property (strong, nonatomic) UILabel *signLabel;//提示框
//订单详情
@property (strong, nonatomic) OrderDetaiWithStore *orderDetailView;
//重新预约
@property (strong, nonatomic) UIView *orderAgainView;//重新预约背景
@property (strong, nonatomic) UIButton *orderAgainButton;//重新预约

@property (copy, nonatomic) NSString *orderID;//订单号
@end
