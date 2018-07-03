//
//  OrderDealWithTableViewCell.h
//  MXrestaurant
//  未处理订单cell
//  Created by lishouping on 2017/11/20.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDealWithTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *labServiceNumber;
@property(nonatomic,strong)UILabel *labTableName;
@property(nonatomic,strong)UILabel *labEatchNumber;
@property(nonatomic,strong)UILabel *labWriter;
@property(nonatomic,strong)UILabel *labOrderTime;
@property(nonatomic,strong)UIButton *btnAddFood;
@property(nonatomic,strong)UIButton *btnSubOrder;
@end
