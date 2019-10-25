//
//  LoginViewController.m
//  Massage
//
//  Created by sophiemarceau_qu on 15/10/18.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "LoginViewController.h"
#import "OrderListViewController.h"
#import "DisclaimerViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    int i;
}
@property (strong, nonatomic) UIView *loginView;//放置两个textField的view
@property (strong, nonatomic) UITextField *phoneTextField;//手机号
@property (strong, nonatomic) UITextField *PINTextField;//验证码
@property (strong, nonatomic) UIButton *getPINButton;//获取验证码按钮
@property (strong, nonatomic) UIButton *loginButton;//登陆按钮
@property (strong, nonatomic) UILabel *warningLabel;//免责声明提示框
@property (strong, nonatomic) UILabel *timeLabel;//60秒后重发
@property (strong, nonatomic) NSTimer *timer;//计时器
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    i = 60;
    self.titles = @"快捷登录";
    [self initView];
}

- (void)backAction {
    if (self.isModalButton)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else
    {
        if (self.isFromOrderList == YES) {
            //转场动画
            CATransition *tran = [CATransition animation];
            tran.duration =.5;
            tran.type =@"oglFlip";
            tran.subtype =kCATransitionFromRight;
            [self.navigationController.view.layer addAnimation:tran forKey:nil];
            [self.navigationController popViewControllerAnimated:YES];
            self.isFromOrderList = NO;
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)initView {
    [self.view addSubview:self.loginView];
    UIImageView *line1 = [[UIImageView alloc]init];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.PINTextField];
    UIImageView *line2 = [[UIImageView alloc]init];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2];
    [self.view addSubview:self.getPINButton];
    [self.view addSubview:self.loginButton];
    //免责声明点击事件
    UITapGestureRecognizer *warningTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(warningLabelTaped:)];
    self.warningLabel.userInteractionEnabled = YES;
    [self.warningLabel addGestureRecognizer:warningTap];
    [self.view addSubview:self.warningLabel];
    //约束
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {//背景view
        make.top.equalTo(self.view.mas_top).offset(15+kNavHeight);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 90));
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {//中间横线
        make.center.equalTo(self.loginView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {//电话号码
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.loginView.mas_top);
        make.bottom.equalTo(line1.mas_top);
    }];
    [self.PINTextField mas_makeConstraints:^(MASConstraintMaker *make) {//验证码
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-kScreenWidth/3);
        make.top.equalTo(line1.mas_bottom);
        make.bottom.equalTo(self.loginView.mas_bottom);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {//短竖线
        make.left.equalTo(self.PINTextField.mas_right);
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.bottom.equalTo(self.loginView.mas_bottom).offset(-10);
        make.width.mas_equalTo(0.5);
    }];
    [self.getPINButton mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
        make.left.equalTo(line2.mas_right).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(line1.mas_bottom);
        make.bottom.equalTo(self.loginView.mas_bottom);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {//登陆按钮
        make.top.equalTo(self.loginView.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(45);
    }];
    [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {//免责声明
        make.top.equalTo(self.loginButton.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
}

#pragma mark - 按钮点击事件
-(void)fieldChanged
{
    if (self.phoneTextField.text.length == 11 && self.PINTextField.text.length == 4) {
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
    }else{
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_gary"] forState:UIControlStateNormal];
    }
}

-(void)getPINButtonPressed:(UIButton *)sender
{
    [MobClick event:VISITOR_GETCODE];
    if (self.phoneTextField.text.length == 11) {
        [self.getPINButton removeFromSuperview];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runClock) userInfo:nil repeats:YES];
        [self.timer fire];
        NSDictionary * dic = @{@"mobile":self.phoneTextField.text,
                               @"smsType":@"2"
                               };
        [[RequestManager shareRequestManager] GetVerifyCodeRusult:dic viewController:self successData:^(NSDictionary *result){
            //            NSLog(@"result-------->%@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                
            }
            else if ([[result objectForKey:@"code"] isEqualToString:@"6090"]){
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"]];
            }
        }failuer:^(NSError *error){
            //            NSLog(@"error-------->%@",error);
            
        }];
    }else{
        [[RequestManager shareRequestManager] tipAlert:@"手机号输入错误，请重新输入" viewController:self];
    }
    
}

-(void)runClock
{
    
    self.timeLabel.text = [NSString stringWithFormat:@"%d秒后重发",i];
    [self.loginView addSubview:self.timeLabel];
    //约束
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
        make.left.equalTo(self.PINTextField.mas_right).offset(10.5);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(0.5);
        make.bottom.equalTo(self.loginView.mas_bottom);
    }];
    i--;
    if (i<0) {
        [self.timer invalidate];
        [self.timeLabel removeFromSuperview];
        [self.loginView addSubview:self.getPINButton];
        //约束
        [self.getPINButton mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
            make.left.equalTo(self.PINTextField.mas_right).offset(10.5);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.top.equalTo(self.phoneTextField.mas_bottom).offset(0.5);
            make.bottom.equalTo(self.loginView.mas_bottom);
        }];
        i=60;
        
    }
    
}

