//
//  DetailFoundViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/10/29.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

typedef void (^ReturnDetailFoundFavoriteChangeBlock)(NSString * change);

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface DetailFoundViewController : BaseViewController
@property (nonatomic , strong )NSString * ID;
@property (nonatomic , copy)ReturnDetailFoundFavoriteChangeBlock returnDetailFoundFavoriteChangeBlock;
-(void)returnText:(ReturnDetailFoundFavoriteChangeBlock)block;


@end
