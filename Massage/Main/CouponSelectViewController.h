//
//  CouponSelectViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/11/21.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^ReturnCouponInfoBlock)(NSDictionary * dic);

@interface CouponSelectViewController : BaseViewController
@property (nonatomic , copy)ReturnCouponInfoBlock returnCouponInfo;
-(void)returnCouponInfo:(ReturnCouponInfoBlock)block;
@property (nonatomic , strong)NSString * serviceID;
@property (nonatomic , strong)NSString * workerId;
@property (nonatomic , strong)NSString * payment;
@property (nonatomic , strong)NSString * storeID;
@end
