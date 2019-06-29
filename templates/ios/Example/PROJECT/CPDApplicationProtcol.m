//
//  SAAppDelegate.m
//  StrongAnimal
//
//  Created by 詹学宝 on 2017/8/28.
//  Copyright © 2017年 浙江网仓科技有限公司. All rights reserved.
//

#import "CPDApplicationProtcol.h"
#import <UIKit/UIKit.h>
#import <SAModuleService/SAModuleService.h>
#import <SAModuleService/SAModuleAppDelegate.h>
#import <JPush/JPUSHService.h>

@interface CPDApplicationProtcol ()<SAModuleAppDelegate>

@end

@implementation CPDApplicationProtcol
+ (void)load{
    [[SAModuleManager sharedInstance] registerModule:[CPDApplicationProtcol class]];
}

+ (void)sa_applicationDidBecomeActive {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
}

+ (void)sa_applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"%s:%@",__FUNCTION__,userInfo);
}

+ (void)sa_applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"%s:%@",__FUNCTION__,userInfo);
}

+ (void)sa_userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:notification.request.content.userInfo];
    }
    NSLog(@"%s:%@",__FUNCTION__,notification.request.content.userInfo);
    completionHandler(UNNotificationPresentationOptionAlert);
}

+ (void)sa_userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"%s:%@",__FUNCTION__,response.notification.request.content.userInfo);
        [JPUSHService handleRemoteNotification:response.notification.request.content.userInfo];
    }
    completionHandler();
}
@end
