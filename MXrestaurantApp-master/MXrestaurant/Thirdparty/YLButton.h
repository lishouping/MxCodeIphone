//
//  YLButton.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/6.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YLButton : UIButton
-(UIButton *)customButtonWithFrame:(CGRect)frame title:(NSString *)title rightImage:(UIImage *)image;
-(UIButton *)customButtonWithFrame1:(CGRect)frame title:(NSString *)title rightImage:(UIImage *)image;
-(UIButton *)customButtonWithFrame:(CGRect)frame title:(NSString *)title topImage:(UIImage *)image;
-(UIButton *)customButtonWithFrame:(CGRect)frame title:(NSString *)title bottomImage:(UIImage *)image;
@end
