//
//  ManagerEmployeeViewController.m
//  MXrestaurant
//
//  Created by MX on 2018/8/16.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "ManagerEmployeeViewController.h"
#import "ManagerEmployeeAddViewController.h"
#import "EmployeeModel.h"
#import "PrintTableViewCell.h"
#import "PrintModel.h"
@interface ManagerEmployeeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableManage;
    NSUserDefaults * userDefaults;
    MBProgressHUD *hud;
    int page;
    int totalnum;
    
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ManagerEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"员工管理";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
        [_tableManage reloadData];
        [self loadData];
    }else{
         [self setupTableView];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)makeUI{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
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
    
    _tableManage = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44-20) style:UITableViewStylePlain];
    _tableManage.delegate = self;
    _tableManage.dataSource =self;
    [self.view addSubview:_tableManage];
}
- (void)rightBtnButtonClick{
    ManagerEmployeeAddViewController *mav = [[ManagerEmployeeAddViewController alloc] init];
    [self.navigationController pushViewController:mav animated:YES];
}
//加上刷新控件
-(void)setupTableView
{
    //下拉刷新
    [_tableManage addHeaderWithTarget:self action:@selector(headerRereshing)];
    //上拉加载
    [_tableManage addFooterWithTarget:self action:@selector(footerRereshing)];
    [_tableManage headerBeginRefreshing];
}


//下拉
- (void)headerRereshing
{
    page=1;
    [self.dataArray removeAllObjects];
    [self loadData];
}
//上拉
-(void)footerRereshing
{
    page++;
    [self loadData];
}

- (void)loadData{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,GETWAITER];
    NSDictionary *parameters = @{@"shop_id": [userDefaults objectForKey:@"shop_id_MX"],
                                 @"pageNo":[NSString stringWithFormat:@"%d",page]
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
            
           
            
            NSArray *dateArray = [responseObject objectForKey:@"DATA"];
            
            if (dateArray.count==0) {
                [_tableManage footerEndRefreshing];
                [_tableManage headerEndRefreshing];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"无更多数据" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                [alert show];
                return ;
            }
            
            totalnum = [[responseObject objectForKey:@"totalnum"] intValue];
            
            for (NSDictionary * dic in dateArray)
            {
                NSString *name = [dic objectForKey:@"name"];
                NSString *username = [dic objectForKey:@"username"];
                NSString *phonenum = [dic objectForKey:@"phonenum"];
                
                NSDictionary *userdic = [dic objectForKey:@"user"];
                
                NSNumber *statusnum = [userdic objectForKey:@"user_status"];
                NSString *user_status = [statusnum stringValue];
                
                NSNumber *numType = [userdic objectForKey:@"type"];
                NSString *type = [numType stringValue];
                
                NSNumber *numWrite = [dic objectForKey:@"waiter_id"];
                NSString *waiter_id = [numWrite stringValue];
                
                EmployeeModel *model = [[EmployeeModel alloc] init];
                model.name = name;
                model.username = username;
                model.phonenum = phonenum;
                model.user_status = user_status;
                model.type = type;
                model.waiter_id = waiter_id;
                [self.dataArray addObject:model];
                
            }
            [_tableManage reloadData];
             [_tableManage headerEndRefreshing];
        }
        
        else
        {
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
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrintTableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
    if (tabcell==nil) {
        tabcell = [[PrintTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
        tabcell.selectionStyle = UITableViewCellStyleDefault;
    }
    EmployeeModel *model =  self.dataArray[indexPath.section];
    tabcell.labName.text = [NSString stringWithFormat:@"%@(%@)",model.name,model.username];
    tabcell.labNumber.text = [NSString stringWithFormat:@"电话:%@",model.phonenum] ;
    if([model.user_status isEqualToString:@"1"]){
        tabcell.labNo.text = [NSString stringWithFormat:@"状态:%@",@"正常"] ;
    }else{
        tabcell.labNo.text = [NSString stringWithFormat:@"状态:%@",@"冻结"] ;
    }
    
    if ([model.type isEqualToString:@"1"]) {
        tabcell.labType.text = [NSString stringWithFormat:@"类型:%@",@"店长"];
    }else {
        tabcell.labType.text = [NSString stringWithFormat:@"打印类型:%@",@"服务员"];
    }
    tabcell.labNo.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    return tabcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EmployeeModel *model =  self.dataArray[indexPath.section];
    NSString *status;
    NSString *userStatus;
    if ([model.user_status isEqualToString:@"1"]) {
        status = @"冻结";
        userStatus = @"2";
    }else{
        status = @"取消冻结";
        userStatus = @"1";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择一个操作" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:status style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,CHANGEWAITER];
        NSDictionary *parameters = @{@"waiter_id": model.waiter_id,
                                     @"status":userStatus
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
                hud.labelText = @"成功";
                [hud hide:YES afterDelay:0.5];
                
                [self.dataArray removeAllObjects];
                [self loadData];
            }
            
            else
            {
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: ==============%@", error);
        }];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,DELWAITER];
        NSDictionary *parameters = @{@"waiter_id": model.waiter_id
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
                hud.labelText = @"成功";
                [hud hide:YES afterDelay:0.5];
                
                [self.dataArray removeAllObjects];
                [self loadData];
            }
            
            else
            {
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: ==============%@", error);
        }];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]] ;
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