-(void)loginButtonPressed:(UIButton *)sender
{
    NSLog(@"登陆");
    [MobClick event:VISITOR_LOGIN];
    [self.phoneTextField resignFirstResponder];
    [self.PINTextField resignFirstResponder];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * deviceTokenStr = [userDefaults objectForKey:@"deviceToken"];
    
    if ([self.phoneTextField.text isEqualToString:@"输入手机号"]) {
        [[RequestManager shareRequestManager] tipAlert:@"请输入手机号" viewController:self];
        return;
    }
    if (self.phoneTextField.text.length<11) {
        [[RequestManager shareRequestManager] tipAlert:@"电话号码尾数不够11位，请重新输入" viewController:self];
        return;
    }
    if ([self.PINTextField.text isEqualToString:@"验证码"]) {
        [[RequestManager shareRequestManager] tipAlert:@"请输入验证码" viewController:self];
        return;
    }
    if (self.PINTextField.text.length < 4) {
        [[RequestManager shareRequestManager] tipAlert:@"验证码位数不够4位，请重新输入" viewController:self];
        return;
    }
    if (!([deviceTokenStr isEqualToString:@""]||[deviceTokenStr isKindOfClass:[NSNull class]]||deviceTokenStr ==nil)) {
        NSDictionary * dic = @{@"mobile":self.phoneTextField.text,
                               @"authCode":self.PINTextField.text,
                               @"deviceToken":deviceTokenStr,
                               };
        [[RequestManager shareRequestManager] LoginUserRequest:dic viewController:self successData:^(NSDictionary *result){
            //        NSLog(@"result-------->%@",result);
            if ([[result objectForKey:@"msg"] isEqualToString:@"ok"]) {
                NSString * UserId = [result objectForKey:@"userID"];
                NSString * mobileNu = [result objectForKey:@"mobile"];
                
                [userDefaults removeObjectForKey:@"userID"];
                [userDefaults setValue:UserId forKey:@"userID"];
                [userDefaults removeObjectForKey:@"mobile"];
                [userDefaults setValue:mobileNu forKey:@"mobile"];
                
                [userDefaults setBool:YES forKey:@"loGin"];
                [userDefaults synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginPageDataNtf"  object:@{@"ret":@"20001" ,@"requestflag":@"addressLauch"}];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }failuer:^(NSError *error){
            //        NSLog(@"error-------->%@",error);
            
        }];
    }
}
//免责声明点击事件
- (void)warningLabelTaped:(UITapGestureRecognizer *)sender {
    [MobClick event:VISITOR_PROTOCOL];
    DisclaimerViewController *vc = [[DisclaimerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag == 101) {
        if (range.location >10) {
            return NO;
        }
    }
    if (textField.tag == 102) {
        if (range.location >3) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 101)
    {
        if ([textField.text isEqualToString:@"输入手机号"]) {
            textField.text = @"";
            textField.textColor = [UIColor blackColor];
        }
    }
    if (textField.tag == 102)
    {
        if ([textField.text isEqualToString:@"验证码"]) {
            textField.text = @"";
            textField.textColor = [UIColor blackColor];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.textColor = [UIColor blackColor];
    if ([textField.text isEqualToString:@""]) {
        if (textField.tag == 101) {
            textField.text = @"输入手机号";
            textField.textColor = C7UIColorGray;
        }else if(textField.tag == 102) {
            textField.text = @"验证码";
            textField.textColor = C7UIColorGray;
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"OK");
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 懒加载
- (UIView *)loginView {
    if (_loginView == nil) {
        self.loginView = [[UIView alloc]init];
        self.loginView.backgroundColor = [UIColor whiteColor];
    }
    return _loginView;
}
- (UITextField *)phoneTextField {
    if (_phoneTextField == nil) {
        self.phoneTextField = [[UITextField alloc]init];
        self.phoneTextField.text = @"输入手机号";
        self.phoneTextField.textColor = C7UIColorGray;
        self.phoneTextField.font = [UIFont systemFontOfSize:15];
        self.phoneTextField.tag = 101;
        self.phoneTextField.delegate = self;
        self.phoneTextField.textAlignment = NSTextAlignmentLeft;
        self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;//出现小叉子
        [self.phoneTextField setTintColor:[UIColor grayColor]];
        self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.phoneTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneTextField;
}
- (UITextField *)PINTextField {
    if (_PINTextField == nil) {
        self.PINTextField = [[UITextField alloc]init];
        self.PINTextField.text = @"验证码";
        self.PINTextField.textColor = C7UIColorGray;
        self.PINTextField.font = [UIFont systemFontOfSize:15];
        self.PINTextField.tag = 102;
        self.PINTextField.delegate = self;
        [self.PINTextField setTintColor:[UIColor grayColor]];
        self.PINTextField.borderStyle = UITextBorderStyleNone;
        self.PINTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.PINTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.PINTextField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _PINTextField;
}
- (UIButton *)getPINButton {
    if (_getPINButton == nil) {
        self.getPINButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.getPINButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.getPINButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getPINButton setTintColor:C6UIColorGray];
        [self.getPINButton addTarget:self action:@selector(getPINButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getPINButton;
}
- (UIButton *)loginButton {
    if (_loginButton == nil) {
        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_gary"] forState:UIControlStateNormal];
        [self.loginButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.loginButton setTintColor:UIColorFromRGB(0xffffff)];
        [self.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
- (UILabel *)warningLabel {
    if (_warningLabel == nil) {
        self.warningLabel = [[UILabel alloc]init];
        NSString * str = @"点击“登录”，即表示同意《华佗驾到免责声明》";
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttribute:NSForegroundColorAttributeName value:C7UIColorGray range:NSMakeRange(0, 12)];
        [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x3c8ecb) range:NSMakeRange(12, 10)];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [str length])];
        self.warningLabel.attributedText = attStr;
        self.warningLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _warningLabel;
}
- (NSTimer *)timer {
    if (_timer == nil) {
        self.timer = [[NSTimer alloc]init];
    }
    return _timer;
}
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = C6UIColorGray;
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}
@end
