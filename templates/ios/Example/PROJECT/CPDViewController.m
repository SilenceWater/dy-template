//
//  CPDViewController.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CPDViewController.h"
#import <SAKit/SAKit.h>
#import <Masonry/Masonry.h>
#import <SAModuleService/SAModuleService.h>

@interface CPDViewController ()<SAViewControllerConfigProtocol>

@end

@implementation CPDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"";
    NSArray *textArray = @[@"注销"];
    
    [textArray enumerateObjectsUsingBlock:^(NSString *text, NSUInteger index, BOOL * _Nonnull stop) {
        
        SAButton *button = [[SAButton alloc] initWithTitle:text buttonCornerStyle:SAButtonCornerStyleArc buttonTintStyle:SAButtonTintStyleFillC1 buttonHeightType:SAButtonHeightTypeH02];
        button.tag = 10 + index;
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(20 + index * 60);
        }];
        
        [button addTarget:self action:@selector(pressRecognizeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)pressRecognizeButtonAction:(SAButton *)button {
    switch (button.tag) {
        default:
        {
            //注销
            [[NSNotificationCenter defaultCenter] postNotificationName:SALoginModuleNeedLogoutNotification object:nil];
            UIViewController<SALoginServiceProtocol> *loginViewController = [SAServiceManager createServiceWithProtocol:@protocol(SALoginServiceProtocol)];
            self.view.window.rootViewController = [[SANavigationController alloc] initWithRootViewController:loginViewController];
        }
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
