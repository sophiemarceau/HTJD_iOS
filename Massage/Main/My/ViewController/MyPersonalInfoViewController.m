//
//  MyPersonalInfoViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/14.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "MyPersonalInfoViewController.h"
#import "publicTableViewCell.h"
#import "BaseTableView.h"
#import "LoginViewController.h"
#import "MyOrderViewController.h"
#import "OrderListViewController.h"
#import "MyAddressViewController.h"
#import "MyFavoritesViewController.h"
#import "MyCouponsViewController.h"
#import "MyConsumptionCodeViewController.h"
#import "FAQViewController.h"
#import "AboutUsViewController.h"
#import "UIImageView+WebCache.h"
#import "MyPersonalTableViewCell.h"

@interface MyPersonalInfoViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *balanceLabel;
    UILabel *couponsLabel;
    UILabel *consumtionLabel;
}
@property (strong, nonatomic) UITableView *MyTableView;
@property (strong, nonatomic) UIImageView *logHeaderView;//登陆后的表头
@property (strong, nonatomic) UIImageView *unlogHeaderView;//未登录的表头
@property (strong, nonatomic) UIButton *loginButton;//登陆按钮
@property (strong, nonatomic) UIButton *exitButton;//退出登录按钮
@property (strong, nonatomic) UIImageView *headImage;//头像
@property (strong, nonatomic) UILabel *nickNameLabel;//昵称
@property (strong, nonatomic) UILabel *phoneLabel;//绑定手机
@property (strong, nonatomic) NSArray *titleNameArray;
@property (strong, nonatomic) NSArray *titleImageArray;
@property (nonatomic,assign) BOOL isLogin;
@end

@implementation MyPersonalInfoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self getMyUserInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    couponsLabel.text = @"";
    consumtionLabel.text = @"";
    
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDetaults objectForKey:@"userID"];
    NSLog(@"userid === %@",userID);
    if ([userID isEqualToString:@""]||[userID isKindOfClass:[NSNull class]] ||userID ==nil) {
        //未登录
        NSLog(@"未登录");
        self.isLogin = NO;
    }else{
        //已登陆
        NSLog(@"已登陆");
        self.isLogin = YES;
        NSLog(@"已加载信息");
    }
    self.titles = @"我的华佗";
    [self getMyUserInfo];
    [self initView];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"LoginPageDataNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginPageDataNtf:) name:@"LoginPageDataNtf" object:nil];
}

-(void)LoginPageDataNtf:(NSNotification *)ntf{
    NSDictionary *info =ntf.object;
    NSString *ret =[info objectForKey:@"ret"];
    if([ret isEqualToString:@"20001"]){
        //已登录
        [self getMyUserInfo];
        self.MyTableView.tableHeaderView = self.logHeaderView;
//        [self.navView addSubview:self.exitButton];
//        //约束
//        [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {//退出按钮
//            make.right.equalTo(self.navView.mas_right).with.offset(-10);
//            make.bottom.equalTo(self.navView.mas_bottom).with.offset(-10);
//            make.size.mas_equalTo(CGSizeMake(70, 20));
//        }];
        
        self.isLogin = YES;
        [self.MyTableView reloadData];
    }
}

