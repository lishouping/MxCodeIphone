//
//  MineViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/5.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "MineViewController.h"
#import "UserInfoTableViewCell.h"
#import "LoginViewController.h"
#import "SalesStatisticsViewController.h"
#import "ServiceStatisticsViewController.h"
#import "PushSettingViewController.h"
#import "PrintSettingViewController.h"
#import "ChangePassViewController.h"
#import "FeedBackViewController.h"
#import "AboutUsViewController.h"
#import "PayImageViewController.h"
#import "QRCodeingViewController.h"
#import "ManagerShopViewController.h"
#import "ManagerPrintViewController.h"
#import "ManagerEmployeeViewController.h"
#import "ManagerTableAreaViewController.h"
#import "ManagerTableViewController.h"
#import "ManagerDishClassViewController.h"
#import "ManagerDishViewController.h"
#import "ManagerDishAddViewController.h"
#import "StatisticalAnalysisViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UIView *headerView;
    UIImageView *userImage;
    UILabel *labUserName;
    UITableView *tableUser;
    NSUserDefaults * userDefaults;
    NSString *roalid;
    
    UIView *footView;
    
    MBProgressHUD *hud;
}
@property(nonatomic,strong)NSMutableArray *dateArray;
@property(nonatomic,strong)NSMutableArray *dateArray2;
@end

@implementation MineViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self loadUnreadInform];
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
}
- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    //进入前台时调用此函数
    [self loadUnreadInform];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
     self.navigationItem.title = [userDefaults objectForKey:@"shop_name"];
    NSNumber *longNumber = [userDefaults objectForKey:@"role_id_MX"];
    roalid = [longNumber stringValue];
    
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.dateArray2 = [[NSMutableArray alloc] initWithCapacity:0];
    [self createUI];
    [self createUITableView];
    tableUser.tableHeaderView = headerView;
    tableUser.tableFooterView = footView;
    [self createDate];
    // Do any additional setup after loading the view.
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:@"pushnew"
                                               object:nil];
}
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
        [self loadUnreadInform];
    }
    else{//登陆失败加载登陆页面控制器
        NSLog(@"-------------%id",loginSuccess);
        
    }
    
}

- (void)createUI{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 120)];
    [headerView setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
    
    userImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-30, 10, 60, 60)];
    [userImage setImage:[UIImage imageNamed:@"userheadview.png"]];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = userImage.bounds.size.width * 0.5;
    userImage.layer.borderWidth = 5.0;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [headerView addSubview:userImage];
    
    labUserName = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+60+10, kWidth-15-15, 25)];
    labUserName.textAlignment = UITextAlignmentCenter;
    [labUserName setTextColor:[UIColor whiteColor]];
    [headerView addSubview:labUserName];
    [labUserName setFont:[UIFont systemFontOfSize:14]];
    [labUserName setText:[userDefaults objectForKey:@"name_MX"]];

    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kHeight, 60)];
    
    
    UIButton *btnSingOut = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, kWidth-10-10, 30)];
    [btnSingOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [btnSingOut setBackgroundColor:[UIColor colorWithRed:221.0/255.0 green:107.0/255.0 blue:85.0/255.0 alpha:1]];
    [btnSingOut setFont:[UIFont systemFontOfSize:14]];
    [btnSingOut addTarget:self action:@selector(signOutClick) forControlEvents:UIControlEventTouchUpInside];
    [btnSingOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:btnSingOut];
    [self createRightBtn];
}

- (void)createRightBtn{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"payimg"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        UIBarButtonItem * negativeSpacer=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width=-15;
        self.navigationItem.rightBarButtonItems=@[negativeSpacer,rightBtnItem];
    }
    else
    {
        self.navigationItem.rightBarButtonItem=rightBtnItem;
    }
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"qrbtn"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        
        UIBarButtonItem * negativeSpacer=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width=-15;
        self.navigationItem.leftBarButtonItems=@[negativeSpacer,leftBarButtonItem];
    }
    else
    {
        self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    }
}

