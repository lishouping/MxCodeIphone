//
//  PayImageViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/25.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "PayImageViewController.h"

@interface PayImageViewController ()<LMJTabDelegate>
{
    NSUserDefaults * userDefaults;
    NSString *selectBtnFlag;
    UIImageView *imgpay;
}
@end

@implementation PayImageViewController
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
    self.navigationItem.title = @"付款二维码";
    userDefaults=[NSUserDefaults standardUserDefaults];
    [self makeUI];
    selectBtnFlag = @"0";
    [self getPayImage];
    // Do any additional setup after loading the view.
}
- (void)makeUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    LMJTab * tab = [[LMJTab alloc] initWithFrame:CGRectMake(10, 10, kWidth-10-10, 30) lineWidth:1 lineColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1]];
    [tab setItemsWithTitle:[NSArray arrayWithObjects:@"微信",@"支付宝", nil] normalItemColor:[UIColor whiteColor] selectItemColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1] normalTitleColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244/255.0 alpha:1] selectTitleColor:[UIColor whiteColor] titleTextSize:15 selectItemNumber:0];
    tab.delegate = self;
    tab.layer.cornerRadius = 5.0;
    [self.view addSubview:tab];
    
    imgpay = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-75, kHeight/2-75, 150, 150)];
    [self.view addSubview:imgpay];
    
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)tab:(LMJTab *)tab didSelectedItemNumber:(NSInteger)number{
    NSLog(@"CLICKED:%ld",number);
    if (number==0) {
        selectBtnFlag = @"0";
        [self getPayImage];
    }else if (number==1){
        selectBtnFlag = @"1";
        [self getPayImage];
    }
}


- (void)getPayImage{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@/%@",API_URL,GETSHOPINFO,[userDefaults objectForKey:@"shop_id_MX"]];
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
            
        
            NSString *wechat_img = [NSString stringWithFormat:@"%@/heygay%@",RESOURCE_URL,[dics objectForKey:@"wechat_img"]];
            NSString *alipay_img = [NSString stringWithFormat:@"%@/heygay%@",RESOURCE_URL,[dics objectForKey:@"alipay_img"]];
            
            
            if ([selectBtnFlag isEqualToString:@"0"]) {
                //微信
                NSURL *url = [[NSURL alloc] initWithString:wechat_img];
                [imgpay sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
            }else{
                //支付宝
                NSURL *url = [[NSURL alloc] initWithString:alipay_img];
                [imgpay sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
            }
            
            
        }
  
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
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
