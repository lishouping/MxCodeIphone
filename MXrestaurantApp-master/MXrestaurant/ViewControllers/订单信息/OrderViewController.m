//
//  OrderViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/5.
//  Copyright © 2017年 lishouping. All rights reserved.
//
#import "OrderViewController.h"
#import "OrderModel.h"
#import "OrderDealWithTableViewCell.h"
#import "OrderHavingDinnerTableViewCell.h"
#import "OrderEndTableViewCell.h"
#import "OrderDeatiledViewController.h"
#import "FoodCustomViewController.h"
#import "PayImageViewController.h"
#import "QRCodeingViewController.h"

@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource,LMJTabDelegate,UIActionSheetDelegate>
{
    UITableView *tableService;
    NSUserDefaults * userDefaults;
    MBProgressHUD *hud;
    int page;
    int totalnum;
    NSString *selectBtnFlag;
    
    NSString *check_way;
    NSString *order_ids;
    NSString *myTotalPrice;
    UIView *nodateView;
}
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation OrderViewController
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
    userDefaults=[NSUserDefaults standardUserDefaults];
    
     self.navigationItem.title = [userDefaults objectForKey:@"shop_name"];
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self makeUI];
    selectBtnFlag = @"-1";
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
    LMJTab * tab = [[LMJTab alloc] initWithFrame:CGRectMake(10, NavBarHeight+10, kWidth-10-10, 30) lineWidth:1 lineColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1]];
    [tab setItemsWithTitle:[NSArray arrayWithObjects:@"未处理",@"正在用餐", @"已完成",nil] normalItemColor:[UIColor whiteColor] selectItemColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1] normalTitleColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1] selectTitleColor:[UIColor whiteColor]  titleTextSize:12 selectItemNumber:0];
    tab.delegate = self;
    tab.layer.cornerRadius = 5.0;
    [self.view addSubview:tab];
    
    tableService = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarHeight+10+30+10, kWidth, kHeight-TabBarHeight-30-10-10-10) style:UITableViewStylePlain];
    tableService.delegate = self;
    tableService.dataSource = self;
    [self.view addSubview:tableService];
    tableService.tableFooterView = [[UIView alloc] init];
    [self createRightBtn];
    
    nodateView = [[UIView alloc] initWithFrame:CGRectMake(0, NavBarHeight+10+30+10, kWidth, kHeight-TabBarHeight-30-10-10-10)];
    [nodateView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgNodate = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-(196/2/2), 80, 196/2, 128/2)];
    [imgNodate setImage:[UIImage imageNamed:@"common_nodata"]];
    [nodateView addSubview:imgNodate];
    
    UILabel *labNodata = [[UILabel alloc] initWithFrame:CGRectMake(0, 80+(128/2)+20, kWidth, 20)];
    [labNodata setText:@"暂无数据"];
    labNodata.textAlignment = NSTextAlignmentCenter;
    [labNodata setFont:[UIFont systemFontOfSize:12]];
    [nodateView addSubview:labNodata];
    
    [self.view addSubview:nodateView];
    
}

