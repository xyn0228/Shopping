//
//  MyNavigationBar.h
//  LimitFree
//
//  Created by Visitor on 15/10/12.
//  Copyright © 2015年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNavigationBar : UIView
- (instancetype)initWithBgImageName:(NSString *)bgImageName andClass:(id)classObject andSEL:(SEL)sel;
@property(nonatomic,strong)NSString *navigationTitle;
@property(nonatomic,strong)UIImageView *navigationTitleView;
@property(nonatomic,strong)NSArray *leftItems;
@property(nonatomic,strong)NSArray *rightItems;
@end






