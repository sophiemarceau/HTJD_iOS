//
//  ConfigData.h
//  Massage
//
//  Created by sophiemarceau_qu on 15/10/17.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigData : NSObject


+ (instancetype)sharedInstance;

/**
 是否第一次启动
 */
- (BOOL)isFirstLaunch;
@end
