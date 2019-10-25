//
//  FlashDealServiceViewController.h
//  Massage
//
//  Created by 牛先 on 16/2/24.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "FlashDealState.h"
#import "FlashDealDetail.h"

@interface FlashDealServiceViewController : BaseViewController
@property (strong, nonatomic) UIScrollView *payScrollView;//整个背景图
//订单状态
@property (strong, nonatomic) FlashDealState *orderStateView;
//消费码
@property (strong, nonatomic) UIView *payCodeView;//消费码背景
@property (strong, nonatomic) UILabel *payCodeLabel;//消费码
@property (strong, nonatomic) UILabel *payCodeStateLabel;//消费码状态
//订单详情
@property (strong, nonatomic) FlashDealDetail *orderDetailView;
//联系客服
@property (strong, nonatomic) UIView *callServiceView;//确认背景
@property (strong, nonatomic) UIButton *callServiceButton;//联系客服

@property (copy, nonatomic) NSString *orderID;//订单号
@property (copy, nonatomic) NSString *isNotFromOrderList;

@property (strong, nonatomic) UIView *storeTelPhoneView;//联系方式背景
@property (strong, nonatomic) UILabel *storeTelPhoneLabel;//联系方式
@property (strong, nonatomic) UIImageView *storeTelPhoneImage;//联系方式图标

@end
