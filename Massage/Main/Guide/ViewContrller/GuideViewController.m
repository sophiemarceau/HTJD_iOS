//
//  GuideViewController.m
//  Massage
//
//  Created by sophiemarceau_qu on 15/10/17.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "GuideViewController.h"
#import "CCLocationManager.h"
@interface GuideViewController ()

@end

@interface GuideViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *intoButton;

@end

@implementation GuideViewController
//@synthesize scrollView;

- (void)viewDidLoad {
        [self startLoaction];
    [super viewDidLoad];
    
    
    NSArray *guideImages = @[
                             @"引导页_1@2x",
                             @"引导页_2@2x",
                             @"引导页_3@2x",
//                             @"Guide_ydy-4.png",
//                             @"Guide_ydy-5.png",
                             ];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth*guideImages.count, kScreenHeight);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    //bottom  480/3 =    500*145
    
    for (int i = 0; i < guideImages.count; i++) {
        NSString *guideImageName = guideImages[i];
        //创建操作指南图片视图
        UIImageView *guideImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:guideImageName]];
        guideImageView.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight);
        [_scrollView addSubview:guideImageView];
        
        if (i == guideImages.count -1) {
            UIButton *button = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(intoButtonAction:) Title:@"进入"];
            

            button.titleLabel.font = [UIFont systemFontOfSize:14];

            [button setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [button setTintColor:UIColorFromRGB(0xffffff)];

            button.frame  = CGRectMake(kScreenWidth-40*AUTO_SIZE_SCALE_X-10, AUTO_SIZE_SCALE_X*30, 40*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X);

            [guideImageView addSubview:button];
            guideImageView.userInteractionEnabled = YES;
        }
    }
}

- (void)intoButtonAction:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //滑动到末尾，这两个值是相等的：
    //scrollView.contentOffset.x == scrollView.contentSize.width-scrollView.width
    CGFloat width =  scrollView.contentSize.width;
    CGFloat scWidth = scrollView.frame.size.width;
    CGFloat  sub = scrollView.contentOffset.x -width+ scWidth;
    if (sub > 30) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
    }
}

- (void)startLoaction
{
    
    [[CCLocationManager shareLocation] startLocation];
    
}


@end