- (void)viewSafeAreaInsetsDidChange{
    VIEWSAFEAREAINSETS(tableService).right;
    [super viewSafeAreaInsetsDidChange];
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
        selectBtnFlag = @"-1";
        [self.dateArray removeAllObjects];
        //[tableService reloadData];
        [tableService headerBeginRefreshing];
    }else if (number==1){
        [self.dateArray removeAllObjects];
        //[tableService reloadData];
        selectBtnFlag = @"0";
        [tableService headerBeginRefreshing];
    }else if (number==2){
        [self.dateArray removeAllObjects];
        //[tableService reloadData];
        selectBtnFlag = @"1";
        [tableService headerBeginRefreshing];
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
    [self.dateArray removeAllObjects];
    [tableService reloadData];
    page=1;
    [self getDate:selectBtnFlag];
}
//上拉
-(void)footerRereshing
{
    page++;
    [self getDate:selectBtnFlag];
}
- (void)getDate:(NSString *)servicestate{
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,ORDERLISTFORWRITER];
    NSDictionary *parameters;
    if ([servicestate isEqualToString:@"0"]) {
        parameters = @{@"waiter_id":[userDefaults objectForKey:@"business_id_MX"],
                       @"page_no":[NSString stringWithFormat:@"%d",page],
                       @"shop_id": [userDefaults objectForKey:@"shop_id_MX"],
                       @"status":servicestate
                                     };
    }else if([servicestate isEqualToString:@"1"]){
        parameters = @{@"waiter_id":[userDefaults objectForKey:@"business_id_MX"],
                       @"page_no":[NSString stringWithFormat:@"%d",page],
                       @"shop_id": [userDefaults objectForKey:@"shop_id_MX"],
                       @"status":servicestate
                       };
    }else if ([servicestate isEqualToString:@"-1"]){
        parameters = @{@"status":servicestate,
                       @"page_no":[NSString stringWithFormat:@"%d",page],
                       @"shop_id": [userDefaults objectForKey:@"shop_id_MX"]
                       };
    }
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
            NSArray *dateArray = [responseObject objectForKey:@"DATA"];
            if (dateArray.count==0) {
                
                
                if (page==1) {
                    nodateView.hidden = NO;
                    tableService.hidden = YES;
                }else{
                    nodateView.hidden = YES;
                    tableService.hidden = NO;
                }
                
                [tableService footerEndRefreshing];
                [tableService headerEndRefreshing];
                 [tableService reloadData];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"无更多数据" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                [alert show];
                return ;
            }
            for (NSDictionary * dic in dateArray)
            {
                NSNumber *longNumber = [dic objectForKey:@"status"];
                NSString *status = [longNumber stringValue];
                if ([status isEqualToString:servicestate]) {
                    NSString *order_id = [dic objectForKey:@"order_id"];
                    NSString *order_num = [dic objectForKey:@"order_num"];
                    NSString *table_id = [dic objectForKey:@"table_id"];
                    NSNumber *payment = [dic objectForKey:@"payment"];
                    NSString *order_time;
                    if ([selectBtnFlag isEqualToString:@"-1"]) {
                        order_time = [dic objectForKey:@"create_time"];
                    }else{
                        order_time = [dic objectForKey:@"order_time"];
                    }
                    NSDictionary *tableobj = [dic objectForKey:@"table"];
                   
                    NSDictionary *writerobj;
                    NSString *name;
                    if ([selectBtnFlag isEqualToString:@"-1"]) {
                        
                    }else{
                        writerobj = [dic objectForKey:@"waiter"];
                        if ([writerobj isEqual:[NSNull null]]) {
                            name = @"";
                        }else{
                            name = [writerobj objectForKey:@"name"];
                        }
                    }
                    NSString *table_name = [tableobj objectForKey:@"table_name"];
                    NSString *people_count = [dic objectForKey:@"people_count"];
                    OrderModel *model = [[OrderModel alloc] init];
                    model.table_id = table_id;
                    model.order_id = order_id;
                    model.order_num = order_num;
                    model.order_time = order_time;
                    model.status = status;
                    model.table_name = table_name;
                    model.people_count = people_count;
                    model.payment = [payment stringValue];
                    if ([selectBtnFlag isEqualToString:@"-1"]) {
                        model.name = @"";
                    }else{
                        model.name = name;
                    }
                    [self.dateArray addObject:model];
                    nodateView.hidden = YES;
                    tableService.hidden = NO;
                    
                }
            }
            [tableService headerEndRefreshing];
            [tableService footerEndRefreshing];

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
    if ([selectBtnFlag isEqualToString:@"-1"]) {
        return 120.0;
    }else if([selectBtnFlag isEqualToString:@"0"]){
        return 120.0;
    }else{
        return 120.0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectBtnFlag isEqualToString:@"-1"]) {
        OrderDealWithTableViewCell  *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc1"];
        if (tabcell==nil) {
            tabcell = [[OrderDealWithTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc1"];
            tabcell.selectionStyle = UITableViewCellStyleDefault;
        }
        OrderModel *svm = self.dateArray[indexPath.section];
        tabcell.labServiceNumber.text = [NSString stringWithFormat:@"订单编号:%@",svm.order_num];
        tabcell.labTableName.text = [NSString stringWithFormat:@"桌号:%@",svm.table_name] ;
        tabcell.labEatchNumber.text = [NSString stringWithFormat:@"用餐人数:%@",svm.people_count];
        tabcell.labOrderTime.text = [NSString stringWithFormat:@"创建时间:%@",[self timeWithTimeIntervalString:svm.order_time]];
        tabcell.btnSubOrder.tag = indexPath.section;
        [tabcell.btnSubOrder addTarget:self action:@selector(submitOrderClick:) forControlEvents:UIControlEventTouchUpInside];
        return tabcell;
    }else if ([selectBtnFlag isEqualToString:@"0"]){
        OrderHavingDinnerTableViewCell  *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc2"];
        if (tabcell==nil) {
            tabcell = [[OrderHavingDinnerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc2"];
            tabcell.selectionStyle = UITableViewCellStyleDefault;
        }
        OrderModel *svm = self.dateArray[indexPath.section];
        tabcell.labServiceNumber.text = [NSString stringWithFormat:@"订单编号:%@",svm.order_num];
        tabcell.labTableName.text = [NSString stringWithFormat:@"桌号:%@",svm.table_name] ;
        tabcell.labEatchNumber.text = [NSString stringWithFormat:@"用餐人数:%@",svm.people_count];
        tabcell.labOrderTime.text = [NSString stringWithFormat:@"创建时间:%@",[self timeWithTimeIntervalString:svm.order_time]];
        tabcell.labWriter.text = [NSString stringWithFormat:@"服务人员:%@",svm.name];
        
        tabcell.btnAddFood.tag = indexPath.section;
        [tabcell.btnAddFood addTarget:self action:@selector(addFoodClick:) forControlEvents:UIControlEventTouchUpInside];
        
        tabcell.btnSubOrder.tag = indexPath.section;
        [tabcell.btnSubOrder addTarget:self action:@selector(checkOrderClick:) forControlEvents:UIControlEventTouchUpInside];
        return tabcell;
    }else{
        OrderEndTableViewCell  *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc3"];
        if (tabcell==nil) {
            tabcell = [[OrderEndTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc3"];
            tabcell.selectionStyle = UITableViewCellStyleDefault;
        }
        OrderModel *svm = self.dateArray[indexPath.section];
        tabcell.labServiceNumber.text = [NSString stringWithFormat:@"订单编号:%@",svm.order_num];
        tabcell.labTableName.text = [NSString stringWithFormat:@"桌号:%@",svm.table_name] ;
        tabcell.labEatchNumber.text = [NSString stringWithFormat:@"用餐人数:%@",svm.people_count];
        tabcell.labOrderTime.text = [NSString stringWithFormat:@"创建时间:%@",[self timeWithTimeIntervalString:svm.order_time]];
        tabcell.labWriter.text = [NSString stringWithFormat:@"服务人员:%@",svm.name];
        tabcell.btnSubOrder.tag = indexPath.section;
        [tabcell.btnSubOrder addTarget:self action:@selector(printClick:) forControlEvents:UIControlEventTouchUpInside];
        return tabcell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectBtnFlag isEqualToString:@"-1"]) {
        OrderModel *svm = self.dateArray[indexPath.section];
        OrderDeatiledViewController *ovc = [[OrderDeatiledViewController alloc] init];
        ovc.order_num = svm.order_num;
        ovc.pageflag = @"0";
        [self.navigationController pushViewController:ovc animated:YES];
    }else if ([selectBtnFlag isEqualToString:@"0"]){
        OrderModel *svm = self.dateArray[indexPath.section];
        OrderDeatiledViewController *ovc = [[OrderDeatiledViewController alloc] init];
        ovc.order_num = svm.order_num;
        ovc.pageflag = @"1";
        [self.navigationController pushViewController:ovc animated:YES];
        
    }else{
        OrderModel *svm = self.dateArray[indexPath.section];
        OrderDeatiledViewController *ovc = [[OrderDeatiledViewController alloc] init];
        ovc.order_num = svm.order_num;
        ovc.pageflag = @"2";
        [self.navigationController pushViewController:ovc animated:YES];

    }
}
-(void)addFoodClick:(UIButton *)btn{
    OrderModel *svm = self.dateArray[btn.tag];
    FoodCustomViewController *fv = [[FoodCustomViewController alloc] init];
    fv.table_id = svm.table_id;
    fv.table_name = svm.table_name;
    [self.navigationController pushViewController:fv animated:YES];
}
// 打印订单
-(void)printClick:(UIButton *)btn{
     OrderModel *svm = self.dateArray[btn.tag];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要打印订单吗?" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self printOrder:svm.order_id];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"---");
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//提交订单
-(void)submitOrderClick:(UIButton *)btn{
     OrderModel *svm = self.dateArray[btn.tag];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要提交订单吗?" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self subOrder:svm.order_id];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"---");
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//结账
-(void)checkOrderClick:(UIButton *)btn{
    NSString *if_check = [[userDefaults objectForKey:@"if_check_MX"] stringValue];
    if ([if_check isEqualToString:@"1"]) {
        OrderModel *svm = self.dateArray[btn.tag];
        order_ids = svm.order_id;
        myTotalPrice = svm.payment;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请选择付款方式"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"现金", @"微信",@"支付宝",@"微信扫码付",@"支付宝扫码付",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }else{
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"暂不支持此权限";
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];
        [hud hide:YES afterDelay:1.5];
    }
}

// 服务员确认下单
-(void)subOrder:(NSString*)order_id{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,CONFIRMORDER];
    NSDictionary *parameters = @{@"waiter_id":[userDefaults objectForKey:@"business_id_MX"],
                                 @"order_id": order_id
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
            NSLog(@"成功");
            hud.labelText =[responseObject objectForKey:@"MESSAGE"];
            [hud hide:YES afterDelay:0.5];

            [self.dateArray removeAllObjects];
            page = 1;
            [self setupTableView];
        }
        
        else
        {
            hud.labelText =[responseObject objectForKey:@"MESSAGE"];
            [hud hide:YES afterDelay:0.5];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}
-(void)printOrder:(NSString *)order_id{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];

    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,PRINTBYORDER];
    NSDictionary *parameters = @{@"order_id": order_id
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
            NSLog(@"成功");
            hud.labelText =@"成功";
            [hud hide:YES afterDelay:0.5];
            [self.dateArray removeAllObjects];
            page = 1;
            [self setupTableView];
        }
        
        else
        {
            hud.labelText =@"失败";
            [hud hide:YES afterDelay:0.5];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (![[actionSheet buttonTitleAtIndex:buttonIndex ] isEqualToString:@"取消"]) {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex ] isEqualToString:@"现金"]) {
            check_way = @"1";
            [self check:order_ids];
        }else if ([[actionSheet buttonTitleAtIndex:buttonIndex ] isEqualToString:@"微信"]){
            check_way = @"2";
            [self check:order_ids];
        }else if ([[actionSheet buttonTitleAtIndex:buttonIndex ] isEqualToString:@"支付宝"]){
            check_way = @"3";
            [self check:order_ids];
        }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"微信扫码付"]){
            QRCodeingViewController *qc = [[QRCodeingViewController alloc] init];
            qc.pageType = @"1";
            qc.order_id = order_ids;
            qc.totalPrice = myTotalPrice;
            [self.navigationController pushViewController:qc animated:YES];
        }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"支付宝扫码付"]){
            QRCodeingViewController *qc = [[QRCodeingViewController alloc] init];
            qc.pageType = @"2";
            qc.order_id = order_ids;
            qc.totalPrice = myTotalPrice;
            [self.navigationController pushViewController:qc animated:YES];
        }
        
    }
}


