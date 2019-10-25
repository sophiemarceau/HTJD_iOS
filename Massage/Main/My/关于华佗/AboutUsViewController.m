//
//  AboutUsViewController.m
//  Massage
//
//  Created by 牛先 on 15/10/21.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "AboutUsViewController.h"
#import "JoinUsViewController.h"
#import "FeedBackViewController.h"
#import "AgreementViewController.h"
#import "nxUILabel.h"

@interface AboutUsViewController ()
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"关于华佗";
    [self initView];
    NSLog(@"viewDidLoad:%f  %f",self.MyScrollView.contentSize.width,self.MyScrollView.contentSize.height);
}
- (void)initView {
    [self.view addSubview:self.MyScrollView];
    [self.MyScrollView addSubview:self.headImageView];
    [self.MyScrollView addSubview:self.banBenLabel];
    UIImageView *line1 = [[UIImageView alloc]init];
    line1.backgroundColor = C7UIColorGray;
    [self.MyScrollView addSubview:line1];
    [self.MyScrollView addSubview:self.titleLabel];
    [self.MyScrollView addSubview:self.quanWeiLabel];
    [self.MyScrollView addSubview:self.jingZhanLabel];
    [self.MyScrollView addSubview:self.teHuiLabel];
    [self.MyScrollView addSubview:self.bianJieLabel];
    UIImageView *line2 = [[UIImageView alloc]init];
    line2.backgroundColor = C7UIColorGray;
    [self.MyScrollView addSubview:line2];
    [self.MyScrollView addSubview:self.pingFenButton];
    [self.MyScrollView addSubview:self.xieYiButton];
    [self.MyScrollView addSubview:self.fanKuiButton];
    [self.MyScrollView addSubview:self.ruZhuButton];
    [self.MyScrollView addSubview:self.weiXinLabel];
    [self.MyScrollView addSubview:self.weiBoLabel];
    [self.MyScrollView addSubview:self.guanFangLabel];
    [self.MyScrollView addSubview:self.ICPLabel];
    //约束
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.MyScrollView.mas_top).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.banBenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(16);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.banBenLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(18);
    }];
    //全面
    nxUILabel *quanmian = [[nxUILabel alloc]init];
    quanmian.text = @"【全面】：";
    quanmian.font = [UIFont systemFontOfSize:12];
    quanmian.textColor = UIColorFromRGB(0X7B7F84);
    [quanmian setVerticalAlignment:VerticalAlignmentTop];
    [self.MyScrollView addSubview:quanmian];
    [quanmian mas_makeConstraints:^(MASConstraintMaker *make) {
        //计算文字宽度
        CGSize size = [quanmian.text sizeWithAttributes:@{NSFontAttributeName:quanmian.font}];
        make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), 35));
    }];
    [self.quanWeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
        make.left.equalTo(quanmian.mas_right);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(35);
    }];
    //权威
    nxUILabel *quanwei = [[nxUILabel alloc]init];
    quanwei.text = @"【权威】：";
    quanwei.font = [UIFont systemFontOfSize:12];
    quanwei.textColor = UIColorFromRGB(0X7B7F84);
    [quanwei setVerticalAlignment:VerticalAlignmentTop];
    [self.MyScrollView addSubview:quanwei];
    [quanwei mas_makeConstraints:^(MASConstraintMaker *make) {
        //计算文字宽度
        CGSize size = [quanwei.text sizeWithAttributes:@{NSFontAttributeName:quanwei.font}];
        make.top.equalTo(self.jingZhanLabel.mas_top);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), 35));
    }];
    [self.jingZhanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.quanWeiLabel.mas_bottom).offset(3);
        make.left.equalTo(quanwei.mas_right);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(35);
    }];
    //精湛
    nxUILabel *jingzhan = [[nxUILabel alloc]init];
    jingzhan.text = @"【精湛】：";
    jingzhan.font = [UIFont systemFontOfSize:12];
    jingzhan.textColor = UIColorFromRGB(0X7B7F84);
    [jingzhan setVerticalAlignment:VerticalAlignmentTop];
    [self.MyScrollView addSubview:jingzhan];
    [jingzhan mas_makeConstraints:^(MASConstraintMaker *make) {
        //计算文字宽度
        CGSize size = [jingzhan.text sizeWithAttributes:@{NSFontAttributeName:jingzhan.font}];
        make.top.equalTo(self.teHuiLabel.mas_top);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), 35));
    }];
    [self.teHuiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jingZhanLabel.mas_bottom).offset(3);
        make.left.equalTo(jingzhan.mas_right);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(35);
    }];
    //便捷
    nxUILabel *bianjie = [[nxUILabel alloc]init];
    bianjie.text = @"【便捷】：";
    bianjie.font = [UIFont systemFontOfSize:12];
    bianjie.textColor = UIColorFromRGB(0X7B7F84);
    [bianjie setVerticalAlignment:VerticalAlignmentTop];
    [self.MyScrollView addSubview:bianjie];
    [bianjie mas_makeConstraints:^(MASConstraintMaker *make) {
        //计算文字宽度
        CGSize size = [bianjie.text sizeWithAttributes:@{NSFontAttributeName:bianjie.font}];
        make.top.equalTo(self.bianJieLabel.mas_top);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(ceilf(size.width), 18));
    }];
    [self.bianJieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teHuiLabel.mas_bottom).offset(3);
        make.left.equalTo(bianjie.mas_right);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(18);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bianJieLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    [self.pingFenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_centerX).offset(-10);
        make.height.mas_equalTo(40);
    }];
    [self.xieYiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    [self.fanKuiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pingFenButton.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_centerX).offset(-10);
        make.height.mas_equalTo(40);
    }];
    [self.ruZhuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xieYiButton.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
//===================微信 微博 官网 ICP证=====================
    if (kScreenHeight > 480) {
        [self.weiXinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.weiBoLabel.mas_top).offset(-5);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.mas_equalTo(14);
        }];
        [self.weiBoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.guanFangLabel.mas_top).offset(-5);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.mas_equalTo(14);
        }];
        [self.guanFangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.ICPLabel.mas_top).offset(-5);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.mas_equalTo(14);
        }];
        [self.ICPLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.top.equalTo(self.guanFangLabel.mas_bottom).offset(5);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.mas_equalTo(14);
            make.bottom.equalTo(self.MyScrollView.mas_bottom);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }else {
        [self.weiXinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ruZhuButton.mas_bottom).offset(20);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.mas_equalTo(14);
        }];
        [self.weiBoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.weiXinLabel.mas_bottom).offset(5);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.mas_equalTo(14);
        }];
        [self.guanFangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.weiBoLabel.mas_bottom).offset(5);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.mas_equalTo(14);
        }];
        [self.ICPLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.guanFangLabel.mas_bottom).offset(5);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.mas_equalTo(14);
            make.bottom.equalTo(self.MyScrollView.mas_bottom);
        }];
    }
    
}

