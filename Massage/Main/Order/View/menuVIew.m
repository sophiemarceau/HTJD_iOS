//
//  menuVIew.m
//  Massage
//
//  Created by 牛先 on 15/10/31.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "menuVIew.h"

@interface menuVIew (){
    CGFloat buttonWidth;
}
@property (strong, nonatomic) UIView *selectedView;
@end

@implementation menuVIew

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(void)setIsNotification:(BOOL)isNotification{
    if (isNotification) {
        [self reciveNotification];
    }
}

-(void)reciveNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"serviceBackAction" object:nil];
}

-(void)notification:(NSDictionary *)dict{
    NSDictionary *dic = [dict valueForKey:@"userInfo"];
    NSString *keyTag = [NSString stringWithFormat:@"%@",dic[@"serviceBackActionKey"]];
    NSInteger tag = [keyTag integerValue];
//    NSLog(@"%ld",tag);
    NSLog(@"==========================%@============接收通知=======",dict);
    // 2
    
    for (UIButton *button in self.subviews) {
        if (button.tag == tag) {
            [self tapped:button];
        }
    }
    
}

- (void)setMenuArray:(NSArray *)menuArray {
    buttonWidth = kScreenWidth/menuArray.count;
    CGFloat buttonHeight = 32;
    for (int i = 0 ; i < menuArray.count; i++) {
        UIButton *menuButton = [[UIButton alloc]initWithFrame:CGRectMake(0+i*buttonWidth, 0, buttonWidth, buttonHeight)];
        [menuButton setTitle:[NSString stringWithFormat:@"%@",menuArray[i]] forState:UIControlStateNormal];
        [menuButton setTitleColor:BlackUIColorC5 forState:UIControlStateNormal];
        menuButton.titleLabel.font = [UIFont systemFontOfSize:13];
        menuButton.tag = i+1;
        [menuButton addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        menuButton.backgroundColor = [UIColor whiteColor];
        [menuButton setTitleColor:RedUIColorC1 forState:UIControlStateSelected];
        
        [self.buttonArray addObject:menuButton];
        
        if (menuButton.tag == 1) {
            menuButton.selected = YES;
            self.selectedButton = menuButton;
            
            //计算文字宽度
            CGSize size = [menuButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
            _selectedView = [[UIView alloc] init];
            _selectedView.frame = CGRectMake(buttonWidth/2-ceilf(size.width)/2, 32, ceilf(size.width), 3);
            _selectedView.backgroundColor = RedUIColorC1;
            [self addSubview:_selectedView];
        }
        [self addSubview:menuButton];
    }
}
- (void)tapped:(UIButton *)sender {

    
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    

    //计算文字宽度
    CGSize size = [self.selectedButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [UIView animateWithDuration:0.1 animations:^{
        self.selectedView.frame = CGRectMake((sender.tag-1) *buttonWidth+buttonWidth/2-ceilf(size.width)/2, 32, ceilf(size.width), 3);
    }];
    
    if ([self.delegate respondsToSelector:@selector(menuViewDidSelect:)]) {
        [self.delegate menuViewDidSelect:sender.tag];
    }
//    // 发送通知到viewController
//    NSString *str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:str forKey:@"menuView"];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"menuViewKey" object:nil userInfo:dic];
    
}
@end
