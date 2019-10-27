//
//  OrderDeatiledViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/22.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "OrderDeatiledViewController.h"
#import "GoodInfoTableViewCell.h"
#import "GoodInfoModel.h"
#import "FoodCustomViewController.h"
#import "OrderHavingDinnerTableViewCell.h"
#import "OrderUpdateViewController.h"
#import "PayImageViewController.h"
@interface OrderDeatiledViewController ()
<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>{
    UILabel *labOrderNumber;
    UILabel *labTableNumber;
    UILabel *labPersonNumber;
    UILabel *labSubOrderTime;
    UILabel *labReson;
    UILabel *labjsType;
    UILabel *labscType;
    
    UILabel *labTotalPrice;
    
    
    
    UITableView *tableGoodInfo;
    NSUserDefaults * userDefaults;
    
    NSString *order_id;
    NSString *table_id;
    NSString *table_name;
    
    MBProgressHUD *hud;
    
    UIView *footView1;
    UIButton *btnAddFood;
    UIButton *btnCancelOrder;
    UIButton *btnUpdateOrder;
    UIButton *btnSubmitOrder;
    
    UIView *footView2;
    UIButton *btnAdd;
    UIButton *btnSubmit;
    UIView *footView3;
    UIButton *benPrintOrder;
    
    NSDictionary *dicdate;
    
    NSString *check_way;
    
    UIButton *btnAgainSubmitOrder;
    UIButton *btnPrintAgint;
    
    
}
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation OrderDeatiledViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    self.navigationItem.title = @"订单详情";
    
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    // Do any additional setup after loading the view.
    [self makeUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.dateArray.count>0) {
        [self.dateArray removeAllObjects];
    }
    [self getOrder];
    
}
-(void)makeUI{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 180)];
    headView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:244.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:headView];
    
    labOrderNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kWidth-10-10, 20)];
    labOrderNumber.font = [UIFont systemFontOfSize:12];
    [headView addSubview:labOrderNumber];
    
    labTableNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 150, 20)];
    labTableNumber.font = [UIFont systemFontOfSize:12];
    [headView addSubview:labTableNumber];
    
    labPersonNumber = [[UILabel alloc] initWithFrame:CGRectMake(10+150+10, 30, 150, 20)];
    labPersonNumber.font = [UIFont systemFontOfSize:12];
    [headView addSubview:labPersonNumber];
    
    labSubOrderTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, kWidth-10-10, 20)];
    labSubOrderTime.font = [UIFont systemFontOfSize:12];
    [headView addSubview:labSubOrderTime];
    
    labReson = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, kWidth-10-10, 20)];
    labReson.font = [UIFont systemFontOfSize:12];
    [headView addSubview:labReson];
    
    labjsType = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, kWidth-10-10, 20)];
    labjsType.font = [UIFont systemFontOfSize:12];
    [headView addSubview:labjsType];
    
    labscType = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2, 105, kWidth-10-10, 20)];
    labscType.font = [UIFont systemFontOfSize:12];
    [headView addSubview:labscType];
    
    
    
    UIView *goodsview = [[UIView alloc] initWithFrame:CGRectMake(0, 140, kWidth, 40)];
    goodsview.backgroundColor = [UIColor whiteColor];
    [headView addSubview:goodsview];
    
    UILabel *goodname = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth/2, 20)];
    goodname.text = @"菜品信息";
    [goodname setFont:[UIFont systemFontOfSize:12]];
    goodname.textColor = [UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1];
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
    tableGoodInfo.tableFooterView = [[UIView alloc] init];
    
    
    tableGoodInfo.tableHeaderView = headView;
    
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-70-44-20, kWidth, 80)];
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
    [total setFont:[UIFont systemFontOfSize:14]];
    [total setText:@"总价:"];
    
    footView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kWidth, 30)];
    [footV addSubview:footView1];
     footView1.hidden = YES;
    btnAddFood = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, (kWidth-20)/4-5, 30)];
    [btnAddFood setTitle:@"加菜" forState:UIControlStateNormal];
    [btnAddFood setFont:[UIFont systemFontOfSize:14]];
    [btnAddFood setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAddFood setBackgroundColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244.0/255.0 alpha:1]];
    btnAddFood.layer.cornerRadius = 5.0;
    [footView1 addSubview:btnAddFood];
    [btnAddFood addTarget:self action:@selector(addFoodClick) forControlEvents:UIControlEventTouchUpInside];
    
    btnCancelOrder = [[UIButton alloc] initWithFrame:CGRectMake((kWidth-20)/4+10, 0, (kWidth-20)/4-5, 30)];
    [btnCancelOrder setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancelOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancelOrder setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
     [btnCancelOrder setFont:[UIFont systemFontOfSize:14]];
    btnCancelOrder.layer.cornerRadius = 5.0;
    [footView1 addSubview:btnCancelOrder];
    [btnCancelOrder addTarget:self action:@selector(cancelOrderClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnUpdateOrder = [[UIButton alloc] initWithFrame:CGRectMake((kWidth-20)/4+10+(kWidth-20)/4, 0,(kWidth-20)/4-5, 30)];
    [btnUpdateOrder setTitle:@"修改" forState:UIControlStateNormal];
    [btnUpdateOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnUpdateOrder setBackgroundColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244.0/255.0 alpha:1]];
    btnUpdateOrder.layer.cornerRadius = 5.0;
    [footView1 addSubview:btnUpdateOrder];
    [btnUpdateOrder setFont:[UIFont systemFontOfSize:14]];
    [btnUpdateOrder addTarget:self action:@selector(updateOrderClick) forControlEvents:UIControlEventTouchUpInside];
    
    btnSubmitOrder = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-10-((kWidth-20)/4), 0, (kWidth-20)/4-5, 30)];
    [btnSubmitOrder setTitle:@"下单" forState:UIControlStateNormal];
    [btnSubmitOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmitOrder setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    btnSubmitOrder.layer.cornerRadius = 5.0;
    [btnSubmitOrder setFont:[UIFont systemFontOfSize:14]];
    [footView1 addSubview:btnSubmitOrder];
    [btnSubmitOrder addTarget:self action:@selector(submitOrderClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    footView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kWidth, 30)];
    [footV addSubview:footView2];
    footView2.hidden = YES;
    
    btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, (kWidth-20)/4-5, 30)];
    [btnAdd setTitle:@"加菜" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAdd setBackgroundColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244.0/255.0 alpha:1]];
    btnAdd.layer.cornerRadius = 5.0;
    [btnAdd setFont:[UIFont systemFontOfSize:14]];
    [footView2 addSubview:btnAdd];
    [btnAdd addTarget:self action:@selector(addFoodClick) forControlEvents:UIControlEventTouchUpInside];
    
    btnAgainSubmitOrder = [[UIButton alloc] initWithFrame:CGRectMake((kWidth-20)/4+10, 0, (kWidth-20)/4-5, 30)];
    [btnAgainSubmitOrder setTitle:@"重新下单" forState:UIControlStateNormal];
    [btnAgainSubmitOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAgainSubmitOrder setBackgroundColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244.0/255.0 alpha:1]];
    btnAgainSubmitOrder.layer.cornerRadius = 5.0;
    [btnAgainSubmitOrder setFont:[UIFont systemFontOfSize:14]];
    [footView2 addSubview:btnAgainSubmitOrder];
    [btnAgainSubmitOrder addTarget:self action:@selector(againOrder) forControlEvents:UIControlEventTouchUpInside];
    
    btnPrintAgint = [[UIButton alloc] initWithFrame:CGRectMake((kWidth-20)/4+10+(kWidth-20)/4, 0, (kWidth-20)/4-5, 30)];
    [btnPrintAgint setTitle:@"打印订单" forState:UIControlStateNormal];
    [btnPrintAgint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnPrintAgint setBackgroundColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244.0/255.0 alpha:1]];
    btnPrintAgint.layer.cornerRadius = 5.0;
    [btnPrintAgint setFont:[UIFont systemFontOfSize:14]];
    [footView2 addSubview:btnPrintAgint];
    [btnPrintAgint addTarget:self action:@selector(printOrderAgain) forControlEvents:UIControlEventTouchUpInside];
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake( kWidth-10-((kWidth-20)/4), 0, (kWidth-20)/4-5, 30)];
    [btnSubmit setTitle:@"结账" forState:UIControlStateNormal];
    [btnSubmit setFont:[UIFont systemFontOfSize:14]];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    btnSubmit.layer.cornerRadius = 5.0;
    [footView2 addSubview:btnSubmit];
    [btnSubmit addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    footView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kWidth, 30)];
    [footV addSubview:footView3];
    
    benPrintOrder = [[UIButton alloc] initWithFrame:CGRectMake( kWidth/2+10, 0, kWidth/2-10-10, 30)];
    [benPrintOrder setTitle:@"打印订单" forState:UIControlStateNormal];
    [benPrintOrder setFont:[UIFont systemFontOfSize:14]];
    [benPrintOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [benPrintOrder setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    benPrintOrder.layer.cornerRadius = 5.0;
    [footView3 addSubview:benPrintOrder];
    [benPrintOrder addTarget:self action:@selector(printClick) forControlEvents:UIControlEventTouchUpInside];
     footView3.hidden = YES;
    
    if ([self.pageflag isEqualToString:@"0"]) {
         footView1.hidden = NO;
    }else if ([self.pageflag isEqualToString:@"1"]){
         footView2.hidden = NO;
    }else if ([self.pageflag isEqualToString:@"2"]){
         footView3.hidden = NO;
    }
    
    
}
-(void)addFoodClick{
    FoodCustomViewController *fv = [[FoodCustomViewController alloc] init];
    fv.isinitres = @"1";
    fv.table_id = table_id;
    fv.table_name = table_name;
    fv.dicdate = dicdate;
    [self.navigationController pushViewController:fv animated:YES];
}
// 取消订单
-(void)cancelOrderClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要取消订单吗?" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancelOrder];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"---");
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
// 打印订单
-(void)printClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要打印订单吗?" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self printOrder];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"---");
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//更新订单
-(void)updateOrderClick{
    OrderUpdateViewController *ouv = [[OrderUpdateViewController alloc] init];
    ouv.mydic = dicdate;
    [self.navigationController pushViewController:ouv animated:YES];
}
//提交订单
-(void)submitOrderClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要提交订单吗?" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self subOrder];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"---");
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}


