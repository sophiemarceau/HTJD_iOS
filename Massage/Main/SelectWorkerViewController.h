//
//  SelectWorkerViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/11/16.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^ReturnSelectWorkerBlock)(NSDictionary * dic);

@interface SelectWorkerViewController : BaseViewController
@property (nonatomic , strong) NSString * amount; //钟数
@property (nonatomic , strong) NSString * serviceTime; //服务时间
@property (nonatomic , strong) NSString * serviceType; //服务类型
@property (nonatomic , strong) NSString * serviceID; //服务ID
@property (nonatomic , strong) NSString * gradeID; //服务等级
@property (nonatomic , strong) NSString * addressID; //服务地址ID

@property (nonatomic , strong) ReturnSelectWorkerBlock returnSelectWorkerBlock;
-(void)returnWorkerSelectDic:(ReturnSelectWorkerBlock)block;

@end
