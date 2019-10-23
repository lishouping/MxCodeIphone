//
//  StatisticalAnalysisViewController.m
//  MXrestaurant
//
//  Created by MX on 2019/10/22.
//  Copyright © 2019年 lishouping. All rights reserved.
//

#import "StatisticalAnalysisViewController.h"
#import "AnalysisTableViewCell.h"

#import "SalesStatisticsViewController.h"
#import "ServiceStatisticsViewController.h"
#import "PushSettingViewController.h"
#import "PrintSettingViewController.h"
#import "ChangePassViewController.h"
#import "FeedBackViewController.h"
#import "AboutUsViewController.h"
#import "PayImageViewController.h"
#import "QRCodeingViewController.h"
#import "ManagerShopViewController.h"
#import "ManagerPrintViewController.h"
#import "ManagerEmployeeViewController.h"
#import "ManagerTableAreaViewController.h"
#import "ManagerTableViewController.h"
#import "ManagerDishClassViewController.h"
#import "ManagerDishViewController.h"
#import "ManagerDishAddViewController.h"
#import "CollectionStatisticsViewController.h"

@interface StatisticalAnalysisViewController (){
    NSUserDefaults * userDefaults;
}

@property(nonatomic,strong)NSMutableArray *dateArray;
@property(nonatomic,strong)NSMutableArray *dateArray2;

@end

@implementation StatisticalAnalysisViewController
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
    // Do any additional setup after loading the view.
    [self makeUI];
    [self createCollection];
    
}

- (void)makeUI{
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.dateArray2 = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([self.myType isEqualToString:@"1"]) {
        self.navigationItem.title = @"统计分析";
        NSArray *array = @[@"销售统计",@"收款统计",@"桌台统计",@"会员统计",@"服务统计"];
        NSArray *arrayimg = @[@"ic_new_1",@"ic_new_15",@"ic_new_4",@"ic_new_14",@"ic_new_9"];
        [self.dateArray addObjectsFromArray:array];
        [self.dateArray2 addObjectsFromArray:arrayimg];
    }else{
        self.navigationItem.title = @"系统设置";
        NSArray *array = @[@"店铺管理",@"打印机设置",@"员工管理",@"桌台分区",@"桌台管理",@"菜品分类",@"菜品管理"];
        NSArray *arrayimg = @[@"ic_new_8",@"ic_new_7",@"ic_new_12",@"ic_new_5",@"ic_new_6",@"ic_new_2",@"ic_new_3"];
        [self.dateArray addObjectsFromArray:array];
        [self.dateArray2 addObjectsFromArray:arrayimg];
    }
}

// 创建Collection
-(void)createCollection{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,20,kWidth, kHeight-20) collectionViewLayout:flowLayout];
    
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    //注册cell和ReusableView（相当于头部）
    [self.collectionView registerClass:[AnalysisTableViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"classifyHeader"];
    
    
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((kWidth-20-20)/3 , 120);
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
    return self.dateArray.count;
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
    AnalysisTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    
    NSString *array = self.dateArray[indexPath.row];
    cell.tabState.text = array;
    [cell.imgeIcon setImage:[UIImage imageNamed:self.dateArray2[indexPath.row]]];
    
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
    NSString *content = self.dateArray[indexPath.row];
    if ([content isEqualToString:@"销售统计"]) {
        SalesStatisticsViewController *atvs = [[SalesStatisticsViewController alloc] init];
        [self.navigationController pushViewController:atvs animated:YES];
    }else if ([content isEqualToString:@"收款统计"]){
        CollectionStatisticsViewController *atvs = [[CollectionStatisticsViewController alloc] init];
        [self.navigationController pushViewController:atvs animated:YES];
    }else if ([content isEqualToString:@"桌台统计"]){
        ServiceStatisticsViewController *atvs = [[ServiceStatisticsViewController alloc] init];
        [self.navigationController pushViewController:atvs animated:YES];
    }else if ([content isEqualToString:@"会员统计"]){
        ServiceStatisticsViewController *atvs = [[ServiceStatisticsViewController alloc] init];
        [self.navigationController pushViewController:atvs animated:YES];
    }else if ([content isEqualToString:@"服务统计"]){
        ServiceStatisticsViewController *atvs = [[ServiceStatisticsViewController alloc] init];
        [self.navigationController pushViewController:atvs animated:YES];
    }else if ([content isEqualToString:@"打印机设置"]){
        ManagerPrintViewController *atvs = [[ManagerPrintViewController alloc] init];
        [self.navigationController pushViewController:atvs animated:YES];
    }else if([content isEqualToString:@"店铺管理"]){
        ManagerShopViewController *mashop = [[ManagerShopViewController alloc] init];
        [self.navigationController pushViewController:mashop animated:YES];
    }else if([content isEqualToString:@"打印机设置"]){
        ManagerShopViewController *mashop = [[ManagerShopViewController alloc] init];
        [self.navigationController pushViewController:mashop animated:YES];
    }else if([content isEqualToString:@"员工管理"]){
        ManagerEmployeeViewController *emvc = [[ManagerEmployeeViewController alloc] init];
        [self.navigationController pushViewController:emvc animated:YES];
    }else if([content isEqualToString:@"桌台分区"]){
        ManagerTableAreaViewController *sv = [[ManagerTableAreaViewController alloc] init];
        [self.navigationController pushViewController:sv animated:YES];
    }else if([content isEqualToString:@"桌台管理"]){
        ManagerTableViewController *mtc = [[ManagerTableViewController alloc] init];
        [self.navigationController pushViewController:mtc animated:YES];
    }else if([content isEqualToString:@"菜品分类"]){
        ManagerDishClassViewController *mcc = [[ManagerDishClassViewController alloc] init];
        [self.navigationController pushViewController:mcc animated:YES];
    }else if([content isEqualToString:@"菜品管理"]){
        ManagerDishViewController *mcc = [[ManagerDishViewController alloc] init];
        [self.navigationController pushViewController:mcc animated:YES];
    }else if([content isEqualToString:@"会员查询"]){
        ManagerDishViewController *mcc = [[ManagerDishViewController alloc] init];
        [self.navigationController pushViewController:mcc animated:YES];
    }
    NSLog(@"=========");
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
