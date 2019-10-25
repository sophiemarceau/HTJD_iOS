//
//  CustomCellTableViewCell.h
//  Pet
//
//  Created by ChinaSoft-Developer-01 on 14/7/24.
//  Copyright (c) 2014年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellTableViewCell : UITableViewCell{
    NSMutableArray *_gridViews;
}
@property (nonatomic,strong)NSArray *data;
@property (nonatomic,strong)UIView *bgview;
@end
