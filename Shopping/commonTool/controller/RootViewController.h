//
//  RootViewController.h
//  Shopping
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyNavigationBar;
@interface RootViewController : UIViewController
- (MyNavigationBar *)createMyNavigationBarWithBgImageName:(NSString *)bgImageName andTitle:(NSString *)title andTitleView:(UIImageView *)view andLeftItems:(NSArray *)leftItems andRightItems:(NSArray *)rightItems andSEL:(SEL)sel andClass:(id)classObject;
@end
