//
//  ManagerDishAddViewController.m
//  MXrestaurant
//
//  Created by MX on 2018/8/21.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "ManagerDishAddViewController.h"
#import "HWPopTool.h"
#import "CategoryModel.h"
#import "TZImagePickerController.h"

@interface ManagerDishAddViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>
{
    MBProgressHUD *hud;
    NSUserDefaults * userDefaults;
    
    UIScrollView *_scrollView;
    UITextField *_tfShopName;
    UITextField *_tfShopPersonName;
    UITextField *_tfShopPersonPhone;
    UITextField *_tfShopAddress;
    UIImageView *imgLogo;
    UIButton *btnSelect;
    
    UIButton *btnSubmit;
    NSString *area_id;
    
    UITableView *tableViewChoose;
    UIView *headView;
    UIView *viewTableState;
    
    NSString *mcategory_id;
    
    UIButton *btnAlLogo;
    
    NSData *mdata ;
}
//餐桌分类
@property(nonatomic,strong)NSMutableArray *dateArray;

@end

@implementation ManagerDishAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    // Do any additional setup after loading the view.
    mcategory_id = @"-1";
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
    [labShopA setText:@"菜品名称"];
    labShopA.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopA];
    
    _tfShopName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10, kWidth-15-80-10-15, 40)];
    _tfShopName.placeholder = @"请输入菜品名称";
    _tfShopName.delegate = self;
    [_tfShopName setTextColor:[UIColor blackColor]];
    _tfShopName.font = [UIFont systemFontOfSize:13];
    _tfShopName.layer.cornerRadius = 3.0;
    _tfShopName.layer.borderWidth = 0.5;
    _tfShopName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopName];
    
    UILabel *labShopF = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10, 80, 40)];
    [labShopF setText:@"菜品分类"];
    labShopF.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopF];
    
    btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10, kWidth-15-80-10-15, 40)];
    [btnSelect addTarget:self action:@selector(selectOnclick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnSelect setTitle:@"请选择菜品分类" forState:UIControlStateNormal];
    btnSelect.font = [UIFont systemFontOfSize:13];
    btnSelect.layer.cornerRadius = 3.0;
    btnSelect.layer.borderWidth = 0.5;
    btnSelect.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [btnSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_scrollView addSubview:btnSelect];
    
    
    UILabel *labShopB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50, 80, 40)];
    [labShopB setText:@"菜品单价"];
    labShopB.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopB];
    
    _tfShopPersonName = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50, kWidth-15-80-10-15, 40)];
    _tfShopPersonName.placeholder = @"请输入菜品单价";
    _tfShopPersonName.delegate = self;
    [_tfShopPersonName setTextColor:[UIColor blackColor]];
    _tfShopPersonName.font = [UIFont systemFontOfSize:13];
    _tfShopPersonName.layer.cornerRadius = 3.0;
    _tfShopPersonName.layer.borderWidth = 0.5;
    _tfShopPersonName.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopPersonName];
    
    UILabel *labShopC = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50, 80, 40)];
    [labShopC setText:@"菜品折扣"];
    labShopC.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopC];
    
    _tfShopPersonPhone = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50, kWidth-15-80-10-15, 40)];
    _tfShopPersonPhone.placeholder = @"请输入菜品折扣";
    _tfShopPersonPhone.delegate = self;
    [_tfShopPersonPhone setTextColor:[UIColor blackColor]];
    _tfShopPersonPhone.font = [UIFont systemFontOfSize:13];
    _tfShopPersonPhone.layer.cornerRadius = 3.0;
    _tfShopPersonPhone.layer.borderWidth = 0.5;
    _tfShopPersonPhone.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopPersonPhone];
    
    UILabel *labShopD = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50, 80, 40)];
    [labShopD setText:@"菜品简介"];
    labShopD.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopD];
    
    _tfShopAddress = [[UITextField alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50, kWidth-15-80-10-15, 40)];
    _tfShopAddress.placeholder = @"请输入菜品简介";
    _tfShopAddress.delegate = self;
    [_tfShopAddress setTextColor:[UIColor blackColor]];
    _tfShopAddress.font = [UIFont systemFontOfSize:13];
    _tfShopAddress.layer.cornerRadius = 3.0;
    _tfShopAddress.layer.borderWidth = 0.5;
    _tfShopAddress.layer.borderColor = [[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1] CGColor];
    [_scrollView addSubview:_tfShopAddress];
    
    
    UILabel *labShopH = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40+10+50+50+50+50, 80, 60)];
    [labShopH setText:@"菜品图片"];
    labShopH.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labShopH];
    
    imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15+80+10, 10+40+10+50+50+50+50, 60, 60)];
    [_scrollView addSubview:imgLogo];
    
    btnAlLogo = [[UIButton alloc] initWithFrame:CGRectMake(15+80+10+60+10, 10+40+10+50+50+50+50, 60, 60)];
    [btnAlLogo addTarget:self action:@selector(selectPic) forControlEvents:UIControlEventTouchUpInside];
    [btnAlLogo setBackgroundColor:[UIColor grayColor]];
    [_scrollView addSubview:btnAlLogo];
    
    
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(30,  kHeight-30-44-20-10, kWidth-30-30, 30)];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:67.0/255.0 green:136.0/255.0 blue:253.0/255.0 alpha:1]];
    btnSubmit.layer.cornerRadius = 3.0;
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnSubmit addTarget:self action:@selector(sumbitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    
  
    
    viewTableState = [[UIView alloc] initWithFrame:CGRectMake(20, 100, kWidth-20-20, kHeight-100-100)];
    viewTableState.backgroundColor = [UIColor whiteColor];
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [headView setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
    UILabel *labTableViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [labTableViewTitle setText:@"请选择菜品分类"];
    [labTableViewTitle setFont:[UIFont systemFontOfSize:16]];
    [labTableViewTitle setTextColor:[UIColor whiteColor]];
    labTableViewTitle.textAlignment = UITextAlignmentCenter;
    [headView addSubview:labTableViewTitle];
    
    tableViewChoose = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, kHeight-100-100) style:UITableViewStylePlain];
    tableViewChoose.delegate = self;
    tableViewChoose.dataSource = self;
    
    
    if ([self.pagetype isEqualToString:@"0"]) {
        //添加
        self.navigationItem.title = @"添加菜品";
    } else if([self.pagetype isEqualToString:@"1"]) {
        //查看
        self.navigationItem.title = @"查看菜品";
        
        _tfShopName.enabled = NO;
        _tfShopAddress.enabled = NO;
        _tfShopPersonName.enabled = NO;
        _tfShopPersonPhone.enabled = NO;
        btnSelect.enabled = NO;
        [btnSubmit setHidden:YES];
        
        [self selectGoods];
    }else{
        self.navigationItem.title = @"修改菜品";
        [self selectGoods];
    }
}
-(void)selectPic{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


//当相片选取完成之后回来到这个函数
//完成后获取图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    NSMutableArray *selectedPhotos = [NSMutableArray arrayWithArray:photos];
    
    
    
    imgLogo.image = selectedPhotos[0];
    
    
    mdata = UIImageJPEGRepresentation(imgLogo.image, 0.5);
    
    
    
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入菜品名称" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if ([mcategory_id isEqualToString:@"-1"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择菜品分类" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopPersonName.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入菜品单价" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else if (_tfShopPersonPhone.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入菜品折扣" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else{
        if ([self.pagetype isEqualToString:@"0"]) {
            //添加
            //开始显示HUD
            hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.minSize = CGSizeMake(100.f, 100.f);
            hud.color=[UIColor blackColor];
            NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,ADDGOODS];
            NSDictionary *parameters = @{
                                         @"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                                         @"category_id": mcategory_id,
                                         @"goods_name": _tfShopName.text,
                                         @"pre_price": _tfShopPersonName.text,
                                         @"discount":_tfShopPersonPhone.text,
                                         @"introduction":_tfShopAddress.text,
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
            
            [manager POST:postUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
        
//                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//                [dictionary setObject:@"multipart/form-data" forKey:@"Content-Type"];
//                [dictionary setObject:[NSNumber numberWithInteger:mdata.length] forKey:@"Content-Length"];
                //[dictionary setObject:@"form-data; name=\"f2\"; filename=\"时钟.zip\"" forKey:@"Content-Disposition"];
                
                //[formData appendPartWithHeaders:dictionary body:mdata];
                
                if(mdata.length>0){
                    [formData appendPartWithFileData:mdata name:@"file" fileName:@"" mimeType:@"image/jpeg"];
                }
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
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
                NSLog(@"error = %@", error);
            }];
            
            
//            [manager POST:postUrl parameters:parameters, success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"结果: %@", responseObject);
//                if ([[responseObject objectForKey:@"CODE"] isEqualToString:@"1000"]) {
//                    hud.labelText = @"成功";
//                    [hud hide:YES afterDelay:0.5];
//                    //说明不是跟视图
//                    [self.navigationController popViewControllerAnimated:NO];
//                }
//                else
//                {
//                    hud.labelText = @"失败";
//                    [hud hide:YES afterDelay:0.5];
//
//                }
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                hud.labelText = @"网络连接异常";
//                [hud hide:YES afterDelay:0.5];
//                NSLog(@"Error: ==============%@", error);
//            }];
            
            
            
        } else if([self.pagetype isEqualToString:@"2"]) {
            //修改
            //开始显示HUD
            hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.minSize = CGSizeMake(100.f, 100.f);
            hud.color=[UIColor blackColor];
            NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,ADDGOODS];
            NSDictionary *parameters = @{
                                         @"good_id":self.goods_id,
                                         @"shop_id":[userDefaults objectForKey:@"shop_id_MX"],
                                         @"category_id": mcategory_id,
                                         @"goods_name": _tfShopName.text,
                                         @"pre_price": _tfShopPersonName.text,
                                         @"discount":_tfShopPersonPhone.text,
                                         @"Introduction":_tfShopAddress.text,
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
            [manager POST:postUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                
                //                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                //                [dictionary setObject:@"multipart/form-data" forKey:@"Content-Type"];
                //                [dictionary setObject:[NSNumber numberWithInteger:mdata.length] forKey:@"Content-Length"];
                //[dictionary setObject:@"form-data; name=\"f2\"; filename=\"时钟.zip\"" forKey:@"Content-Disposition"];
                
                //[formData appendPartWithHeaders:dictionary body:mdata];
                
                if(mdata.length>0){
                    [formData appendPartWithFileData:mdata name:@"file" fileName:@"" mimeType:@"image/jpeg"];
                }
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
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
                NSLog(@"error = %@", error);
            }];
        }
        
        
    }
    
    
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
            
            NSArray *mdateArray = [responseObject objectForKey:@"DATA"];
            for (NSDictionary * dic in mdateArray)
            {
                NSNumber *cnm =  [dic objectForKey:@"category_id"];
                NSString *category_id = [cnm stringValue];
                
                NSString *category_name = [dic objectForKey:@"category_name"];
                NSString *category_status = [dic objectForKey:@"category_status"];
                
                CategoryModel *mo = [[CategoryModel alloc] init];
                mo.category_id =category_id;
                mo.category_name =category_name;
                mo.category_status =category_status;
                
                [self.dateArray addObject:mo];
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

- (void)selectGoods{
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,SELECTGOODS];
    NSDictionary *parameters = @{@"goods_id": self.goods_id};
    
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
            
           NSDictionary  *dic = [responseObject objectForKey:@"DATA"];
            
            NSNumber *cnum = [dic objectForKey:@"category_id"];
            NSString *category_id = [cnum stringValue];
            mcategory_id = category_id;
            NSString *goods_name = [dic objectForKey:@"goods_name"];
            NSString *pre_price = [[NSNumber numberWithLong:[ [dic objectForKey:@"pre_price"]longValue]] stringValue];
            NSNumber *dcon = [dic objectForKey:@"discount"];
            NSString *discount = [dcon stringValue];
            NSString *img_url = [dic objectForKey:@"img_url"];
            NSString *introduction = [dic objectForKey:@"introduction"];
            
            [_tfShopName setText:goods_name];
            [_tfShopPersonName setText:pre_price];
            [_tfShopPersonPhone setText:discount];
            [_tfShopAddress setText:introduction];
            [btnSelect setTitle:self.category_name forState:UIControlStateNormal];
            
       
            
            
            NSString *img = [NSString stringWithFormat:@"%@/%@",RESOURCE_URL,img_url];
            NSURL *icon_img = [[NSURL alloc] initWithString:img];
            [imgLogo sd_setImageWithURL:icon_img placeholderImage:[UIImage imageNamed:@"icon"]];
            
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
    CategoryModel *model = [self.dateArray objectAtIndex:indexPath.section];
    
    tabcell.textLabel.text = model.category_name;
    
    
    return tabcell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryModel *model = self.dateArray[indexPath.section];
    [btnSelect setTitle:model.category_name forState:UIControlStateNormal];
    mcategory_id = model.category_id;
    
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        
    }];
}


@end
