//
//  ManagerPrintViewController.m
//  MXrestaurant
//
//  Created by MX on 2018/8/15.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "ManagerPrintViewController.h"
#import "PrintTableViewCell.h"
#import "PrintModel.h"
#import "ManagerPrintAddViewController.h"

@interface ManagerPrintViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableManage;
    NSUserDefaults * userDefaults;
    MBProgressHUD *hud;
    
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ManagerPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"打印机管理";
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
    ManagerPrintAddViewController *mav = [[ManagerPrintAddViewController alloc] init];
    mav.printer_id = @"-100";
    [self.navigationController pushViewController:mav animated:YES];
}
- (void)loadData{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,PRINTLIST];
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
        if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {

            NSArray *dateArray = [responseObject objectForKey:@"DATA"];
        
            for (NSDictionary * dic in dateArray)
            {
                NSString *type_print = [dic objectForKey:@"type_print"];
                NSString *printer_no = [dic objectForKey:@"printer_no"];
                NSString *printer_name = [dic objectForKey:@"printer_name"];
                NSString *print_num = [dic objectForKey:@"print_num"];
                NSString *printer_id = [dic objectForKey:@"id"];
                
                NSString *key = [dic objectForKey:@"key"];
                NSString *printer_way = [dic objectForKey:@"printer_way"];
                NSString *page_size = [dic objectForKey:@"page_size"];
                NSString *back_good_if_print = [dic objectForKey:@"back_good_if_print"];
                NSString *print_way = [dic objectForKey:@"print_way"];
                PrintModel *model = [[PrintModel alloc] init];
                model.type_print = type_print;
                model.printer_no = printer_no;
                model.printer_name = printer_name;
                model.print_num = print_num;
                model.printer_id = printer_id;
                model.key = key;
                model.printer_way = printer_way;
                model.page_size = page_size;
                model.back_good_if_print = back_good_if_print;
                model.print_way = print_way;
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
    return 55.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrintTableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
    if (tabcell==nil) {
        tabcell = [[PrintTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
        tabcell.selectionStyle = UITableViewCellStyleDefault;
    }
    PrintModel *model =  self.dataArray[indexPath.section];
    tabcell.labName.text = [NSString stringWithFormat:@"打印机名称:%@",model.printer_name];
    tabcell.labNumber.text = [NSString stringWithFormat:@"编号:%@",model.printer_no] ;
    tabcell.labNo.text = [NSString stringWithFormat:@"打印份数:%@",model.print_num] ;
    if (![model.type_print isEqual:[NSNull null]]) {
        if ([model.type_print isEqualToString:@"1"]) {
            tabcell.labType.text = [NSString stringWithFormat:@"打印类型:%@",@"后厨"];
        }else {
            tabcell.labType.text = [NSString stringWithFormat:@"打印类型:%@",@"结账"];
        }
    }else{
        tabcell.labType.text = [NSString stringWithFormat:@"打印类型:%@",@"后厨"];
    }
    tabcell.labNo.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    return tabcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PrintModel *model =  self.dataArray[indexPath.section];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择一个操作" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ManagerPrintAddViewController *mvc = [[ManagerPrintAddViewController alloc] init];
        mvc.printer_id = [NSString stringWithFormat:@"%@",model.printer_id];
        mvc.printer_no = model.printer_no;
        mvc.printer_name = model.printer_name;
        mvc.type_print = model.type_print;
        mvc.key = model.key;
        mvc.print_num = model.print_num;
        mvc.print_way = [NSString stringWithFormat:@"%@",model.print_way];
        mvc.page_size = model.page_size;
        mvc.back_good_if_print = model.back_good_if_print;
        [self.navigationController pushViewController:mvc animated:YES];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"删除中...";
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,PRINTDEL];
        NSDictionary *parameters = @{@"shop_id": [userDefaults objectForKey:@"shop_id_MX"],
                                     @"printer_id":model.printer_id
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
