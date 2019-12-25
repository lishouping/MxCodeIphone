//
//  OrderSubmitViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/19.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "OrderSubmitViewController.h"
#import "GoodInfoTableViewCell.h"
#import "GoodInfoModel.h"
#import "OrderConductViewController.h"

@interface OrderSubmitViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource>{
    UILabel *labTableName;
    UITableView *tableGoodInfo;
    NSUserDefaults * userDefaults;
    
    MBProgressHUD *hud;
    
    UIButton *btnFoodType;
    UIButton *btnSangcaiTime;
    UITextField *tfFoodNumber;
    UITextField *tfFoodResen;
    
    UIView *pickV;
    UIPickerView *pickerView;
    NSArray *dateArray;
    

    NSString *way;
    NSString *go_goods_way;
    
    UIButton *btnAdd;
    UIButton *btnSubmit;
    
    UILabel *labTotalPrice;
}
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation OrderSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.navigationItem.title = @"订单详情";
    [self makeUI];
    
    [self getShoppingCar];
    // Do any additional setup after loading the view.
}
-(void)makeUI{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 80)];
    headView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:244.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:headView];
    labTableName = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth-20-20, 20)];
    labTableName.font = [UIFont systemFontOfSize:20];
    labTableName.text = [NSString stringWithFormat:@"桌号%@",self.table_name];
    [labTableName setFont:[UIFont systemFontOfSize:15]];
    [headView addSubview:labTableName];
    
    UIView *goodsview = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kWidth, 40)];
    goodsview.backgroundColor = [UIColor whiteColor];
    [headView addSubview:goodsview];
    
    UILabel *goodname = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth/2, 20)];
    goodname.text = @"菜品信息";
    goodname.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [goodname setFont:[UIFont systemFontOfSize:12]];
    [goodsview addSubview:goodname];
    
    UILabel *goodprice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2, 10, kWidth/2/3, 20)];
    goodprice.text = @"单价";
    [goodprice setFont:[UIFont systemFontOfSize:12]];
    goodprice.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [goodsview addSubview:goodprice];
    
    UILabel *goodnum = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2/3+kWidth/2, 10, kWidth/2, 20)];
    goodnum.text = @"数量";
    [goodnum setFont:[UIFont systemFontOfSize:12]];
    goodnum.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [goodsview addSubview:goodnum];
    
    UILabel *goodtotalprice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2/3+kWidth/2/3+kWidth/2, 10, kWidth/2, 20)];
    goodtotalprice.text = @"价格";
    [goodtotalprice setFont:[UIFont systemFontOfSize:12]];
    goodtotalprice.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
    [goodsview addSubview:goodtotalprice];
    
    tableGoodInfo = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-80-80) style:UITableViewStylePlain];
    tableGoodInfo.delegate = self;
    tableGoodInfo.dataSource = self;
    [self.view addSubview:tableGoodInfo];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    footView.backgroundColor = [UIColor whiteColor];
    tableGoodInfo.tableFooterView = footView;
    tableGoodInfo.tableHeaderView = headView;
    
    UIView *jcview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    [jcview setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [footView addSubview:jcview];
    
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth/2-20, 20)];
    lab1.text = @"就餐方式:";
    [lab1 setFont:[UIFont systemFontOfSize:12]];
    [jcview addSubview:lab1];
    
    btnFoodType = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/2, 10, kWidth/2-20, 20)];
    [btnFoodType setTitle:@"堂食" forState:UIControlStateNormal];
    [btnFoodType setFont:[UIFont systemFontOfSize:12]];
    [btnFoodType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnFoodType setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [jcview addSubview:btnFoodType];
    btnFoodType.tag = 0;
    [btnFoodType addTarget:self action:@selector(btnFoodTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    way = @"1";
    
    
    UIView *shview = [[UIView alloc] initWithFrame:CGRectMake(0, 40+1, kWidth, 40)];
    [shview setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [footView addSubview:shview];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth/2-20, 20)];
    lab2.text = @"上菜方式:";
    [lab2 setFont:[UIFont systemFontOfSize:12]];
    [shview addSubview:lab2];
    
    
    btnSangcaiTime = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/2, 10, kWidth/2-20, 20)];
    [btnSangcaiTime setTitle:@"做好即上" forState:UIControlStateNormal];
    [btnSangcaiTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSangcaiTime setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [btnSangcaiTime setFont:[UIFont systemFontOfSize:12]];
    [shview addSubview:btnSangcaiTime];
    btnSangcaiTime.tag = 1;
    [btnSangcaiTime addTarget:self action:@selector(btnFoodTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    go_goods_way = @"1";
    
    
    UIView *jcnuview = [[UIView alloc] initWithFrame:CGRectMake(0, 40+40+2, kWidth, 40)];
    [jcnuview setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [footView addSubview:jcnuview];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth/2-20, 20)];
    lab3.text = @"就餐人数:";
    [lab3 setFont:[UIFont systemFontOfSize:12]];
    [jcnuview addSubview:lab3];
    
    tfFoodNumber = [[UITextField alloc] initWithFrame:CGRectMake(kWidth/2, 10,  kWidth/2-20, 20)];
    tfFoodNumber.placeholder = @"请输入就餐人数";
    tfFoodNumber.delegate = self;
    [tfFoodNumber setFont:[UIFont systemFontOfSize:12]];
    [jcnuview addSubview:tfFoodNumber];
    
    
    UIView *review = [[UIView alloc] initWithFrame:CGRectMake(0, 40+40+40+3, kWidth, 40)];
    [review setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]];
    [footView addSubview:review];
    
    UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth/2-20, 20)];
    lab4.text = @"菜品备注:";
    [lab4 setFont:[UIFont systemFontOfSize:12]];
    [review addSubview:lab4];
    
    tfFoodResen = [[UITextField alloc] initWithFrame:CGRectMake(kWidth/2, 10,  kWidth/2-20, 20)];
    tfFoodResen.placeholder = @"请输入菜品备注";
    [tfFoodResen setFont:[UIFont systemFontOfSize:12]];
    tfFoodResen.delegate = self;
    [review addSubview:tfFoodResen];
    
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-TabBarHeight-TabbarSafeBottomMargin-80, kWidth, 80)];
    footV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footV];
    
    
    
    labTotalPrice = [UILabel new];
    [footV addSubview:labTotalPrice];
    [labTotalPrice zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.autoWidth();
        layout.heightValue(20);
        layout.rightSpace(10);
        layout.topSpace(5);
    }];
    [labTotalPrice setFont:[UIFont systemFontOfSize:12]];
    [labTotalPrice setTextColor:[UIColor colorWithRed:220.0/255.0 green:20.0/255.0 blue:60.0/255.0 alpha:1]];
    
    
    UILabel *total = [UILabel new];
     [footV addSubview:total];
    [total zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.autoWidth();
        layout.heightValue(20);
        layout.rightSpaceByView(labTotalPrice, 5);
         layout.topSpace(5);
    }];
    [total setFont:[UIFont systemFontOfSize:12]];
    [total setText:@"总价:"];
   
    
    btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, kWidth/2-10-10, 30)];
    [btnAdd setTitle:@"加菜" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAdd setBackgroundColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244.0/255.0 alpha:1]];
    btnAdd.layer.cornerRadius = 5.0;
    [btnAdd setFont:[UIFont systemFontOfSize:12]];
    [footV addSubview:btnAdd];
    [btnAdd addTarget:self action:@selector(addFoodClick) forControlEvents:UIControlEventTouchUpInside];
  
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake( kWidth/2+10, 30, kWidth/2-10-10, 30)];
    [btnSubmit setTitle:@"确认下单" forState:UIControlStateNormal];
    [btnSubmit setFont:[UIFont systemFontOfSize:12]];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    btnSubmit.layer.cornerRadius = 5.0;
    [footV addSubview:btnSubmit];
    [btnSubmit addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)addFoodClick{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)submitClick{
    [self submitOrder];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text{
    [btnFoodType setTitle:text forState:UIControlStateNormal];
}
-(void)btnFoodTypeClick:(UIButton*)btn{
    
    pickV = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-300, kWidth, 300)];
    [self.view addSubview:pickV];
    
    if (btn.tag==0) {
        dateArray = [NSArray arrayWithObjects:@"堂食",@"打包",nil];
    }else{
        dateArray = [NSArray arrayWithObjects:@"做好即上",@"等待叫起",nil];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    [view setBackgroundColor:[UIColor colorWithRed:252.0/255 green:252.0/255 blue:252.0/255 alpha:1]];
    [pickerView addSubview:view];
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 300)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickV addSubview:pickerView];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-50-20, 5, 50, 50)];
    [btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [pickV addSubview: btnClose];
    
    pickV.hidden = NO;
}
-(void)closeBtnClick{
    pickV.hidden = YES;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    return dateArray.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    
    return [dateArray objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    if ([[dateArray objectAtIndex:row] isEqualToString:@"堂食"]) {
         [btnFoodType setTitle:[dateArray objectAtIndex:row] forState:UIControlStateNormal];
        way = @"1";
    }else if ([[dateArray objectAtIndex:row] isEqualToString:@"打包"]){
         [btnFoodType setTitle:[dateArray objectAtIndex:row] forState:UIControlStateNormal];
        way = @"2";
    }else if ([[dateArray objectAtIndex:row] isEqualToString:@"做好即上"]){
         [btnSangcaiTime setTitle:[dateArray objectAtIndex:row] forState:UIControlStateNormal];
        go_goods_way = @"1";
    }else if ([[dateArray objectAtIndex:row] isEqualToString:@"等待叫起"]){
         [btnSangcaiTime setTitle:[dateArray objectAtIndex:row] forState:UIControlStateNormal];
        go_goods_way = @"2";
    }
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
        double longNumber1;
        //如果加菜订单有值需要拼接加菜和原始菜的信息
        if (self.dicdate!=nil) {
            
            NSDictionary *mdic = self.dicdate;
            
            NSDictionary *cardic = [mdic objectForKey:@"cart"];
            longNumber1 = [[cardic objectForKey:@"total_price"] doubleValue];
            NSArray *dateArray = [cardic objectForKey:@"goods_set"];
            for (NSDictionary * dic in dateArray)
            {
                NSString *good_id = [[NSNumber numberWithLong:[ [dic objectForKey:@"good_id"] longValue]] stringValue];
                NSString *pre_price = [[NSNumber numberWithLong:[ [dic objectForKey:@"pre_price"]longValue]] stringValue];
                NSString *good_name = [dic objectForKey:@"good_name"];
                NSString *good_num = [[NSNumber numberWithLong:[[dic objectForKey:@"good_num"]longValue]] stringValue];
                NSString *good_price = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"good_price"]doubleValue]];
                NSString *good_total_price = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"good_total_price"]doubleValue]];
                
                NSString *cart_good_id = [[NSNumber numberWithLong:[[dic objectForKey:@"cart_good_id"]longValue]] stringValue];
                NSString *if_up = [[NSNumber numberWithLong:[[dic objectForKey:@"if_up"]longValue]] stringValue];
                
                GoodInfoModel *model = [[GoodInfoModel alloc] init];
                model.good_id = good_id;
                model.pre_price = pre_price;
                model.good_name = good_name;
                model.good_price = good_price;
                model.good_num = good_num;
                model.good_total_price = good_total_price;
                model.cart_good_id = cart_good_id;
                model.if_up = if_up;
                NSString *ext_size_id = [dic objectForKey:@"ext_size_id"];
                if ([[dic objectForKey:@"ext_size_id"] isEqual:[NSNull null]]) {
                    ext_size_id = @"-100";
                }
                model.ext_size_id = ext_size_id;
                [self.dateArray addObject:model];
            }
        }
        if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
            NSDictionary *dics =[responseObject objectForKey:@"DATA"];
            NSString *total_price = [NSString stringWithFormat:@"￥%.2f",[[dics objectForKey:@"total_price"]doubleValue]];
            //NSString *total_price = [NSString stringWithFormat:@"￥%@",[dics objectForKey:@"total_price"]];
            double lonNum = [[dics objectForKey:@"total_price"] doubleValue];
            double total;
            if (self.dicdate!=nil) {
                total = lonNum+longNumber1;
                labTotalPrice.text = [NSString stringWithFormat:@"￥%.2f",total];
            }else{
                labTotalPrice.text = [NSString stringWithFormat:@"%@",total_price];
            }
            NSArray *dateArray = [dics objectForKey:@"goods_set"];
            for (NSDictionary * dic in dateArray)
            {
                NSString *good_id = [[NSNumber numberWithLong:[ [dic objectForKey:@"good_id"] longValue]] stringValue];
                NSString *pre_price = [[NSNumber numberWithLong:[ [dic objectForKey:@"pre_price"]longValue]] stringValue];
                NSString *good_name = [dic objectForKey:@"good_name"];
                NSString *good_num = [[NSNumber numberWithLong:[[dic objectForKey:@"good_num"]longValue]] stringValue];
                NSString *good_price = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"good_price"]doubleValue]];
                NSString *good_total_price = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"good_total_price"]doubleValue]];
                
                NSString *cart_good_id = [[NSNumber numberWithLong:[[dic objectForKey:@"cart_good_id"]longValue]] stringValue];
                NSString *if_up = [[NSNumber numberWithLong:[[dic objectForKey:@"if_up"]longValue]] stringValue];
                
                GoodInfoModel *model = [[GoodInfoModel alloc] init];
                model.good_id = good_id;
                model.pre_price = pre_price;
                model.good_name = good_name;
                model.good_price = good_price;
                model.good_num = good_num;
                model.good_total_price = good_total_price;
                model.cart_good_id = cart_good_id;
                model.if_up = if_up;
                [self.dateArray addObject:model];
            }
            [tableGoodInfo reloadData];
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