// 根据订单号取订单详情信息
- (void)getOrder{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,GETORDERBYNO];
    NSDictionary *parameters = @{@"order_num": self.order_num
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
            
            dicdate = dics;
            
            NSString *comments = [dics objectForKey:@"comments"];
            if ([comments isEqual:[NSNull null]]) {
                labReson.text = [NSString stringWithFormat:@"%@",@"备注:无"];
            }else{
                labReson.text = [NSString stringWithFormat:@"备注:%@",comments];
            }
            
            order_id = [dics objectForKey:@"order_id"];
            
            NSString *order_num = [dics objectForKey:@"order_num"];
            [labOrderNumber setText:[NSString stringWithFormat:@"订单编号:%@",order_num]];
            
            NSDictionary *tableDic = [dics objectForKey:@"table"];
            
            table_id = [tableDic objectForKey:@"table_id"];
            table_name = [tableDic objectForKey:@"table_name"];
            [labTableNumber setText:[NSString stringWithFormat:@"桌号:%@",table_name]];
            
            NSString *people_count = [[NSNumber numberWithLong:[[dics objectForKey:@"people_count"]longValue]] stringValue];
            [labPersonNumber setText:[NSString stringWithFormat:@"用餐人数:%@",people_count]];
            
            NSString *way = [[NSNumber numberWithLong:[[dics objectForKey:@"way"]longValue]] stringValue];
            if ([way isEqualToString:@"1"]) {
                [labjsType setText:[NSString stringWithFormat:@"就餐方式:堂食"]];
            }else{
                [labjsType setText:[NSString stringWithFormat:@"就餐方式:打包"]];
            }
            NSString *go_goods_way = [[NSNumber numberWithLong:[[dics objectForKey:@"go_goods_way"]longValue]] stringValue];
            
            if ([go_goods_way isEqualToString:@"1"]) {
                [labscType setText:[NSString stringWithFormat:@"上菜方式:做好即上"]];
            }else{
                [labscType setText:[NSString stringWithFormat:@"上菜方式:等待叫起"]];
            }
            
            NSString *order_time = [dics objectForKey:@"create_time"];
            
            [labSubOrderTime setText:[NSString stringWithFormat:@"下单时间:%@",[self timeWithTimeIntervalString:order_time]]];
            
            NSDictionary *cardic = [dics objectForKey:@"cart"];
            
            NSString *total_price = [cardic objectForKey:@"total_price"];
            [labTotalPrice setText:[NSString stringWithFormat:@"%@元",total_price]];
            
            
            
            NSArray *dateArray = [cardic objectForKey:@"goods_set"];
            for (NSDictionary * dic in dateArray)
            {
                
                
                NSString *good_id = [[NSNumber numberWithLong:[ [dic objectForKey:@"good_id"] longValue]] stringValue];
                NSString *pre_price = [[NSNumber numberWithLong:[ [dic objectForKey:@"pre_price"]longValue]] stringValue];
                NSString *good_name = [dic objectForKey:@"good_name"];
                NSString *good_price = [NSString stringWithFormat:@"%.1f",[[dic objectForKey:@"good_price"]doubleValue]];
                NSString *good_num = [[NSNumber numberWithLong:[[dic objectForKey:@"good_num"]longValue]] stringValue];
                NSString *good_total_price = [NSString stringWithFormat:@"%.1f",[[dic objectForKey:@"good_total_price"]doubleValue]];
                
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


//结账
-(void)submitClick{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择付款方式"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"现金", @"微信",@"支付宝",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (![[actionSheet buttonTitleAtIndex:buttonIndex ] isEqualToString:@"取消"]) {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex ] isEqualToString:@"现金"]) {
            check_way = @"1";
        }else if ([[actionSheet buttonTitleAtIndex:buttonIndex ] isEqualToString:@"微信"]){
            check_way = @"2";
        }else if ([[actionSheet buttonTitleAtIndex:buttonIndex ] isEqualToString:@"支付宝"]){
            check_way = @"3";
        }
        [self check];
    }
}



