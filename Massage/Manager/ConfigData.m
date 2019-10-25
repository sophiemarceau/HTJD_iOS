//
//  ConfigData.m
//  Massage
//
//  Created by sophiemarceau_qu on 15/10/17.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "ConfigData.h"

@implementation ConfigData

+ (instancetype)sharedInstance
{
    static ConfigData *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[ConfigData alloc] init];
    });
    return instance;
}

- (BOOL)isFirstLaunch
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL lastRunVersion = [defaults boolForKey:LAST_RUN_VERSION_KEY];
    if (!lastRunVersion) {
        //为第一次登录
        [defaults setBool:YES forKey:LAST_RUN_VERSION_KEY];
        [defaults synchronize];
        return YES;
    }
    return NO;
}

@end
