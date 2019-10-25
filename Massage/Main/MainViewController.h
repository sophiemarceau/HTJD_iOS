//
//  MainViewController.h
//  Massage
//
//  Created by sophiemarceau_qu on 15/5/25.
//  Copyright (c) 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"
@interface MainViewController : UITabBarController<EAIntroDelegate>
{
   
}
@property (nonatomic,strong)UIImageView *tabbarView;

@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic) UIImageView *orderCountImg;

@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) NSMutableArray *imvArray;
@property (nonatomic, retain) NSMutableArray *labelArray;

- (void)selectorAction:(UIButton *)butt;

@end
