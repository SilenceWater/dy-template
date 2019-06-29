//
//  CPDAppDelegate.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CPDAppDelegate.h"
#import "CPDViewController.h"
#import <SAFoundation/NSString+SAExtend.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <SAKit/UIViewController+SANavController.h>
#import <SAConfig/SAConfig.h>
#import <SAModuleService/SAModuleService.h>
#import <JPush/JPUSHService.h>
#import <SATouchIDManager/SATouchIDManager.h>
#import <SAKit/SAViewControllerIntercepter.h>

#import <SAGlobal/SAUserObject.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation CPDAppDelegate

- (NSString *)rsaPublicKey{
    return @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDOTJ/mAHAoicU5zfrdHOwltud31eiuW6FS11hvoaeOPtJDtWHMzPANOSbk4UlqojeisbCYw6cLD19Tx3NNfKOt13mtBtuyDNnP7sCcPtLBB8Q8cRgf6AKYg4WN2WNvKuijRbNrLlLhb23fk4WgVNg0xdmZmO+wFMJbU0x+JCankQIDAQAB";
}

//极光推送AppKey
- (NSString *)sa_jpushAppKey {
    // 测试的appkey:9e3302a977e43cf1f0e9b809
    //    return @"9e3302a977e43cf1f0e9b809";
    switch ([SAAppConfig shareInstance].sa_targetType) {
        case SATargetTypeAppStore:
        {
            return @"8a3d910b13be8bfbd9a0cf23";
        }
            break;
        case SATargetTypeEnterprise:
        {
            return @"7eaed6ccd1a84f5620fbae06";
        }
            break;
        case SATargetTypeVores:
        {
            return @"";
        }
            break;
        default:
            return nil;
            break;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //     Override point for customization after application launch.
    //配置 IQKeyboardManager
    [self setupTheme];
    
    //配置 controller delloc 打印
    [SAViewControllerIntercepter enableVCDeallocLog];
    
    //配置网络请求、微信、请求环境

    NSLog(@"网络环境：CIT");
    [[SAAppConfig shareInstance] sa_setAppConfigOptions:SAAppConfigOptionNetwork | SAAppConfigOptionWechat targetType:SATargetTypeAppStore environmentType:SAEnvironmentTypeCIT];

  
    //    初始化JPush
    //    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:nil];
    [JPUSHService setupWithOption:launchOptions
                           appKey:[self sa_jpushAppKey]
                          channel:nil
                 apsForProduction:NO];
    NSLog(@"%@",[self sa_jpushAppKey]);
    //  公司 的 appkey: 8a3d910b13be8bfbd9a0cf23,设备类型i 企业的:7eaed6ccd1a84f5620fbae06,iq  [self sa_jpushAppKey]
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        UIViewController<SALoginServiceProtocol> *loginViewController = [SAServiceManager createServiceWithProtocol:@protocol(SALoginServiceProtocol)];
        [loginViewController setSa_pushId:registrationID];
    }];
    
    application.applicationIconBadgeNumber = 0;
    CGFloat currentDeviceVersionFloat = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (currentDeviceVersionFloat >= 10.0) {
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"Notification center Open success");
            } else {
                NSLog(@"Notification center Open failed");
            }
        }];
    } else if (currentDeviceVersionFloat >= 8.0) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert |
                                                                                                    UIUserNotificationTypeSound |
                                                                                                    UIUserNotificationTypeBadge)
                                                                                        categories:nil]];
    }
    
    //    //开启指纹验证
    //    if ([SATouchIDManager isTouchIDAvailable]) {
    //        [SATouchIDManager isTouchIDShouldLoad:^(BOOL shouldLoad) {
    //            if (shouldLoad) {
    //                [SATouchIDManager sharedInstance].isOpened = YES;
    //            }
    //        }];
    //    }
    
    //配置加密
    [[self rsaPublicKey] writePublicKey];
    
    //设置 rootViewController
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    UIViewController<SALoginServiceProtocol> *loginViewController = [SAServiceManager createServiceWithProtocol:@protocol(SALoginServiceProtocol)];
    //登陆成功回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidLoginNotification) name:SALoginModuleLoginDidSucceedNotification object:nil];
    if ([SAUserObject sa_isUserLogin]) {
        
//        id <SAHomeProtocol>homeObject = [SAServiceManager createServiceWithProtocol:@protocol(SAHomeProtocol)];
//        self.window.rootViewController = [homeObject setupHomeViewController];
        
        self.window.rootViewController = [[SANavigationController alloc] initWithRootViewController:[[CPDViewController alloc] init]];
    }else {
        self.window.rootViewController = [[SANavigationController alloc] initWithRootViewController:loginViewController];
    }
    [[SAModuleManager sharedInstance] trigger_applicationDidFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)appDidLoginNotification {
    
//    id <SAHomeProtocol>homeObject = [SAServiceManager createServiceWithProtocol:@protocol(SAHomeProtocol)];
//    UIViewController *rootViewController = [homeObject setupHomeViewController];
    
    SANavigationController *homeNav = [[SANavigationController alloc] initWithRootViewController:[CPDViewController new]];
    
    [UIView transitionFromView:self.window.rootViewController.view toView:homeNav.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        self.window.rootViewController = homeNav;
    }];
}

// 注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //注册deviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark-
#pragma mark- 配置应用主题
- (void)setupTheme {
    //键盘弹出，自适应
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
}

@end
