//
//  technicianViewController.m
//  Massage
//
//  Created by 屈小波 on 15/10/26.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "technicianViewController.h"
#import "ServiceDetailCell.h"
#import "CWStarRateView.h"
#import "ServiceDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "CustomCellTableViewCell.h"
#import "MyServiceTableViewCell.h"
#import "RoutePlanViewController.h"
#import "clientCommentListViewController.h"
#import "LCProgressHUD.h"
#import "SJAvatarBrowser.h"
#import "UMSocial.h"
#import "LoginViewController.h"
#import "SingleLevelServiceTableViewCell.h"
#import "noWifiView.h"
#import "AppDelegate.h"

@interface technicianViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>{
    NSString *aString;
    float height;
    
    NSDictionary * dataDic;
    
    NSString * isFavorite;
    UIWebView * phoneCallWebView;
    
    UIButton * favoriteBtn;
    UIButton * shareBtn;
    UIButton * backBtn;
    
    NSString * favoriteChange;
    NSString * defaultFavorite;
    
//    UIActivityIndicatorView *activityIndicator;
    noWifiView *failView;

}

@property (nonatomic , strong) UITableView *serviceTable;
@property (nonatomic , strong) UIView *HeaderView;//列表头
@property (nonatomic , strong) UIView *HeaderPicture;//
@property (nonatomic , strong) UIImageView *HeadImageView;//头像
@property (nonatomic , strong) UILabel *nameLabel;//姓名
@property (nonatomic , strong) CWStarRateView *startView;//评级
@property (nonatomic , strong) UILabel *scoresLabel;//分数
@property (nonatomic , strong) UILabel *orderCountLabel;
@property (nonatomic , strong) UILabel *orderFromLabel;
@property (nonatomic , strong) UIImageView *lineImageView;//直线
@property (nonatomic , strong) UILabel *experienceLabel;//经验
@property (nonatomic , strong) UIView *experienctView;//经验视图
@property (nonatomic , strong) UIButton *moreButton;//下拉菜单

@property (nonatomic , strong) UIView *ClientView;

@property (nonatomic , strong) UIView *StoreNameView;
@property (nonatomic , strong) UILabel *StoreNameLabel;
@property (nonatomic , strong) UIImageView *phoneView;
@property (nonatomic , strong) UIImageView *line1ImageView;

@property (nonatomic , strong) UIView *ServiceView;
@property (nonatomic , strong) UIImageView *ServiceImageView;
@property (nonatomic , strong) UILabel *ServiceZoneLabel;
@property (nonatomic , strong) UILabel *distanceLabel;
@property (nonatomic , strong) UIImageView *line2ImageView;

@property (nonatomic , strong) UIView *ClientSayView;
@property (nonatomic , strong) UIImageView *ClientImageview;
@property (nonatomic , strong) UILabel *ClientLabel;
@property (nonatomic , strong) UILabel *ClientCountLabel;


@property (nonatomic , strong) UIImageView *ClientArrow1;
@property (nonatomic , strong) UIImageView *ClientArrow2;
@property (nonatomic , strong) UIImageView *ClientArrow3;

@property (nonatomic , strong) UIView *ServiceUIView;
@property (nonatomic , strong) UILabel *ServiceLabel;

@property (nonatomic , strong) NSMutableArray *serviceData;
@end

@implementation technicianViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(gotoServiceDetailController:) name:@"gotoServiceDetailController" object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    if (self.returnStoreWorkerFavoriteChangeBlock != nil) {
        self.returnStoreWorkerFavoriteChangeBlock(favoriteChange);
    }
}

-(void)returnText:(ReturnStoreWorkerFavoriteChangeBlock)block
{
    self.returnStoreWorkerFavoriteChangeBlock = block;
}