- (void)getMyUserInfo {
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDetaults objectForKey:@"userID"];
    NSLog(@"userID--%@",userID);
    if (!([userID isEqualToString:@""]||[userID isKindOfClass:[NSNull class]]||userID ==nil)) {
        NSDictionary * dic = @{
                               @"userID":userID
                               };
        [[RequestManager shareRequestManager] GetMyUserInfo:dic viewController:self successData:^(NSDictionary *result) {
            NSLog(@"result------------>%@",result);
            if(IsSucessCode(result)){
                MyDocDic = [NSDictionary dictionaryWithDictionary:result];
                
                NSString * str1 = [MyDocDic objectForKey:@"mobile"];
                if (str1.length == 11) {
                    NSString * substr1 = [str1 substringToIndex:3];
                    NSString * substr2 = [str1 substringWithRange:NSMakeRange(7, 4)];
                    NSString * newStr = [NSString stringWithFormat:@"%@%@%@",substr1,@"****",substr2];
                    self.phoneLabel.text = newStr;
                }
                self.nickNameLabel.text = [MyDocDic objectForKey:@"name"];
                if ([self.nickNameLabel.text isEqualToString:@"未知昵称"]) {
                    self.nickNameLabel.hidden = YES;
                    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {//电话
                        make.centerY.equalTo(self.logHeaderView.mas_centerY);
                        make.left.equalTo(self.headImage.mas_right).with.offset(16*AUTO_SIZE_SCALE_X);
//                        make.bottom.equalTo(self.headImage.mas_bottom).with.offset(-12);
                        make.right.equalTo(self.exitButton.mas_left).with.offset(-10*AUTO_SIZE_SCALE_X);
                        make.height.mas_equalTo(15);
                    }];
                }else {
                    self.nickNameLabel.hidden = NO;
                    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {//电话
//                        make.centerY.equalTo(self.logHeaderView.mas_centerY);
                        make.left.equalTo(self.headImage.mas_right).with.offset(16*AUTO_SIZE_SCALE_X);
                        make.bottom.equalTo(self.headImage.mas_bottom).with.offset(-12);
                        make.right.equalTo(self.exitButton.mas_left).with.offset(-10*AUTO_SIZE_SCALE_X);
                        make.height.mas_equalTo(15);
                    }];
                }
                [self.headImage setImageWithURL:[NSURL URLWithString:[MyDocDic objectForKey:@"userIcons"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
                [userDetaults synchronize];
                CGFloat deposit = [[MyDocDic objectForKey:@"deposit"]floatValue];
                deposit = deposit/100;
                balanceLabel.text = [NSString stringWithFormat:@"%.2f",deposit];
                if ([[MyDocDic objectForKey:@"couponCount"]intValue] == 0) {
                    couponsLabel.text = @"";
                }else {
                    couponsLabel.text = [NSString stringWithFormat:@"您有%d张优惠券",[[MyDocDic objectForKey:@"couponCount"]intValue]];
                }
                if ([[MyDocDic objectForKey:@"exchangeCodeCount"]intValue] == 0) {
                    consumtionLabel.text = @"";
                }else {
                    consumtionLabel.text = [NSString stringWithFormat:@"待消费%d个",[[MyDocDic objectForKey:@"exchangeCodeCount"]intValue]];
                }
                [self.MyTableView reloadData];
            }else{
                NDLog(@"--删除userid------");
//                [self resultFail:result];
            }
        } failuer:^(NSError *error) {
            
        }];
    }
}

- (void)initView {
    [self.view addSubview:self.MyTableView];
}
#pragma mark - 按钮点击事件
-(void)loginButtonPressed:(UIButton *)sender
{
    NSLog(@"跳转到登录界面");
    LoginViewController * vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)exitButtonPressed:(UIButton *)sender
{
    NSLog(@"退出登录");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"是否退出登录"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是",nil];
    [alert show];
    [MobClick endEvent:MY_LOGOUT];
}

#pragma mark - UIAlertViewDelegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    
    if (buttonIndex == 0) {
        NSLog(@"取消注销");
        return;
    }
    if (buttonIndex == 1) {
        NSLog(@"注销账户");
        NSUserDefaults * deft = [NSUserDefaults standardUserDefaults];
        [deft setBool:NO forKey:@"loGin"];
        [deft removeObjectForKey:@"userID"];
        [deft removeObjectForKey:@"mobile"];
        [deft removeObjectForKey:@"accountBalance"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginPageDataNtf"  object:@{@"ret":@"20002" ,@"requestflag":@"addressLauch"}];
        
        //未登录
        self.MyTableView.tableHeaderView = self.unlogHeaderView;
//        [self.exitButton removeFromSuperview];
        balanceLabel.text = @"";
        couponsLabel.text = @"";
        consumtionLabel.text = @"";
        [self.MyTableView reloadData];
        self.isLogin = NO;
    }
}

