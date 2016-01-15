//
//  GuangScollerView.m
//  Shopping
//
//  Created by qianfeng on 15/1/12.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "GuangScollerView.h"

#import "GuangScollerViewModel.h"
#import "GuangPointsClassModel.h"

#import "UIImageView+WebCache.h"

/**  图片点击事件tag  */
#define BaseTag 687
/**  view分页控制器  */
#define MinView BoundsWidth * 20 / 32.f + 25
/**  btn点击tag  */
#define CommonTag 765
/** 滚动图片的高 */
#define AdsH BoundsWidth * 20 / 32.f

#define BtnY BoundsWidth * 20 / 32.f + 28
#define BtnW (BoundsWidth / 6.0)
#define btnH 44


@interface GuangScollerView ()<UIScrollViewDelegate>
{
    /**  所有广告数据  */
    NSArray *_allAds;
    void (^_clickAction)(GuangScollerViewModel * model);
    /**  分类数据  */
    NSArray *_allData;
    void (^_ClassAction)(GuangPointsClassModel * model);
    
}
/**  广告界面展示  */
@property(strong , nonatomic) UIScrollView * scrollViewAds;
/**  scollerView上的标题  */
@property(strong , nonatomic) UILabel * labeltext;
/**  分类  */
@property(strong , nonatomic) UIScrollView * scrollViewClass;
/**  定时器  */
@property(strong , nonatomic) NSTimer * timer;
/**  view分页控制  */
@property(strong , nonatomic) UIView * scollViewControl;
/**  全部按钮  */
@property(strong , nonatomic) UIButton * btn;
/**  装按钮的数组  */
@property(strong , nonatomic) NSMutableArray * btnArr;
@end

@implementation GuangScollerView

#pragma mark -----------懒加载------------
/**  view分页控制  */
-(UIView *)scollViewControl
{
    if (_scollViewControl == nil) {
        
        _scollViewControl = [[UIView alloc]init];
        _scollViewControl.frame = CGRectMake(-3, AdsH + 25, (BoundsWidth / 5) + 3, 3);
        _scollViewControl.backgroundColor = [UIColor blueColor];
        _scollViewControl.layer.cornerRadius = 4;
        _scollViewControl.layer.masksToBounds = YES;
        
        [self addSubview:_scollViewControl];
    }
    return _scollViewControl;
}
/**  广告界面展示懒加载  */
-(UIScrollView *)scrollViewAds
{
    if (_scrollViewAds == nil) {
        _scrollViewAds = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labeltext.frame), BoundsWidth, AdsH)];
        _scrollViewAds.pagingEnabled = YES;
        _scrollViewAds.showsHorizontalScrollIndicator = NO;
        _scrollViewAds.showsVerticalScrollIndicator = NO;
        _scrollViewAds.delegate = self;
        _scrollViewAds.bounces = NO;
        
        [self addSubview:_scrollViewAds];
        [self addScrollTimer];
    }
    return _scrollViewAds;
}
/**  分类懒加载  */
-(UIScrollView *)scrollViewClass
{
    if (_scrollViewClass == nil) {
        
        _scrollViewClass = [[UIScrollView alloc]init];
        _scrollViewClass.frame =CGRectMake(BtnW + 1, BtnY, BtnW * 5 - 1, btnH);
        _scrollViewClass.showsHorizontalScrollIndicator = NO;
        _scrollViewClass.showsVerticalScrollIndicator = NO;
        _scrollViewClass.userInteractionEnabled = YES;
        
        [self addSubview:_scrollViewClass];

    }
    return _scrollViewClass;
}
/**  标题视图  */
-(UILabel *)labeltext
{
    if (_labeltext == nil) {
        
        _labeltext = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, BoundsWidth, 25)];
        _labeltext.font = [UIFont systemFontOfSize:10];
        _labeltext.textAlignment = NSTextAlignmentCenter;
        _labeltext.textColor = [UIColor grayColor];
        _labeltext.text = @"-全球最炙手可热的单品 等你来发现哦-";
        
        [self addSubview:_labeltext];
    }
    return _labeltext;
}
#pragma mark -------初始化---------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, BoundsWidth,CGRectGetMaxY(self.scrollViewAds.frame) + 48);
        [self scollViewControl];
        [self scrollViewClass];
        _btnArr = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -------回调-----------