-(void)leftButtonClick{
    QRCodeingViewController *qvc = [[QRCodeingViewController alloc] init];
    [self.navigationController pushViewController:qvc animated:YES];
}
-(void)rightBtnButtonClick{
    PayImageViewController *pivc = [[PayImageViewController alloc] init];
    [self.navigationController pushViewController:pivc animated:YES];
}
- (void)signOutClick{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出登录吗?" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:lvc animated:YES];
        [userDefaults setObject:@"" forKey:@"userName_MX"];
        [userDefaults setObject:@"" forKey:@"passWord_MX"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"---");
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
- (void)createUITableView{
    tableUser = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    tableUser.delegate = self;
    tableUser.dataSource = self;
    [self.view addSubview:tableUser];
    [tableUser reloadData];

}
- (void)createDate{
    if ([roalid isEqualToString:@"2"]) {
        NSArray *array1 = @[@"密码修改",@"意见反馈",@"关于我们"];
        NSArray *arrayimg1 = @[@"icon_my4",@"icon_my6",@"icon_my7"];
        [self.dateArray addObjectsFromArray:array1];
         [self.dateArray2 addObjectsFromArray:arrayimg1];
    }else{
        NSArray *array = @[@"统计分析",@"系统设置",@"密码修改",@"意见反馈",@"关于我们",@"会员查询"];
        NSArray *arrayimg = @[@"ic_new_1",@"ic_new_15",@"ic_new_16",@"ic_new_13",@"ic_new_17",@"ic_new_10",@"ic_new_11"];
        [self.dateArray addObjectsFromArray:array];
        [self.dateArray2 addObjectsFromArray:arrayimg];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 40.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoTableViewCell  *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc1"];
    if (tabcell==nil) {
        tabcell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc1"];
        tabcell.selectionStyle = UITableViewCellStyleDefault;
    }
    NSString *array = self.dateArray[indexPath.section];
    tabcell.labtitle.text = array;
    [tabcell.imginfo setImage:[UIImage imageNamed:self.dateArray2[indexPath.section]]];
    return tabcell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 15;
    }else{
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]init];
    
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
   return headerView;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *content = self.dateArray[indexPath.section];
    if ([content isEqualToString:@"统计分析"]) {
        StatisticalAnalysisViewController *atvs = [[StatisticalAnalysisViewController alloc] init];
        atvs.myType = @"1";
        [self.navigationController pushViewController:atvs animated:YES];
    }else if ([content isEqualToString:@"系统设置"]){
        StatisticalAnalysisViewController *atvs = [[StatisticalAnalysisViewController alloc] init];
        atvs.myType = @"2";
        [self.navigationController pushViewController:atvs animated:YES];
    }else if ([content isEqualToString:@"密码修改"]){
        ChangePassViewController *atvs = [[ChangePassViewController alloc] init];
        [self.navigationController pushViewController:atvs animated:YES];
    }else if ([content isEqualToString:@"意见反馈"]){
        FeedBackViewController *atvs = [[FeedBackViewController alloc] init];
        [self.navigationController pushViewController:atvs animated:YES];
    }else if ([content isEqualToString:@"关于我们"]){
        AboutUsViewController *atvs = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:atvs animated:YES];
    }else if([content isEqualToString:@"会员查询"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"会员查询" message:nil preferredStyle:  UIAlertControllerStyleAlert];
        //在AlertView中添加一个输入框
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入会员手机号";
        }];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf = alert.textFields.firstObject;
            
            [self searchMember:tf.text];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
}
// 获取徽标上的数字 通知未读条数
-(void)loadUnreadInform{
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
        
        
        if ([SERVICE_COUNT isEqualToString:@"0"]) {
            UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
            item.badgeValue = nil;
        }else{
            UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
            item.badgeValue=[NSString stringWithFormat:@"%@",SERVICE_COUNT];
        }
        
        if ([ORDER_COUNT isEqualToString:@"0"]) {
            UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
            item.badgeValue = nil;
        }else{
            UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
            item.badgeValue=[NSString stringWithFormat:@"%@",ORDER_COUNT];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
    
}

// 查询是否是会员
-(void)searchMember:(NSString *)phone{
    //开始显示HUD
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL_MEMBER,FINDONEBYPHONE];
    NSDictionary *parameters = @{@"shopId": [userDefaults objectForKey:@"menmbers_shop_id"],@"userPhone":phone};
    
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
        
        NSString *code = [responseObject objectForKey:@"code"];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([code isEqualToString:@"1"]) {
            hud.labelText = msg;
            [hud hide:YES afterDelay:0.5];
        }else{
            hud.labelText = msg;
            [hud hide:YES afterDelay:0.5];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.labelText = @"网络连接异常";
        [hud hide:YES afterDelay:0.5];
        NSLog(@"Error: ==============%@", error);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
