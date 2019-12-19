//
//  TableinfoViewController.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/5.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "TableinfoViewController.h"
#import "CollectionViewCell.h"
#import "TableInfoModel.h"
#import "AieaModel.h"
#import "YLButton.h"
#import "ChooseTableViewController.h"
#import "FoodCustomViewController.h"
#import "OrderConductViewController.h"
#import "PayImageViewController.h"
#import "OrderDeatiledViewController.h"
#import "ResViewController.h"
#import "QRCodeingViewController.h"
#import "HWPopTool.h"
#import "ResModel.h"

#import "ChooseClassModel.h"
#import "ResTableViewCell.h"

@interface TableinfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSUserDefaults * userDefaults;
    YLButton *btnTableState;
    YLButton *btnTableClass;
    
    UIView *viewTableState;
    UIView *viewTableClass;
    UIView *viewTable;
    
    UITableView *tableViewChoose;
    // 预定
    UITableView *resTableView;
    UIView *viewResTable;
    
    UIView *headView;
    UIView *headView1;
    UIView *headView2;
    
    MBProgressHUD *hud;
    NSString *curr_table_id;
    NSString *new_table_id;
}
@property(nonatomic,strong)NSMutableArray *tableDateArray;
@property(nonatomic,strong)NSMutableArray *aierDateArray;

// 餐桌状态 餐桌分类
@property(nonatomic,strong)NSMutableArray *dateArray;
// 餐桌订餐
@property(nonatomic,strong)NSMutableArray *resDateArray;
@end

@implementation TableinfoViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [self loadUnreadInform];
    if (self.selectType==nil) {
        //下拉刷新
        [self.collectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
        [self.collectionView headerBeginRefreshing];
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
}
- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    //进入前台时调用此函数
    [self loadUnreadInform];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableDateArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.aierDateArray= [[NSMutableArray alloc] initWithCapacity:0];
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.resDateArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.selectType = nil;
    self.selectClass = nil;
    self.selectContent = nil;
    
    [self makeUI];
    [self createCollection];
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:@"pushnew"
                                               object:nil];
    
   
    userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *title =[userDefaults objectForKey:@"shop_name"];
    self.navigationItem.title = title;
}
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
        [self loadUnreadInform];
    }
    else{//登陆失败加载登陆页面控制器
        NSLog(@"-------------%id",loginSuccess);
        
    }
    
}
-(void)makeUI{
    btnTableState = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnTableState setFont:[UIFont systemFontOfSize:12]];
    [btnTableState customButtonWithFrame:CGRectMake(0, NavBarHeight,kWidth/2, 40) title:@"餐桌状态" rightImage:[UIImage imageNamed:@"nav_icon"]];
    [btnTableState setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnTableState.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    [self.view addSubview:btnTableState];
    [btnTableState addTarget:self action:@selector(tableStateClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    btnTableClass = [YLButton buttonWithType:UIButtonTypeCustom];
    [btnTableClass setFont:[UIFont systemFontOfSize:12]];
    [btnTableClass customButtonWithFrame:CGRectMake(kWidth/2, NavBarHeight,kWidth/2, 40) title:@"餐桌分类" rightImage:[UIImage imageNamed:@"nav_icon"]];
    [btnTableClass setTitleColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnTableClass.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1];
    [self.view addSubview:btnTableClass];
    [btnTableClass addTarget:self action:@selector(tableClassClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self createRightBtn];
    
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [headView setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
    UILabel *labTableViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [labTableViewTitle setText:@"请选择"];
    [labTableViewTitle setFont:[UIFont systemFontOfSize:16]];
    [labTableViewTitle setTextColor:[UIColor whiteColor]];
    labTableViewTitle.textAlignment = UITextAlignmentCenter;
    [headView addSubview:labTableViewTitle];
    
    headView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [headView1 setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
    UILabel *labTableViewTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [labTableViewTitle1 setText:@"预定信息"];
    [labTableViewTitle1 setFont:[UIFont systemFontOfSize:16]];
    [labTableViewTitle1 setTextColor:[UIColor whiteColor]];
    labTableViewTitle1.textAlignment = UITextAlignmentCenter;
    [headView1 addSubview:labTableViewTitle1];
    
    headView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [headView2 setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
    UILabel *labTableViewTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, 40)];
    [labTableViewTitle2 setText:@"请选择意向桌台"];
    [labTableViewTitle2 setFont:[UIFont systemFontOfSize:16]];
    [labTableViewTitle2 setTextColor:[UIColor whiteColor]];
    labTableViewTitle2.textAlignment = UITextAlignmentCenter;
    [headView2 addSubview:labTableViewTitle2];
    
    
    resTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, kHeight-100-100) style:UITableViewStylePlain];
    resTableView.delegate = self;
    resTableView.dataSource = self;
   
    
    
    
    tableViewChoose = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth-20-20, kHeight-100-100) style:UITableViewStylePlain];
    tableViewChoose.delegate = self;
    tableViewChoose.dataSource = self;

    
    
    
    viewTableState = [[UIView alloc] initWithFrame:CGRectMake(20, 100, kWidth-20-20, kHeight-100-100)];
    viewTableState.backgroundColor = [UIColor whiteColor];
   
    
    viewTableClass = [[UIView alloc] initWithFrame:CGRectMake(20, 100, kWidth-20-20, kHeight-100-100)];
    viewTableClass.backgroundColor = [UIColor whiteColor];
    
    viewResTable = [[UIView alloc] initWithFrame:CGRectMake(20, 100, kWidth-20-20, kHeight-100-100)];
    viewResTable.backgroundColor = [UIColor whiteColor];
    
    viewTable = [[UIView alloc] initWithFrame:CGRectMake(20, 100, kWidth-20-20, kHeight-100-100)];
    viewTable.backgroundColor = [UIColor whiteColor];
   
}

