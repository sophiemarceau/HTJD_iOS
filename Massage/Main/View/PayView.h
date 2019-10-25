//
//  PayView.h
//  Massage
//
//  Created by htjd_IOS on 15/11/16.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol PayViewDelegate <NSObject>
//
//-(void)changePay:(NSDictionary *)dic;
//
//@end

@interface PayView : UIView
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)NSString * balanceStr;
@property (nonatomic,strong)NSString * money;
//@property (nonatomic,weak)id <PayViewDelegate> delegate;
@property (strong, nonatomic) NSString *fromController;
#pragma mark 金额变动，恢复初始的 支付方式
-(void)setDefaultMode;
@end
