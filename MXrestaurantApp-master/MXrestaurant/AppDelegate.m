//
//  AppDelegate.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/5.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "AppDelegate.h"
#import "OrderViewController.h"
#import "ServiceViewController.h"
#import "LoginViewController.h"
#import "MineViewController.h"
#import "TableinfoViewController.h"
#import "QRCodeingViewController.h"
#import "OrderDeatiledViewController.h"
#import "ServiceDetaliedViewController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<UITabBarControllerDelegate>{
    NSString *cTitle;
    NSString *pushidnum;
    NSString *type;
    NSArray * classViewControllerArray;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]] ;
    self.window.backgroundColor = [UIColor whiteColor];
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:@"loginState"
                                               object:nil];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = navc;
    
//    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
//
//    NSString *islogin =  [userDefaults objectForKey:@"islogin_CP"];
//    NSString *telephone =  [userDefaults objectForKey:@"telephone_CP"];
//    if ([islogin isEqualToString:@"true"]) {
//        [self createAppearance];
//        [self createWindowRootViewController];
//
//    }else{
//        LoginViewController *loginVC = [[LoginViewController alloc] init];
//        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        self.window.rootViewController = navc;
//    }
    self.isfinish = @"NO";
    [NSThread sleepForTimeInterval:2.0];
    [self.window makeKeyAndVisible];
    
    
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
    if (userInfo) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushnew" object:@YES];
        
        NSLog(@"推送消息==== %@",userInfo);
        NSString *dic = [userInfo objectForKey:@"iosNotification extras key"];
        
        NSArray *array = [dic componentsSeparatedByString:@","];
        
        cTitle = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        NSString *urlString = array[0];
        NSString *pushid = [urlString stringByReplacingOccurrencesOfString:@"}" withString:@""];
        NSArray *array2 = [pushid componentsSeparatedByString:@":"];
        pushidnum = array2[1];
        
        NSString *typeString = array[1];
        NSString *pushtype = [typeString stringByReplacingOccurrencesOfString:@"}" withString:@""];
        NSArray *array3 = [pushtype componentsSeparatedByString:@":"];
        type = array3[1];
        
        
        if ([type isEqualToString:@"1"]) {//订单
            OrderDeatiledViewController *VC = [OrderDeatiledViewController new];
            VC.order_num = pushidnum;
            VC.pageflag = @"0";
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([type isEqualToString:@"2"]){//服务
            ServiceDetaliedViewController *VC = [ServiceDetaliedViewController new];
            VC.service_id = pushidnum;
            VC.content = cTitle;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }
        
//        [self jumpViewController:nil];
    }
    
    return YES;
}


- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
        [self createAppearance];
        [self createWindowRootViewController];
    }
    else{//登陆失败加载登陆页面控制器
        NSLog(@"-------------%id",loginSuccess);
        
    }
    
}
//导航条的颜色以及tabBar的背景色 tabBarItem的title的颜色
-(void)createAppearance
{
    //状态栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0)
    {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
        //导航条标题的颜色
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        //tabBar的背景色
        [UITabBar appearance].barTintColor=[UIColor colorWithRed:252.0/255 green:252.0/255 blue:252.0/255 alpha:1];
        //tabBarItem的title的颜色
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:158.0/255 green:158.0/255 blue:158.0/255 alpha:1] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    }
    else
    {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:26.0/255 green:31.0/255 blue:44.0/255 alpha:1]];
        //导航条标题的颜色
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        //tabBar的背景色
        [UITabBar appearance].barTintColor=[UIColor colorWithRed:252.0/255 green:252.0/255 blue:252.0/255 alpha:1];
        //tabBarItem的title的颜色
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:158.0/255 green:158.0/255 blue:158.0/255 alpha:1] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    }
    
}


