//
//  TableinfoViewController.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/5.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "RootViewController.h"

@interface TableinfoViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *selectType;
@property(nonatomic,strong)NSString *selectContent;
@property(nonatomic,strong)NSString *selectClass;
@property(nonatomic,strong)NSArray *book_list;
@end
