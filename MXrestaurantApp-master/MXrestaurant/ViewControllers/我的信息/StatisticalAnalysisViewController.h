//
//  StatisticalAnalysisViewController.h
//  MXrestaurant
//
//  Created by MX on 2019/10/22.
//  Copyright © 2019年 lishouping. All rights reserved.
//

#import "RootViewController.h"

@interface StatisticalAnalysisViewController : RootViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSString *myType;
@end