//创建TabBarController
-(void)createWindowRootViewController
{
    classViewControllerArray=@[@"TableinfoViewController",@"ServiceViewController",@"OrderViewController",@"MineViewController"];
    NSArray * titleArray=@[@"桌台",@"服务",@"订单",@"我的"];
    NSArray * itemSelectImageArray=@[@"tabbar1_cur",@"tabbar2_cur",@"tabbar4_cur",@"tabbar5_cur"];
    NSArray * itemNormalImageArray=@[@"tabbar1",@"tabbar2",@"tabbar4",@"tabbar5"];
    NSMutableArray * viewControllersArray=[NSMutableArray arrayWithCapacity:0];
    int i=0;
    for (NSString * vcName in classViewControllerArray)
    {
        
        Class ViewController=NSClassFromString(vcName);
        UIViewController * vc=(UIViewController *)[[ViewController alloc]init];
        vc.title=titleArray[i];
        UINavigationController * nvc=[[UINavigationController alloc]initWithRootViewController:vc];
        if ([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0) {
            nvc.tabBarItem.selectedImage = [[UIImage imageNamed:itemSelectImageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            nvc.tabBarItem.image = [[UIImage imageNamed:itemNormalImageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            //tabbar.tintColor = [UIColor whiteColor];
            //            if (i==0) {
            //                nvc.tabBarItem.badgeColor = [UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1];
            //                nvc.tabBarItem.badgeValue = @"12";
            //            }
            
        }else{
            
            [nvc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:itemSelectImageArray[i]] withFinishedUnselectedImage:[UIImage imageNamed:itemNormalImageArray[i]]];
        }

        i++;
        [viewControllersArray addObject:nvc];
        
        
    }
    UITabBarController * tbc=[[UITabBarController alloc]init];
    tbc.delegate = self;
    tbc.viewControllers=viewControllersArray;
    self.window.rootViewController=tbc;
    
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary*)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
     [[NSNotificationCenter defaultCenter] postNotificationName:@"pushnew" object:@YES];
    NSString *dic = [userInfo objectForKey:@"iosNotification extras key"];
    
    NSArray *array = [dic componentsSeparatedByString:@","];
    
    cTitle = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    NSString *urlString = array[0];
    NSString *pushid = [urlString stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSArray *array2 = [pushid componentsSeparatedByString:@":"];
    pushidnum = array2[1];
    
    NSString *typeString = array[1];
    NSString *pushtype = [typeString stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSArray *array3 = [pushtype componentsSeparatedByString:@":"];
    type = array3[1];
    
    [self loadUnreadInform];
    
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示!" message:[NSString stringWithFormat:@"%@",@"收到新消息是否查看"] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
    alert.delegate = self;
    [alert show];
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"pushnew" object:@YES];
     NSLog(@"iOS7及以上系统，收到通知:%@",userInfo);
    
    NSString *dic = [userInfo objectForKey:@"iosNotification extras key"];
 
    NSArray *array = [dic componentsSeparatedByString:@","];
    
    cTitle = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];

    NSString *urlString = array[0];
    NSString *pushid = [urlString stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSArray *array2 = [pushid componentsSeparatedByString:@":"];
    pushidnum = array2[1];
    
    NSString *typeString = array[1];
    NSString *pushtype = [typeString stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSArray *array3 = [pushtype componentsSeparatedByString:@":"];
    type = array3[1];
    
     [self loadUnreadInform];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示!" message:[NSString stringWithFormat:@"%@",@"收到新消息是否查看"] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
    alert.delegate = self;
    [alert show];
  
    
    JPushNotificationRequest *notf = [[JPushNotificationRequest alloc] init];
    
    [JPUSHService addNotification:notf];
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"查看"]) {
        if ([type isEqualToString:@"1"]) {//订单
            OrderDeatiledViewController *VC = [OrderDeatiledViewController new];
            VC.order_num = pushidnum;
            VC.pageflag = @"0";
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([type isEqualToString:@"2"]){//服务
            ServiceDetaliedViewController *VC = [ServiceDetaliedViewController new];
            VC.service_id = pushidnum;
            VC.content = cTitle;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }
    }
    
}
// 获取徽标上的数字 通知未读条数
-(void)loadUnreadInform{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,GETNOREADNUMBER];
    NSDictionary *parameters = @{@"shop_id": [userDefaults objectForKey:@"shop_id_MX"]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *key =[userDefaults objectForKey:@"login_key_MX"];
    NSString *longbusid = [[userDefaults objectForKey:@"business_id_MX"] stringValue];
    
    [manager.requestSerializer setValue:key forHTTPHeaderField:@"key"];
    [manager.requestSerializer setValue:longbusid forHTTPHeaderField:@"id"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager POST:postUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"结果: %@", responseObject);
        
        NSNumber *longNumber1 = [responseObject objectForKey:@"ORDER_COUNT"];
        NSString *ORDER_COUNT = [longNumber1 stringValue];
        
        NSNumber *longNumber2 = [responseObject objectForKey:@"SERVICE_COUNT"];
        NSString *SERVICE_COUNT = [longNumber2 stringValue];
        
     
        Class ViewController=NSClassFromString(@"ServiceViewController");
        UIViewController * vc=(UIViewController *)[[ViewController alloc]init];
        UINavigationController * nvc1=[[UINavigationController alloc]initWithRootViewController:vc];
        
        Class ViewController2=NSClassFromString(@"OrderViewController");
        UIViewController * vc2=(UIViewController *)[[ViewController2 alloc]init];
        UINavigationController * nvc2=[[UINavigationController alloc]initWithRootViewController:vc2];
        
        //设置taBbar角标
        UITabBarController *tabBarVC = (UITabBarController*)self.window.rootViewController;
        
        
        
        if ([SERVICE_COUNT isEqualToString:@"0"]) {
            UITabBarItem *item = [[[tabBarVC tabBar] items] objectAtIndex:1];
            item.badgeValue = nil;
        }else{
            UITabBarItem *item = [[[tabBarVC tabBar] items] objectAtIndex:1];
            item.badgeValue = [NSString stringWithFormat:@"%@",SERVICE_COUNT];
        }
        
        if ([ORDER_COUNT isEqualToString:@"0"]) {
            UITabBarItem *item = [[[tabBarVC tabBar] items] objectAtIndex:2];
            item.badgeValue = nil;
        }else{
            UITabBarItem *item = [[[tabBarVC tabBar] items] objectAtIndex:2];
            item.badgeValue=[NSString stringWithFormat:@"%@",ORDER_COUNT];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    
    
    return str;
}
@end