#pragma mark - TableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//分区的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        return self.titleNameArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"MyPersonalTableViewCell";
    MyPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[MyPersonalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        //标题图片
        cell.titleImage.image = [UIImage imageNamed:@"uc_menu_balance"];
        //标题
        cell.titleLabel.text = @"我的余额";
        //余额
        if (self.isLogin == NO) {
            cell.detailLabel.hidden = YES;
        }else {
            cell.detailLabel.hidden = NO;
            cell.detailLabel.textColor = RedUIColorC1;
            cell.detailLabel.text = [NSString stringWithFormat:@"%.2f",[[MyDocDic objectForKey:@"deposit"]floatValue]/100];
        }
        return cell;
    }else {
        cell.detailLabel.hidden = YES;
        //标题图片
        cell.titleImage.image = [UIImage imageNamed:[self.titleImageArray objectAtIndex:indexPath.row]];
        //标题
        cell.titleLabel.text = [self.titleNameArray objectAtIndex:indexPath.row];
        //最后一行不添加横线
        if (indexPath.row != self.titleNameArray.count-1) {
            cell.line.hidden = NO;
        }else {
            cell.line.hidden = YES;
        }
        if (indexPath.row == 2) {
            if (self.isLogin == NO) {
                cell.detailLabel.hidden = YES;
            }else {
                cell.detailLabel.hidden = NO;
                cell.detailLabel.textColor = C6UIColorGray;
                if ([[MyDocDic objectForKey:@"couponCount"]intValue] == 0) {
                    cell.detailLabel.text = @"";
                }else {
                    cell.detailLabel.text = [NSString stringWithFormat:@"您有%d张优惠券",[[MyDocDic objectForKey:@"couponCount"]intValue]];
                }
            }
        }
        if (indexPath.row == 3) {
            if (self.isLogin == NO) {
                cell.detailLabel.hidden = YES;
            }else {
                cell.detailLabel.hidden = NO;
                cell.detailLabel.textColor = C6UIColorGray;
                if ([[MyDocDic objectForKey:@"exchangeCodeCount"]intValue] == 0) {
                    cell.detailLabel.text = @"";
                }else {
                    cell.detailLabel.text = [NSString stringWithFormat:@"待消费%d个",[[MyDocDic objectForKey:@"exchangeCodeCount"]intValue]];
                }
            }
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.isLogin == NO) {
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            MyOrderViewController *vc = [[MyOrderViewController alloc]init];
            vc.acStr = [NSString stringWithFormat:@"%@",[MyDocDic objectForKey:@"deposit"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        if ([[self.titleNameArray objectAtIndex:indexPath.row] isEqualToString:@"我的订单"]) {
            if (self.isLogin == NO) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                OrderListViewController *vc = [[OrderListViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if ([[self.titleNameArray objectAtIndex:indexPath.row] isEqualToString:@"我的地址"]) {
            if (self.isLogin == NO) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                MyAddressViewController *vc = [[MyAddressViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                [MobClick event:MY_ADRESS];
            }
        } else if ([[self.titleNameArray objectAtIndex:indexPath.row] isEqualToString:@"我的收藏"]) {
            if (self.isLogin == NO) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                MyFavoritesViewController *vc = [[MyFavoritesViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                [MobClick event:MY_COLLECT];
            }
        } else if ([[self.titleNameArray objectAtIndex:indexPath.row] isEqualToString:@"优惠兑换"]) {
            if (self.isLogin == NO) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                MyCouponsViewController *vc = [[MyCouponsViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                [MobClick event:MY_COUPON];
            }
        } else if ([[self.titleNameArray objectAtIndex:indexPath.row] isEqualToString:@"消费码"]) {
            if (self.isLogin == NO) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                MyConsumptionCodeViewController *vc = [[MyConsumptionCodeViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                [MobClick event:MY_CODE];
            }
        } else if ([[self.titleNameArray objectAtIndex:indexPath.row] isEqualToString:@"常见问题"]) {
            FAQViewController *vc = [[FAQViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            [MobClick event:MY_QA];
        } else if ([[self.titleNameArray objectAtIndex:indexPath.row] isEqualToString:@"关于华佗"]) {
            AboutUsViewController *vc = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            [MobClick event:MY_ABOUTUS];
        }
    }
}
#pragma mark - 懒加载
- (UITableView *)MyTableView {
    if (_MyTableView == nil) {
        self.MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight)];
        self.MyTableView.delegate = self;
        self.MyTableView.dataSource = self;
        self.MyTableView.rowHeight = 45*AUTO_SIZE_SCALE_X;
        self.MyTableView.showsVerticalScrollIndicator = NO;
        self.MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.MyTableView.backgroundColor = [UIColor clearColor];
        if (self.isLogin == YES) {
            self.MyTableView.tableHeaderView = self.logHeaderView;
        }else {
            self.MyTableView.tableHeaderView = self.unlogHeaderView;
        }
    }
    return _MyTableView;
}
- (UIImageView *)unlogHeaderView {
    if (_unlogHeaderView == nil) {
        self.unlogHeaderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
        [self.unlogHeaderView setImage:[UIImage imageNamed:@"uc_bg_header"]];
        self.unlogHeaderView.userInteractionEnabled = YES;
        
        [self.unlogHeaderView addSubview:self.loginButton];
        //约束
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {//登陆按钮
            make.center.equalTo(self.unlogHeaderView);
            make.size.mas_equalTo(CGSizeMake(104, 37));
        }];
    }
    return _unlogHeaderView;
}
- (UIImageView *)logHeaderView {
    if (_logHeaderView == nil) {
        self.logHeaderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
        [self.logHeaderView setImage:[UIImage imageNamed:@"uc_bg_header"]];
        self.logHeaderView.userInteractionEnabled = YES;
        //已登录
        [self.logHeaderView addSubview:self.exitButton];
        [self.logHeaderView addSubview:self.headImage];
        [self.logHeaderView addSubview:self.nickNameLabel];
        [self.logHeaderView addSubview:self.phoneLabel];
        //约束
        [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {//退出按钮
            make.right.equalTo(self.logHeaderView.mas_right).with.offset(-15);
            make.centerY.equalTo(self.logHeaderView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(70, 20));
        }];
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {//头像
            make.centerY.equalTo(self.logHeaderView.mas_centerY);
            make.left.equalTo(self.logHeaderView.mas_left).with.offset(18*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {//昵称
            make.left.equalTo(self.headImage.mas_right).with.offset(16*AUTO_SIZE_SCALE_X);
            make.top.equalTo(self.headImage.mas_top).with.offset(11.5);
            make.right.equalTo(self.exitButton.mas_left).with.offset(-10*AUTO_SIZE_SCALE_X);
            make.height.mas_equalTo(15);
        }];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {//电话
            //            make.centerY.equalTo(self.logHeaderView.mas_centerY);
            make.left.equalTo(self.headImage.mas_right).with.offset(16*AUTO_SIZE_SCALE_X);
            make.bottom.equalTo(self.headImage.mas_bottom).with.offset(-12);
            make.right.equalTo(self.exitButton.mas_left).with.offset(-10*AUTO_SIZE_SCALE_X);
            make.height.mas_equalTo(15);
        }];
    }
    return _logHeaderView;
}
- (UIButton *)loginButton {
    if (_loginButton == nil) {
        self.loginButton = [[UIButton alloc]init];
        [self.loginButton setTitle:@"点击登录" forState:UIControlStateNormal];
        [self.loginButton setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        self.loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"uc_btn_login"] forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
- (UIButton *)exitButton {
    if (_exitButton == nil) {
        self.exitButton = [[UIButton alloc]init];
        [self.exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [self.exitButton setTitleColor:UIColorFromRGB(0xe5a68a) forState:UIControlStateNormal];
        self.exitButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.exitButton addTarget:self action:@selector(exitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}
- (UIImageView *)headImage {
    if (_headImage == nil) {
        self.headImage = [[UIImageView alloc]init];
        self.headImage.layer.cornerRadius = 30.0;
        self.headImage.layer.masksToBounds = YES;
    }
    return _headImage;
}
- (UILabel *)nickNameLabel {
    if (_nickNameLabel == nil) {
        self.nickNameLabel = [[UILabel alloc]init];
        self.nickNameLabel.textAlignment = NSTextAlignmentLeft;
        self.nickNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nickNameLabel;
}
- (UILabel *)phoneLabel {
    if (_phoneLabel == nil) {
        self.phoneLabel = [[UILabel alloc]init];
        self.phoneLabel.textAlignment = NSTextAlignmentLeft;
        self.phoneLabel.font = [UIFont systemFontOfSize:15];
    }
    return _phoneLabel;
}
- (NSArray *)titleNameArray {
    if (_titleNameArray == nil) {
        self.titleNameArray = [NSArray arrayWithObjects:@"我的地址", @"我的收藏", @"优惠兑换", @"消费码", @"常见问题", @"关于华佗", nil];
    }
    return _titleNameArray;
}
- (NSArray *)titleImageArray {
    if (_titleImageArray == nil) {
        self.titleImageArray = [NSArray arrayWithObjects:@"uc_menu_myaddress", @"uc_menu_myfavorites", @"uc_menu_mycoupons", @"uc_menu_myconsumptioncode", @"uc_menu_help", @"uc_menu_about", nil];
    }
    return _titleImageArray;
}
@end
