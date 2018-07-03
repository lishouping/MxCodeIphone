//
//  FoodCustomViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/18.
//  Copyright © 2017年 lishouping. All rights reserved.
//
static int showview = 0;
#import "FoodCustomViewController.h"
#import "FoodClassTableViewCell.h"
#import "FoodListTableViewCell.h"
#import "ShoppingCarLIstTableViewCell.h"
#import "CategoryModel.h"
#import "FoodModel.h"
#import "GoodInfoModel.h"
#import "OrderSubmitViewController.h"
#import "SelectExtsViewController.h"


@interface FoodCustomViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableViewClass;
    UITableView *tableViewFood;
    UITableView *tableViewShopCar;
    UIButton *btnShopCar;
    UILabel *labFoodNumber;
    UILabel *shopCarPrice;
    
    UIButton *btnGotoOrder;
    
    UIView *shoppingCarView;
    UIButton *btnClearShopCar;
    
    UILabel *labPrice;
    
     NSUserDefaults * userDefaults;
    
    NSString *cart_id;
    
     NSTimer *timer;
}
@property(nonatomic,strong)NSMutableArray *dateArrayCategory;
@property(nonatomic,strong)NSMutableArray *dateArrayFoodList;
@property(nonatomic,strong)NSMutableArray *dateArrayShoppingCar;
@end

@implementation FoodCustomViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
//    if ([self.isinitres isEqualToString:@"1"]) {
//        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAction) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    }else{
//        [self.dateArrayShoppingCar removeAllObjects];
//        [self getShoppingCar];
//    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

}

-(void)updateAction{
    NSLog(@"------");
    [self.dateArrayShoppingCar removeAllObjects];
    [self getShoppingCar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    self.dateArrayCategory = [[NSMutableArray alloc] initWithCapacity:0];
    self.dateArrayFoodList = [[NSMutableArray alloc] initWithCapacity:0];
    self.dateArrayShoppingCar = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.navigationItem.title = @"点餐";
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self makeUI];
    
    [self getTableClass];
    
}
-(void)makeUI{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kWidth, 40)];
    [titleView setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1]];
    [self.view addSubview:titleView];
    
    UILabel *labClass = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth/3, 40)];
    labClass.textAlignment = UITextAlignmentCenter;
    labClass.text = @"分类";
    labClass.font = [UIFont systemFontOfSize:12];
    [titleView addSubview:labClass];
    
    UILabel *labFoodName = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/3, 0, kWidth/3, 40)];
    labFoodName.textAlignment = UITextAlignmentCenter;
    labFoodName.text = @"菜品名称";
    labFoodName.font = [UIFont systemFontOfSize:12];
    [titleView addSubview:labFoodName];
    
    UILabel *labPri = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/3*2, 0, kWidth/3, 40)];
    labPri.textAlignment = UITextAlignmentCenter;
    labPri.text = @"价格";
    labPri.font = [UIFont systemFontOfSize:12];
    [titleView addSubview:labPri];
    
    
    tableViewClass = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kWidth/3, kHeight-40-80-44) style:UITableViewStylePlain];
    tableViewClass.delegate = self;
    tableViewClass.dataSource = self;
    [self.view addSubview:tableViewClass];
    tableViewClass.tableFooterView = [[UIView alloc] init];
    
    tableViewFood = [[UITableView alloc] initWithFrame:CGRectMake(kWidth/3, 40, kWidth/3*2, kHeight-40-80-44) style:UITableViewStylePlain];
    tableViewFood.delegate = self;
    tableViewFood.dataSource = self;
    [self.view addSubview:tableViewFood];
    tableViewFood.tableFooterView = [[UIView alloc] init];
    
    
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-50-64, kWidth, 50)];
    [self.view addSubview:footView];
    
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]];
    [footView addSubview:view];
    [view zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.widthValue(kWidth);
        layout.heightValue(1);
        layout.topSpace(0);
    }];
    
    btnShopCar = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [btnShopCar setImage:[UIImage imageNamed:@"icon_shopping"] forState:UIControlStateNormal];
    [footView addSubview:btnShopCar];
    [btnShopCar addTarget:self action:@selector(shopChangeClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(10+30, 3, 25, 25)];
    [bgview setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:20.0/255.0 blue:60.0/255.0 alpha:1]];
    bgview.layer.cornerRadius = 13.5;
    [footView addSubview:bgview];
    
    labFoodNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    labFoodNumber.textColor = [UIColor whiteColor];
    labFoodNumber.textAlignment = UITextAlignmentCenter;
    labFoodNumber.font = [UIFont systemFontOfSize:10];
    [bgview addSubview:labFoodNumber];
    
    labPrice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-30, 10, 100, 30)];
    labPrice.font = [UIFont systemFontOfSize:15];
    labPrice.textColor =[UIColor colorWithRed:220.0/255.0 green:20.0/255.0 blue:60.0/255.0 alpha:1];
    [footView addSubview:labPrice];
    
    btnGotoOrder = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-80, 0, 80, 50)];
    [btnGotoOrder setTitle:@"去下单" forState:UIControlStateNormal];
    btnGotoOrder.font = [UIFont systemFontOfSize:12];
    [btnGotoOrder setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    [btnGotoOrder addTarget:self action:@selector(goToOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btnGotoOrder];
    
    
    shoppingCarView = [UIView new];
    shoppingCarView.backgroundColor =[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    [self.view addSubview:shoppingCarView];
    [shoppingCarView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.widthValue(kWidth);
        layout.heightValue(250);
        layout.bottomSpace(50);
    }];
    shoppingCarView.hidden= YES;
    
    UILabel *labShopCar = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-40, 5, 80, 20)];
    labShopCar.text = @"购物车";
    [labShopCar setFont:[UIFont systemFontOfSize:14]];
    labShopCar.textAlignment = UITextAlignmentCenter;
    [shoppingCarView addSubview:labShopCar];
    
    
    btnClearShopCar = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-40-5, 5, 40, 20)];
    [btnClearShopCar setTitle:@"清空" forState:UIControlStateNormal];
    [btnClearShopCar setFont:[UIFont systemFontOfSize:14]];
    [btnClearShopCar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnClearShopCar addTarget:self action:@selector(shoppingCarClear) forControlEvents:UIControlEventTouchUpInside];
    [btnClearShopCar setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]];
    [shoppingCarView addSubview:btnClearShopCar];
    
    
   
    tableViewShopCar = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kWidth, 220) style:UITableViewStylePlain];
    tableViewShopCar.backgroundColor =[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    tableViewShopCar.delegate = self;
    tableViewShopCar.dataSource = self;
    [shoppingCarView addSubview:tableViewShopCar];
    tableViewShopCar.tableFooterView = [[UIView alloc] init];
    
    
    
    
    [self createNav];
}
-(void)createNav
{
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"cp_back"] forState:UIControlStateNormal];
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

