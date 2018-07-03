//
//  ServiceDetaliedViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/11.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "ServiceDetaliedViewController.h"

@interface ServiceDetaliedViewController ()
{
    NSUserDefaults * userDefaults;
    MBProgressHUD *hud;
}
@end

@implementation ServiceDetaliedViewController
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
    self.navigationItem.title = @"未处理服务";
     userDefaults=[NSUserDefaults standardUserDefaults];
    [self makeUI];
    // Do any additional setup after loading the view.
}
- (void)makeUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    self.labTableNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
//    self.labTableNumber.font = [UIFont systemFontOfSize:15];
//    self.labTableNumber.text = [NSString stringWithFormat:@"桌号:%@",self.table_name];
//    [self.view addSubview:self.labTableNumber];
//
    self.labServiceState = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 170, 20)];
    self.labServiceState.font = [UIFont systemFontOfSize:12];
    self.labServiceState.text = [NSString stringWithFormat:@"服务状态:%@",@"未处理"];
    [self.view addSubview:self.labServiceState];
    
//    self.labSendServiceTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+20, kWidth-10-10, 20)];
//    self.labSendServiceTime.font = [UIFont systemFontOfSize:15];
//    self.labSendServiceTime.text = [NSString stringWithFormat:@"服务时间:%@",self.serviceTime];
//    [self.view addSubview:self.labSendServiceTime];
    
    self.labServiceContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+20, kWidth-10-10, 20)];
    self.labServiceContent.font = [UIFont systemFontOfSize:12];
    self.labServiceContent.text =  [NSString stringWithFormat:@"服务内容:%@",self.content];
    [self.view addSubview:self.labServiceContent];
    
    self.btnServiceHander = [[UIButton alloc] initWithFrame:CGRectMake(10, kHeight-10-30-44-20, kWidth-10-10, 30)];
    [self.btnServiceHander setTitle:@"确认服务" forState:UIControlStateNormal];
    self.btnServiceHander.font = [UIFont systemFontOfSize:12];
    [self.btnServiceHander setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnServiceHander setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    self.btnServiceHander.layer.cornerRadius = 3.0;
    [self.view addSubview:self.btnServiceHander];
    [self.btnServiceHander addTarget:self action:@selector(todoService) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)todoService{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"处理中...";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    
    
    
    //点击按钮的响应事件；
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,TODOSERVICE];
    NSDictionary *parameters = @{@"waiter_id":[userDefaults objectForKey:@"business_id_MX"],
                                 @"service_id":self.service_id,
                                 @"status":@"1"
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
      
            hud.labelText = @"处理成功";
            [hud hide:YES afterDelay:0.5];
            [self.navigationController popViewControllerAnimated:NO];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
