//
//  OrderDetaiWithStoreAndContact.h
//  Massage
//
//  Created by 牛先 on 15/11/6.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nxUILabel.h"

@interface OrderDetaiWithStoreAndContact : UIView
@property (strong, nonatomic) UILabel *storeNameLabel;//门店名称
@property (strong, nonatomic) UILabel *serviceTimeLabel;//服务时长
@property (strong, nonatomic) UILabel *beltLabel;//钟数
@property (strong, nonatomic) UILabel *dateTime;//预约时间
@property (strong, nonatomic) UILabel *dateWorker;//预约技师
@property (strong, nonatomic) nxUILabel *addressLabel;//服务地址
@property (strong, nonatomic) UILabel *contactName;//联系人
@property (strong, nonatomic) UILabel *phoneNumber;//联系电话
@property (strong, nonatomic) nxUILabel *remarkLabel;//备注
@property (strong, nonatomic) UILabel *priceDetailLabel;//价格详情
@property (strong, nonatomic) UILabel *totalTimeLabel;//总时长
@property (strong, nonatomic) UILabel *totalPriceLabel;//总价

@property (strong, nonatomic) NSDictionary *data;//接收数据的字典
@end
