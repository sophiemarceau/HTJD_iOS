//
//  WaitForHomeServiceViewController.h
//  Massage
//
//  Created by 牛先 on 15/11/6.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderStateView.h"
#import "OrderDetaiWithContact.h"

@interface WaitForHomeServiceViewController : BaseViewController
@property (strong, nonatomic) UIScrollView *payScrollView;
//提示框
@property (strong, nonatomic) UIView *signView;//提示框背景
@property (strong, nonatomic) UILabel *signLabel;//提示框
//订单状态
@property (strong, nonatomic) OrderStateView *orderStateView;
//订单详情
@property (strong, nonatomic) OrderDetaiWithContact *orderDetailView;
//我要加钟
@property (strong, nonatomic) UIView *addBeltView;//加钟背景
@property (strong, nonatomic) UIButton *addBeltButton;//我要加钟

@property (copy, nonatomic) NSString *orderID;//订单号
@property (copy, nonatomic) NSString *isNotFromOrderList;
@end