//结账
-(void)check:(NSString *)order_id{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,CHECK_URL];
    NSDictionary *parameters = @{@"order_id": order_id,
                                 @"waiter_id":[userDefaults objectForKey:@"business_id_MX"],
                                  @"check_way":check_way
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
            NSLog(@"成功");
            hud.labelText =[responseObject objectForKey:@"MESSAGE"];
            [hud hide:YES afterDelay:0.5];
            if ([check_way isEqualToString:@"1"]) {
                [self.dateArray removeAllObjects];
                page = 1;
                [self setupTableView];
                 [tableService reloadData];
            }else{
                PayImageViewController *pivc = [[PayImageViewController alloc] init];
                [self.navigationController pushViewController:pivc animated:YES];
            }
        }
        
        else
        {
            hud.labelText =[responseObject objectForKey:[responseObject objectForKey:@"MESSAGE"]];
            [hud hide:YES afterDelay:0.5];
            if ([check_way isEqualToString:@"1"]) {
                [self.dateArray removeAllObjects];
                page = 1;
                [self setupTableView];
                [tableService reloadData];
            }else{
                PayImageViewController *pivc = [[PayImageViewController alloc] init];
                [self.navigationController pushViewController:pivc animated:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}



- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    
    if ([timeString isEqual:[NSNull  null]]) {
        return @"";
    }else{
        NSTimeInterval interval    =[timeString doubleValue] / 1000.0;
        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString       = [formatter stringFromDate: date];
        
        return dateString;
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
