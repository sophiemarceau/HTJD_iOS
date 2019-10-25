//
//  FinishedByQuickPassViewController.h
//  Massage
//
//  Created by 牛先 on 15/11/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderStateView.h"
#import "nxUILabel.h"

@interface FinishedByQuickPassViewController : BaseViewController
@property (strong, nonatomic) UIScrollView *payScrollView;//整个背景图
//订单状态
@property (strong, nonatomic) UIView *orderStateView;
@property (strong, nonatomic) UILabel *orderStateLabel;//订单状态
@property (strong, nonatomic) UIImageView *orderNumImageView;//订单编号图标
@property (strong, nonatomic) UILabel *orderNumLabel;//订单编号
@property (strong, nonatomic) UIImageView *orderDateImageView;//订单日期图标
@property (strong, nonatomic) UILabel *orderDateLabel;//订单日期
@property (strong, nonatomic) UIImageView *serviceImageView;//项目图标
@property (strong, nonatomic) UILabel *serviceNameLabel;//项目名称
//服务地址
@property (strong, nonatomic) UIView *addressView;//地址背景
@property (strong, nonatomic) nxUILabel *addressLabel;//服务地址
//订单详情
@property (strong, nonatomic) UIView *orderDetailView;//详情背景
@property (strong, nonatomic) UILabel *phoneNumber;//联系电话
@property (strong, nonatomic) UILabel *saveLabel;//节省
@property (strong, nonatomic) UILabel *totalSaveLabel;//总计节省
@property (strong, nonatomic) UILabel *totalPriceLabel;//总支付
@property (strong, nonatomic) UILabel *actualPriceLabel;//实际支付
//分享领券
@property (strong, nonatomic) UIView *sharedView;//分享背景
@property (strong, nonatomic) UIButton *sharedButton;//分享领券

@property (copy, nonatomic) NSString *orderID;//订单号

@property (strong, nonatomic) UIView *quickPassView;//闪付介绍
@end