-(void)gotoLogVC
{
    favoriteBtn.userInteractionEnabled = YES;
//    favoritesBtn.userInteractionEnabled = YES;
    
    LoginViewController * vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backAction
{
    if ([self.backType isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)favoriteBtnPressed:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    NSLog(@"收藏");
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    if (!userID) {
        [[RequestManager shareRequestManager] tipAlert:@"您还未登录，不能使用收藏功能" viewController:self];
        [self performSelector:@selector(gotoLogVC) withObject:nil afterDelay:1.0];
        return;
    }
    //0当前未收藏
    if ([isFavorite isEqualToString:@"0"]) {
        [MobClick event:DOOR_TICHNICIANDETAIL_COLLECT];
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"itemType":@"2",//0 门店，1项目，2技师，3发现
                               @"itemID":self.workerID,//门店ID/服务ID/技师ID/发现ID
                               };
        [[RequestManager shareRequestManager] addCollect:dic viewController:self successData:^(NSDictionary *result) {
            favoriteBtn.userInteractionEnabled = YES;
//            favoritesBtn.userInteractionEnabled = YES;
            NDLog(@"技师收藏 %@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                //提示 添加收藏成功
                isFavorite = @"1";
                [LCProgressHUD showSuccess:@"收藏成功"];
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
                 if ([isFavorite isEqualToString:defaultFavorite]) {
                    favoriteChange = @"0";
                }else{
                    favoriteChange = @"1";
                }
            }
            else
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        } failuer:^(NSError *error) {
            favoriteBtn.userInteractionEnabled = YES;
//            favoritesBtn.userInteractionEnabled = YES;
        }];
        
    }
    //1当前已收藏
    else if ([isFavorite isEqualToString:@"1"]){
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"itemType":@"2",//0 门店，1项目，2技师，3发现
                               @"itemID":self.workerID,//门店ID/服务ID/技师ID/发现ID
                               };
        [[RequestManager shareRequestManager] cancelCollect:dic viewController:self successData:^(NSDictionary *result) {
            favoriteBtn.userInteractionEnabled = YES;
//            favoritesBtn.userInteractionEnabled = YES;
            NDLog(@"删除技师收藏 %@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                //提示 取消收藏成功
                isFavorite = @"0";
                [LCProgressHUD showSuccess:@"收藏已取消"];
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
                if ([isFavorite isEqualToString:defaultFavorite]) {
                    favoriteChange = @"0";
                }else{
                    favoriteChange = @"1";
                }
            }
            else
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        } failuer:^(NSError *error) {
            favoriteBtn.userInteractionEnabled = YES;
//            favoritesBtn.userInteractionEnabled = YES;
        }];
    }
    
    //    NSDictionary * dic = @{
    //                           @"userID":userID,
    //                           @"itemType":@"2",//0 门店，1项目，2技师，3发现
    //                           @"itemId":self.workerID,//门店ID/服务ID/技师ID/发现ID
    //                           };
    //    [[RequestManager shareRequestManager] addCollect:dic viewController:self successData:^(NSDictionary *result) {
    //        NDLog(@"技师收藏 %@",result);
    //    } failuer:^(NSError *error) {
    //
    //    }];
}

-(void)shareBtnPressed:(UIButton *)sender
{
    [MobClick event:DOOR_TICHNICIANDETAIL_SHARE];
    NSLog(@"分享");
    NSString *url = [NSString stringWithFormat:@"http://wechat.huatuojiadao.com/weixin_user/html/wechat.html#pt-detail?id=%@",self.workerID];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.url = url;
    
    //微博 & 微信 & 朋友圈 & 复制链接
//    NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"icon"]]];
//    NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
//    UIImage *img = [UIImage imageWithData:imgData];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"introduction"]]
                                     shareImage:self.HeadImageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,@"CustomPlatform",nil]
                                       delegate:self];
    
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    
    //如果是朋友圈，则替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    //设置微信好友title方法为
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"%@ %@",[dataDic objectForKey:@"name"],[dataDic objectForKey:@"gradeName"]];
    
    //设置微信朋友圈title方法替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"%@ %@",[dataDic objectForKey:@"name"],[dataDic objectForKey:@"gradeName"]];
}
#pragma mark 接收广播
-(void)gotoServiceDetailController:(NSNotification *)notification
{
    [MobClick event:DOOR_TICHNICIANDETAIL_PROJECTDETAIL];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:notification.object];
    ServiceDetailViewController * vc =[[ServiceDetailViewController alloc] init];
    vc.haveWorker = YES;
    vc.serviceType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isSelfOwned"]];
    //isSelfOwned 0门店 1自营
    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"isSelfOwned"]] isEqualToString:@"0"]) {
        vc.isStore = YES;
        vc.isSelfOwned = @"0";
        vc.workerInfoDic = [NSDictionary dictionaryWithDictionary:dataDic];
    }else if([[NSString stringWithFormat:@"%@",[dic objectForKey:@"isSelfOwned"]] isEqualToString:@"1"]) {
        vc.isStore = NO;
        vc.isSelfOwned = @"1";
        vc.workerInfoDic = [NSDictionary dictionaryWithDictionary:dataDic];
    }
    //    NDLog(@"技师信息%@",vc.workerInfoDic);
    vc.serviceID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ID"]];
    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
}