- (void)createRightBtn{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"payimg"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        UIBarButtonItem * negativeSpacer=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width=-15;
        self.navigationItem.rightBarButtonItems=@[negativeSpacer,rightBtnItem];
    }
    else
    {
        self.navigationItem.rightBarButtonItem=rightBtnItem;
    }
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"qrbtn"] forState:UIControlStateNormal];
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

-(void)leftButtonClick{
    QRCodeingViewController *qvc = [[QRCodeingViewController alloc] init];
    [self.navigationController pushViewController:qvc animated:YES];
}

-(void)rightBtnButtonClick{
    PayImageViewController *pivc = [[PayImageViewController alloc] init];
    [self.navigationController pushViewController:pivc animated:YES];
}

// 餐桌状态按钮点击事件
-(void)tableStateClick{
    [tableViewChoose reloadData];
    self.selectType = @"1000";
    tableViewChoose.tableHeaderView = headView;
    tableViewChoose.tableFooterView = [[UIView alloc] init];
     [viewTableState addSubview:tableViewChoose];
    [self.dateArray removeAllObjects];
    [tableViewChoose reloadData];
    [self getTableState];
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone	;
    [[HWPopTool sharedInstance] showWithPresentView:viewTableState animated:YES];
}
// 餐桌分类点击事件
-(void)tableClassClick{
    [tableViewChoose reloadData];
    self.selectType = @"2000";
    tableViewChoose.tableHeaderView = headView;
    tableViewChoose.tableFooterView = [[UIView alloc] init];
    [viewTableClass addSubview:tableViewChoose];
    [self.dateArray removeAllObjects];
    [tableViewChoose reloadData];
    [self getTableClass];
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone;
    [[HWPopTool sharedInstance] showWithPresentView:viewTableClass animated:YES];
}
// 创建Collection
-(void)createCollection{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavBarHeight+10+40,kWidth, kHeight-NavBarHeight-10-40) collectionViewLayout:flowLayout];
    
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    //注册cell和ReusableView（相当于头部）
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"classifyHeader"];

   
}
//下拉
- (void)headerRereshing
{
    if (self.tableDateArray.count>0) {
        [self.tableDateArray removeAllObjects];
        [self.collectionView reloadData];
    }
    self.selectType = nil;
    self.selectClass = nil;
    self.selectContent = nil;
    [self loadData];
    
}
-(void)loadData{
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
                NSArray *table_list = [dic objectForKey:@"table_list"];
                AieaModel *airm = [[AieaModel alloc] init];
                airm.area_id = area_id;
                airm.area_name = area_name;
                airm.tableinfo = table_list;
                [self.aierDateArray addObject:airm];
                
                
                
                for (NSDictionary * dictable  in table_list) {
                    
                    NSString *table_status = [[dictable objectForKey:@"table_status"] stringValue];
                    if ([table_status isEqualToString:@"1"]) {
                        TableInfoModel *model = [TableInfoModel new];
                        NSDictionary *orderinfo = [dictable objectForKey:@"order_info"];
                        model.book_list = [dictable objectForKey:@"book_list"];
                        model.table_name = [dictable objectForKey:@"table_name"];
                        model.table_status = [dictable objectForKey:@"table_status"];
                        model.table_id =[dictable objectForKey:@"table_id"];
                        model.order_num = [orderinfo objectForKey:@"order_num"];
                        model.orderstate = [orderinfo objectForKey:@"status"];
                         [self.tableDateArray  addObject:model];
                    }else{
                        TableInfoModel *model = [TableInfoModel new];
                        model.book_list = [dictable objectForKey:@"book_list"];
                        model.table_name = [dictable objectForKey:@"table_name"];
                        model.table_status = [dictable objectForKey:@"table_status"];
                        model.table_id =[dictable objectForKey:@"table_id"];
                         [self.tableDateArray  addObject:model];
                    }
                    
                }
            }
            [self.collectionView reloadData];
            [self.collectionView headerEndRefreshing];
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
- (void)setTableStatesInfo:(NSString *)stateName{
     [self.tableDateArray removeAllObjects];
      [self.collectionView reloadData];
    for (int i=0; i<self.aierDateArray.count; i++) {
        AieaModel *model = self.aierDateArray[i];
        NSString *areaid = model.area_id;
        NSString *areaname = model.area_name;
        NSArray *areaarray = model.tableinfo;
        for (NSDictionary * dic in areaarray){
            NSString *table_name = [dic objectForKey:@"table_name"];
            NSNumber *longNumber = [NSNumber numberWithLong:[[dic objectForKey:@"table_status"] longValue]];
            NSString *table_status = [longNumber stringValue];
            NSString *table_id = [dic objectForKey:@"table_id"];
            
            if (self.selectContent==nil||self.selectClass==nil) {
                if ([stateName isEqualToString:table_status]) {
                    if ([table_status isEqualToString:@"1"]) {
                        TableInfoModel *model = [TableInfoModel new];
                        NSDictionary *orderinfo = [dic objectForKey:@"order_info"];
                        NSString *orderstate = [orderinfo objectForKey:@"status"];
                        NSString *order_num = [orderinfo objectForKey:@"order_num"];
                        
                        model.table_name = table_name;
                        model.table_status = table_status;
                        model.table_id =table_id;
                        model.order_num = order_num;
                        model.orderstate = orderstate;
                        [self.tableDateArray  addObject:model];
                    }else{
                        TableInfoModel *model = [TableInfoModel new];
                        model.table_name = table_name;
                        model.table_status = table_status;
                        model.table_id =table_id;
                        [self.tableDateArray  addObject:model];
                    }
                }
            }else{
                if ([stateName isEqualToString:table_status]&&[areaname isEqualToString:self.selectClass]) {
                    if ([table_status isEqualToString:@"1"]) {
                        TableInfoModel *model = [TableInfoModel new];
                        NSDictionary *orderinfo = [dic objectForKey:@"order_info"];
                        NSString *orderstate = [orderinfo objectForKey:@"status"];
                        NSString *order_num = [orderinfo objectForKey:@"order_num"];
                        
                        model.table_name = table_name;
                        model.table_status = table_status;
                        model.table_id =table_id;
                        model.order_num = order_num;
                        model.orderstate = orderstate;
                        [self.tableDateArray  addObject:model];
                    }else{
                        TableInfoModel *model = [TableInfoModel new];
                        model.table_name = table_name;
                        model.table_status = table_status;
                        model.table_id =table_id;
                        [self.tableDateArray  addObject:model];
                    }
                }
            }
            
        }
        
    }
   
    [self.collectionView reloadData];
    
}

