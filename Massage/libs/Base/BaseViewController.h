
//  WXMovie
//
//  Created by 牛顿、 on 13-9-4.
//  Copyright (c) 2013年 www.736014814@qq.com牛顿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavView.h"

@interface BaseViewController : UIViewController

@property(nonatomic,assign)BOOL isBackButton; //push
@property(nonatomic,assign)BOOL isModalButton;//present
@property(nonatomic,assign)BOOL isBackFromOrderPay;
@property (nonatomic,copy) NSString *titles;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong)BaseNavView *navView;


-(void)backAction;

@end
