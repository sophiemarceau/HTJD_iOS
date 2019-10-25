//
//  StoreAppointmentFromServiceViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/11/19.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface StoreAppointmentFromServiceViewController : BaseViewController
@property (nonatomic,strong) NSString * serviceID;
@property (nonatomic,strong) NSDictionary * serviceInfoDic;
//@property (nonatomic,assign) int maxNumberClock;
@end
