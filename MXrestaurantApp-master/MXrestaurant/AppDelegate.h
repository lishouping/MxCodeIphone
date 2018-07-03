//
//  AppDelegate.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/5.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *appKey = @"3564c52a453a86670ded3ad1";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)NSString *isfinish;

@end