-(void)downLoaddata
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSString * longitude = [userDefaults objectForKey:@"longitude"];
    NSString * latitude = [userDefaults objectForKey:@"latitude"];
    if (!userID) {
        userID = @"";
    }
    NSDictionary * dic = @{
                           @"ID":self.workerID,
                           @"userID":userID,
                           @"longitude":longitude,
                           @"latitude":latitude,
                           };
    [[RequestManager shareRequestManager] getSysSkillDetailInfo:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@" %@",result);
        [self hideHud];
        failView.hidden = YES;
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//            [activityIndicator stopAnimating];
//            activityIndicator.hidden = YES;
            
            dataDic = [NSDictionary dictionaryWithDictionary:result];
            //            [self.serviceData addObjectsFromArray:[result objectForKey:@"serviceList"]];
            
            isFavorite = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFavorite"]];
            defaultFavorite = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFavorite"]];
            if ([isFavorite isEqualToString:@"1"]) {
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites_che"] forState:UIControlStateNormal];
            }else
            {
                [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
            }
            
            NSMutableArray * array = [NSMutableArray arrayWithArray: [result objectForKey:@"serviceList"] ];
            
            //            NSMutableArray * array0 =[[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray * array1 =[NSMutableArray array];
            if (array.count > 0) {
                NSMutableArray *cellArray = [array1 lastObject];
                for (int i = 0; i < array.count; i++) {
                    if (cellArray.count == 2 || cellArray == nil) {
                        cellArray = [NSMutableArray arrayWithCapacity:2];
                        [array1 addObject:cellArray];
                        
                    }
                    NSDictionary *dic = array[i];
                    
                    [cellArray addObject:dic];
                }
            }
            
            [ self.serviceData addObjectsFromArray:array1];
            
            
            [self initView];
        }
        else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
        
    } failuer:^(NSError *error) {
        [self hideHud];
        failView.hidden = NO;
    }];
}

