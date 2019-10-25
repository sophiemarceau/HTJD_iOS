//
//  ServiceDetailViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/10/27.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//
typedef void (^ReturnServiceFavoriteChangeBlock)(NSString * change);

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ServiceDetailViewController : BaseViewController     
@property (nonatomic,assign) BOOL haveWorker;
@property (nonatomic,assign) BOOL isStore;
@property (nonatomic,strong) NSString * serviceID;
@property (nonatomic,strong) NSString * isSelfOwned;
@property (nonatomic,strong) NSString * serviceType; //0 到店 1 自营
@property (nonatomic,strong) NSDictionary * workerInfoDic;
@property (nonatomic,strong) NSString * backType; //1返回时回到到店首页
@property (nonatomic , copy) ReturnServiceFavoriteChangeBlock returnServiceFavoriteChangeBlock;
-(void)returnText:(ReturnServiceFavoriteChangeBlock)block;
@end
