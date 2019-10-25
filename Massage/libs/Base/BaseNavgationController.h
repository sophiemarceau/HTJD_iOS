
//  YouYiLian
//
//  Created by DevNiudun on 15/3/19.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    TransitionLeft = 1,
    TransitionRight,
    TransitionTop,
    TransitionBottom
}TransitionDirection;

@interface BaseNavgationController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController direction:(TransitionDirection)direction;

@end
