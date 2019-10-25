//
//  BaseNavView.m
//  newTestDemo
//
//  Created by Hello酷狗 on 15/5/22.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "BaseNavView.h"

#define   kScreenHeight [UIScreen mainScreen].bounds.size.height
#define   kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface BaseNavView()

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation BaseNavView

- (instancetype)init
{
    if (self = [super init]) {
        //初始化视图
        [self _initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}

//初始化视图
- (void)_initView
{
   //创建标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        [self setNeedsLayout];
    }
}
//
- (void)layoutSubviews
{
    [super layoutSubviews];

    self.titleLabel.frame = CGRectMake((kScreenWidth-200)/2, 20, 200, 44);
    self.titleLabel.font =[UIFont boldSystemFontOfSize:18];
    self.titleLabel.text = _title;

   

}




@end