- (void)updateGoodsPrice:(NSString *)carGoid nums:(NSString*)price{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"修改中...";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];

    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,UPDATEGOODSPRICE];
    NSDictionary *parameters = @{@"cart_goods_id": carGoid,
                                 @"price":price
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
            hud.labelText = @"修改成功";
            [hud hide:YES afterDelay:0.5];
            [self.dateArray removeAllObjects];
            [self getShoppingCar];
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

- (void)submitOrder{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,SAVEORDER_URL];
    NSString *reseon;
    if (tfFoodResen.text.length == 0) {
        reseon = @"0";
    }else{
        reseon = tfFoodResen.text;
    }
    NSString *peopocont;
    if (tfFoodNumber.text.length == 0) {
        peopocont = @"0";
    }else{
        peopocont = tfFoodNumber.text;
    }
    
    NSDictionary *parameters = @{@"cart_id": self.cart_id,
                                 @"waiter_id":[userDefaults objectForKey:@"business_id_MX"],
                                 @"comments":reseon,
                                 @"people_count":peopocont,
                                 @"way":way,
                                 @"go_goods_way":go_goods_way
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
            OrderConductViewController *ovc = [[OrderConductViewController alloc] init];
            ovc.table_id = self.table_id;
            ovc.table_name = self.table_name;
            [self.navigationController pushViewController:ovc animated:YES];
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

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tfFoodNumber resignFirstResponder];
    [tfFoodResen resignFirstResponder];
    return YES;
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
    GoodInfoTableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
    if (tabcell==nil) {
        tabcell = [[GoodInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
    }
    tabcell.selectionStyle = UITableViewCellSelectionStyleNone;
    GoodInfoModel *model = self.dateArray[indexPath.section];
    
    tabcell.goodname.text = model.good_name;
    tabcell.goodprice.text = model.good_price;
    tabcell.goodnum.text = [NSString stringWithFormat:@"X%@",model.good_num];;
    tabcell.goodtotalprice.text = [NSString stringWithFormat:@"￥%@",model.good_total_price];
    
    return tabcell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     GoodInfoModel *model = self.dateArray[indexPath.section];
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择操作" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    if ([model.good_name containsString:@"赠"]) {
        return;
    }else{
        [alert addAction:[UIAlertAction actionWithTitle:@"赠菜" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText=@"";
            hud.minSize = CGSizeMake(100.f, 100.f);
            hud.color=[UIColor blackColor];
            NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,SONGGOODS];
            NSDictionary *parameters = @{@"goods_id": model.good_id,
                                         @"num":@"1",
                                         @"ext_id":@"",
                                         @"card_id":self.cart_id,
                                         @"waiter_id":[userDefaults objectForKey:@"business_id_MX"],
                                         @"table_id":self.table_id
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
                    [self.dateArray removeAllObjects];
                    [self getShoppingCar];
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
    }
    
    //在AlertView中添加一个输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入修改的菜品价格";
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = alert.textFields.firstObject;
        
        [self updateGoodsPrice:model.cart_good_id nums:tf.text];
        
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
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
