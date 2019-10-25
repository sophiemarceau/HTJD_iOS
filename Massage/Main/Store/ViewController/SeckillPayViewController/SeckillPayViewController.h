//
//  SeckillPayViewController.h
//  Massage
//
//  Created by htjd_IOS on 16/2/29.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface SeckillPayViewController : BaseViewController
@property (nonatomic , strong) NSString * minPrice;
@property (nonatomic , strong) NSString * specialID;
@property (nonatomic , strong) NSString * priceID;
@property (nonatomic , strong) NSString * servName;
@property (nonatomic , strong) NSString * storeName;
@property (nonatomic , strong) NSString * servIcom;
@property (nonatomic , strong) NSMutableArray * activitydescArray;
@end
