//
//  ServiceViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/5.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "ServiceViewController.h"
#import "ServiceModel.h"
#import "HasServiceTableViewCell.h"
#import "NoServiceTableViewCell.h"
#import "ServiceDetaliedViewController.h"
#import "PayImageViewController.h"
#import "QRCodeingViewController.h"

@interface ServiceViewController ()<UITableViewDelegate,UITableViewDataSource,LMJTabDelegate>{
    UITableView *tableService;
    NSUserDefaults * userDefaults;
     MBProgressHUD *hud;
    int page;
    int totalnum;
    NSString *selectBtnFlag;
      UIView *nodateView;
}
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation ServiceViewController
- (void)viewWillAppear:(BOOL)animated
{
    if (self.dateArray.count>0) {
        [self.dateArray removeAllObjects];
        [tableService reloadData];
        [self getDate:selectBtnFlag];
    }else{
       [self setupTableView];
    }
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
    self.navigationItem.title = @"聚巷客栈";

    userDefaults=[NSUserDefaults standardUserDefaults];
    
     self.navigationItem.title = [userDefaults objectForKey:@"shop_name"];
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self makeUI];
    selectBtnFlag = @"0";
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
- (void)makeUI{
    LMJTab * tab = [[LMJTab alloc] initWithFrame:CGRectMake(10, 10+44+20, kWidth-10-10, 30) lineWidth:1 lineColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1]];
    [tab setItemsWithTitle:[NSArray arrayWithObjects:@"未处理",@"已处理", nil] normalItemColor:[UIColor whiteColor] selectItemColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1] normalTitleColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1] selectTitleColor:[UIColor whiteColor] titleTextSize:12 selectItemNumber:0];
    tab.delegate = self;
    tab.layer.cornerRadius = 5.0;
    [self.view addSubview:tab];
    
    tableService = [[UITableView alloc] initWithFrame:CGRectMake(0, 10+44+20+30+10, kWidth, kHeight-44-20-20-10) style:UITableViewStylePlain];
    tableService.delegate = self;
    tableService.dataSource = self;
    [self.view addSubview:tableService];
    tableService.tableFooterView = [[UIView alloc] init];
    [self createRightBtn];
    
    nodateView = [[UIView alloc] initWithFrame:CGRectMake(0,10+44+20+30+10, kWidth, kHeight-44-20-20-10)];
    [nodateView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgNodate = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-(196/2), 80, 196, 128)];
    [imgNodate setImage:[UIImage imageNamed:@"common_nodata"]];
    [nodateView addSubview:imgNodate];
    [self.view addSubview:nodateView];
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

-(void)tab:(LMJTab *)tab didSelectedItemNumber:(NSInteger)number{
    NSLog(@"CLICKED:%ld",number);
    if (number==0) {
        
        selectBtnFlag = @"0";
        [self.dateArray removeAllObjects];
        [tableService reloadData];
       [self setupTableView];
    }else if (number==1){
        [self.dateArray removeAllObjects];
        selectBtnFlag = @"1";
        [tableService reloadData];
        [self setupTableView];
      
    }
}

//加上刷新控件
-(void)setupTableView
{
    //下拉刷新
    [tableService addHeaderWithTarget:self action:@selector(headerRereshing)];
    //上拉加载
    [tableService addFooterWithTarget:self action:@selector(footerRereshing)];
    [tableService headerBeginRefreshing];
}