-(void)initView
{
    
    
    WS(this_schedule);
    self.titles = [dataDic objectForKey:@"name"];
    aString =[dataDic objectForKey:@"introduction"];;
    
    [self.view addSubview:self.serviceTable];
    [self.HeaderView addSubview:self.HeaderPicture];
    [self.HeaderPicture addSubview:self.HeadImageView];
    [self.HeaderPicture addSubview:self.nameLabel];
    [self.HeaderPicture addSubview:self.startView];
    [self.HeaderPicture addSubview:self.scoresLabel];
    [self.HeaderPicture addSubview:self.orderCountLabel];
    [self.HeaderPicture addSubview:self.orderFromLabel];
    
    
    [self.HeaderPicture addSubview:self.lineImageView];
    [self.HeaderView addSubview:self.experienctView];
    [self.experienctView addSubview:self.experienceLabel];
    [self.experienctView addSubview:self.moreButton];
    [self.HeaderView addSubview:self.ClientView];
    
    
    [self.ClientView addSubview:self.StoreNameView];
    [self.StoreNameView addSubview:self.phoneView];
    [self.StoreNameView addSubview:self.StoreNameLabel];
    [self.StoreNameView addSubview:self.ClientArrow1];
    [self.StoreNameView addSubview:self.line1ImageView];
    
    
    [self.ClientView addSubview:self.ServiceView];
    [self.ServiceView addSubview:self.ServiceImageView];
    [self.ServiceView addSubview:self.ServiceZoneLabel];
    [self.ServiceView addSubview:self.distanceLabel];
    [self.ServiceView addSubview:self.ClientArrow2];
    [self.ServiceView addSubview:self.line2ImageView];
    
    [self.ClientView addSubview:self.ClientSayView];
    [self.ClientSayView addSubview:self.ClientImageview];
    [self.ClientSayView addSubview:self.ClientLabel];
    [self.ClientSayView addSubview:self.ClientArrow3];
    [self.ClientSayView addSubview: self.ClientCountLabel];
    
    
    
    
    [self.ClientView addSubview:self.ServiceUIView];
    [self.ServiceUIView addSubview: self.ServiceLabel];
    
    [self.HeaderPicture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*AUTO_SIZE_SCALE_X
                                         ));
    }];
    
    //头像
    [self.HeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(66*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X));
    }];
    
    //名字
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_schedule.HeadImageView.mas_right).offset(10*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-10-66*AUTO_SIZE_SCALE_X-10-10*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X));
    }];
    self.nameLabel.text = [dataDic objectForKey:@"name"];
    
    //评分
    [self.scoresLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10+10*AUTO_SIZE_SCALE_X+66*AUTO_SIZE_SCALE_X+106*AUTO_SIZE_SCALE_X+8*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_schedule.nameLabel.mas_bottom).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(80*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X));
    }];
    self.scoresLabel.text = [NSString stringWithFormat:@"%@分",[dataDic objectForKey:@"score"]];
    
    self.startView.scorePercent =[[dataDic objectForKey:@"score"] floatValue]/5.0f;
    //单数
    [self.orderCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(this_schedule.HeadImageView.mas_right).offset(10*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo(this_schedule.scoresLabel.mas_bottom).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    self.orderCountLabel.text = [NSString stringWithFormat:@"接单数量: %@",[dataDic objectForKey:@"orderCount"]];
    //单数来自
    [self.orderFromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(this_schedule.scoresLabel.mas_bottom).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-10-10-66*AUTO_SIZE_SCALE_X-10*AUTO_SIZE_SCALE_X-100*AUTO_SIZE_SCALE_X-10*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"isSelfOwned"]] isEqualToString:@"1"]) {
        self.orderFromLabel.text = @"自营: 华佗驾到";
    }else
        self.orderFromLabel.text = @"";
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(this_schedule.HeaderPicture.mas_bottom).offset(-0.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
    [self.experienctView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(this_schedule.HeaderPicture.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,100*AUTO_SIZE_SCALE_X));
        
    }];
    
    [self.experienceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(18*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-20, 53*AUTO_SIZE_SCALE_X));
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kScreenWidth/2-11*AUTO_SIZE_SCALE_X/2);
        make.top.mas_equalTo(this_schedule.experienceLabel.mas_bottom).offset(12*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(11*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ClientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 208*AUTO_SIZE_SCALE_X));
    }];
    
    [self.StoreNameView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45*AUTO_SIZE_SCALE_X));
    }];
    
    
    [self.phoneView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.StoreNameLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(58);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 15*AUTO_SIZE_SCALE_X));
    }];
    self.StoreNameLabel.text =[dataDic objectForKey:@"storeName"];
    
    [self.ClientArrow1  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(7*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    
    [self.line1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(this_schedule.StoreNameView.mas_bottom).offset(-0.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5
                                         ));
    }];
    
    [self.ServiceView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(this_schedule.StoreNameView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 67*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ServiceImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(23*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(13*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X));
    }];
    
    
    
    [self.ServiceZoneLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(58);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(200*AUTO_SIZE_SCALE_X, 35*AUTO_SIZE_SCALE_X));
    }];
    self.ServiceZoneLabel.text = [dataDic objectForKey:@"storeAddress"];
    
    [self.ClientArrow2  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(26.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(7*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    [self.distanceLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(this_schedule.ClientArrow2.mas_left).offset(-10);
        make.bottom.mas_equalTo(-27*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
    }];
//    self.distanceLabel.text =[NSString stringWithFormat:@"%@km",[dataDic objectForKey:@"distance"]];
    CGFloat dist = [[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"distance"]] floatValue];
    if (dist >= 1) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%0.1fkm",dist];
    }else{
        int dista = dist*1000;
        self.distanceLabel.text = [NSString stringWithFormat:@"%dm",dista];
    }
    [self.line2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(this_schedule.ServiceView.mas_bottom).offset(-0.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5
                                         ));
    }];
    
    
    
    [self.ClientSayView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(this_schedule.ServiceView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 45*AUTO_SIZE_SCALE_X));
    }];
    
    
    [self.ClientImageview  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ClientLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(58);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ClientArrow3  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(7*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ClientCountLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(this_schedule.ClientArrow3.mas_left).offset(-10);
        make.bottom.mas_equalTo(-15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
    }];
    if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"commentCount"]] isEqualToString:@"0"]) {
        self.ClientCountLabel.text =@"暂无评论";
    }else{
        self.ClientCountLabel.text =[NSString stringWithFormat:@"%@条",[dataDic objectForKey:@"commentCount"]];
    }
    
    [self.ServiceUIView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(this_schedule.ClientView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 40*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ServiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.ServiceUIView.mas_centerX);
        make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    
    
    [self.serviceTable setTableHeaderView:self.HeaderView];
}

