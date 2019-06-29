//
//  CPDAppDelegate.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CPDAppDelegate.h"
#import "CPDViewController.h"

@implementation CPDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[SAAppConfig shareInstance] sa_setAppConfigOptions:SAAppConfigOptionNetwork | SAAppConfigOptionWechat targetType:SATargetTypeAppStore environmentType:SAEnvironmentTypeCIT];

    
    return YES;
}



#pragma mark-
#pragma mark- 配置应用主题
- (void)setupTheme {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
}

@end
