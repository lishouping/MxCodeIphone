//
//  ManagerTableAreaViewController.m
//  MXrestaurant
//
//  Created by MX on 2018/8/16.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "ManagerTableAreaViewController.h"

@interface ManagerTableAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableManage;
    NSUserDefaults * userDefaults;
    MBProgressHUD *hud;
    
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ManagerTableAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"桌台分区管理";
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
        [self loadData];
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
    
    _tableManage = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44-20) style:UITableViewStylePlain];
    _tableManage.delegate = self;
    _tableManage.dataSource =self;
    [self.view addSubview:_tableManage];
}
- (void)rightBtnButtonClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"增加分区" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    //在AlertView中添加一个输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入分区名";
    }];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = alert.textFields.firstObject;
        
        if (tf.text.length == 0) {
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请输入分区名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
        }else{
            hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText=@"修改中...";
            hud.minSize = CGSizeMake(100.f, 100.f);
            hud.color=[UIColor blackColor];
            NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,INSERTAREA];
            NSDictionary *parameters = @{@"area_name": tf.text,
                                         @"shop_id":[userDefaults objectForKey:@"shop_id_MX"]
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
                    hud.labelText = @"失败";
                    [hud hide:YES afterDelay:0.5];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: ==============%@", error);
            }];
        }
        
        
        
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}
- (void)loadData{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,GETTABLEINFO_URL];
    NSDictionary *parameters = @{@"shopid": [userDefaults objectForKey:@"shop_id_MX"]};
    
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
            
            for (NSDictionary * dic in dateArray)
            {
                NSString *area_id = [dic objectForKey:@"area_id"];
                NSString *area_name = [dic objectForKey:@"area_name"];
                NSString *create_time = [dic objectForKey:@"create_time"];
                
                TableAreaModel *model = [[TableAreaModel alloc] init];
                model.area_id = area_id;
                model.area_name = area_name;
                model.create_time = create_time;
       
                
                [self.dataArray addObject:model];
                
            }
            [_tableManage reloadData];
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
    return 40.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableAreaTableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
    if (tabcell==nil) {
        tabcell = [[TableAreaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
        tabcell.selectionStyle = UITableViewCellStyleDefault;
    }
    TableAreaModel *model =  self.dataArray[indexPath.section];
    tabcell.labNum.text = [NSString stringWithFormat:@"%ld",indexPath.section+1];
    tabcell.labAreaName.text = [NSString stringWithFormat:@"分区名称:%@",model.area_name];
    tabcell.labCreateTime.text = [NSString stringWithFormat:@"创建时间:%@",[self timeWithTimeIntervalString:model.create_time]] ;
    return tabcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TableAreaModel *model =  self.dataArray[indexPath.section];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择一个操作" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改分区" message:nil preferredStyle:  UIAlertControllerStyleAlert];
        //在AlertView中添加一个输入框
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入分区名";
            textField.text = model.area_name;
        }];
       
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf = alert.textFields.firstObject;
            
            if (tf.text.length == 0) {
                UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请输入分区名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [al show];
            }else{
                hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.labelText=@"修改中...";
                hud.minSize = CGSizeMake(100.f, 100.f);
                hud.color=[UIColor blackColor];
                NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,UNDATEAREA];
                NSDictionary *parameters = @{@"area_name": tf.text,
                                             @"area_id":model.area_id,
                                             @"shop_id":[userDefaults objectForKey:@"shop_id_MX"]
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
                        hud.labelText = [responseObject objectForKey:@"MESSAGE"];
                        [hud hide:YES afterDelay:0.5];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"Error: ==============%@", error);
                }];
            }
            
            
            
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"删除中...";
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,DELAREA];
        NSDictionary *parameters = @{@"area_id": model.area_id
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
                hud.labelText = [responseObject objectForKey:@"MESSAGE"];
                [hud hide:YES afterDelay:0.5];
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