#pragma mark 网络失败 刷新
- (void)reloadButtonClick:(UIButton *)sender {
    [self downLoaddata];
    [self showHudInView:self.view hint:@"正在加载"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showHudInView:self.view hint:@"正在加载"];
    
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];

    
    favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteBtn.frame = CGRectMake(kScreenWidth - (28*AUTO_SIZE_SCALE_X+5)*2, 20, 28*AUTO_SIZE_SCALE_X, 44);
    [favoriteBtn setImage:[UIImage imageNamed:@"icon_sd_favorites"] forState:UIControlStateNormal];
    [favoriteBtn addTarget:self action:@selector(favoriteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:favoriteBtn];
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(kScreenWidth - 28*AUTO_SIZE_SCALE_X-5, 20, 28*AUTO_SIZE_SCALE_X, 44);
    [shareBtn setImage:[UIImage imageNamed:@"icon_sd_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:shareBtn];
    
//    activityIndicator = [[UIActivityIndicatorView alloc]
//                         initWithActivityIndicatorStyle:
//                         UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicator.color = [UIColor blackColor];
//    activityIndicator.center = CGPointMake(self.view.center.x, self.view.center.y);;
//    [activityIndicator startAnimating]; // 开始旋转
//    [self.view addSubview:activityIndicator];
    
    [self downLoaddata];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return (108.75f+10.0f+88.0f-20)*AUTO_SIZE_SCALE_X;
    return (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f-20;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.serviceData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify =@"SingleLevelServiceTableViewCell";
    
    SingleLevelServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[SingleLevelServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (self.serviceData.count>0) {
        cell.backgroundColor = [UIColor clearColor];
        
        cell.data = self.serviceData[indexPath.row];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    currentrRow = indexPath.row;
    
}


-(void)onClickView:(id )sender{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSLog(@"onClickView-----------tag-->%@",dataDic);
    if([[singleTap view ] tag]==11000){
        
        NSString * tel =[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"storeTel"]];
        tel = [tel stringByReplacingOccurrencesOfString:@"(" withString:@""];
        tel = [tel stringByReplacingOccurrencesOfString:@")" withString:@""];
        tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
        tel = [tel stringByReplacingOccurrencesOfString:@"－" withString:@""];
        tel = [tel stringByReplacingOccurrencesOfString:@"（" withString:@""];
        tel = [tel stringByReplacingOccurrencesOfString:@"）" withString:@""];
        tel = [tel stringByReplacingOccurrencesOfString:@":" withString:@""];
        tel = [tel stringByReplacingOccurrencesOfString:@"：" withString:@""];
        
        NSLog(@"%@",tel);
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]];
        //    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        //    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        
        if ( !phoneCallWebView ) {
            
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }else if([[singleTap view ] tag]==11001){
        RoutePlanViewController *vc = [[RoutePlanViewController alloc]init];
        vc.latitude = [[dataDic objectForKey:@"latitude"]doubleValue];
        vc.longitude = [[dataDic objectForKey:@"longitude"]doubleValue];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([[singleTap view ] tag]==11002){
        
        
        if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"commentCount"]] isEqualToString:@"0"]) {
            [[RequestManager shareRequestManager] tipAlert:@"暂没有评论" viewController:self];
        }else{
            [MobClick event:DOOR_TICHNICIANDETAIL_COMMENT];
            clientCommentListViewController *vc = [[clientCommentListViewController alloc] init];
            vc.ID = self.workerID;
            vc.type = @"2";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        
        
    }
}

-(void)onClickMoreButton:(id *)sender{
    NSLog(@"onClickMoreButton");
    self.moreButton.selected =!self.moreButton.selected;
    if (self.moreButton.selected) {
        [MobClick event:DOOR_TICHNICIANDETAIL_MORE];
        [self.HeaderView layoutIfNeeded];
        
        UIFont *font = [UIFont systemFontOfSize:13];
        CGSize titleSize = [aString sizeWithFont:font constrainedToSize:CGSizeMake(self.experienceLabel.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        float big =  MAX(titleSize.height,  53*AUTO_SIZE_SCALE_X);
        
        [self.experienceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(big));
        }];
        
        height = big- 53*AUTO_SIZE_SCALE_X;
        [self.experienctView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(kScreenWidth,100*AUTO_SIZE_SCALE_X+big- 53*AUTO_SIZE_SCALE_X));
        }];
        CGRect newFrame = self.HeaderView.frame;
        newFrame.size.height = self.HeaderView.size.height + big- 53*AUTO_SIZE_SCALE_X;
        self.HeaderView.frame = newFrame;
        
    }else{
        
        [self.experienceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-20, 53*AUTO_SIZE_SCALE_X));
            
        }];
        
        [self.experienctView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth,100*AUTO_SIZE_SCALE_X));
            
        }];
        CGRect newFrame = self.HeaderView.frame;
        newFrame.size.height = self.HeaderView.size.height - height;
        self.HeaderView.frame = newFrame;
        
        
        
        
        //        [self.serviceTable beginUpdates];
        //
        //        [self.serviceTable endUpdates];
        
        
    }
    [self.serviceTable setTableHeaderView:self.HeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(UIView *)HeaderView{
    if (!_HeaderView) {
        _HeaderView =[UIView new];
        _HeaderView.frame = CGRectMake(0, 0, kScreenWidth, 418*AUTO_SIZE_SCALE_X);
        _HeaderView.backgroundColor = C2UIColorGray;
        
    }
    return _HeaderView;
}


-(UIView *)HeaderPicture{
    if (!_HeaderPicture) {
        _HeaderPicture =[UIView new];
        _HeaderPicture.backgroundColor = [UIColor whiteColor];
    }
    return _HeaderPicture;
}
-(UIImageView *)HeadImageView{
    if (!_HeadImageView) {
        _HeadImageView =[UIImageView new];
        [_HeadImageView setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
        _HeadImageView.layer.borderColor = UIColorFromRGB(0xe8e9e8).CGColor;
        _HeadImageView.layer.borderWidth = 1.0f;
        _HeadImageView.layer.cornerRadius = 4.0;
        
        UITapGestureRecognizer * headImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
        _HeadImageView.userInteractionEnabled = YES;
        [_HeadImageView addGestureRecognizer:headImageTap];
        
    }
    return _HeadImageView;
}

-(void)showBigImage:(UITapGestureRecognizer * )sender
{
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
    
}

-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton =[UIButton new];
        
        
        [_moreButton setBackgroundColor:[UIColor clearColor]];
        [_moreButton setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"icon_up"] forState:UIControlStateSelected];
        [_moreButton addTarget:self action:@selector(onClickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.selected = NO;
    }
    return _moreButton;
}

-(UIView *)ClientView{
    if (!_ClientView) {
        _ClientView =[UIView new];
        _ClientView.backgroundColor = C2UIColorGray;
    }
    return _ClientView;
    
}


-(UILabel *)ClientLabel{
    if (!_ClientLabel) {
        _ClientLabel =[UILabel new];
        _ClientLabel.font = [UIFont systemFontOfSize:14];
        _ClientLabel.textColor =BlackUIColorC5;
        _ClientLabel.text = @"用户评论";
        
    }
    return _ClientLabel;
    
}

-(UIView *)ClientCountLabel{
    if (!_ClientCountLabel) {
        _ClientCountLabel =[UILabel new];
        _ClientCountLabel.textColor =C7UIColorGray;
        _ClientCountLabel.textAlignment =NSTextAlignmentRight;
        _ClientCountLabel.font =[UIFont systemFontOfSize:12];
    }
    return _ClientCountLabel;
    
}

-(UIView *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel =[UILabel new];
        _distanceLabel.textColor =C7UIColorGray;
        _distanceLabel.textAlignment =NSTextAlignmentRight;
        _distanceLabel.font =[UIFont systemFontOfSize:12];
        
    }
    return _distanceLabel;
    
}



