//
//  FinishedHomeByStoreViewController.h
//  Massage
//
//  Created by 牛先 on 15/11/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderStateView.h"
#import "OrderDetaiWithStoreAndContact.h"

@interface FinishedHomeByStoreViewController : BaseViewController
@property (strong, nonatomic) UIScrollView *payScrollView;
//订单状态
@property (strong, nonatomic) OrderStateView *orderStateView;
//服务时间
@property (strong, nonatomic) UIView *serviceTimeView;//服务时间背景
@property (strong, nonatomic) UILabel *serviceBeginLabel;//开始时间
@property (strong, nonatomic) UILabel *serviceEndLabel;//结束时间
//订单详情
@property (strong, nonatomic) OrderDetaiWithStoreAndContact *orderDetailView;
//分享领券
@property (strong, nonatomic) UIView *sharedView;//分享背景
@property (strong, nonatomic) UIButton *againButton;//再次预约
@property (strong, nonatomic) UIButton *sharedButton;//分享领券

@property (copy, nonatomic) NSString *orderID;//订单号
@end