- (void)setTableClassInfo:(NSString *)className{
    [self.tableDateArray removeAllObjects];
    for (int i=0; i<self.aierDateArray.count; i++) {
        AieaModel *model = self.aierDateArray[i];
        NSString *areaid = model.area_id;
        NSString *areaname = model.area_name;
        NSArray *areaarray = model.tableinfo;
        for (NSDictionary * dic in areaarray){
            NSString *table_name = [dic objectForKey:@"table_name"];
            NSNumber *longNumber = [NSNumber numberWithLong:[[dic objectForKey:@"table_status"] longValue]];
            NSString *table_status = [longNumber stringValue];
            NSString *table_id = [dic objectForKey:@"table_id"];
            
            if (self.selectContent==nil||self.selectClass==nil) {
                if ([className isEqualToString:areaname]) {
                    if ([table_status isEqualToString:@"1"]) {
                        TableInfoModel *model = [TableInfoModel new];
                        NSDictionary *orderinfo = [dic objectForKey:@"order_info"];
                        NSString *orderstate = [orderinfo objectForKey:@"status"];
                        NSString *order_num = [orderinfo objectForKey:@"order_num"];
                        
                        model.table_name = table_name;
                        model.table_status = table_status;
                        model.table_id =table_id;
                        model.order_num = order_num;
                        model.orderstate = orderstate;
                        [self.tableDateArray  addObject:model];
                    }else{
                        TableInfoModel *model = [TableInfoModel new];
                        model.table_name = table_name;
                        model.table_status = table_status;
                        model.table_id =table_id;
                        [self.tableDateArray  addObject:model];
                    }
                }
            }else{
                if ([className isEqualToString:areaname]&&[self.selectContent isEqualToString:table_status]) {
                    if ([table_status isEqualToString:@"1"]) {
                        TableInfoModel *model = [TableInfoModel new];
                        NSDictionary *orderinfo = [dic objectForKey:@"order_info"];
                        NSString *orderstate = [orderinfo objectForKey:@"status"];
                        NSString *order_num = [orderinfo objectForKey:@"order_num"];
                        
                        model.table_name = table_name;
                        model.table_status = table_status;
                        model.table_id =table_id;
                        model.order_num = order_num;
                        model.orderstate = orderstate;
                        [self.tableDateArray  addObject:model];
                    }else{
                        TableInfoModel *model = [TableInfoModel new];
                        model.table_name = table_name;
                        model.table_status = table_status;
                        model.table_id =table_id;
                        [self.tableDateArray  addObject:model];
                    }
                }
            }
            
        }
        
    }
    
    [self.collectionView reloadData];
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((kWidth-20-20*3)/4    , (kWidth-20-20*3)/4);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //return UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tableDateArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    TableInfoModel * model = self.tableDateArray[indexPath.row];

    int *tablestate = [model.table_status intValue];
    if (tablestate==0) {//空闲
         cell.tableNum.text = model.table_name;
        cell.tabState.text = @"空闲";
        cell.tableInfoView.layer.borderColor = [[UIColor colorWithRed:255.0/255.0 green:81.0/255.0 blue:93.0/255.0 alpha:1] CGColor];
        cell.tableInfoView.backgroundColor = [UIColor whiteColor];
        
        cell.tableNum.textColor = [UIColor colorWithRed:225.0/255.0 green:81.0/255.0 blue:93.0/255.0 alpha:1];
        cell.tabState.textColor = [UIColor colorWithRed:225.0/255.0 green:81.0/255.0 blue:93.0/255.0 alpha:1];
       
    }else if (tablestate==1){//正在用餐
         cell.tableNum.text = model.table_name;
        cell.tabState.text = @"正在用餐";
        cell.tableInfoView.layer.borderColor = [[UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:107/255.0 alpha:1] CGColor];
        cell.tableInfoView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:107/255.0 alpha:1];
        cell.tableNum.textColor = [UIColor whiteColor];
        cell.tabState.textColor = [UIColor whiteColor];
        
        
        UILongPressGestureRecognizer* longgs=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
        [cell addGestureRecognizer:longgs];//为cell添加手势
        longgs.minimumPressDuration=1.0;//定义长按识别时长
        longgs.view.tag=indexPath.row;//将手势和cell的序号绑定
        
    }else if (tablestate==2){//预定
         cell.tableNum.text = model.table_name;
        cell.tabState.text = @"预定";
        cell.tableInfoView.layer.borderColor = [[UIColor colorWithRed:255.0/255.0 green:156.0/255.0 blue:84.0/255.0 alpha:1] CGColor];
        cell.tableInfoView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:156.0/255.0 blue:84.0/255.0 alpha:1];
        cell.tableNum.textColor = [UIColor whiteColor];
        cell.tabState.textColor = [UIColor whiteColor];
    }else if (tablestate==3){//占用
         cell.tableNum.text = model.table_name;
        cell.tabState.text = @"占用";
        cell.tableInfoView.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:199.0/255.0 blue:134.0/255.0 alpha:1] CGColor];
        cell.tableInfoView.backgroundColor = [UIColor colorWithRed:99.0/255.0 green:199.0/255.0 blue:134.0/255.0 alpha:1];
        cell.tableNum.textColor = [UIColor whiteColor];
        cell.tabState.textColor = [UIColor whiteColor];
    }else if (tablestate==4){//其他
         cell.tableNum.text = model.table_name;
        cell.tabState.text = @"其他";
        cell.tableInfoView.layer.borderColor = [[UIColor colorWithRed:116.0/255.0 green:172.0/255.0 blue:251.0/255.0 alpha:1] CGColor];
        cell.tableInfoView.backgroundColor = [UIColor colorWithRed:116.0/255.0 green:172.0/255.0 blue:251.0/255.0 alpha:1];
        cell.tableNum.textColor = [UIColor whiteColor];
        cell.tabState.textColor = [UIColor whiteColor];
    }

    return cell;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TableInfoModel * model=self.tableDateArray[indexPath.row];
    int *tablestate = [model.table_status intValue];
    int *orderstate = [model.orderstate intValue];
    if (tablestate==0) {
        FoodCustomViewController *fov = [[FoodCustomViewController alloc] init];
        fov.table_id = model.table_id;
        fov.table_name = model.table_name;
        [self.navigationController pushViewController:fov animated:YES];
    }else if (tablestate==1&&orderstate==0){
        OrderConductViewController *ocv = [[OrderConductViewController alloc] init];
        ocv.table_id = model.table_id;
        ocv.table_name = model.table_name;
        [self.navigationController pushViewController:ocv animated:YES];
    }else if (tablestate==1&&orderstate==-1){
        OrderDeatiledViewController *ovc = [[OrderDeatiledViewController alloc] init];
        ovc.order_num = model.order_num;
        ovc.pageflag = @"0";
        [self.navigationController pushViewController:ovc animated:YES];
    }else if (tablestate==2){
        self.selectType = @"4000";
        resTableView.tableFooterView = [[UIView alloc] init];
        resTableView.tableHeaderView = headView1;
        [viewResTable addSubview:resTableView];
        if (self.resDateArray.count>0) {
             [self.resDateArray removeAllObjects];
             [resTableView reloadData];
        }
        for (NSDictionary * dic in model.book_list)
        {
            NSString *use_time = [dic objectForKey:@"use_time"];
            NSString *people_num = [dic objectForKey:@"people_num"];
            NSString *name = [dic objectForKey:@"name"];
            NSString *phone = [dic objectForKey:@"phone"];
            NSString *table_name = [dic objectForKey:@"table_name"];
            NSString *table_id = [dic objectForKey:@"table_id"];
            
            ResModel *resv = [[ResModel alloc] init];
            resv.use_time = use_time;
            resv.people_num = people_num;
            resv.name = name;
            resv.phone = phone;
            resv.table_name = table_name;
            resv.table_id = table_id;
            [self.resDateArray addObject:resv];
        }
        [resTableView reloadData];
        [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
        [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone    ;
        [[HWPopTool sharedInstance] showWithPresentView:viewResTable animated:YES];
        
    
    }
    
    NSLog(@"=========");
}

-(void)longpress:(UILongPressGestureRecognizer*)ges{
     CGPoint pointTouch = [ges locationInView:self.collectionView];
    if(ges.state==UIGestureRecognizerStateBegan){
        //获取目标cell
        //删除操作
        if(self.tableDateArray.count>1){
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
            
            TableInfoModel * model = self.tableDateArray[indexPath.row];
            curr_table_id = model.table_id;
            
            self.selectType = @"3000";
            tableViewChoose.tableFooterView = [[UIView alloc] init];
            tableViewChoose.tableHeaderView = headView2;
            [viewTable addSubview:tableViewChoose];
            [self.dateArray removeAllObjects];
            [tableViewChoose reloadData];
            [self loadChangeData];
            [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
            [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone    ;
            [[HWPopTool sharedInstance] showWithPresentView:viewTable animated:YES];
        }else{
            NSLog(@"---------");
        }
    }
   
}

// 获取徽标上的数字 通知未读条数
-(void)loadUnreadInform{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,GETNOREADNUMBER];
    NSDictionary *parameters = @{@"shop_id": [userDefaults objectForKey:@"shop_id_MX"]};
    
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
        
        NSNumber *longNumber1 = [responseObject objectForKey:@"ORDER_COUNT"];
        NSString *ORDER_COUNT = [longNumber1 stringValue];
        
        NSNumber *longNumber2 = [responseObject objectForKey:@"SERVICE_COUNT"];
        NSString *SERVICE_COUNT = [longNumber2 stringValue];
        
        
        if ([SERVICE_COUNT isEqualToString:@"0"]) {
            UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
            item.badgeValue = nil;
        }else{
            UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
            item.badgeValue=[NSString stringWithFormat:@"%@",SERVICE_COUNT];
        }
        
        if ([ORDER_COUNT isEqualToString:@"0"]) {
            UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
            item.badgeValue = nil;
        }else{
            UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
            item.badgeValue=[NSString stringWithFormat:@"%@",ORDER_COUNT];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
    
}

// 餐桌状态
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
//餐桌分类
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

// 获取餐桌 用于切换
-(void)loadChangeData{
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
                NSArray *table_list = [dic objectForKey:@"table_list"];
                
                for (NSDictionary * dictable  in table_list) {
                    TableInfoModel *model = [TableInfoModel new];
                    model.table_name = [dictable objectForKey:@"table_name"];
                    model.table_status = [dictable objectForKey:@"table_status"];
                    model.table_id =[dictable objectForKey:@"table_id"];
                    [self.dateArray addObject:model];
                }
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

//切换餐桌
- (void)tableChangeData{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"切换中";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];

    NSString *postUrl = [NSString stringWithFormat:@"%@%@",API_URL,CHANGETABLES];
    NSDictionary *parameters = @{@"curr_table_id": curr_table_id,@"new_table_id":new_table_id};
    
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
            hud.labelText = @"换桌成功";
            [hud hide:YES afterDelay:0.5];
            if (self.tableDateArray.count>0) {
                [self.tableDateArray removeAllObjects];
                [self.collectionView reloadData];
            }
            self.selectType = nil;
            self.selectClass = nil;
            self.selectContent = nil;
            [self loadData];
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
// 餐桌状态或者分类列表显示
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.selectType isEqualToString:@"4000"]) {
        return self.resDateArray.count;
    }else{
         return self.dateArray.count;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectType isEqualToString:@"4000"]) {
        return 110.0;
    }else{
        return 40.0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
    if (tabcell==nil) {
        tabcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
    }
    if ([self.selectType isEqualToString:@"3000"]) {
        TableInfoModel *model = self.dateArray[indexPath.section];
        tabcell.textLabel.text = model.table_name;
        [tabcell.textLabel setFont:[UIFont systemFontOfSize:12]];
        tabcell.textLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1];
        tabcell.textLabel.textAlignment = UITextAlignmentCenter;
        tabcell.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1];
         return tabcell;
    }else if([self.selectType isEqualToString:@"2000"]){
        ChooseClassModel *model = self.dateArray[indexPath.section];
        tabcell.textLabel.text = model.tableusename;
        [tabcell.textLabel setFont:[UIFont systemFontOfSize:12]];
        tabcell.textLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1];
        tabcell.textLabel.textAlignment = UITextAlignmentCenter;
        tabcell.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1];
        return tabcell;
    }else if([self.selectType isEqualToString:@"4000"]){
        ResTableViewCell *tabcell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
        if (tabcell==nil) {
            tabcell = [[ResTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
            tabcell.selectionStyle = UITableViewCellStyleDefault;
        }
        ResModel *svm = self.resDateArray[indexPath.section];
        tabcell.labTableNumber.text = [NSString stringWithFormat:@"需求时间:%@",[self timeWithTimeIntervalString:svm.use_time]];
        tabcell.labCreateTime.text = [NSString stringWithFormat:@"预定人:%@",svm.name] ;
        tabcell.labServiceTime.text = [NSString stringWithFormat:@"联系电话:%@",svm.phone] ;
        tabcell.labServiceContent.text = [NSString stringWithFormat:@"餐桌名称:%@",svm.table_name];
        tabcell.labServiceState.text = [NSString stringWithFormat:@"用餐人数:%@",svm.people_num];
        tabcell.btnServiceHander.tag = indexPath.section;
        [tabcell.btnServiceHander addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        return tabcell;
    }
    else{
        ChooseClassModel *model = self.dateArray[indexPath.section];
        tabcell.textLabel.text = model.tableusename;
        [tabcell.textLabel setFont:[UIFont systemFontOfSize:12]];
        tabcell.textLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1];
        tabcell.textLabel.textAlignment = UITextAlignmentCenter;
        tabcell.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1];
        return tabcell;
    }
    return nil;
}
-(void)btnClick:(UIButton *)btn{
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        
    }];
    ResModel *svm = self.resDateArray[btn.tag];
    FoodCustomViewController *fov = [[FoodCustomViewController alloc] init];
    fov.table_id = svm.table_id;
    fov.table_name = svm.table_name;
    [self.navigationController pushViewController:fov animated:YES];
}
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    NSTimeInterval interval    =[timeString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    
    return dateString;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    if ([self.selectType isEqualToString:@"1000"]) {
         ChooseClassModel *model = self.dateArray[indexPath.section];
        [self.tableDateArray removeAllObjects];
        [self.collectionView reloadData];
        self.selectContent = model.tableusename;
        if ([self.selectContent isEqualToString:@"空闲"]) {
            [self setTableStatesInfo:@"0"];
            self.selectContent = @"0";
        }else if ([self.selectContent isEqualToString:@"正在用餐"]){
            [self setTableStatesInfo:@"1"];
            self.selectContent = @"1";
        }else if ([self.selectContent isEqualToString:@"预定"]){
            [self setTableStatesInfo:@"2"];
            self.selectContent = @"2";
        }else if ([self.selectContent isEqualToString:@"占用"]){
            [self setTableStatesInfo:@"3"];
            self.selectContent = @"3";
        }else if ([self.selectContent isEqualToString:@"其他"]){
            [self setTableStatesInfo:@"4"];
            self.selectContent = @"4";
        }
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            
        }];
    }else if ([self.selectType isEqualToString:@"3000"]){
        TableInfoModel *model = self.dateArray[indexPath.section];
        new_table_id = model.table_id;
        [self tableChangeData];
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            
        }];
        
    }else{
         ChooseClassModel *model = self.dateArray[indexPath.section];
         [self.tableDateArray removeAllObjects];
         [self.collectionView reloadData];
         self.selectClass = model.tableusename;
         [self setTableClassInfo:self.selectClass];
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            
        }];
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
