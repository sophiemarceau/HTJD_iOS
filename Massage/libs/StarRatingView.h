//
//  StarRatingView.h
//  Massage
//
//  Created by 屈小波 on 14/11/10.
//  Copyright (c) 2014年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarRatingView;

@protocol NewStarRatingViewDelegate <NSObject>

@optional

-(void)starRatingView:(StarRatingView *)view score:(float)score;
@end
@interface StarRatingView : UIView

@property (nonatomic, readonly) int numberOfStar;

@property (nonatomic, weak) id <NewStarRatingViewDelegate> delegate;

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate;

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

@end

#define kBACKGROUND_STAR @"icon_star_2_big"
#define kFOREGROUND_STAR @"icon_star_1_big"
#define kNUMBER_OF_STAR  5