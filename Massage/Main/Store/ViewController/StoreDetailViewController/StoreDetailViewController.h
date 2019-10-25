//
//  StoreDetailViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/10/19.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

typedef void (^ReturnStoreFavoriteChangeBlock)(NSString * change);

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface StoreDetailViewController : BaseViewController
@property (nonatomic ,strong) NSString * storeID;
@property (nonatomic,strong) NSString * backType; //1返回时回到到店首页

@property (nonatomic , copy) ReturnStoreFavoriteChangeBlock returnStoreFavoriteChangeBlock;
-(void)returnText:(ReturnStoreFavoriteChangeBlock)block;
@end
