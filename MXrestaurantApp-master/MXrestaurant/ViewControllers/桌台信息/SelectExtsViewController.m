//
//  SelectExtsViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/12/20.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "SelectExtsViewController.h"
#import "FoodClassTableViewCell.h"
#import "ExtsModel.h"

@interface SelectExtsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableViewClass;
    NSUserDefaults * userDefaults;
    UIButton *btnGotoOrder;
    UILabel *labPrice;
     MBProgressHUD *hud;
    
    NSString *good_id;
    NSString *ext_id;
    
}
@property(nonatomic,strong)NSMutableArray *dateArrayCategory;
@end

@implementation SelectExtsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择规格";
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    self.dateArrayCategory = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self makeUI];
    [self getDate];
    
    // Do any additional setup after loading the view.
}
- (void)getDate{
    NSArray *dateArray = self.goods_exts_list;
    for (NSDictionary * dic in dateArray)
    {
        NSString *ext_id = [[NSNumber numberWithLong:[ [dic objectForKey:@"ext_id"] longValue]] stringValue];
        NSString *price = [[NSNumber numberWithLong:[ [dic objectForKey:@"price"]longValue]] stringValue];
        NSString *good_id = [dic objectForKey:@"good_id"];
        NSString *size = [dic objectForKey:@"size"];
       
       
        
        ExtsModel *model = [[ExtsModel alloc] init];
        model.ext_id = ext_id;
        model.price = price;
        model.size = size;
        model.good_id = good_id;
  
        [self.dateArrayCategory addObject:model];
    }
    [tableViewClass reloadData];
}
- (void)makeUI{
    tableViewClass = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-40-80-44) style:UITableViewStylePlain];
    tableViewClass.delegate = self;
    tableViewClass.dataSource = self;
    [self.view addSubview:tableViewClass];
    
        tableViewClass.tableFooterView = [[UIView alloc] init];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-50-64, kWidth, 50)];
    [self.view addSubview:footView];
    
    labPrice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-30, 10, 100, 30)];
    labPrice.font = [UIFont systemFontOfSize:15];
    labPrice.textColor =[UIColor colorWithRed:220.0/255.0 green:20.0/255.0 blue:60.0/255.0 alpha:1];
    [footView addSubview:labPrice];
    
    btnGotoOrder = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-80, 0, 80, 50)];
    [btnGotoOrder setTitle:@"加入购物车" forState:UIControlStateNormal];
    btnGotoOrder.font = [UIFont systemFontOfSize:12];
    [btnGotoOrder setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [btnGotoOrder addTarget:self action:@selector(goToOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btnGotoOrder];
}
-(void)goToOrderClick{
    [self addFoodClick];
}
// 添加菜品
- (void)addFoodClick{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,ADDSHOPPINGCAR_URL];
    NSDictionary *parameters = @{@"shop_id": [userDefaults objectForKey:@"shop_id_MX"],
                                 @"table_id": self.table_id,
                                 @"good_id":good_id,
                                 @"from":@"2",
                                 @"ext_id":ext_id
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
            hud.labelText = @"添加成功";
            [hud hide:YES afterDelay:0.5];
            [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            hud.labelText = @"网络连接异常";
            [hud hide:YES afterDelay:0.5];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return self.dateArrayCategory.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FoodClassTableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
    if (tabcell==nil) {
        tabcell = [[FoodClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
    }
    
    UIView *slectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth/3, 40)];
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    linView.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [slectView addSubview:linView];
    tabcell.selectedBackgroundView = slectView;
    
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    
    tabcell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    ExtsModel *model = self.dateArrayCategory[indexPath.section];
    tabcell.labClass.text = model.size;
    
    if (indexPath.section==0) {
        good_id = model.good_id;
        ext_id = model.ext_id;
        labPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
    }
    
    return tabcell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:tableViewClass]) {
        ExtsModel *model = self.dateArrayCategory[indexPath.section];
        
        good_id = model.good_id;
        ext_id = model.ext_id;
        labPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
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
