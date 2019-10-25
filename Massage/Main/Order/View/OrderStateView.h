//
//  OrderStateView.h
//  Massage
//
//  Created by 牛先 on 15/11/6.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStateView : UIView
@property (strong, nonatomic) UILabel *orderStateLabel;//订单状态
@property (strong, nonatomic) UIImageView *orderNumImageView;//订单编号图标
@property (strong, nonatomic) UILabel *orderNumLabel;//订单编号
@property (strong, nonatomic) UIImageView *orderDateImageView;//订单日期图标
@property (strong, nonatomic) UILabel *orderDateLabel;//订单日期
@property (strong, nonatomic) UIImageView *serviceImageView;//项目图标
@property (strong, nonatomic) UILabel *serviceNameLabel;//项目名称
@property (strong, nonatomic) UILabel *servicePriceLabel;//项目价格

@property (strong, nonatomic) NSDictionary *data;//接收数据的字典
@end