#pragma mark - 懒加载
- (UIScrollView *)MyScrollView {
    if (_MyScrollView == nil) {
        self.MyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
//        self.MyScrollView.contentSize = CGSizeMake(kScreenWidth, 568-kNavHeight);
        self.MyScrollView.backgroundColor = C2UIColorGray;
        self.MyScrollView.showsVerticalScrollIndicator = NO;
        self.MyScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _MyScrollView;
}
- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_57"]];
        [self.headImageView.layer setMasksToBounds:YES];
        self.headImageView.layer.cornerRadius = 10.0;
        self.headImageView.layer.borderWidth = 0.5;
        self.headImageView.layer.borderColor = UIColorFromRGB(0xebeae5).CGColor;
    }
    return _headImageView;
}
- (UILabel *)banBenLabel {
    if (_banBenLabel == nil) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDictionary));
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString * banbenStr = [NSString stringWithFormat:@"v%@", app_Version];
        self.banBenLabel = [[UILabel alloc]init];
        self.banBenLabel.text = [NSString stringWithFormat:@"华佗驾到iOS %@",banbenStr];
        self.banBenLabel.textColor = UIColorFromRGB(0xbcb09c);
        self.banBenLabel.font = [UIFont systemFontOfSize:13];
        self.banBenLabel.textAlignment = NSTextAlignmentCenter;
        self.banBenLabel.numberOfLines = 0;
    }
    return _banBenLabel;
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.text = @"推拿按摩，找我华佗！";
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = UIColorFromRGB(0x7b7f84);
    }
    return _titleLabel;
}
- (nxUILabel *)quanWeiLabel {
    if (_quanWeiLabel == nil) {
        self.quanWeiLabel = [[nxUILabel alloc]init];
        self.quanWeiLabel.text = @"无论到店、到家、都为您提供优质服务；";
        self.quanWeiLabel.textColor = UIColorFromRGB(0X7B7F84);
        self.quanWeiLabel.textAlignment = NSTextAlignmentLeft;
        self.quanWeiLabel.font = [UIFont systemFontOfSize:12];
        self.quanWeiLabel.numberOfLines = 0;
        [self.quanWeiLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _quanWeiLabel;
}
- (nxUILabel *)jingZhanLabel {
    if (_jingZhanLabel == nil) {
        self.jingZhanLabel = [[nxUILabel alloc]init];
        self.jingZhanLabel.text = @"全国推拿协会副会长刘长信为首席技术顾问；";
        self.jingZhanLabel.textColor = UIColorFromRGB(0X7B7F84);
        self.jingZhanLabel.textAlignment = NSTextAlignmentLeft;
        self.jingZhanLabel.font = [UIFont systemFontOfSize:12];
        self.jingZhanLabel.numberOfLines = 0;
        [self.jingZhanLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _jingZhanLabel;
}
- (nxUILabel *)teHuiLabel {
    if (_teHuiLabel == nil) {
        self.teHuiLabel = [[nxUILabel alloc]init];
        self.teHuiLabel.text = @"所有技师至少五年以上经验，更有十年、十五年顶尖高手；";
        self.teHuiLabel.textColor = UIColorFromRGB(0X7B7F84);
        self.teHuiLabel.textAlignment = NSTextAlignmentLeft;
        self.teHuiLabel.font = [UIFont systemFontOfSize:12];
        self.teHuiLabel.numberOfLines = 0;
        [self.teHuiLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _teHuiLabel;
}
- (nxUILabel *)bianJieLabel {
    if (_bianJieLabel == nil) {
        self.bianJieLabel = [[nxUILabel alloc]init];
        self.bianJieLabel.text = @"全面支持App/微信下单。";
        self.bianJieLabel.textColor = UIColorFromRGB(0X7B7F84);
        self.bianJieLabel.textAlignment = NSTextAlignmentLeft;
        self.bianJieLabel.font = [UIFont systemFontOfSize:12];
        self.bianJieLabel.numberOfLines = 0;
        [self.bianJieLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _bianJieLabel;
}
- (UIButton *)pingFenButton {
    if (_pingFenButton == nil) {
        self.pingFenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.pingFenButton setTitle:@"支持华佗，打分鼓励" forState:UIControlStateNormal ];
        self.pingFenButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.pingFenButton.titleLabel.textColor = [UIColor whiteColor];
        self.pingFenButton.backgroundColor = OrangeUIColorC4;
        [self.pingFenButton addTarget:self action:@selector(pingFenButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.pingFenButton.layer.cornerRadius = 5.0;
    }
    return _pingFenButton;
}
- (UIButton *)xieYiButton {
    if (_xieYiButton == nil) {
        self.xieYiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.xieYiButton setTitle:@"用户协议" forState:UIControlStateNormal ];
        self.xieYiButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.xieYiButton.titleLabel.textColor = [UIColor whiteColor];
        self.xieYiButton.backgroundColor = OrangeUIColorC4;
        [self.xieYiButton addTarget:self action:@selector(xieYiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.xieYiButton.layer.cornerRadius = 5.0;
    }
    return _xieYiButton;
}
- (UIButton *)fanKuiButton {
    if (_fanKuiButton == nil) {
        self.fanKuiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.fanKuiButton setTitle:@"使用反馈" forState:UIControlStateNormal ];
        self.fanKuiButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.fanKuiButton.titleLabel.textColor = [UIColor whiteColor];
        self.fanKuiButton.backgroundColor = OrangeUIColorC4;
        [self.fanKuiButton addTarget:self action:@selector(fanKuiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.fanKuiButton.layer.cornerRadius = 5.0;
    }
    return _fanKuiButton;
}
- (UIButton *)ruZhuButton {
    if (_ruZhuButton == nil) {
        self.ruZhuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ruZhuButton setTitle:@"门店入驻" forState:UIControlStateNormal ];
        self.ruZhuButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.ruZhuButton.titleLabel.textColor = [UIColor whiteColor];
        self.ruZhuButton.backgroundColor = OrangeUIColorC4;
        [self.ruZhuButton addTarget:self action:@selector(ruZhuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.ruZhuButton.layer.cornerRadius = 5.0;
    }
    return _ruZhuButton;
}
- (UILabel *)weiXinLabel {
    if (_weiXinLabel == nil) {
        self.weiXinLabel = [[UILabel alloc]init];
        self.weiXinLabel.text = @"关注微信：华佗驾到";
        self.weiXinLabel.textColor = UIColorFromRGB(0X7B7F84);
        self.weiXinLabel.textAlignment = NSTextAlignmentCenter;
        self.weiXinLabel.font = [UIFont systemFontOfSize:11];
        self.weiXinLabel.numberOfLines = 0;
    }
    return _weiXinLabel;
}
- (UILabel *)weiBoLabel {
    if (_weiBoLabel == nil) {
        self.weiBoLabel = [[UILabel alloc]init];
        self.weiBoLabel.text = @"关注微博：潼诚一得-华佗驾到";
        self.weiBoLabel.textColor = UIColorFromRGB(0X7B7F84);
        self.weiBoLabel.textAlignment = NSTextAlignmentCenter;
        self.weiBoLabel.font = [UIFont systemFontOfSize:11];
        self.weiBoLabel.numberOfLines = 0;
    }
    return _weiBoLabel;
}
- (UILabel *)guanFangLabel {
    if (_guanFangLabel == nil) {
        self.guanFangLabel = [[UILabel alloc]init];
        self.guanFangLabel.text = @"官方网站:www.huatuojiadao.com";
        self.guanFangLabel.textColor = UIColorFromRGB(0X7B7F84);
        self.guanFangLabel.textAlignment = NSTextAlignmentCenter;
        self.guanFangLabel.font = [UIFont systemFontOfSize:11];
        self.guanFangLabel.numberOfLines = 0;
    }
    return _guanFangLabel;
}
- (UILabel *)ICPLabel {
    if (_ICPLabel == nil) {
        self.ICPLabel = [[UILabel alloc]init];
        self.ICPLabel.text = @"沪ICP证 14047865号";
        self.ICPLabel.textColor = UIColorFromRGB(0X7B7F84);
        self.ICPLabel.textAlignment = NSTextAlignmentCenter;
        self.ICPLabel.font = [UIFont systemFontOfSize:11];
        self.ICPLabel.numberOfLines = 0;
    }
    return _ICPLabel;
}
#pragma mark - 按钮点击事件
-(void)pingFenButtonPressed:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=945956826&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
}
-(void)xieYiButtonPressed:(UIButton *)sender {
    AgreementViewController *vc = [[AgreementViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fanKuiButtonPressed:(UIButton *)sender {
    FeedBackViewController *vc = [[FeedBackViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)ruZhuButtonPressed:(UIButton *)sender {
    JoinUsViewController *vc = [[JoinUsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
