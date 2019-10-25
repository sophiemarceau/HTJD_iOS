//
//  HomeCommentViewController.m
//  Massage
//
//  Created by 牛先 on 15/11/19.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "HomeCommentViewController.h"

@interface HomeCommentViewController ()
@property (strong, nonatomic) UIScrollView *backScrollView;
//三个背景图
@property (strong, nonatomic) UIView *scoreView;//分数
@property (strong, nonatomic) UIView *attitudeView;//态度
@property (strong, nonatomic) UIView *commentView;//评价
@end

@implementation HomeCommentViewController
{
    UIButton *serviceScoreBtn;//项目评分按钮
    NSMutableArray *serviceScoreBtnArray;//存储项目按钮
    
    UIButton *workerScoreBtn;//技师评分按钮
    NSMutableArray *workerScoreBtnArray;//存储技师按钮
    
    UIButton *attitudeBtn;//态度按钮
    NSMutableArray *attitudeBtnArray;//存储态度按钮
    
    NSMutableArray * BedCommentArray;//存储评论数据
    NSMutableArray * selectBtnArray;//存储选中状态按钮
    NSMutableArray * normalBtnArray;//存储一般状态按钮
    
    UITextView *commentTextView;//评论内容
    UIButton *commentButton;//提交评论
    
    NSString *serviceScoreStr;//服务分数
    NSString *workerScoreStr;//技师分数
    
    NSString * bedStr;
}
@synthesize orderID;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles =  @"发表评论";
    BedCommentArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    selectBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
    normalBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    serviceScoreBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
    workerScoreBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
    attitudeBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    bedStr = @"";
    
    [self getCommentList];
    NDLog(@"orderID:%@",self.orderID);
}
- (void)getCommentList {
    NSDictionary * dic = @{
                           @"type":@"2"
                           };
    [[RequestManager shareRequestManager] getTagList:dic viewController:self successData:^(NSDictionary *result) {
        NDLog(@"result --------------- >%@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            BedCommentArray = [NSMutableArray arrayWithArray:[result objectForKey:@"tagList"]];
            [self initView];
        }
    } failuer:^(NSError *error) {
        
    }];
}
- (void)initView {
    //项目评分五角星
    UILabel *serviceLabel = [CommentMethod initLabelWithText:@"项目" textAlignment:NSTextAlignmentLeft font:15];
    serviceLabel.frame = CGRectMake((kScreenWidth-210)/2, 15, 30, 15);
    serviceLabel.textColor = BlackUIColorC5;
    [self.scoreView addSubview:serviceLabel];
    
    serviceScoreStr = @"5";//默认5分
    
    for (int i = 4000; i < 4005; i++) {
        serviceScoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        serviceScoreBtn.frame = CGRectMake(((kScreenWidth-210)/2+45) + (10+25)*(i-4000), 10, 25, 25);
        [serviceScoreBtn setBackgroundImage:[UIImage imageNamed:@"icon_star_11"] forState:UIControlStateNormal];
        [serviceScoreBtn addTarget:self action:@selector(serviceScoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        serviceScoreBtn.tag = i;
        [serviceScoreBtnArray addObject:serviceScoreBtn];
        [self.scoreView addSubview:serviceScoreBtn];
    }
    //技师评分五角星
    UILabel *workerLabel = [CommentMethod initLabelWithText:@"技师" textAlignment:NSTextAlignmentLeft font:15];
    workerLabel.frame = CGRectMake((kScreenWidth-210)/2, 60, 30, 15);
    workerLabel.textColor = BlackUIColorC5;
    [self.scoreView addSubview:workerLabel];
    
    workerScoreStr = @"5";//默认5分
    
    for (int i = 5000; i < 5005; i++) {
        workerScoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        workerScoreBtn.frame = CGRectMake(((kScreenWidth-210)/2+45) + (10+25)*(i-5000), 55, 25, 25);
        [workerScoreBtn setBackgroundImage:[UIImage imageNamed:@"icon_star_11"] forState:UIControlStateNormal];
        [workerScoreBtn addTarget:self action:@selector(workerScoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        workerScoreBtn.tag = i;
        [workerScoreBtnArray addObject:workerScoreBtn];
        [self.scoreView addSubview:workerScoreBtn];
    }
    
    [self.backScrollView addSubview:self.scoreView];
    
    //标签页
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 10;//用来控制button距离父视图的高
    for (int i = 0; i < BedCommentArray.count; i++) {
        attitudeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        attitudeBtn.tag = [[NSString stringWithFormat:@"%@",[[BedCommentArray objectAtIndex:i] objectForKey:@"ID"]] intValue];
        attitudeBtn.backgroundColor = [UIColor whiteColor];
        [attitudeBtn addTarget:self action:@selector(attitudeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [attitudeBtn setTitleColor:C6UIColorGray forState:UIControlStateNormal];
        attitudeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        attitudeBtn.layer.cornerRadius = 3.0;
        attitudeBtn.layer.masksToBounds = YES;
        attitudeBtn.layer.borderColor = C7UIColorGray.CGColor;
        attitudeBtn.layer.borderWidth = 1.0;
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat length = [[[BedCommentArray objectAtIndex:i] objectForKey:@"tagName"] boundingRectWithSize:CGSizeMake(kScreenWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [attitudeBtn setTitle:[[BedCommentArray objectAtIndex:i] objectForKey:@"tagName"] forState:UIControlStateNormal];
        //设置button的frame
        attitudeBtn.frame = CGRectMake(12 + w, h, length + 12 , 30);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(12 + w + length + 12 > kScreenWidth){
            w = 0; //换行时将w置为0
            h = h + attitudeBtn.frame.size.height + 8;//距离父视图也变化
            attitudeBtn.frame = CGRectMake(12 + w, h, length + 12, 30);//重设button的frame
        }
        w = attitudeBtn.frame.size.width + attitudeBtn.frame.origin.x - 7;//间距为15-7
        [self.attitudeView addSubview:attitudeBtn];
        [normalBtnArray addObject:attitudeBtn];
    }
    [self.backScrollView addSubview:self.attitudeView];
    
    //评论页
    commentTextView = [[UITextView alloc]init];
    commentTextView.text = @"请点评一下我们吧～";
    commentTextView.backgroundColor = C8UIColorGray;
    commentTextView.layer.cornerRadius = 4.0;
    commentTextView.layer.masksToBounds = YES;
    commentTextView.textAlignment = NSTextAlignmentLeft;
    commentTextView.textColor = BlackUIColorC5;
    commentTextView.font = [UIFont systemFontOfSize:13];
    commentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    commentTextView.textColor = C7UIColorGray;
    commentTextView.returnKeyType = UIReturnKeyDefault;
    commentTextView.scrollEnabled = YES;
    commentTextView.delegate = self;
    UIToolbar * textviewtopView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    [textviewtopView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [textviewtopView setItems:buttonsArray];
    [commentTextView setInputAccessoryView:textviewtopView];
    //提交评论按钮
    commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setTitle:@"提交评论" forState:UIControlStateNormal];
    [commentButton setTitleColor:BlackUIColorC5 forState:UIControlStateNormal];
    commentButton.backgroundColor = [UIColor whiteColor];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    commentButton.layer.cornerRadius = 1.0;
    commentButton.layer.borderColor = C7UIColorGray.CGColor;
    commentButton.layer.borderWidth = 1.0;
    [commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.commentView addSubview:commentButton];
    [self.commentView addSubview:commentTextView];
    [self.backScrollView addSubview:self.commentView];
    
    [self.view addSubview:self.backScrollView];
    //约束
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.backScrollView.mas_top).offset(10);
        make.height.mas_equalTo(98);
    }];
    [self.attitudeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.scoreView.mas_bottom).offset(10);
        make.height.mas_equalTo(h + attitudeBtn.frame.size.height + 10);
    }];
    if (self.view.bounds.size.height -64 - 10 - 98 - 10 - 10 - h - attitudeBtn.frame.size.height - 10 > 206) {
        [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.attitudeView.mas_bottom).offset(10);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }else {
        [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.attitudeView.mas_bottom).offset(10);
            make.height.mas_equalTo(206);
            make.bottom.equalTo(self.backScrollView.mas_bottom);
        }];
    }
    [commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.top.equalTo(self.commentView.mas_top).offset(10);
        make.bottom.equalTo(commentButton.mas_top).offset(-20);
    }];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.commentView.mas_bottom).offset(-16);
        make.size.mas_equalTo(CGSizeMake(90, 35));
    }];
}
#pragma mark - 按钮点击事件
//项目评分
- (void)serviceScoreBtnClick:(UIButton *)sender {
    for (serviceScoreBtn in serviceScoreBtnArray) {
        if (serviceScoreBtn.tag <= sender.tag) {
            [serviceScoreBtn setBackgroundImage:[UIImage imageNamed:@"icon_star_11"] forState:UIControlStateNormal];
        }else {
            [serviceScoreBtn setBackgroundImage:[UIImage imageNamed:@"icon_star_22"] forState:UIControlStateNormal];
        }
    }
    serviceScoreStr = [NSString stringWithFormat:@"%ld",(long)sender.tag-4000+1];
    NDLog(@"项目分数(上门):%@",serviceScoreStr);
}
//技师评分
- (void)workerScoreBtnClick:(UIButton *)sender {
    for (workerScoreBtn in workerScoreBtnArray) {
        if (workerScoreBtn.tag <= sender.tag) {
            [workerScoreBtn setBackgroundImage:[UIImage imageNamed:@"icon_star_11"] forState:UIControlStateNormal];
        }else {
            [workerScoreBtn setBackgroundImage:[UIImage imageNamed:@"icon_star_22"] forState:UIControlStateNormal];
        }
    }
    workerScoreStr = [NSString stringWithFormat:@"%ld",(long)sender.tag-5000+1];
    NDLog(@"技师分数(上门):%@",workerScoreStr);
}
//态度标签
- (void)attitudeBtnClick:(UIButton *)sender {
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag < 20000000) {
        sender.backgroundColor = OrangeUIColorC4;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.layer.borderColor = OrangeUIColorC4.CGColor;
        sender.layer.borderWidth = 1.0;
//        NSString * titleStr = sender.titleLabel.text;
        NSString * titleStr = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        [selectBtnArray addObject:titleStr];
        sender.tag = sender.tag + 10000000;
    }else if (sender.tag > 20000000) {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:C6UIColorGray forState:UIControlStateNormal];
        sender.layer.borderColor = C7UIColorGray.CGColor;
        sender.layer.borderWidth = 1.0;
        sender.tag = sender.tag - 10000000;
        NSString * titleStr = [NSString stringWithFormat:@"%ld",(long)sender.tag];
