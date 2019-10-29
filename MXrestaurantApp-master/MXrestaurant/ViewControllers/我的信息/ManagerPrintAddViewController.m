//
//  ManagerPrintAddViewController.m
//  MXrestaurant
//
//  Created by MX on 2018/8/15.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "ManagerPrintAddViewController.h"

@interface ManagerPrintAddViewController()<UITextFieldDelegate,UIScrollViewDelegate> 
{
    MBProgressHUD *hud;
    NSUserDefaults * userDefaults;
    
    UIScrollView *_scrollView;
    UITextField *_tfShopName;
    UITextField *_tfShopPersonName;
    UITextField *_tfShopPersonPhone;
    UITextField *_tfShopAddress;
    UIButton *btnSelect;
    UIButton *btnTcPrint;
    UIButton *btnPrintType;
    
    UIButton *btnSubmit;
    NSString *printType;
    NSString *backPrint;
    NSString *printWay;
    
}
@end

@implementation ManagerPrintAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.printer_id isEqualToString:@"-100"]) {
        self.navigationItem.title = @"添加打印机";
    }else{
        self.navigationItem.title = @"修改打印机";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    userDefaults=[NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view.
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
    [labShopA setText:@"打印机名称"];
    labShopA.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopA];
    
    _tfShopName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10, kWidth-15-80-10-15, 40)];
    _tfShopName.placeholder = @"请输入打印机名称";
    _tfShopName.delegate = self;
    [_tfShopName setTextColor:[UIColor blackColor]];
    _tfShopName.font = [UIFont systemFontOfSize:13];
    _tfShopName.layer.cornerRadius = 3.0;
    _tfShopName.layer.borderWidth = 0.5;
     [_tfShopName setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _tfShopName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_tfShopName setText:self.printer_name];
    [_scrollView addSubview:_tfShopName];
    
    
    UILabel *labShopB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10, 80, 40)];
    [labShopB setText:@"打印机编号"];
    labShopB.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopB];
    
    _tfShopPersonName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10, kWidth-15-80-10-15, 40)];
    _tfShopPersonName.placeholder = @"请输入打印机编号";
    _tfShopPersonName.delegate = self;
    [_tfShopPersonName setTextColor:[UIColor blackColor]];
    _tfShopPersonName.font = [UIFont systemFontOfSize:13];
    _tfShopPersonName.layer.cornerRadius = 3.0;
    _tfShopPersonName.layer.borderWidth = 0.5;
      [_tfShopPersonName setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _tfShopPersonName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_tfShopPersonName setText:self.printer_no];
    [_scrollView addSubview:_tfShopPersonName];
    
    UILabel *labShopC = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50, 80, 40)];
    [labShopC setText:@"打印机KEY"];
    labShopC.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopC];
    
    _tfShopPersonPhone = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+40+10, kWidth-15-80-10-15, 40)];
    _tfShopPersonPhone.placeholder = @"请输入打印机KEY";
    _tfShopPersonPhone.delegate = self;
    [_tfShopPersonPhone setTextColor:[UIColor blackColor]];
    _tfShopPersonPhone.font = [UIFont systemFontOfSize:13];
    _tfShopPersonPhone.layer.cornerRadius = 3.0;
    _tfShopPersonPhone.layer.borderWidth = 0.5;
    [_tfShopPersonPhone setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _tfShopPersonPhone.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    if (![self.key isEqual:[NSNull null]]) {
         [_tfShopPersonPhone setText:self.key];
    }
   
    
    [_scrollView addSubview:_tfShopPersonPhone];
    
    
    if ([self.printer_id isEqualToString:@"-100"]) {
        UILabel *labShopE = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+40+10+50, 80, 40)];
        [labShopE setText:@"打印份数"];
        labShopE.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:labShopE];
        
        printType = @"0";
        _tfShopAddress = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+40+10+50, kWidth-15-80-10-15, 40)];
        _tfShopAddress.placeholder = @"请输入打印份数";
        _tfShopAddress.delegate = self;
        [_tfShopAddress setTextColor:[UIColor blackColor]];
        _tfShopAddress.font = [UIFont systemFontOfSize:13];
        _tfShopAddress.layer.cornerRadius = 3.0;
        _tfShopAddress.layer.borderWidth = 0.5;
        [_tfShopAddress setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _tfShopAddress.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
        [_tfShopAddress setText:self.print_num];
        [_scrollView addSubview:_tfShopAddress];
        
        
        UILabel *labShopF = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+40+10+50+50, 80, 40)];
        [labShopF setText:@"打印类型"];
        labShopF.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:labShopF];
        
        btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+40+10+50+50, kWidth-15-80-10-15, 40)];
        [btnSelect addTarget:self action:@selector(selectOnclick) forControlEvents:(UIControlEventTouchUpInside)];
        [btnSelect setTitle:@"请选择打印类型" forState:UIControlStateNormal];
        btnSelect.font = [UIFont systemFontOfSize:13];
        btnSelect.layer.cornerRadius = 3.0;
        btnSelect.layer.borderWidth = 0.5;
        btnSelect.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
        [btnSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scrollView addSubview:btnSelect];
        if ([self.type_print isEqualToString:@"1"]) {
            [btnSelect setTitle:@"后厨" forState:UIControlStateNormal];
            printType = self.type_print;
        }else if([self.type_print isEqualToString:@"2"]){
            [btnSelect setTitle:@"结账" forState:UIControlStateNormal];
            printType = self.type_print;
        }
        
        
        UILabel *labShopF1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+40+10+50+50+50, 80, 40)];
        [labShopF1 setText:@"退菜打印"];
        labShopF1.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:labShopF1];
        
        btnTcPrint = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+40+10+50+50+50, kWidth-15-80-10-15, 40)];
        [btnTcPrint addTarget:self action:@selector(selectOnclick1) forControlEvents:(UIControlEventTouchUpInside)];
        [btnTcPrint setTitle:@"请选择" forState:UIControlStateNormal];
        btnTcPrint.font = [UIFont systemFontOfSize:13];
        btnTcPrint.layer.cornerRadius = 3.0;
        btnTcPrint.layer.borderWidth = 0.5;
        btnTcPrint.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
        [btnTcPrint setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scrollView addSubview:btnTcPrint];
        
        if ([self.back_good_if_print isEqualToString:@"1"]) {
            [btnTcPrint setTitle:@"是" forState:UIControlStateNormal];
            backPrint = self.back_good_if_print;
        }else if([self.back_good_if_print isEqualToString:@"2"]){
            [btnTcPrint setTitle:@"否" forState:UIControlStateNormal];
            backPrint = self.back_good_if_print;
        }
        
        
        
        UILabel *labShopF22 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+40+10+50+50+50+50, 80, 40)];
        [labShopF22 setText:@"打印类型"];
        labShopF22.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:labShopF22];
        
        btnPrintType = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+40+10+50+50+50+50, kWidth-15-80-10-15, 40)];
        [btnPrintType addTarget:self action:@selector(selectOnclick2) forControlEvents:(UIControlEventTouchUpInside)];
        [btnPrintType setTitle:@"后厨打印方式" forState:UIControlStateNormal];
        btnPrintType.font = [UIFont systemFontOfSize:13];
        btnPrintType.layer.cornerRadius = 3.0;
        btnPrintType.layer.borderWidth = 0.5;
        btnPrintType.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
        [btnPrintType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scrollView addSubview:btnPrintType];
        
    }else{
        UILabel *labShopE = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10, 80, 40)];
        [labShopE setText:@"打印份数"];
        labShopE.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:labShopE];
        
        printType = @"0";
        _tfShopAddress = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10, kWidth-15-80-10-15, 40)];
        _tfShopAddress.placeholder = @"请输入打印份数";
        _tfShopAddress.delegate = self;
        [_tfShopAddress setTextColor:[UIColor blackColor]];
        _tfShopAddress.font = [UIFont systemFontOfSize:13];
        _tfShopAddress.layer.cornerRadius = 3.0;
        [_tfShopAddress setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _tfShopAddress.layer.borderWidth = 0.5;
        _tfShopAddress.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
        [_tfShopAddress setText:self.print_num];
        [_scrollView addSubview:_tfShopAddress];
        
        UILabel *labShopF = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50, 80, 40)];
        [labShopF setText:@"打印类型"];
        labShopF.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:labShopF];
        
        btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50, kWidth-15-80-10-15, 40)];
        [btnSelect addTarget:self action:@selector(selectOnclick) forControlEvents:(UIControlEventTouchUpInside)];
        [btnSelect setTitle:@"请选择打印类型" forState:UIControlStateNormal];
        btnSelect.font = [UIFont systemFontOfSize:13];
        btnSelect.layer.cornerRadius = 3.0;
        btnSelect.layer.borderWidth = 0.5;
        btnSelect.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
        [btnSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scrollView addSubview:btnSelect];
        if ([self.type_print isEqualToString:@"1"]) {
            [btnSelect setTitle:@"后厨" forState:UIControlStateNormal];
            printType = self.type_print;
        }else if([self.type_print isEqualToString:@"2"]){
            [btnSelect setTitle:@"结账" forState:UIControlStateNormal];
            printType = self.type_print;
        }
        
        
        UILabel *labShopF1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50, 80, 40)];
        [labShopF1 setText:@"退菜打印"];
        labShopF1.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:labShopF1];
        
        btnTcPrint = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50, kWidth-15-80-10-15, 40)];
        [btnTcPrint addTarget:self action:@selector(selectOnclick1) forControlEvents:(UIControlEventTouchUpInside)];
        [btnTcPrint setTitle:@"请选择" forState:UIControlStateNormal];
        btnTcPrint.font = [UIFont systemFontOfSize:13];
        btnTcPrint.layer.cornerRadius = 3.0;
        btnTcPrint.layer.borderWidth = 0.5;
        btnTcPrint.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
        [btnTcPrint setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scrollView addSubview:btnTcPrint];
        
        if ([self.back_good_if_print isEqualToString:@"1"]) {
            [btnTcPrint setTitle:@"是" forState:UIControlStateNormal];
            backPrint = self.back_good_if_print;
        }else if([self.back_good_if_print isEqualToString:@"2"]){
            [btnTcPrint setTitle:@"否" forState:UIControlStateNormal];
            backPrint = self.back_good_if_print;
        }
        
        
        
        UILabel *labShopF22 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50, 80, 40)];
        [labShopF22 setText:@"打印类型"];
        labShopF22.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:labShopF22];
        
        btnPrintType = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50, kWidth-15-80-10-15, 40)];
        [btnPrintType addTarget:self action:@selector(selectOnclick2) forControlEvents:(UIControlEventTouchUpInside)];
        [btnPrintType setTitle:@"后厨打印方式" forState:UIControlStateNormal];
        btnPrintType.font = [UIFont systemFontOfSize:13];
        btnPrintType.layer.cornerRadius = 3.0;
        btnPrintType.layer.borderWidth = 0.5;
        btnPrintType.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
        [btnPrintType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scrollView addSubview:btnPrintType];
        
    }
    
    
    if ([self.print_way isEqualToString:@"1"]) {
        [btnPrintType setTitle:@"一菜一打" forState:UIControlStateNormal];
        printWay = self.print_way;
    }else if([self.print_way isEqualToString:@"2"]){
        [btnPrintType setTitle:@"一单一打" forState:UIControlStateNormal];
        printWay = self.print_way;
    }
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(30,  kHeight-30-44-20-10, kWidth-30-30, 30)];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:67.0/255.0 green:136.0/255.0 blue:253.0/255.0 alpha:1]];
    [btnSubmit setFont:[UIFont systemFontOfSize:14]];
    btnSubmit.layer.cornerRadius = 3.0;
    if ([self.printer_id isEqualToString:@"-100"]) {
        [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
        [btnSubmit addTarget:self action:@selector(sumbitClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btnSubmit setTitle:@"修改" forState:UIControlStateNormal];
        [btnSubmit addTarget:self action:@selector(editPrintClick) forControlEvents:UIControlEventTouchUpInside];
        
        labShopB.hidden = YES;
        _tfShopPersonName.hidden = YES;
        labShopC.hidden = YES;
        _tfShopPersonPhone.hidden = YES;
        
    }
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:btnSubmit];
}