-(UIImageView *)line1ImageView{
    if (!_line1ImageView) {
        _line1ImageView =[UIImageView new];
        _line1ImageView.image = [UIImage imageNamed:@""];
        _line1ImageView.backgroundColor =C2UIColorGray;
        
    }
    return _line1ImageView;
}

-(UIImageView *)ServiceImageView{
    if (!_ServiceImageView) {
        _ServiceImageView =[UIImageView new];
        _ServiceImageView.image = [UIImage imageNamed:@"icon_sd_awayfrom"];
        
    }
    return _ServiceImageView;
    
}



-(UILabel *)ServiceZoneLabel{
    if (!_ServiceZoneLabel) {
        _ServiceZoneLabel =[UILabel new];
        _ServiceZoneLabel.font = [UIFont systemFontOfSize:14];
        _ServiceZoneLabel.textColor =BlackUIColorC5;
        _ServiceZoneLabel.numberOfLines =2;
        
        
    }
    return _ServiceZoneLabel;
}


-(UITableView *)serviceTable{
    if (!_serviceTable) {
        _serviceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navView.frame.size.height, kScreenWidth, kScreenHeight-self.navView.frame.size.height)];
        _serviceTable.delegate = self;
        _serviceTable.dataSource = self;
        _serviceTable.rowHeight = 110;
        _serviceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _serviceTable.backgroundColor = [UIColor clearColor];
    }
    return _serviceTable;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font =[UIFont boldSystemFontOfSize:16];
        _nameLabel.textColor =BlackUIColorC5;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment =NSTextAlignmentLeft;
    }
    return _nameLabel;
}