//下拉
- (void)headerRereshing
{
    page=1;
    [self.dateArray removeAllObjects];
    [self getDate:selectBtnFlag];
}
//上拉
-(void)footerRereshing
{
    page++;
    [self getDate:selectBtnFlag];
}
- (void)getDate:(NSString *)servicestate{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,SELECTSERVICELIST];
    NSDictionary *parameters = @{@"waiter_id":[userDefaults objectForKey:@"business_id_MX"],
                                 @"page_no":[NSString stringWithFormat:@"%d",page],
                                 @"shop_id": [userDefaults objectForKey:@"shop_id_MX"],
                                 @"status":servicestate
                                 };
    
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
        if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
            totalnum = [[responseObject objectForKey:@"totalnum"] intValue];
            NSArray *dateArray = [responseObject objectForKey:@"DATA"];
            if (dateArray.count==0) {
                [tableService footerEndRefreshing];
                [tableService headerEndRefreshing];
                nodateView.hidden = NO;
                tableService.hidden = YES;
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"无更多数据" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                [alert show];
                return ;
            }
            for (NSDictionary * dic in dateArray)
            {
                NSNumber *longNumber1 = [dic objectForKey:@"service_id"];
                NSString *service_id = [longNumber1 stringValue];
                NSString *service_content = [dic objectForKey:@"service_content"];
                NSNumber *longNumber = [dic objectForKey:@"status"];
                NSString *status = [longNumber stringValue];
                NSString *create_time = [dic objectForKey:@"create_time"];
                
                NSString *receive_time = @"";
                NSDictionary *waiterobj;
                NSString *name = @"";
                
                if ([servicestate isEqualToString:@"1"]) {
                    receive_time = [dic objectForKey:@"receive_time"];
                    waiterobj = [dic objectForKey:@"waiter"];
                    name = [waiterobj objectForKey:@"name"];
                }
                NSDictionary *tableobj = [dic objectForKey:@"table"];
                NSString *table_name = [tableobj objectForKey:@"table_name"];
                
                
                if ([servicestate isEqualToString:status]) {
                    ServiceModel *servimodl = [[ServiceModel alloc] init];
                    servimodl.service_id = service_id;
                    servimodl.service_content = service_content;
                    servimodl.status = status;
                    servimodl.create_time = create_time;
                    servimodl.receive_time = receive_time;
                    servimodl.table_name = table_name;
                    servimodl.name = name;
                    [self.dateArray addObject:servimodl];
                }
                
                
            }
            nodateView.hidden = YES;
            tableService.hidden = NO;
            [tableService headerEndRefreshing];
            [tableService reloadData];
        }
        
        else
        {
            nodateView.hidden = NO;
            tableService.hidden = YES;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"MESSAGE"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alert show];
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectBtnFlag isEqualToString:@"0"]) {
        return 90.0;
    }else{
        return 110.0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectBtnFlag isEqualToString:@"0"]) {
       HasServiceTableViewCell  *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc1"];
        if (tabcell==nil) {
            tabcell = [[HasServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc1"];
            tabcell.selectionStyle = UITableViewCellStyleDefault;
        }
        ServiceModel *svm = self.dateArray[indexPath.section];
        tabcell.labTableNumber.text = [NSString stringWithFormat:@"桌号:%@",svm.table_name];
        tabcell.labSendServiceTime.text = [NSString stringWithFormat:@"创建时间:%@",[self timeWithTimeIntervalString:svm.create_time]] ;
        tabcell.labServiceContent.text = [NSString stringWithFormat:@"%@",svm.service_content];
        tabcell.labServiceContent.numberOfLines = 2;
        if ([svm.status isEqualToString:@"0"]) {
            tabcell.labServiceState.text = @"状态:未处理";
        }else if ([svm.status isEqualToString:@"1"]){
            tabcell.labServiceState.text = @"状态:已处理";
        }else if ([svm.status isEqualToString:@"2"]){
            tabcell.labServiceState.text = @"状态:已取消";
        }
        tabcell.tag = indexPath.section;
        tabcell.btnServiceHander.tag = indexPath.section;
        [tabcell.btnServiceHander addTarget:self action:@selector(serviceTodo:) forControlEvents:UIControlEventTouchUpInside];
        
        return tabcell;
    }else{
        NoServiceTableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
        if (tabcell==nil) {
            tabcell = [[NoServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
            tabcell.selectionStyle = UITableViewCellStyleDefault;
        }
        ServiceModel *svm = self.dateArray[indexPath.section];
        tabcell.labTableNumber.text = [NSString stringWithFormat:@"桌号:%@",svm.table_name];
        tabcell.labCreateTime.text = [NSString stringWithFormat:@"创建时间:%@",[self timeWithTimeIntervalString:svm.create_time]] ;
        tabcell.labServiceTime.text = [NSString stringWithFormat:@"服务时间:%@",[self timeWithTimeIntervalString:svm.receive_time]] ;
        tabcell.labServiceContent.text = [NSString stringWithFormat:@"%@",svm.service_content];
        tabcell.labServiceContent.numberOfLines = 2;
        tabcell.labServicePerson.text = [NSString stringWithFormat:@"服务人:%@",svm.name];
//        if ([svm.status isEqualToString:@"0"]) {
//            tabcell.labServiceState.text = @"状态:未处理";
//        }else if ([svm.status isEqualToString:@"1"]){
//            tabcell.labServiceState.text = @"状态:已处理";
//        }else if ([svm.status isEqualToString:@"2"]){
//            tabcell.labServiceState.text = @"状态:已取消";
//        }
        return tabcell;
    }
}
-(void)serviceTodo:(UIButton *)btn{
    ServiceModel *svm = self.dateArray[btn.tag];
    NSString *service_id = svm.service_id;
    [self alertView:service_id];;
    
}
-(void)alertView:(NSString *)serviceid{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要处理服务吗?" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //开始显示HUD
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"处理中...";
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];

        
        
        //点击按钮的响应事件；
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,TODOSERVICE];
        NSDictionary *parameters = @{@"waiter_id":[userDefaults objectForKey:@"business_id_MX"],
                                     @"service_id":serviceid,
                                     @"status":@"1"
                                     };
        
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
            if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
                [self.dateArray removeAllObjects];
                [tableService reloadData];
                [self getDate:selectBtnFlag];
                hud.labelText = @"处理成功";
                [hud hide:YES afterDelay:0.5];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"MESSAGE"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                [alert show];
                
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: ==============%@", error);
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"---");
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([selectBtnFlag isEqualToString:@"0"]) {
//        ServiceDetaliedViewController *serde = [[ServiceDetaliedViewController alloc] init];
//        ServiceModel *svm = self.dateArray[indexPath.section];
//        serde.service_id = svm.service_id;
//        serde.content = svm.service_content;
//        serde.table_name = svm.table_name;
//        serde.serviceTime = [self timeWithTimeIntervalString:svm.create_time];
//        [self.navigationController pushViewController:serde animated:YES];
//    }
//}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
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
