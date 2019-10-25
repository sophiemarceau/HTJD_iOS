//
//  FlashDealFinishViewController.h
//  Massage
//
//  Created by 牛先 on 16/2/24.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "FlashDealState.h"
#import "FlashDealDetail.h"

@interface FlashDealFinishViewController : BaseViewController
@property (strong, nonatomic) UIScrollView *payScrollView;//整个背景图
//订单状态
@property (strong, nonatomic) FlashDealState *orderStateView;
//消费码
@property (strong, nonatomic) UIView *payCodeView;//消费码背景
@property (strong, nonatomic) UILabel *payCodeLabel;//消费码
@property (strong, nonatomic) UILabel *payCodeStateLabel;//消费码状态
@property (strong, nonatomic) UILabel *payTimeLabel;//消费时间
//订单详情
@property (strong, nonatomic) FlashDealDetail *orderDetailView;

@property (copy, nonatomic) NSString *orderID;//订单号

@end
