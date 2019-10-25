//
//  TimeTableViewCell.m
//  Massage
//
//  Created by htjd_IOS on 15/11/13.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//
#define CurrentWidth (kScreenWidth-24*AUTO_SIZE_SCALE_X)

#import "TimeTableViewCell.h"
#import "TimeView.h"
@implementation TimeTableViewCell
//@synthesize data;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
    [self _initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)_initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    _gridViews = [[NSMutableArray alloc]init];
//    for (int i=0; i<4; i++) {
//        TimeView *grid = [[TimeView alloc]initWithFrame:CGRectZero];
//        [_gridViews addObject:grid];
//        [self.contentView addSubview:grid];
//    }
    self.contentView.backgroundColor =[UIColor clearColor];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.bgview) {
        [self.bgview removeFromSuperview];
    }
    self.bgview = [UIView new];
    
    self.bgview.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.bgview.backgroundColor =[UIColor clearColor];
    [self.contentView addSubview:self.bgview];

    _gridViews = [[NSMutableArray alloc]init];
    for (int i=0; i<4; i++) {
        TimeView *grid = [[TimeView alloc]initWithFrame:CGRectZero];
        [_gridViews addObject:grid];
        [self.bgview addSubview:grid];
    }

    
    //    NSLog(@"self.data = %@",self.data);
    for (int i=0; i<4; i++) {
        TimeView *grid =[_gridViews objectAtIndex:i];
        if (i == 0) {
            grid.frame = CGRectMake(0, 0, (CurrentWidth-6*AUTO_SIZE_SCALE_X)/4, 45*AUTO_SIZE_SCALE_X);
        }else if (i == 1 ) {
            grid.frame = CGRectMake( (CurrentWidth-6*AUTO_SIZE_SCALE_X)/4+2*AUTO_SIZE_SCALE_X, 0, (CurrentWidth-6*AUTO_SIZE_SCALE_X)/4, 45*AUTO_SIZE_SCALE_X);
        }else if (i == 2 ) {
            grid.frame = CGRectMake(( (CurrentWidth-6*AUTO_SIZE_SCALE_X)/4+2*AUTO_SIZE_SCALE_X)*i, 0, (CurrentWidth-6*AUTO_SIZE_SCALE_X)/4, 45*AUTO_SIZE_SCALE_X);
        }else if (i == 3 ) {
            grid.frame = CGRectMake(( (CurrentWidth-6*AUTO_SIZE_SCALE_X)/4+2*AUTO_SIZE_SCALE_X)*i, 0, (CurrentWidth-6*AUTO_SIZE_SCALE_X)/4, 45*AUTO_SIZE_SCALE_X);
        }
        
        if (i<self.data.count) {
            grid.hidden = NO;
            
            grid.dataDic = self.data[i];

            if (self.selectDictionary !=nil) {
                if ([[self.selectDictionary objectForKey:@"timeSlot"] isEqualToString:[self.data[i] objectForKey:@"timeSlot"]]) {
                    grid.selectFlag =@"1";
                }else{
                    grid.selectFlag =@"0";
                }
            }else{
                 grid.selectFlag =@"0";
            }
        }else{
            grid.hidden = YES;
        }
       
    }
}

@end
