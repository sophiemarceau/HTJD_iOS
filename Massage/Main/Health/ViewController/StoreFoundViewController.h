//
//  StoreFoundViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/10/29.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

typedef void (^ReturnStoreFoundFavoriteChangeBlock)(NSString * change);

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface StoreFoundViewController : BaseViewController
@property (nonatomic , strong )NSString * ID;
@property (nonatomic , copy) ReturnStoreFoundFavoriteChangeBlock returnStoreFoundFavoriteChangeBlock;
-(void)returnText:(ReturnStoreFoundFavoriteChangeBlock)block;
@end
