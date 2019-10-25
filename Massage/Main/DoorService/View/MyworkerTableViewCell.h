//
//  MyworkerTableViewCell.h
//  Massage
//
//  Created by htjd_IOS on 15/12/8.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyworkerTableViewCell : UITableViewCell
@property (nonatomic,strong)  NSMutableDictionary *data;
@property (strong, nonatomic) UIView *backView;//背景图
@property (strong, nonatomic) UIImageView *headImageView;//头像
@property (strong, nonatomic) UIImageView *dateImageView;//今日可约
@property (strong, nonatomic) UILabel *nameLabel;//姓名
@property (strong, nonatomic) UILabel *busyLabel;//可约
@property (strong, nonatomic) UIImageView *levelImageView;//等级图标
@property (strong, nonatomic) UILabel *levelLabel;//等级
@property (strong, nonatomic) UILabel *scoreLabel;//评分
@property (strong, nonatomic) UILabel *orderLabel;//单数
@property (strong, nonatomic) UILabel *distanceLabel;//距离
@property (strong, nonatomic) UILabel *scoreNumLabel;//评分详情
@property (strong, nonatomic) UILabel *orderNumLabel;//单数详情
@property (strong, nonatomic) UILabel *distanceNumLabel;//距离详情
@property (strong, nonatomic) UILabel *introduceLabel;//简介
@property (strong, nonatomic) UILabel *yuYueButton;//预约
@end
