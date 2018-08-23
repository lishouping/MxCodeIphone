//
//  ManagerTableAddViewController.m
//  MXrestaurant
//
//  Created by MX on 2018/8/20.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "ManagerTableAddViewController.h"
#import "ChooseClassModel.h"
#import "HWPopTool.h"
#import "AieaModel.h"

@interface ManagerTableAddViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *hud;
    NSUserDefaults * userDefaults;
    
    UIScrollView *_scrollView;
    UITextField *_tfShopName;
    UITextField *_tfShopPersonName;
    UITextField *_tfShopPersonPhone;
    UITextField *_tfShopAddress;
    UIButton *btnSelect;
    
    UIButton *btnSubmit;
    NSString *area_id;
    
    UITableView *tableViewChoose;
    UIView *headView;
    UIView *viewTableState;
    
    NSArray *mdateArray;
}
//餐桌分类
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation ManagerTableAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新增桌台";
    self.view.backgroundColor = [UIColor whiteColor];
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    // Do any additional setup after loading the view.
    area_id = @"-1";
    [self makeUI];
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
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-30-10-44-20)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(kWidth, kHeight+100);//滚动范围的大小
    
    
    UILabel *labShopA = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 40)];
    [labShopA setText:@"桌台名称"];
    labShopA.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopA];
    
    _tfShopName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10, kWidth-15-80-10-15, 40)];
    _tfShopName.placeholder = @"请输入桌台名称";
    _tfShopName.delegate = self;
    [_tfShopName setTextColor:[UIColor blackColor]];
    _tfShopName.font = [UIFont systemFontOfSize:13];
    _tfShopName.layer.cornerRadius = 3.0;
    _tfShopName.layer.borderWidth = 0.5;
    _tfShopName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopName];
    
    
    UILabel *labShopB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10, 80, 40)];
    [labShopB setText:@"容纳人数"];
    labShopB.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopB];
    
    _tfShopPersonName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10, kWidth-15-80-10-15, 40)];
    _tfShopPersonName.placeholder = @"请输入容纳人数";
    _tfShopPersonName.delegate = self;
    [_tfShopPersonName setTextColor:[UIColor blackColor]];
    _tfShopPersonName.font = [UIFont systemFontOfSize:13];
    _tfShopPersonName.layer.cornerRadius = 3.0;
    _tfShopPersonName.layer.borderWidth = 0.5;
    _tfShopPersonName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopPersonName];
    
    UILabel *labShopF = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50, 80, 40)];
    [labShopF setText:@"分区名称"];
    labShopF.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopF];
    
    btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50, kWidth-15-80-10-15, 40)];
    [btnSelect addTarget:self action:@selector(selectOnclick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnSelect setTitle:@"请选择分区名称" forState:UIControlStateNormal];
    btnSelect.font = [UIFont systemFontOfSize:13];
    btnSelect.layer.cornerRadius = 3.0;
    btnSelect.layer.borderWidth = 0.5;
    btnSelect.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [btnSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_scrollView addSubview:btnSelect];
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(30,  kHeight-30-44-20-10, kWidth-30-30, 30)];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:67.0/255.0 green:136.0/255.0 blue:253.0/255.0 alpha:1]];
    btnSubmit.layer.cornerRadius = 3.0;
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnSubmit addTarget:self action:@selector(sumbitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    
    if ([self.pagetype isEqualToString:@"1"]) {
        //添加
        
    } else {
        //修改
        [self loadData];
        
    }
    
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
    tableViewChoose.tableHeaderView = headView;
    tableViewChoose.tableFooterView = [[UIView alloc] init];
    [viewTableState addSubview:tableViewChoose];
    [self.dateArray removeAllObjects];
    [tableViewChoose reloadData];
    [self loadData];
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone    ;
    [[HWPopTool sharedInstance] showWithPresentView:viewTableState animated:YES];
}

-(void)sumbitClick{
    
    if (_tfShopName.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入桌台名称" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopPersonName.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入容纳人数" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if ([area_id isEqualToString:@"-1"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择分区名称" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    
    else{
        //开始显示HUD
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,ADDTABLE];
        NSDictionary *parameters = @{@"table_name": _tfShopName.text,
                                     @"people_count": _tfShopPersonName.text,
                                     @"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                                     @"area_id":area_id
                                     };	
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
        NSString *key =[userDefaults objectForKey:@"login_key_MX"];
        NSString *longbusid = [[userDefaults objectForKey:@"business_id_MX"] stringValue];
        
        [manager.requestSerializer setValue:key forHTTPHeaderField:@"key"];
        [manager.requestSerializer setValue:longbusid forHTTPHeaderField:@"id"];
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:postUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"结果: %@", responseObject);
            if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
                hud.labelText = @"成功";
                [hud hide:YES afterDelay:0.5];
                //说明不是跟视图
                [self.navigationController popViewControllerAnimated:NO];
            }
            else
            {
                hud.labelText = @"失败";
                [hud hide:YES afterDelay:0.5];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            hud.labelText = @"网络连接异常";
            [hud hide:YES afterDelay:0.5];
            NSLog(@"Error: ==============%@", error);
        }];
        
    }
    
    
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
            
             mdateArray = [responseObject objectForKey:@"DATA"];
            
            for (NSDictionary * dic in mdateArray)
            {
                NSString *area_name = [dic objectForKey:@"area_name"];
                NSNumber *areid = [dic objectForKey:@"area_id"];
                NSString *area_id = [areid stringValue];
                
                AieaModel *model = [[AieaModel alloc] init];
                model.area_id = area_id;
                model.area_name = area_name;
                
                [self.dateArray addObject:model];
                
                
            }
            [tableViewChoose reloadData];
            if ([self.pagetype isEqualToString:@"2"]) {
                [self getOneTable];
            }
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
    return self.dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
    if (tabcell==nil) {
        tabcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
        tabcell.selectionStyle = UITableViewCellStyleDefault;
    }
     tabcell.textLabel.textAlignment = UITextAlignmentCenter;
    AieaModel *model = [self.dateArray objectAtIndex:indexPath.section];
    
    tabcell.textLabel.text = model.area_name;
   
    
    return tabcell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AieaModel *model = self.dateArray[indexPath.section];
    [btnSelect setTitle:model.area_name forState:UIControlStateNormal];
    area_id = model.area_id;
    
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        
    }];
}

-(void)getOneTable{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@/%@",API_URL,GETONETABLE,self.table_id];
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
            NSDictionary *dics =[responseObject objectForKey:@"DATA"];
            
            NSString *table_name = [dics objectForKey:@"table_name"];
            NSNumber *content = [dics objectForKey:@"people_count"];
            NSString *people_count = [content stringValue];
            NSNumber *areaid = [dics objectForKey:@"area_id"];
            
            area_id =[areaid stringValue];
            
            [_tfShopName setText:table_name];
            [_tfShopPersonName setText:people_count];
            
            
            
            [self getAreaName:area_id];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}

- (void)getAreaName:(NSString *)areaId{
    for (NSDictionary * dic in mdateArray)
    {
        
        NSString *area_name = [dic objectForKey:@"area_name"];
        NSNumber *areid = [dic objectForKey:@"area_id"];
        NSString *area_id = [areid stringValue];
        
        if ([areaId isEqualToString:area_id]) {
            [btnSelect setTitle:area_name forState:UIControlStateNormal];
            break;
        }
    }
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
