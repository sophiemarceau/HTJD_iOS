//
//  TimeTableViewCell.h
//  Massage
//
//  Created by htjd_IOS on 15/11/13.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTableViewCell : UITableViewCell
{
    NSMutableArray *_gridViews;
}

@property (nonatomic,strong)NSArray *data;
@property (nonatomic,strong)NSMutableDictionary *selectDictionary;
@property (nonatomic,assign)long cellRow;
@property (nonatomic,strong)UIView *bgview;

@end
