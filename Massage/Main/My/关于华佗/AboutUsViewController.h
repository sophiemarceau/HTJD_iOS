//
//  AboutUsViewController.h
//  Massage
//
//  Created by 牛先 on 15/10/21.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "nxUILabel.h"

@interface AboutUsViewController : BaseViewController

@property (strong, nonatomic) UIScrollView *MyScrollView;//背景scrollView
@property (strong, nonatomic) UIImageView *headImageView;//头像
@property (strong, nonatomic) UILabel *banBenLabel;//版本
@property (strong, nonatomic) UILabel *titleLabel;//标题
@property (strong, nonatomic) nxUILabel *quanWeiLabel;//权威
@property (strong, nonatomic) nxUILabel *jingZhanLabel;//精湛
@property (strong, nonatomic) nxUILabel *teHuiLabel;//特惠
@property (strong, nonatomic) nxUILabel *bianJieLabel;//便捷
@property (strong, nonatomic) UIButton *pingFenButton;//评分
@property (strong, nonatomic) UIButton *xieYiButton;//协议
@property (strong, nonatomic) UIButton *fanKuiButton;//反馈
@property (strong, nonatomic) UIButton *ruZhuButton;//入驻
@property (strong, nonatomic) UILabel *weiXinLabel;//微信
@property (strong, nonatomic) UILabel *weiBoLabel;//微博
@property (strong, nonatomic) UILabel *guanFangLabel;//官方
@property (strong, nonatomic) UILabel *ICPLabel;//ICP
@end