/**  传入所有的广告数据，并提供回调  */
-(void)setAdsData:(NSArray *)allAds ClickCallBack:(void (^)(GuangScollerViewModel *))click
{
//    for (UIView *subView in self.scrollViewAds.subviews) {
//        [subView removeFromSuperview];
//    }
    _allAds = allAds;
    _clickAction = click;
    
    for (int i = 0; i < allAds.count + 2; i++) {
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(BoundsWidth * i, 0, BoundsWidth, CGRectGetHeight(self.scrollViewAds.frame))];
        
        image.userInteractionEnabled = YES;
        GuangScollerViewModel * model = [[GuangScollerViewModel alloc]init];
        if (i == 0) {
            model = allAds.lastObject;
            [image sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"loading"]];
        }else if (i ==  6)
        {
            model = allAds.firstObject;
            [image sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"loading"]];
        }else
        {
            model = allAds[i - 1];
            [image sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"loading"]];
        }
        /**  为图片添加点击事件  */
        [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        image.tag = BaseTag + i;
        
        [self.scrollViewAds addSubview:image];
    }

    self.scrollViewAds.contentSize = CGSizeMake((allAds.count + 2) * BoundsWidth, 0);
    
    [self.scrollViewAds setContentOffset:CGPointMake(CGRectGetWidth(self.scrollViewAds.frame), 0) animated:NO];
}
/**  image点击事件  */
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag - 1 - BaseTag;
    
    if(index == 5)
    {
        index = 0;
    }
    GuangScollerViewModel * model = [_allAds objectAtIndex:index];
    
    if (_clickAction) {
        _clickAction(model);
    }
}
/**  分类数据  */
-(void)setClassData:(NSArray *)allData ClickCallBack:(void (^)(GuangPointsClassModel *))click
{
    [self scrollViewClass];
    _allData = allData;
    _ClassAction = click;
    /**  设置滚动范围  */
    self.scrollViewClass.contentSize = CGSizeMake(BtnW * (allData.count - 1.5), 0);
    
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnY, BtnW, btnH)];
    [_btn setTitle:@"全部" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _btn.titleLabel.font = [UIFont systemFontOfSize:12];
    _btn.tag = 11;
    [_btn addTarget:self action:@selector(pointBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btn.selected = YES;
    [self addSubview:_btn];
    [_btnArr addObject:_btn];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(BtnW, BtnY + 16, 1, 12)];
    view.backgroundColor = [UIColor blackColor];
    [self addSubview:view];
    
    
    
    for (int i = 0; i < allData.count; i++) {
        GuangPointsClassModel * model  = allData[i];
        UIButton * classBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnH * i, 0, BtnW, btnH)];
        [classBtn setTitle:model.name forState:UIControlStateNormal];
        [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [classBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        classBtn.tag = CommonTag + i;
        classBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [classBtn addTarget:self action:@selector(pointBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        if(i != allData.count - 1)
        {
            UIView * pointView = [[UIView alloc] initWithFrame:CGRectMake(BtnW - 1, btnH * 0.5, 1, 1)];
            pointView.backgroundColor = [UIColor blackColor];
            [classBtn addSubview:pointView];
        }
        [self.scrollViewClass addSubview:classBtn];
        [_btnArr addObject:classBtn];
    }
    
}
/**  按钮点击事件  */
-(void)pointBtnClick:(UIButton *)btn
{
    for (UIButton * classBtn in _btnArr) {
        classBtn.selected = NO;
    }
    btn.selected = YES;
    
    
    if (btn.tag == 11) {
        DJLog(@"全部");
        
        self.allBlock(0);
        return;
    }

    NSInteger index = btn.tag - CommonTag;
    
    if (index == _allData.count) {
        index = 0;
    }
    
    GuangPointsClassModel * model = [_allData objectAtIndex:index];
    
    if (_ClassAction) {
        
        _ClassAction(model);
        
    }
    
}

 #pragma mark ----------定时器方法--------
/**  添加计时器  */
-(void)addScrollTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
/**  删除计时器  */
-(void)removeScrollTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
/**  下一页  */
-(void)nextPage
{
    CGPoint point = self.scrollViewAds.contentOffset;
    point.x += CGRectGetWidth(self.scrollViewAds.frame);
    [self.scrollViewAds setContentOffset:point animated:YES];
}
#pragma mark -------UIScollView协议方法

/**  当触摸屏幕时调用该方法  */
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self removeScrollTimer];
}
/**  当手指离开屏幕时调用该方法  */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self addScrollTimer];
    [self scrollViewDidScrollView:scrollView];
}
/** 当有动画执行时调用该方法 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidScrollView:scrollView];
}

/** 滚动页数判断 */
-(void)scrollViewDidScrollView:(UIScrollView *)scrollView
{
    
    NSInteger _page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    if (_page == 0) {
        [self.scrollViewAds setContentOffset:CGPointMake(BoundsWidth * _allAds.count, 0) animated:NO];
        [UIView animateWithDuration:0.5 animations:^{
            self.scollViewControl.frame = CGRectMake(0, MinView, BoundsWidth, 3
);
        }];
        
    }else if (_page == _allAds.count + 1)
    {
        [self.scrollViewAds setContentOffset:CGPointMake(BoundsWidth, 0) animated:NO];
       
        [UIView animateWithDuration:0.5 animations:^{
             self.scollViewControl.frame = CGRectMake(0, MinView, BoundsWidth * 0.2, 3);
        }];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
           self.scollViewControl.frame = CGRectMake(0, MinView, BoundsWidth * (_page / 5.0), 3);
        }];
    }
}
@end
