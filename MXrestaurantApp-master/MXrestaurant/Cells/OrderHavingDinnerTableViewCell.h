//
//  OrderHavingDinnerTableViewCell.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/21.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHavingDinnerTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *labServiceNumber;
@property(nonatomic,strong)UILabel *labTableName;
@property(nonatomic,strong)UILabel *labEatchNumber;
@property(nonatomic,strong)UILabel *labWriter;
@property(nonatomic,strong)UILabel *labOrderTime;
@property(nonatomic,strong)UIButton *btnAddFood;
@property(nonatomic,strong)UIButton *btnSubOrder;
@end
