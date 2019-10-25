//
//  SingleLevelServiceTableViewCell.h
//  Massage
//
//  Created by htjd_IOS on 15/12/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleLevelServiceTableViewCell : UITableViewCell{
    NSMutableArray *_gridViews;
}
@property (nonatomic,strong)NSArray *data;
@property (nonatomic,strong)UIView *bgview;

@end
