//
//  FeedBackViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/30.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController () <UITextViewDelegate>
@property (strong, nonatomic) UIView *feedBackView;
@property (strong, nonatomic) UITextView *feedBackTextView;
@property (strong, nonatomic) UIButton *sendBtn;
@property (strong, nonatomic) UILabel *textCountLabel;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"使用反馈";
    [self initView];
    
}
- (void)initView {
    
    [self.navView addSubview:self.sendBtn];
    
    self.feedBackTextView.text = @"请写下您对华佗驾到的建议吧";
    self.feedBackTextView.textAlignment = NSTextAlignmentLeft;
    self.feedBackTextView.textColor = [UIColor blackColor];
    self.feedBackTextView.font = [UIFont systemFontOfSize:14];
    self.feedBackTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.feedBackTextView.textColor = C7UIColorGray;
    self.feedBackTextView.returnKeyType = UIReturnKeyDefault;
    self.feedBackTextView.scrollEnabled = YES;
    self.feedBackTextView.delegate = self;
    UIToolbar * textviewtopView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    [textviewtopView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [textviewtopView setItems:buttonsArray];
    [self.feedBackTextView setInputAccessoryView:textviewtopView];
    [self.feedBackView addSubview:self.feedBackTextView];
    [self.feedBackView addSubview:self.textCountLabel];
    [self.view addSubview:self.feedBackView];
    //约束
    [self.textCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.feedBackView.mas_bottom).offset(-15);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
    [self.feedBackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.feedBackView.mas_top).offset(15);
        make.bottom.equalTo(self.textCountLabel.mas_top).offset(-15);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navView.mas_right);
        make.bottom.equalTo(self.navView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, navBtnHeight));
    }];
}
#pragma mark - 按钮点击事件
- (void)sendBtnClick:(UIButton *)sender {
    sender.enabled = NO;
    if ([self.feedBackTextView.text isEqualToString:@"请写下您对华佗驾到的建议吧"]) {
        [[RequestManager shareRequestManager] tipAlert:@"请说些什么吧" viewController:self];
        sender.enabled = YES;
    }else {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"context":self.feedBackTextView.text,
                               };
        [[RequestManager shareRequestManager] addFeedBack:dic viewController:self successData:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                [[RequestManager shareRequestManager] tipAlert:@"提交反馈成功，感谢您的建议" viewController:self];
                [self performSelector:@selector(Show) withObject:self afterDelay:2.0];
            }else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                sender.enabled = YES;
            }
        } failuer:^(NSError *error) {
            sender.enabled = YES;
            
        }];
    }
}
-(void)Show
{
    self.sendBtn.enabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
//收起键盘
-(void) dismissKeyBoard{
    [self.feedBackTextView resignFirstResponder];
}
//点击空白处关闭键盘
//重写vc的touchesBegan方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    self.textCountLabel.text = [NSString stringWithFormat:@"%ld/500",(long)number];
    if (number > 500) {
        [[RequestManager shareRequestManager] tipAlert:@"文字已达到最长限度" viewController:self];
        textView.text = [textView.text substringToIndex:500];
        number = 500;
        
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:@"请写下您对华佗驾到的建议吧"]) {
        textView.text = @"";
    }
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:1.00];
    [UIView commitAnimations];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIView commitAnimations];
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请写下您对华佗驾到的建议吧";
        textView.textColor = C7UIColorGray;
    }
}

#pragma mark - 懒加载
- (UIView *)feedBackView {
    if (_feedBackView == nil) {
        self.feedBackView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavHeight+10, kScreenWidth, 300)];
        self.feedBackView.backgroundColor = [UIColor whiteColor];
    }
    return _feedBackView;
}
- (UITextView *)feedBackTextView {
    if (_feedBackTextView == nil) {
        self.feedBackTextView = [UITextView new];
    }
    return _feedBackTextView;
}
- (UIButton *)sendBtn {
    if (_sendBtn == nil) {
        self.sendBtn = [CommentMethod createButtonWithImageName:@"" Target:self Action:@selector(sendBtnClick:) Title:@"提交"];
        self.sendBtn.backgroundColor = [UIColor clearColor];
    }
    return _sendBtn;
}
- (UILabel *)textCountLabel {
    if (_textCountLabel == nil) {
        self.textCountLabel = [CommentMethod initLabelWithText:@"0/500" textAlignment:NSTextAlignmentRight font:14];
        self.textCountLabel.textColor = C7UIColorGray;
    }
    return _textCountLabel;
}
@end
