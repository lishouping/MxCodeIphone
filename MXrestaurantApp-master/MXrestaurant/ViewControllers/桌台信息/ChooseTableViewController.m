//
//  ChooseTableViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/6.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "ChooseTableViewController.h"
#import "ChooseClassModel.h"
#import "TableinfoViewController.h"

@interface ChooseTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableViewChoose;
    NSUserDefaults * userDefaults;
}
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation ChooseTableViewController
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
    self.navigationItem.title = @"请选择";
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self makeUI];
    [self getChooseDate];
    // Do any additional setup after loading the view.
}

- (void)makeUI{
    tableViewChoose = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    tableViewChoose.delegate = self;
    tableViewChoose.dataSource = self;
    [self.view addSubview:tableViewChoose];
}
- (void)getChooseDate{
    if ([self.selectType isEqualToString:@"1000"]) {//状态
        [self getTableState];
    }else{//分类
        [self getTableClass];
    }
}
- (void)getTableState{
    ChooseClassModel *ccmodel = [[ChooseClassModel alloc] init];
    ccmodel.tableuseid = @"0";
    ccmodel.tableusename = @"空闲";
    
    ChooseClassModel *ccmodel1 = [[ChooseClassModel alloc] init];
    ccmodel1.tableuseid = @"1";
    ccmodel1.tableusename = @"正在用餐";
    
    ChooseClassModel *ccmode2 = [[ChooseClassModel alloc] init];
    ccmode2.tableuseid = @"2";
    ccmode2.tableusename = @"预定";
    
    ChooseClassModel *ccmodel3 = [[ChooseClassModel alloc] init];
    ccmodel3.tableuseid = @"3";
    ccmodel3.tableusename = @"占用";
    
    ChooseClassModel *ccmodel4 = [[ChooseClassModel alloc] init];
    ccmodel4.tableuseid = @"4";
    ccmodel4.tableusename = @"其他";
    
    [self.dateArray addObject:ccmodel];
    [self.dateArray addObject:ccmodel1];
    [self.dateArray addObject:ccmode2];
    [self.dateArray addObject:ccmodel3];
    [self.dateArray addObject:ccmodel4];
    
    [tableViewChoose reloadData];
    
}
- (void)getTableClass{
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
                
                ChooseClassModel *airm = [[ChooseClassModel alloc] init];
                airm.tableuseid = area_id;
                airm.tableusename = area_name;
               
                [self.dateArray addObject:airm];
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
    }
    ChooseClassModel *model = self.dateArray[indexPath.section];
    tabcell.textLabel.text = model.tableusename;
    tabcell.textLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1];
    tabcell.textLabel.textAlignment = UITextAlignmentCenter;
    tabcell.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1];
    return tabcell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseClassModel *model = self.dateArray[indexPath.section];
    
    if ([self.selectType isEqualToString:@"1000"]) {
        TableinfoViewController *personVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        personVC.selectType = self.selectType;
        personVC.selectContent = model.tableusename;
        [self.navigationController popToViewController:personVC animated:true];
    }else{
        TableinfoViewController *personVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        personVC.selectType = self.selectType;
        personVC.selectClass = model.tableusename;
        [self.navigationController popToViewController:personVC animated:true];
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
