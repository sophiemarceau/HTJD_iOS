//
//  technicianViewController.h
//  Massage
//
//  Created by 屈小波 on 15/10/26.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//
typedef void (^ReturnStoreWorkerFavoriteChangeBlock)(NSString * change);

#import "BaseViewController.h"

@interface technicianViewController : BaseViewController
@property (nonatomic,strong)NSString *flag;//0 门店 ，1自营
@property (nonatomic , strong) NSString * workerID;
@property (nonatomic,strong) NSString * backType; //1返回时回到到店首页

@property (nonatomic , copy)ReturnStoreWorkerFavoriteChangeBlock returnStoreWorkerFavoriteChangeBlock;
-(void)returnText:(ReturnStoreWorkerFavoriteChangeBlock)block;
@end
