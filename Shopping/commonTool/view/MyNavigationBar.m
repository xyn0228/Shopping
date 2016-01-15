//
//  MyNavigationBar.m
//  LimitFree
//
//  Created by Visitor on 15/10/12.
//  Copyright © 2015年 Visitor. All rights reserved.
//

#import "MyNavigationBar.h"
#import "MyNavitaionItem.h"

@interface MyNavigationBar()
@property(nonatomic,weak) UIView * baseView;
@end

@implementation MyNavigationBar
{
    id _classObject;
    SEL _sel;
}

- (instancetype)initWithBgImageName:(NSString *)bgImageName andClass:(id)classObject andSEL:(SEL)sel
{
    self = [super init];
    if(self)
    {
        _classObject = classObject;
        _sel = sel;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        UIView * baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        baseView.userInteractionEnabled = YES;
        self.baseView = baseView;
        [self addSubview:self.baseView];
    }
    return self;
}

- (void)setNavigationTitle:(NSString *)navigationTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:self.baseView.bounds];
    label.backgroundColor = [UIColor whiteColor];
    label.text = navigationTitle;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    [self.baseView addSubview:label];
}

- (void)setNavigationTitleView:(UIImageView *)navigationTitleView
{
    navigationTitleView.frame = CGRectMake((self.baseView.frame.size.width-navigationTitleView.frame.size.width)/2, (self.baseView.frame.size.height-navigationTitleView.frame.size.height)/2, navigationTitleView.frame.size.width, navigationTitleView.frame.size.height);
    [self.baseView addSubview:navigationTitleView];
}

- (void)setLeftItems:(NSArray *)leftItems
{
    int index = 0;
    float btnX = 0.0f;
    for(MyNavitaionItem *item in leftItems)
    {
        UIImage *image = [UIImage imageNamed:item.itemImageName];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX+10.f, (self.baseView.frame.size.height-image.size.height)/2, image.size.width, image.size.height);
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setTitle:item.itemTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 1000+index;
        [btn addTarget:_classObject action:_sel forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:btn];
                
        btnX = btnX + 10.f + image.size.width;
        index++;
    }
}


- (void)setRightItems:(NSArray *)rightItems
{
    int index = 0;
    float btnX = [[UIScreen mainScreen] bounds].size.width;
    for(MyNavitaionItem *item in rightItems)
    {
        UIImage *image = [UIImage imageNamed:item.itemImageName];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX-10.f-image.size.width, (self.baseView.frame.size.height-image.size.height)/2, image.size.width, image.size.height);
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setTitle:item.itemTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 2000+index;
        [btn addTarget:_classObject action:_sel forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:btn];
        
        btnX = btn.frame.origin.x;
        index++;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
