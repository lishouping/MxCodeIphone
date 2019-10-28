//
//  QRCodeingViewController.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/5.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "RootViewController.h"

@interface QRCodeingViewController : RootViewController
/**
 * pageType 0 表示扫码点餐
 * pageType 1 表示微信支付扫码付款
 * pageType 2 表示支付宝支付扫码付款
 */
@property(nonatomic,strong)NSString *pageType;
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic,strong)NSString *totalPrice;
@property(nonatomic,strong)NSString *client_no;
@property(nonatomic,strong)NSString *checkWay;
@end