-(NSMutableArray *)serviceData{
    if(!_serviceData){
        _serviceData = [NSMutableArray array];
        
        //        [_serviceData addObject:@{@"titile":@"ceshi"}];
        //        [_serviceData addObject:@{@"titile":@"ceshi"}];
        //        [_serviceData addObject:@{@"titile":@"ceshi"}];
        //        [_serviceData addObject:@{@"titile":@"ceshi"}];
        //        [_serviceData addObject:@{@"titile":@"ceshi"}];
        //        [_serviceData addObject:@{@"titile":@"ceshi"}];
        //        [_serviceData addObject:@{@"titile":@"ceshi"}];
        //        [_serviceData addObject:@{@"titile":@"ceshi"}];
        
        
    }
    return _serviceData;
}


-(CWStarRateView *)startView{
    if (!_startView) {
        //        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.mas_equalTo(this_schedule.HeadImageView.mas_right).offset(10*AUTO_SIZE_SCALE_X);
        //            make.top.mas_equalTo(15*AUTO_SIZE_SCALE_X);
        //            make.size.mas_equalTo(CGSizeMake(kScreenWidth-10-66*AUTO_SIZE_SCALE_X-10-10*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X));
        //        }];
        _startView = [[CWStarRateView alloc] initWithFrame:CGRectMake(7+10*AUTO_SIZE_SCALE_X+66*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X+16*AUTO_SIZE_SCALE_X+10, 110*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X) numberOfStars:5];
        _startView.backgroundColor =[UIColor clearColor];
        
        _startView.allowIncompleteStar = YES;
        _startView.hasAnimation = YES;
    }
    
    return _startView;
}

-(UILabel *)scoresLabel{
    if (!_scoresLabel) {
        _scoresLabel = [UILabel new];
        _scoresLabel.backgroundColor =[UIColor clearColor];
        _scoresLabel.textColor =C6UIColorGray;
        _scoresLabel.font =[UIFont systemFontOfSize:13];
        _scoresLabel.textAlignment =NSTextAlignmentLeft;
    }
    
    return _scoresLabel;
}

-(UILabel *)orderCountLabel{
    if (!_orderCountLabel) {
        _orderCountLabel = [UILabel new];
        _orderCountLabel.font =[UIFont systemFontOfSize:14];
        _orderCountLabel.textColor =BlackUIColorC5;
        _orderCountLabel.backgroundColor =[UIColor clearColor];
        _orderCountLabel.textAlignment =NSTextAlignmentLeft;
        
    }
    return _orderCountLabel;
}

-(UILabel *)orderFromLabel{
    if (!_orderFromLabel) {
        _orderFromLabel = [UILabel new];
        _orderFromLabel.backgroundColor =[UIColor clearColor];
        _orderFromLabel.textColor =BlackUIColorC5;
        _orderFromLabel.font =[UIFont systemFontOfSize:14];
        _orderFromLabel.text =@"自营：华佗驾到";
        _orderFromLabel.textAlignment =NSTextAlignmentLeft;
    }
    return _orderFromLabel;
}



-(UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor =C2UIColorGray;
    }
    
    return _lineImageView;
}


-(UILabel *)experienceLabel{
    if (!_experienceLabel) {
        _experienceLabel = [UILabel new];
        _experienceLabel.numberOfLines = 0;
        _experienceLabel.textColor =C6UIColorGray;
        _experienceLabel.font =[UIFont systemFontOfSize:13];
        _experienceLabel.backgroundColor =[UIColor clearColor];
        _experienceLabel.text =aString;
        
        
    }
    
    return _experienceLabel;
}


