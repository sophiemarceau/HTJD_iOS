//
//  SeckillTableViewCell.h
//  Massage
//
//  Created by htjd_IOS on 16/2/25.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeckillServiceView.h"

@protocol SeckillTableViewCellPayDelete <NSObject>

-(void)gotoSecKillPay:(NSDictionary *)dic;
-(void)gotoServiceDetail:(NSDictionary *)dic;

@end


@interface SeckillTableViewCell : UITableViewCell

@property (nonatomic , assign) int mycount;
//@property (nonatomic , strong) SeckillServiceView * bgView;
@property (nonatomic , strong) NSDictionary * dataDic;
@property (nonatomic , assign) BOOL timeout;
@property (nonatomic , assign) BOOL timebegin;
@property (nonatomic , strong) NSString * type;
@property (nonatomic , weak) id<SeckillTableViewCellPayDelete> delegate;
@end