-(void)check{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,CHECK_URL];
    NSDictionary *parameters = @{@"order_id": order_id,
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
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                PayImageViewController *pivc = [[PayImageViewController alloc] init];
                [self.navigationController pushViewController:pivc animated:YES];
            }
        }
        
        else
        {
            hud.labelText =[responseObject objectForKey:@"MESSAGE"];
            [hud hide:YES afterDelay:0.5];
            if ([check_way isEqualToString:@"1"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                PayImageViewController *pivc = [[PayImageViewController alloc] init];
                [self.navigationController pushViewController:pivc animated:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}


// 取消订单
-(void)cancelOrder{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,CANCELORDER_URL];
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
            hud.labelText =[responseObject objectForKey:@"MESSAGE"];
            [hud hide:YES afterDelay:0.5];
            [self.navigationController popViewControllerAnimated:NO];
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
// 服务员确认下单
-(void)subOrder{
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
            hud.labelText = [responseObject objectForKey:@"MESSAGE"];
            [hud hide:YES afterDelay:0.5];
            [self.navigationController popViewControllerAnimated:NO];
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
-(void)printOrder{
    
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
            hud.labelText =[responseObject objectForKey:@"MESSAGE"];
            [hud hide:YES afterDelay:0.5];
             [self.navigationController popViewControllerAnimated:NO];
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
    
    if ([model.if_up isEqualToString:@"1"]) {
        tabcell.goodname.text = [NSString stringWithFormat:@"%@(已上菜)",model.good_name] ;
    }
    
    tabcell.goodprice.text = model.good_price;
    tabcell.goodnum.text = [NSString stringWithFormat:@"X%@",model.good_num];;
    tabcell.goodtotalprice.text = [NSString stringWithFormat:@"￥%@",model.good_total_price];
    
    return tabcell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodInfoModel *model = self.dateArray[indexPath.section];
    
    
    
    if ([self.pageflag isEqualToString:@"0"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"减菜" message:nil preferredStyle:  UIAlertControllerStyleAlert];
        //在AlertView中添加一个输入框
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入要减少的数量";
        }];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tf = alert.textFields.firstObject;
            
            hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText=@"减菜中...";
            hud.minSize = CGSizeMake(100.f, 100.f);
            hud.color=[UIColor blackColor];
            NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,REMGOODS];
            NSDictionary *parameters;
            if ([model.ext_size_id isEqualToString:@"-100"]) {
                parameters = @{@"order_num":self.order_num,
                               @"goods_id":model.good_id,
                               @"num":tf.text
                               };
            }else{
                parameters = @{@"order_num":self.order_num,
                               @"goods_id":model.good_id,
                               @"num":tf.text,
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
                    hud.labelText = @"操作成功";
                    [hud hide:YES afterDelay:0.5];
                    
                    [self.dateArray removeAllObjects];
                    [self getOrder];
                }
                
                else
                {
                    hud.labelText = @"失败";
                    [hud hide:YES afterDelay:0.5];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: ==============%@", error);
            }];
            
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
        
        
        
    }else if ([self.pageflag isEqualToString:@"1"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择一个操作" message:nil preferredStyle:  UIAlertControllerStyleAlert];
        
        
        [alert addAction:[UIAlertAction actionWithTitle:@"退菜" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退菜" message:nil preferredStyle:  UIAlertControllerStyleAlert];
            //在AlertView中添加一个输入框
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入退菜数量";
            }];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入退菜价格";
            }];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *tf = alert.textFields.firstObject;
                UITextField *tf1 = alert.textFields.lastObject;
                
                
                hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.labelText=@"退菜中...";
                hud.minSize = CGSizeMake(100.f, 100.f);
                hud.color=[UIColor blackColor];
                NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,RETURNGOODS];
                NSDictionary *parameters;
                if ([model.ext_size_id isEqualToString:@"-100"]) {
                    parameters = @{@"cart_goods_id": model.cart_good_id,
                                   @"num":tf.text,
                                   @"price":tf1.text
                                   };
                }else{
                    parameters = @{@"cart_goods_id": model.cart_good_id,
                                   @"num":tf.text,
                                   @"price":tf1.text,
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
                        hud.labelText = @"退菜成功";
                        [hud hide:YES afterDelay:0.5];
                        
                        [self.dateArray removeAllObjects];
                        [self getOrder];
                    }
                    
                    else
                    {
                        hud.labelText = @"退菜失败";
                        [hud hide:YES afterDelay:0.5];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"Error: ==============%@", error);
                }];
                
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"划菜" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText=@"划菜中...";
            hud.minSize = CGSizeMake(100.f, 100.f);
            hud.color=[UIColor blackColor];
            NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,GOODSUPDATE];
            NSDictionary *parameters = @{@"cart_goods_id": model.cart_good_id
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
                    hud.labelText = @"划菜成功";
                    [hud hide:YES afterDelay:0.5];
                    
                    [self.dateArray removeAllObjects];
                    [self getOrder];
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
    }else if ([self.pageflag isEqualToString:@"2"]){
        
    }
    
    
    
}
// 重新下单
-(void)againOrder{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"下单中...";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,ORDERREPRINT];
    NSDictionary *parameters;
    parameters = @{@"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                   @"order_id":order_id
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
            //说明不是跟视图
            [self.navigationController popViewControllerAnimated:NO];
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
// 打印订单
-(void)printOrderAgain{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"打印中...";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,ORDERPRINT];
    NSDictionary *parameters;
    parameters = @{@"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                   @"order_id":order_id
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
            //说明不是跟视图
            [self.navigationController popViewControllerAnimated:NO];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
