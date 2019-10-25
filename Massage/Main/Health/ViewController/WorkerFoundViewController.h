//
//  WorkerFoundViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/10/29.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

typedef void (^ReturnWorkerFoundFavoriteChangeBlock)(NSString * change);

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface WorkerFoundViewController : BaseViewController
@property (nonatomic , strong )NSString * ID;

@property (nonatomic , copy)ReturnWorkerFoundFavoriteChangeBlock returnWorkerFoundFavoriteChangeBlock;
-(void)returnText:(ReturnWorkerFoundFavoriteChangeBlock)block;
@end
