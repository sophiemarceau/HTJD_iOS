//
//  TechnicianMyselfViewController.m
//  Massage
//
//  Created by sophiemarceau_qu on 15/11/4.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "TechnicianMyselfViewController.h"
#import "ServiceDetailViewController.h"
#import "clientCommentListViewController.h"
#import "UIImageView+WebCache.h"
#import "ServiceDetailCell.h"
#import "MyServiceTableViewCell.h"
#import "CWStarRateView.h"
#import "CustomCellTableViewCell.h"
#import "LCProgressHUD.h"
#import "SJAvatarBrowser.h"
#import "detailTableViewCell.h"
#import "UMSocial.h"

#import "LoginViewController.h"
#import "SingleLevelServiceTableViewCell.h"

#import "noWifiView.h"
#import "AppDelegate.h"

@interface TechnicianMyselfViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>{
    
    NSString *aString;
    float height;
    NSDictionary * dataDic;
    NSString * isFavorite;
    
    BOOL selected;
    
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
@property (nonatomic , strong) UILabel *ServiceZoneLabel;

@property (nonatomic , strong) NSMutableArray *serviceData;
@end


@implementation TechnicianMyselfViewController
@synthesize workerID;

-(void)downLoaddata
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    if (!userID) {
        userID = @"";
    }
    NSDictionary * dic = @{
                           @"ID":self.workerID,
                           @"userID":userID,
                           @"longitude":@"",
                           @"latitude":@"",
                           };
    [[RequestManager shareRequestManager] getSysSkillDetailInfo:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@"%@",result);
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(gotoServiceDetailController:) name:@"gotoServiceDetailController" object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
    if (self.returnMyselfFavoriteChangeBlock != nil) {
        self.returnMyselfFavoriteChangeBlock(favoriteChange);
    }
}

-(void)returnText:(ReturnMyselfFavoriteChangeBlock)block
{
    self.returnMyselfFavoriteChangeBlock = block;
}

#pragma mark 网络失败 刷新
- (void)reloadButtonClick:(UIButton *)sender {
     [self downLoaddata];
    [self showHudInView:self.view hint:@"正在加载"];

}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    selected =NO;
    
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
    NSLog(@"收藏");
    
    sender.userInteractionEnabled = NO;
    //    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSString * userID = [userDefaults objectForKey:@"userID"];
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
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSLog(@"userID %@",userID);
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
    vc.serviceID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ID"]];
    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoServiceDetailController" object:nil];
}

