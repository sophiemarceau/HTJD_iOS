//
//  SelectTimeViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/11/12.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^ReturnSelectTimeBlock)(NSString * showTime,NSString * selectTime,NSString * transportationFee,NSDictionary * currentDic,long day ) ;


@interface SelectTimeViewController : BaseViewController
@property (nonatomic,strong) NSString * serviceID;
@property (nonatomic,strong) NSString * beltStr;
@property (nonatomic,strong) NSString * workerID;
//@property (nonatomic,strong) NSMutableDictionary * selectTimedic;
//@property (nonatomic,assign) long currentDay;

@property (nonatomic,strong) NSString * defaultShowTimeStr;
@property (nonatomic,strong) NSString * defaultSelectTimeStr;
@property (nonatomic,strong) NSString * defaultTransFee;
@property (nonatomic,assign) long defaultDay;
@property (nonatomic,strong)NSMutableDictionary *defaultDictionary;

//@property (nonatomic,strong) NSString * beltStr;
//@property (nonatomic,strong) NSString * beltStr;
//@property (nonatomic,strong) NSString * beltStr;

@property (nonatomic, copy) ReturnSelectTimeBlock returnSelectTimeBlock;
- (void)returnText:(ReturnSelectTimeBlock)block;
@end
