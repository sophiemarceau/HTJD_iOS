//
//  FlashDealDetail.h
//  Massage
//
//  Created by 牛先 on 16/2/24.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nxUILabel.h"

@interface FlashDealDetail : UIView
@property (strong, nonatomic) UILabel *storeNameLabel;//门店名称
@property (strong, nonatomic) UILabel *serviceTimeLabel;//服务时长
@property (strong, nonatomic) nxUILabel *addressLabel;//服务地址
@property (strong, nonatomic) UILabel *totalPriceLabel;//总价

@property (strong, nonatomic) NSDictionary *data;//接收数据的字典
@property (strong, nonatomic) NSMutableArray *reminderArray;

@end