-(void)selectOnclick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择打印类型" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"后厨" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        printType = @"1";
        [btnSelect setTitle:@"后厨" forState:UIControlStateNormal];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"结账" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        printType = @"2";
        [btnSelect setTitle:@"结账" forState:UIControlStateNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]] ;
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}


-(void)selectOnclick1{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否退菜打印" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        backPrint = @"1";
        [btnTcPrint setTitle:@"是" forState:UIControlStateNormal];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        backPrint = @"2";
        [btnTcPrint setTitle:@"否" forState:UIControlStateNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]] ;
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
-(void)selectOnclick2{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"后厨打印方式" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"一菜一打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        printWay = @"1";
        [btnPrintType setTitle:@"一菜一打" forState:UIControlStateNormal];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"一单一打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        printWay = @"2";
        [btnPrintType setTitle:@"一单一打" forState:UIControlStateNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]] ;
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
// 新增
-(void)sumbitClick{
    if (_tfShopName.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入打印机名称" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopPersonName.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入打印机编号" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopPersonPhone.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入打印机KEY" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopAddress.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入打印份数" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if ([printType isEqualToString:@"0"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择打印机类型" preferredStyle:  UIAlertControllerStyleAlert];
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
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,PRINTADD];
        NSDictionary *parameters = @{@"printer_name": _tfShopName.text,
                                     @"printer_no": _tfShopPersonName.text,
                                     @"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                                     @"key":_tfShopPersonPhone.text,
                                     @"print_num":_tfShopAddress.text,
                                     @"type_print":printType,
                                     @"printer_way":@"3",
                                     @"page_size":@"58",
                                     @"ip":@"",
                                     @"port":@"",
                                     @"back_good_if_print":backPrint,
                                     @"print_way":printWay
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
// 修改
-(void)editPrintClick{
    if (_tfShopName.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入打印机名称" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopAddress.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入打印份数" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if ([printType isEqualToString:@"0"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择打印机类型" preferredStyle:  UIAlertControllerStyleAlert];
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
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,PRINTUPDATE];
        NSDictionary *parameters = @{@"printer_id":self.printer_id,
                                     @"printer_name": _tfShopName.text,
                                     @"printer_no": _tfShopPersonName.text,
                                     @"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                                     @"key":_tfShopPersonPhone.text,
                                     @"print_num":_tfShopAddress.text,
                                     @"type_print":printType,
                                     @"printer_way":@"3",
                                     @"page_size":@"58",
                                     @"ip":@"",
                                     @"port":@"",
                                     @"back_good_if_print":backPrint,
                                     @"print_way":printWay
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
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tfShopName resignFirstResponder];
     [_tfShopPersonName resignFirstResponder];
     [_tfShopPersonPhone resignFirstResponder];
     [_tfShopAddress resignFirstResponder];
    return YES;
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