-(void)leftButtonClick
{
    [timer invalidate];
    timer = nil;
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)shopChangeClick{
    if (showview==0) {//隐藏状态
        if (self.dateArrayShoppingCar.count==0||self.dateArrayShoppingCar==nil) {
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"您还没有点餐" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
        }else{
            shoppingCarView.hidden = NO;
            showview = 1;
        }
       
    }else{
        shoppingCarView.hidden = YES;
        showview = 0;
    }
}

- (void)goToOrderClick{
    if ([labFoodNumber.text isEqualToString:@"0"]) {
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"您还没有点餐" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else{
        [timer invalidate];
        timer = nil;
        OrderSubmitViewController *ovc = [[OrderSubmitViewController alloc] init];
        ovc.table_name = self.table_name;
        ovc.table_id = self.table_id;
        ovc.cart_id = cart_id;
        ovc.dicdate = self.dicdate;
        [self.navigationController pushViewController:ovc animated:YES];
    }
}
- (void)shoppingCarClear{
    [self deleteCartClick];
}
// 获取分类
- (void)getTableClass{
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
                
                CategoryModel *model = [[CategoryModel alloc] init];
                model.category_id = category_id;
                model.category_name = category_name;
                model.category_status = category_status;
                model.goods_list = goods_list;
                [self.dateArrayCategory addObject:model];
            }
            [tableViewClass reloadData];
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

//查询菜品
- (void)selectFoodInfo:(CategoryModel *) model post:(NSInteger *) pos{
    [self.dateArrayFoodList removeAllObjects];
    NSArray *dateArray = model.goods_list;
    for (NSDictionary * dic in dateArray)
    {
        NSString *goods_name = [dic objectForKey:@"goods_name"];
        NSString *pre_price = [dic objectForKey:@"pre_price"];
        NSString *good_id = [dic objectForKey:@"good_id"];
        NSString *good_exts_flag = [dic objectForKey:@"good_exts_flag"];
        
        
        FoodModel *model = [[FoodModel alloc] init];
        model.goods_name = goods_name;
        model.pre_price = pre_price;
        model.good_id = good_id;
        if ([self isBlankString:good_exts_flag]) {
            model.good_exts_flag = @"0";
        }else{
            NSArray *dateArray = [dic objectForKey:@"goods_exts_list"];
            model.good_exts_flag = good_exts_flag;
            model.goods_exts_list = dateArray;
        }
        [self.dateArrayFoodList addObject:model];
    }
    [tableViewFood reloadData];
    
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
// 获取购物车
- (void)getShoppingCar{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,GETSHOPPINGCAR_URL];
    NSDictionary *parameters = @{@"shop_id": [userDefaults objectForKey:@"shop_id_MX"],
                                 @"table_id": self.table_id
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
            NSDictionary *dics =[responseObject objectForKey:@"DATA"];
            
            cart_id = [[NSNumber numberWithLong:[ [dics objectForKey:@"cart_id"] longValue]] stringValue];
            
            NSNumber *longNumber1 = [NSNumber numberWithLong:[[dics objectForKey:@"total_num"] longValue]];
            NSString *total_num = [longNumber1 stringValue];
            
            NSString *total_price = [NSString stringWithFormat:@"￥%@",[dics objectForKey:@"total_price"]];
            
            labFoodNumber.text = total_num;
            if ([total_price isEqualToString:@"￥(null)"]) {
                 labPrice.text = @"￥0";
            }else{
                 labPrice.text = [NSString stringWithFormat:@"%@",total_price];
            }
           
            NSArray *dateArray = [dics objectForKey:@"goods_set"];
            for (NSDictionary * dic in dateArray)
            {
                
                
                NSString *good_id = [[NSNumber numberWithLong:[ [dic objectForKey:@"good_id"] longValue]] stringValue];
                NSString *pre_price = [[NSNumber numberWithLong:[ [dic objectForKey:@"pre_price"]longValue]] stringValue];
                NSString *good_name = [dic objectForKey:@"good_name"];
                NSString *good_num = [[NSNumber numberWithLong:[[dic objectForKey:@"good_num"]longValue]] stringValue];
                NSString *good_price = [NSString stringWithFormat:@"%.1f",[[dic objectForKey:@"good_price"]doubleValue]];
                NSString *good_total_price = [NSString stringWithFormat:@"%.1f",[[dic objectForKey:@"good_total_price"]doubleValue]];
                
                
                
                NSString *ext_size_id = [dic objectForKey:@"ext_size_id"];
                
                if ([[dic objectForKey:@"ext_size_id"] isEqual:[NSNull null]]) {
                    ext_size_id = @"-100";
                }
                
                GoodInfoModel *model = [[GoodInfoModel alloc] init];
                model.good_id = good_id;
                model.pre_price = pre_price;
                model.good_name = good_name;
                model.good_price = good_price;
                model.good_num = good_num;
                model.good_total_price = good_total_price;
                model.ext_size_id = ext_size_id;
                [self.dateArrayShoppingCar addObject:model];
            }
            [tableViewShopCar reloadData];
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
// 添加菜品
- (void)addFoodClick:(NSString *)good_id{
    
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,ADDSHOPPINGCAR_URL];
    NSDictionary *parameters = @{@"shop_id": [userDefaults objectForKey:@"shop_id_MX"],
                                 @"table_id": self.table_id,
                                 @"good_id":good_id,
                                 @"from":@"2"
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
            [self.dateArrayShoppingCar removeAllObjects];
            [self getShoppingCar];
        }else if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"10000"]){
            [self.dateArrayShoppingCar removeAllObjects];
            [self getShoppingCar];
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
// 添加菜品购物车
- (void)addFoodShopcar:(GoodInfoModel *)model{
    NSDictionary *parameters;
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,ADDSHOPPINGCAR_URL];
    if ([model.ext_size_id isEqualToString:@"-100"]) {
        parameters = @{@"shop_id": [userDefaults objectForKey:@"shop_id_MX"],
                       @"table_id": self.table_id,
                       @"good_id":model.good_id,
                       @"from":@"2"
                       };
    }else{
        parameters = @{@"shop_id": [userDefaults objectForKey:@"shop_id_MX"],
                       @"table_id": self.table_id,
                       @"good_id":model.good_id,
                       @"from":@"2",
                       @"ext_id":model.ext_size_id
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
            [self.dateArrayShoppingCar removeAllObjects];
            [self getShoppingCar];
        }else if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"10000"]){
            [self.dateArrayShoppingCar removeAllObjects];
            [self getShoppingCar];
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
//减少商品
- (void)removeFoodClick:(GoodInfoModel *)model{
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,REMOVECAR_URL];
    NSDictionary *parameters;
    if ([model.ext_size_id isEqualToString:@"-100"]) {
        parameters= @{@"cart_id": cart_id,
                      @"good_id":model.good_id
                      };
    }else{
        parameters= @{@"cart_id": cart_id,
                      @"good_id":model.good_id,
                      @"ext_id":model.ext_size_id
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
            [self.dateArrayShoppingCar removeAllObjects];
            [self getShoppingCar];
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
//清空购物车/cart/deleteCart
- (void)deleteCartClick{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,DELETECAR_URL];
    NSDictionary *parameters = @{@"cart_id": cart_id
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
            [self.dateArrayShoppingCar removeAllObjects];
            [self getShoppingCar];
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
    if ([tableView isEqual:tableViewClass]) {
        return self.dateArrayCategory.count;
    }else if ([tableView isEqual:tableViewFood]){
        return self.dateArrayFoodList.count;
    }
    else{
        return self.dateArrayShoppingCar.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:tableViewClass]) {
        return 40.0;
    }else if ([tableView isEqual:tableViewFood]){
        return 40.0;
    }else{
       return 40.0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:tableViewClass]) {
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
        CategoryModel *model = self.dateArrayCategory[indexPath.section];
        tabcell.labClass.text = model.category_name;
        if (indexPath.section==0) {
            [self selectFoodInfo:model post:indexPath.section];
        }
        
        
        
        return tabcell;
    }else if ([tableView isEqual:tableViewFood]){
        FoodListTableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
        if (tabcell==nil) {
            tabcell = [[FoodListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
        }
        FoodModel *model = self.dateArrayFoodList[indexPath.section];
       
        tabcell.labFoodName.text = model.goods_name;
        tabcell.labFoodPrice.text = [NSString stringWithFormat:@"￥%@",model.pre_price];
        tabcell.btnAddFood.tag = indexPath.section;
        [tabcell.btnAddFood addTarget:self action:@selector(addFood:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([model.good_exts_flag isEqualToString:@"1"]) {
            tabcell.labFoodPrice.hidden = YES;
            tabcell.btnAddFood.hidden = YES;
            tabcell.btnExtSelect.hidden = NO;
        }else{
            tabcell.labFoodPrice.hidden = NO;
            tabcell.btnAddFood.hidden = NO;
            tabcell.btnExtSelect.hidden = YES;
        }
        tabcell.btnExtSelect.tag = indexPath.section;
        [tabcell.btnExtSelect addTarget:self action:@selector(selectExt:) forControlEvents:UIControlEventTouchUpInside];
        return tabcell;
    }
    else{
        ShoppingCarLIstTableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
        if (tabcell==nil) {
            tabcell = [[ShoppingCarLIstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
        }
        GoodInfoModel *model = self.dateArrayShoppingCar[indexPath.section];
        tabcell.labFoodName.text = model.good_name;
        
        tabcell.labFoodPrice.text = [NSString stringWithFormat:@"￥%@",model.good_price];
        tabcell.labFoodNum.text = model.good_num;
        tabcell.btnFreeFood.tag = indexPath.section;
        tabcell.btnAddFood.tag = indexPath.section;
        [tabcell.btnFreeFood addTarget:self action:@selector(freShpCarFood:) forControlEvents:UIControlEventTouchUpInside];
        [tabcell.btnAddFood addTarget:self action:@selector(addShpCarFood:) forControlEvents:UIControlEventTouchUpInside];
        
        return tabcell;
    }
}

-(void)addFood:(UIButton*)btn{
    FoodModel *svm = self.dateArrayFoodList[btn.tag];
    [self addFoodClick:svm.good_id];
}
-(void)selectExt:(UIButton*)btn{
    FoodModel *model = self.dateArrayFoodList[btn.tag];
    SelectExtsViewController *svc = [[SelectExtsViewController alloc] init];
    svc.table_id = self.table_id;
    svc.goods_exts_list = model.goods_exts_list;
    [self.navigationController pushViewController:svc animated:YES];
}


-(void)addShpCarFood:(UIButton*)btn{
    GoodInfoModel *svm = self.dateArrayShoppingCar[btn.tag];
    [self addFoodShopcar:svm];
}
-(void)freShpCarFood:(UIButton*)btn{
    GoodInfoModel *svm = self.dateArrayShoppingCar[btn.tag];
    [self removeFoodClick:svm];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:tableViewClass]) {
        CategoryModel *model = self.dateArrayCategory[indexPath.section];
        [self selectFoodInfo:model post:indexPath.section];
        
    }else{
         UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
