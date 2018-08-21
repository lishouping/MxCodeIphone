//
//  ManagerDishViewController.m
//  MXrestaurant
//
//  Created by MX on 2018/8/21.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "ManagerDishViewController.h"
#import "ManagerDishAddViewController.h"
#import "CategoryModel.h"
#import "DishTableViewCell.h"
#import "DishModel.h"
#import "HWPopTool.h"
@interface ManagerDishViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableManage;
    NSUserDefaults * userDefaults;
    MBProgressHUD *hud;
    
    
    UITableView *tableViewChoose;
    UIView *headView;
    UIView *viewTableState;
    
    UIView *titleView;
    UIButton *btnArea;
    
    NSString *selecType;
    
    NSArray *mdateArray;
    UITextField *searchBar;
    
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *areaArray;
@end

@implementation ManagerDishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"菜品管理";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.areaArray = [[NSMutableArray alloc] initWithCapacity:0];
    
   
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.dataArray.count>0) {
         selecType = @"1";
        [self.dataArray removeAllObjects];
        [_tableManage reloadData];
        [self loadData];
    }else{
        selecType = @"1";
        [self loadData];
    }
    
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
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    [self.view addSubview:titleView];
    
    
    
    
    btnArea = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
    [btnArea setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [titleView addSubview:btnArea];
    [btnArea addTarget:self action:@selector(selectOnclick) forControlEvents:UIControlEventTouchUpInside];
    
    _tableManage = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kWidth, kHeight-44-20-60) style:UITableViewStylePlain];
    _tableManage.delegate = self;
    _tableManage.dataSource =self;
    [self.view addSubview:_tableManage];
    
    
    
    
    
    viewTableState = [[UIView alloc] initWithFrame:CGRectMake(20, 100, kWidth-20-20, kHeight-100-100)];
    viewTableState.backgroundColor = [UIColor whiteColor];
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [headView setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
    UILabel *labTableViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [labTableViewTitle setText:@"请选择分区"];
    [labTableViewTitle setFont:[UIFont systemFontOfSize:16]];
    [labTableViewTitle setTextColor:[UIColor whiteColor]];
    labTableViewTitle.textAlignment = UITextAlignmentCenter;
    [headView addSubview:labTableViewTitle];
    
    tableViewChoose = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, kHeight-100-100) style:UITableViewStylePlain];
    tableViewChoose.delegate = self;
    tableViewChoose.dataSource = self;
}

-(void)selectOnclick{
    [tableViewChoose reloadData];
    selecType = @"2";
    tableViewChoose.tableHeaderView = headView;
    tableViewChoose.tableFooterView = [[UIView alloc] init];
    [viewTableState addSubview:tableViewChoose];
    [self.areaArray removeAllObjects];
    [tableViewChoose reloadData];
    [self loadDataArea];
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone;
    [HWPopTool sharedInstance].tapOutsideToDismiss = false;
    [[HWPopTool sharedInstance] showWithPresentView:viewTableState animated:YES];
    
}