-(UIView *)experienctView{
    if (!_experienctView) {
        _experienctView = [UIView new];
        _experienctView.backgroundColor =[UIColor whiteColor];
        UITapGestureRecognizer * setDefaultViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMoreButton:)];
        [_experienctView addGestureRecognizer:setDefaultViewTap];
    }
    return _experienctView;
}

-(UIView *)StoreNameView{
    if (!_StoreNameView) {
        _StoreNameView =[UIView new];
        _StoreNameView.backgroundColor =[UIColor whiteColor];
        
        UITapGestureRecognizer * setDefaultViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickView:)];
        [_StoreNameView addGestureRecognizer:setDefaultViewTap];
        UIView *singleTapView = [setDefaultViewTap view];
        singleTapView.tag = 11000;
        //        _ServiceLabel.text = @"服务商圈";
        
    }
    return _StoreNameView;
    
}

-(UILabel *)StoreNameLabel{
    if (!_StoreNameLabel) {
        _StoreNameLabel =[UILabel new];
        _StoreNameLabel.textColor =BlackUIColorC5;
        _StoreNameLabel.font =[UIFont systemFontOfSize:14];
    }
    return _StoreNameLabel;
    
}

-(UIImageView *)phoneView{
    if (!_phoneView) {
        _phoneView = [UIImageView new];
        _phoneView.image =[UIImage imageNamed:@"icon_sd_tel"];
        
    }
    
    return _phoneView;
}


-(UIImageView *)line2ImageView{
    if (!_line2ImageView) {
        _line2ImageView = [UIImageView new];
        _line2ImageView.backgroundColor =C2UIColorGray;
    }
    
    return _line2ImageView;
}

-(UIView *)ServiceView{
    if (!_ServiceView) {
        _ServiceView =[UIView new];
        _ServiceView.backgroundColor =[UIColor whiteColor];
        
        UITapGestureRecognizer * setDefaultViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickView:)];
        [_ServiceView addGestureRecognizer:setDefaultViewTap];
        UIView *singleTapView = [setDefaultViewTap view];
        singleTapView.tag = 11001;
        //        _ServiceLabel.text = @"服务商圈";
        
    }
    return _ServiceView;
    
}

-(UIView *)ClientSayView{
    if (!_ClientSayView) {
        _ClientSayView =[UIView new];
        _ClientSayView.backgroundColor =[UIColor whiteColor];
        
        
        UITapGestureRecognizer * setDefaultViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickView:)];
        [_ClientSayView addGestureRecognizer:setDefaultViewTap];
        UIView *singleTapView = [setDefaultViewTap view];
        singleTapView.tag = 11002;
        //        _ServiceLabel.text = @"服务商圈";
        
    }
    return _ClientSayView;
    
}

-(UIImageView *)ClientImageview{
    if (!_ClientImageview) {
        _ClientImageview = [UIImageView new];
        _ClientImageview.image = [UIImage imageNamed:@"icon_sd_comment"];
    }
    
    return _ClientImageview;
}


-(UIImageView *)ClientArrow1{
    if (!_ClientArrow1) {
        _ClientArrow1 = [UIImageView new];
        _ClientArrow1.image = [UIImage imageNamed:@"icon_sd_next"];
        
    }
    
    return _ClientArrow1;
}

-(UIImageView *)ClientArrow2{
    if (!_ClientArrow2) {
        _ClientArrow2 = [UIImageView new];
        _ClientArrow2.image = [UIImage imageNamed:@"icon_sd_next"];
    }
    
    return _ClientArrow2;
}

-(UIImageView *)ClientArrow3{
    if (!_ClientArrow3) {
        _ClientArrow3 = [UIImageView new];
        
        _ClientArrow3.image = [UIImage imageNamed:@"icon_sd_next"];
    }
    
    return _ClientArrow3;
}



-(UIView *)ServiceUIView{
    if (!_ServiceUIView) {
        _ServiceUIView =[UIView new];
        _ServiceUIView.backgroundColor =[UIColor whiteColor];
        //        _ServiceLabel.text = @"服务商圈";
        
    }
    return _ServiceUIView;
    
}

-(UILabel *)ServiceLabel{
    if (!_ServiceLabel) {
        _ServiceLabel =[UILabel new];
        _ServiceLabel.textColor =RedUIColorC1;
        _ServiceLabel.text =@"服务列表";
        _ServiceLabel.font =[UIFont systemFontOfSize:14];
    }
    return _ServiceLabel;
    
}


@end
