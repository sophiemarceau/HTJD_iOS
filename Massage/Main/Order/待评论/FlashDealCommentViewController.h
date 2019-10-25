//
//  FlashDealCommentViewController.h
//  Massage
//
//  Created by 牛先 on 16/2/24.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "FlashDealState.h"
#import "FlashDealDetail.h"

@interface FlashDealCommentViewController : BaseViewController
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
//我要评论
@property (strong, nonatomic) UIView *commentView;//评论背景
@property (strong, nonatomic) UIButton *commentButton;//我要评论

@property (copy, nonatomic) NSString *orderID;//订单号

@end