- (void)rightBtnButtonClick{
    ManagerDishAddViewController *madis = [[ManagerDishAddViewController alloc] init];
    [self.navigationController pushViewController:madis animated:YES];
    
}
- (void)loadDataArea{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@/%@",API_URL,SELECTCATEGORY_URL,[userDefaults objectForKey:@"shop_id_MX"]];
    //NSDictionary *parameters = @{@"shopid": [userDefaults objectForKey:@"shop_id_MX"]};
    
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
    
    [manager GET:postUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"结果: %@", responseObject);
        if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
            
            mdateArray = [responseObject objectForKey:@"DATA"];
            for (NSDictionary * dic in mdateArray)
            {
                NSString *category_id = [dic objectForKey:@"category_id"];
                NSString *category_name = [dic objectForKey:@"category_name"];
                NSString *category_status = [dic objectForKey:@"category_status"];
                NSArray *goods_list = [dic objectForKey:@"goods_list"];
                
                CategoryModel *mo = [[CategoryModel alloc] init];
                mo.category_id =category_id;
                mo.category_name =category_name;
                mo.category_status =category_status;
                mo.goods_list =goods_list;
                
                [self.areaArray addObject:mo];
            }
            [tableViewChoose reloadData];
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

- (void)loadData{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@/%@",API_URL,SELECTCATEGORY_URL,[userDefaults objectForKey:@"shop_id_MX"]];
    //NSDictionary *parameters = @{@"shopid": [userDefaults objectForKey:@"shop_id_MX"]};
    
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
    
    [manager GET:postUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"结果: %@", responseObject);
        if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
            
            NSArray *dateArray = [responseObject objectForKey:@"DATA"];
            for (NSDictionary * dic in dateArray)
            {
                NSString *category_id = [dic objectForKey:@"category_id"];
                NSString *category_name = [dic objectForKey:@"category_name"];
                NSString *category_status = [dic objectForKey:@"category_status"];
                NSArray *goods_list = [dic objectForKey:@"goods_list"];
                
                for (NSDictionary * dic1 in goods_list) {
                    NSString *goods_name = [dic1 objectForKey:@"goods_name"];
                    NSString *pre_price = [dic1 objectForKey:@"pre_price"];
                    NSString *good_id = [dic1 objectForKey:@"good_id"];
                    
                    DishModel *model = [[DishModel alloc] init];
                    model.goods_name = goods_name;
                    model.pre_price = pre_price;
                    model.good_id = good_id;
                    model.category_name = category_name;
                    [self.dataArray addObject:model];
                }
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
    if ([selecType isEqualToString:@"1"]) {
         return self.dataArray.count;
    }else if([selecType isEqualToString:@"2"]){
         return self.areaArray.count;
    }else{
         return 0
        ;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selecType isEqualToString:@"1"]) {
        DishTableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
        if (tabcell==nil) {
            tabcell = [[DishTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
            tabcell.selectionStyle = UITableViewCellStyleDefault;
        }
        DishModel *model =  self.dataArray[indexPath.section];
        tabcell.labNum.text = [NSString stringWithFormat:@"%ld",indexPath.section+1];
        tabcell.labName.text = [NSString stringWithFormat:@"名称:%@",model.goods_name];
        tabcell.labCreateTime.text = [NSString stringWithFormat:@"分类:%@",model.category_name] ;
        tabcell.labStatus.text = [NSString stringWithFormat:@"价格:%@元",model.pre_price];
        tabcell.labStatus.textColor = [UIColor colorWithRed:255.0/255.0 green:62.0/255.0 blue:65.0/255.0 alpha:1];
        tabcell.labStatus.textAlignment = UITextAlignmentLeft;
        return tabcell;
    }else if([selecType isEqualToString:@"2"]){
        UITableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
        if (tabcell==nil) {
            tabcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
            tabcell.selectionStyle = UITableViewCellStyleDefault;
        }
        tabcell.textLabel.textAlignment = UITextAlignmentCenter;
        CategoryModel *model = [self.areaArray objectAtIndex:indexPath.section];
        
        tabcell.textLabel.text = model.category_name;
        
        
        return tabcell;
    }else{
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selecType isEqualToString:@"1"]) {
        DishModel *model =  self.dataArray[indexPath.section];
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择一个操作" message:nil preferredStyle:  UIAlertControllerStyleAlert];
        
        
        
        [alert addAction:[UIAlertAction actionWithTitle:@"详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText=@"删除中...";
            hud.minSize = CGSizeMake(100.f, 100.f);
            hud.color=[UIColor blackColor];
            NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,DELGOODS];
            NSDictionary *parameters = @{@"good_id": model.good_id
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
    }else{
        
        CategoryModel *model = self.areaArray[indexPath.section];
        
        
        selecType = @"1";
        [self selectFoodInfo:model.category_name];
        
        
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            
        }];
        
        
    }

}


//查询菜品
- (void)selectFoodInfo:(NSString *) className{
    [self.dataArray removeAllObjects];
    [_tableManage reloadData];
    for (NSDictionary * dic in mdateArray)
    {
        NSString *category_name = [dic objectForKey:@"category_name"];
        
        NSArray *goods_list = [dic objectForKey:@"goods_list"];
        
        if ([category_name isEqualToString:className]) {
            
            for (NSDictionary * dic1 in goods_list) {
                NSString *goods_name = [dic1 objectForKey:@"goods_name"];
                NSString *pre_price = [dic1 objectForKey:@"pre_price"];
                NSString *good_id = [dic1 objectForKey:@"good_id"];
                
                DishModel *model = [[DishModel alloc] init];
                model.goods_name = goods_name;
                model.pre_price = pre_price;
                model.good_id = good_id;
                model.category_name = category_name;
                [self.dataArray addObject:model];
            }
            
        }
    }

    [_tableManage reloadData];
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