-(void)initView
{
    
    aString = [dataDic objectForKey:@"introduction"];
    
    [self.view addSubview:self.serviceTable];
    
    self.titles =[dataDic objectForKey:@"name"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else{
        return self.serviceData.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (selected) {
            return self.HeaderView.frame.size.height;
        }else{
            return 200*AUTO_SIZE_SCALE_X;
        }
    }
    else if (indexPath.section == 1){
        
        return (220)*AUTO_SIZE_SCALE_X;
        
    }else{

        return (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f-20;

    }
    
}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identify =@"techcell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            //取消cell的选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        [cell.contentView addSubview:self.HeaderView];
        [self.HeaderView addSubview:self.HeaderPicture];
        [self.HeaderPicture addSubview:self.HeadImageView];
        [self.HeaderPicture addSubview:self.nameLabel];
        [self.HeaderPicture addSubview:self.startView];
        [self.HeaderPicture addSubview:self.scoresLabel];
        [self.HeaderPicture addSubview:self.orderCountLabel];
        [self.HeaderPicture addSubview:self.lineImageView];
        [self.HeaderView addSubview:self.experienctView];
        [self.experienctView addSubview:self.experienceLabel];
        [self.experienctView addSubview:self.moreButton];

        self.HeaderPicture.frame = CGRectMake(0, 0, kScreenWidth, 100*AUTO_SIZE_SCALE_X);

        self.HeadImageView.frame = CGRectMake(10, 15*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X);
        
        self.nameLabel.frame = CGRectMake(self.HeadImageView.frame.origin.x+self.HeadImageView.frame.size.width+10, 15*AUTO_SIZE_SCALE_X, kScreenWidth-10-66*AUTO_SIZE_SCALE_X-10-10*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X);
        
        self.scoresLabel.frame = CGRectMake(10+10*AUTO_SIZE_SCALE_X+66*AUTO_SIZE_SCALE_X+106*AUTO_SIZE_SCALE_X+8*AUTO_SIZE_SCALE_X, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, 80*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X);
        
        self.startView.scorePercent = [[dataDic objectForKey:@"score"] floatValue]/5.0f;
        
        self.orderCountLabel.frame = CGRectMake(self.HeadImageView.frame.size.width+self.HeadImageView.frame.origin.x+10*AUTO_SIZE_SCALE_X, self.scoresLabel.frame.origin.y+self.scoresLabel.frame.size.width+10*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);

        self.lineImageView.frame = CGRectMake(10, self.HeaderPicture.frame.size.height+self.HeaderPicture.frame.origin.y-0.5*AUTO_SIZE_SCALE_X, kScreenWidth, 0.5);

        
        
        
        if(selected){
        
        }else{
            self.experienctView.frame = CGRectMake(0, self.HeaderPicture.frame.origin.y+self.HeaderPicture.frame.size.height, kScreenWidth, 100*AUTO_SIZE_SCALE_X);
            
            self.experienceLabel.frame = CGRectMake(10, 18*AUTO_SIZE_SCALE_X, kScreenWidth-20, 53*AUTO_SIZE_SCALE_X);
            
            self.moreButton.frame = CGRectMake(kScreenWidth/2-11*AUTO_SIZE_SCALE_X/2, self.experienceLabel.frame.origin.y+self.experienceLabel.frame.size.height+12*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X);
        }

        self.nameLabel.text =[dataDic objectForKey:@"name"];
        self.scoresLabel.text = [NSString stringWithFormat:@"%@分",[dataDic objectForKey:@"score"]];
        self.orderCountLabel.text = [NSString stringWithFormat:@"已成交%@单",[dataDic objectForKey:@"orderCount"]];
        
        return cell;
    }
    else if (indexPath.section == 1){
        
        static NSString *identify =@"techcontentcell";

        detailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[detailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        UITapGestureRecognizer * setDefaultViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickView:)];
        [cell.ClientSayView addGestureRecognizer:setDefaultViewTap];
        UIView *singleTapView = [setDefaultViewTap view];
        singleTapView.tag = 11002;

        cell.listArrayData = dataDic;
        return cell;
    }else{
        static NSString *identify =@"SingleLevelServiceTableViewCell";
        
        SingleLevelServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[SingleLevelServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        if (self.serviceData.count>0) {
            cell.data = self.serviceData[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    currentrRow = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
}


-(void)onClickView:(id )sender{
    
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

-(void)onClickMoreButton:(id *)sender{
    NSLog(@"onClickMoreButton");
    
    self.moreButton.selected =!self.moreButton.selected;
    selected = self.moreButton.selected;
    if (selected) {
        [MobClick event:DOOR_TICHNICIANDETAIL_MORE];
        UIFont *font = [UIFont systemFontOfSize:13];
        CGSize titleSize = [aString sizeWithFont:font constrainedToSize:CGSizeMake(self.experienceLabel.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        float big =  MAX(ceilf(titleSize.height) ,  53*AUTO_SIZE_SCALE_X);
        
//        [self.experienceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(big));
//        }];
        self.experienceLabel.frame = CGRectMake(self.experienceLabel.frame.origin.x, self.experienceLabel.frame.origin.y, self.experienceLabel.frame.size.width, big);
        
        height = big- 53*AUTO_SIZE_SCALE_X;
//        [self.experienctView mas_updateConstraints:^(MASConstraintMaker *make) {
//            
//            make.size.mas_equalTo(CGSizeMake(kScreenWidth,100*AUTO_SIZE_SCALE_X+big- 53*AUTO_SIZE_SCALE_X));
//        }];
        
        self.experienctView.frame = CGRectMake(self.experienctView.frame.origin.x, self.experienctView.frame.origin.y, self.experienctView.frame.size.width, 100*AUTO_SIZE_SCALE_X+big- 53*AUTO_SIZE_SCALE_X);
        CGRect newFrame = self.HeaderView.frame;
        newFrame.size.height = self.HeaderView.size.height + big- 53*AUTO_SIZE_SCALE_X;
        self.HeaderView.frame = newFrame;
        
        
        
        self.moreButton.frame = CGRectMake(self.moreButton.frame.origin.x, self.moreButton.frame.origin.y+height, self.moreButton.frame.size.width, self.moreButton.frame.size.height);
        
        
    }else{
        
        
        
        self.experienceLabel.frame = CGRectMake(self.experienceLabel.frame.origin.x, self.experienceLabel.frame.origin.y, kScreenWidth-20, 53*AUTO_SIZE_SCALE_X);
        
//        [self.experienceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(kScreenWidth-20, 53*AUTO_SIZE_SCALE_X));
//            
//        }];
        
//        [self.experienctView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(kScreenWidth,100*AUTO_SIZE_SCALE_X));
//            
//        }];
        self.experienctView.frame = CGRectMake(self.experienctView.frame.origin.x, self.experienctView.frame.origin.y, self.experienctView.frame.size.width, 100*AUTO_SIZE_SCALE_X);
        CGRect newFrame = self.HeaderView.frame;
        newFrame.size.height = self.HeaderView.size.height - height;
        self.HeaderView.frame = newFrame;
        
        
        self.moreButton.frame = CGRectMake(self.moreButton.frame.origin.x, self.experienceLabel.frame.origin.y+self.experienceLabel.frame.size.height+12*AUTO_SIZE_SCALE_X, self.moreButton.frame.size.width, self.moreButton.frame.size.height);
    }
    
    [self.serviceTable beginUpdates];
    
    [self.serviceTable endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(UIView *)HeaderView{
    if (!_HeaderView) {
        _HeaderView =[UIView new];
        _HeaderView.frame = CGRectMake(0, 0, kScreenWidth, 200*AUTO_SIZE_SCALE_X);
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



-(UILabel *)ServiceZoneLabel{
    if (!_ServiceZoneLabel) {
        _ServiceZoneLabel =[UILabel new];
        _ServiceZoneLabel.font = [UIFont systemFontOfSize:13];
        
        
        _ServiceZoneLabel.numberOfLines =3;
        _ServiceZoneLabel.textColor = C6UIColorGray;
        
        
    }
    return _ServiceZoneLabel;
}








@end
