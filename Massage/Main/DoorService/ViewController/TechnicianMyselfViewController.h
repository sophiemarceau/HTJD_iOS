//
//  TechnicianMyselfViewController.h
//  Massage
//
//  Created by sophiemarceau_qu on 15/11/4.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

typedef void (^ReturnMyselfFavoriteChangeBlock)(NSString * change);

#import "BaseViewController.h"

@interface TechnicianMyselfViewController : BaseViewController
@property (nonatomic , strong) NSString * workerID;
@property (nonatomic,strong) NSString * backType; //1返回时回到到店首页

@property (nonatomic , copy) ReturnMyselfFavoriteChangeBlock returnMyselfFavoriteChangeBlock;
-(void)returnText:(ReturnMyselfFavoriteChangeBlock)block;
@end
