//
//  WaitForStoreServiceViewController.h
//  Massage
//
//  Created by 牛先 on 15/11/5.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderStateView.h"
#import "OrderDetaiWithStore.h"

@interface WaitForStoreServiceViewController : BaseViewController
@property (strong, nonatomic) UIScrollView *payScrollView;//整个背景图
//取消订单提示
@property (strong, nonatomic) UIView *cancleSignView;//订单取消背景
@property (strong, nonatomic) UILabel *cancleLabel;//订单取消提示
//订单状态
@property (strong, nonatomic) OrderStateView *orderStateView;
//消费码
@property (strong, nonatomic) UIView *payCodeView;//消费码背景
@property (strong, nonatomic) UILabel *payCodeLabel;//消费码
//订单详情
@property (strong, nonatomic) OrderDetaiWithStore *orderDetailView;
//联系客服
@property (strong, nonatomic) UIView *customServiceView;//确认背景
@property (strong, nonatomic) UIButton *callServiceButton;//联系客服

@property (copy, nonatomic) NSString *orderID;//订单号
@property (copy, nonatomic) NSString *isNotFromOrderList;
@end
