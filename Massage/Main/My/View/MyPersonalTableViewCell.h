//
//  MyPersonalTableViewCell.h
//  Massage
//
//  Created by 牛先 on 16/1/28.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPersonalTableViewCell : UITableViewCell
@property (nonatomic,strong)NSMutableDictionary *data;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIImageView *titleImage;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIImageView *rightImage;
@property (strong, nonatomic) UIImageView *line;
@end