//        NSString * titleStr = sender.titleLabel.text;
        [selectBtnArray removeObject:titleStr];
    }
    bedStr = @"";
    NSLog(@"selectBtnArray count --------- >%lu",(unsigned long)[selectBtnArray count]);
    for (int i=0; i<[selectBtnArray count]; i++) {
        if ([bedStr isEqualToString:@""]) {
            bedStr = [selectBtnArray objectAtIndex:0];
        }else{
            NSString * subStr = [NSString stringWithFormat:@",%@",[selectBtnArray objectAtIndex:i]];
            bedStr = [bedStr stringByAppendingString:subStr];
        }
    }
    NSLog(@"bedStr ======== >%@",bedStr);
}
//提交评论
- (void)commentButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    if ([serviceScoreStr isEqualToString:@"0"]||[workerScoreStr isEqualToString:@"0"]) {
        [[RequestManager shareRequestManager] tipAlert:@"请您先进行评分～" viewController:self];
        sender.enabled = YES;
    }else {
        if ([commentTextView.text isEqualToString:@"请点评一下我们吧～"]) {
            commentTextView.text = @"";
        }
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"orderID":self.orderID,
                               @"projectScore":serviceScoreStr,
                               @"skillScore":workerScoreStr,
                               @"remark":commentTextView.text,
                               @"tags":bedStr
                               };
        [[RequestManager shareRequestManager] CommentOrder:dic viewController:self successData:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                [[RequestManager shareRequestManager] tipAlert:@"评论成功" viewController:self];
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
    commentButton.enabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentOrderNtf" object:@{@"comment":@"finished"}];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//收起键盘
-(void) dismissKeyBoard{
    [commentTextView resignFirstResponder];
}
//点击空白处关闭键盘
//重写vc的touchesBegan方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 500) {
        [[RequestManager shareRequestManager] tipAlert:@"文字已达到最长限度" viewController:self];
        textView.text = [textView.text substringToIndex:500];
        number = 500;
        
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:@"请点评一下我们吧～"]) {
        textView.text = @"";
    }
    self.view.frame = CGRectMake(0, -100, kScreenWidth, kScreenHeight);
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
        textView.text = @"请点评一下我们吧～";
        textView.textColor = C7UIColorGray;
    }
}
#pragma mark - 懒加载
- (UIScrollView *)backScrollView {
    if (_backScrollView == nil) {
        self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        self.backScrollView.backgroundColor = C2UIColorGray;
        self.backScrollView.showsVerticalScrollIndicator = NO;
        self.backScrollView.showsHorizontalScrollIndicator = NO;;
    }
    return _backScrollView;
}
- (UIView *)scoreView {
    if (_scoreView == nil) {
        self.scoreView = [UIView new];
        self.scoreView.backgroundColor = [UIColor whiteColor];
    }
    return _scoreView;
}
- (UIView *)attitudeView {
    if (_attitudeView == nil) {
        self.attitudeView = [UIView new];
        self.attitudeView.backgroundColor = [UIColor whiteColor];
    }
    return _attitudeView;
}
- (UIView *)commentView {
    if (_commentView == nil) {
        self.commentView = [UIView new];
        self.commentView.backgroundColor = [UIColor whiteColor];
    }
    return _commentView;
}
@end
