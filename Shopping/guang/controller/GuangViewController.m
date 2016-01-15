//
//  GuangViewController.m
//  Shopping
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "GuangViewController.h"

#import "MyNavitaionItem.h"
#import "MyNavigationBar.h"

#import "GuangScollerView.h"
#import "GuangBeforeTableViewCell.h"

#import "GunagHeaderUrl.h"


#import "GuangScollerViewModel.h"
#import "GuangPointsClassModel.h"
#import "GuangAllModle.h"

@interface GuangViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) MyNavigationBar * bar;
/**
 *  分段控件
 */
@property(strong , nonatomic) UISegmentedControl * segmentHero;
/**
 *  存放第一个界面数据
 */
@property(strong , nonatomic) NSMutableArray * before;
/**
 *  存放第二个界面数据
 */
@property(strong , nonatomic) NSMutableArray * after;
/**  头视图数据源  */
@property(strong , nonatomic) NSMutableArray * hearViewArr;
/**  分类数据源  */
@property(strong , nonatomic) NSMutableArray * poinClassArr;
/**  1视图  */
@property(strong , nonatomic) UITableView * tableBefore;
/**  2视图  */
@property(strong , nonatomic) UITableView * tableAfter;
/**  1像素线  */
@property(strong , nonatomic) UIView * viewImage;
/**  广告视图  */
@property(strong , nonatomic) GuangScollerView * headrView;


@property(nonatomic,assign) BOOL isFresh;


@end

@implementation GuangViewController
/**  全部数据的全局变量  */
 static int allInt = 1;
 static int allIndex = 0;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFresh = YES;
    /**  加载数据  */
    [self loadData];

    
    //解决两个TableView错位的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadMyNavigationBar];
    [self loadNavSegment];
    [self loadTopBtnImage];
    [self.view addSubview:self.tableBefore];
    [self.view addSubview:self.tableAfter];
    [self addDownFresh];
    [self addUpFresh];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _tableBefore.hidden = NO;
    _tableAfter.hidden = YES;
    
    _segmentHero.selectedSegmentIndex = 0;
}
#pragma mark -------- 加载数据 ----------
/**  加载数据  */
-(void)loadData
{
    [self loadScollViewData];
    [self loadPoinClassData];
    [self loadAllData];
}
/**  加载scollView数据  */
-(void)loadScollViewData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadHomePage) name:Guang_ScollView_URL object:nil];
    [[DownLoadManager sharedDownLoadManager] addDownLoadMessageWithRUL:Guang_ScollView_URL andType:Guang_ScollView_URL];
}
/**  加载全部分类数据  */
-(void)loadPoinClassData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadPoinClass) name:Guang_Classification_URL object:nil];
    [[DownLoadManager sharedDownLoadManager] addDownLoadMessageWithRUL:Guang_Classification_URL andType:Guang_Classification_URL];
}

/**  加载全部数据  */
-(void)loadAllData
{
   
    if (self.isFresh == YES) {
        allInt = 1;
    }else
    {
        allInt ++;
    }
    
    NSString * str = [NSString stringWithFormat:Guang_All_URL,allInt,allIndex];
    
    DJLog(@"%@",str);
    [DownLoadManager sharedDownLoadManager].allIndex = allInt;
    [DownLoadManager sharedDownLoadManager].allID = allIndex;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadAllData) name:str object:nil];
    [[DownLoadManager sharedDownLoadManager] addDownLoadMessageWithRUL:str andType:str];

}
/**  获取全部数据  */
-(void)downLoadAllData
{

    NSMutableArray * arr = [[DownLoadManager sharedDownLoadManager] getDownLoadData:[NSString stringWithFormat:Guang_All_URL,allInt,allIndex]];
    
    if (self.isFresh == NO) {
        /**  加一个数组  */
        [self.before addObjectsFromArray:arr];
    }else
    {
       self.before  = [[DownLoadManager sharedDownLoadManager] getDownLoadData:[NSString stringWithFormat:Guang_All_URL,allInt,allIndex]];
    }
        [self endRefreshingReloadData];
}
/**  获取数据  */
-(void)downLoadHomePage
{
    self.hearViewArr = [[DownLoadManager sharedDownLoadManager] getDownLoadData:Guang_ScollView_URL];
    [self.headrView setAdsData:self.hearViewArr ClickCallBack:^(GuangScollerViewModel *model) {
        
    }];
}
/**  获取数据  */
-(void)downLoadPoinClass
{
    self.poinClassArr = [[DownLoadManager sharedDownLoadManager] getDownLoadData:Guang_Classification_URL];
    
    __weak typeof(self) weakSelf = self;
    [self.headrView setClassData:self.poinClassArr ClickCallBack:^(GuangPointsClassModel *model) {
        DJLog(@"%@,%@",model.name,model.ID);
        
        allIndex = model.ID.intValue;
        
        [weakSelf loadAllData];
    }];
}
/**
 *  添加返回顶部按钮
 */
-(void)loadTopBtnImage
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *toTopImage = [UIImage imageNamed:@"arrow"];
    [btn setImage:toTopImage forState:UIControlStateNormal];
    btn.frame = CGRectMake(SCREEN_WIDTH - toTopImage.size.width *1.5 - 10, SCREEN_HEIGHT - 44 - toTopImage.size.height * 1.5, toTopImage.size.height *1.5, toTopImage.size.width * 1.5);
    [self.view addSubview:btn];
}
// 实现返回按钮方法
-(void)pressBtn:(id)sender
{
    if (self.segmentHero.selectedSegmentIndex == 0) {
        [self.tableBefore setContentOffset:CGPointMake(0, 0) animated:YES];
    }else
    {
        [self.tableAfter setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark ---- 懒加载
/**  头视图  */
-(GuangScollerView *)headrView
{
    if (_headrView == nil) {
        _headrView = [[GuangScollerView alloc]init];
        void(^alllBlock)(int) = ^(int ttttt)
        {
            allIndex = ttttt;
            [self loadAllData];
        };
        _headrView.allBlock = alllBlock;
    }
    return _headrView;
}
-(NSMutableArray *)before
{
    if (_before == nil) {
        _before = [[NSMutableArray alloc]init];
    }
    return _before;
}
-(NSMutableArray *)after
{
    if (_after == nil) {
        _after = [[NSMutableArray alloc]init];
    }
    return _after;
}
-(UITableView *)tableBefore
{
    if (_tableBefore == nil) {
        _tableBefore = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
        _tableBefore.delegate = self;
        _tableBefore.dataSource = self;
        _tableBefore.autoresizesSubviews = NO;
        _tableBefore.tableHeaderView = self.headrView;
        // 数据刷新之前，隐藏页面中的表格
        _tableBefore.tableFooterView = [[UIView alloc]init];
        
        [_tableBefore registerNib:[UINib nibWithNibName:@"GuangBeforeTableViewCell" bundle:nil] forCellReuseIdentifier:@"AllCell"];

    }
    return _tableBefore;
}
-(UITableView *)tableAfter
{
    if (_tableAfter == nil) {
        _tableAfter = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT  -44) style:UITableViewStylePlain];
        _tableAfter.delegate = self;
        _tableAfter.backgroundColor = [UIColor grayColor];
        _tableAfter.dataSource = self;
        _tableAfter.autoresizesSubviews = NO;
        _tableAfter.tableFooterView = [[UIView alloc]init];

    }
    return _tableAfter;
}
/**
 *  创建分段控件
 */
-(void)loadNavSegment
{
    UISegmentedControl * seng = [[UISegmentedControl alloc] initWithItems:@[@"全球晒货",@"库大师"]];
    seng.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    seng.selectedSegmentIndex = 0;
    [seng addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    seng.tintColor = [UIColor clearColor];
    NSDictionary * selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]};
    [seng setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    
    NSDictionary * unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor]};
    [seng setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    self.segmentHero = seng;
    [self.bar addSubview:self.segmentHero];
    
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 62, SCREEN_WIDTH * 0.5, 2);
    view.backgroundColor = [UIColor greenColor];
    self.viewImage = view;
    [self.bar addSubview:self.viewImage];
    
}
/**
 *  通过segment实现table切换
 */
-(void)segmentValueChange:(id)sender
{

    UISegmentedControl * segment = (UISegmentedControl *)sender;
    
    if (segment.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.viewImage.frame = CGRectMake(0, 62, SCREEN_WIDTH * 0.5, 2);
        }];

        _tableAfter.hidden = YES;
        _tableBefore.hidden = NO;
        
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
           self.viewImage.frame = CGRectMake(SCREEN_WIDTH * 0.5, 62, SCREEN_WIDTH * 0.5, 2);
        }];
        _tableAfter.hidden = NO;
        _tableBefore.hidden = YES;
    }
    
}
/** 加载导航 */
-(void)loadMyNavigationBar
{
    self.bar = [self createMyNavigationBarWithBgImageName:nil andTitle:nil andTitleView:nil andLeftItems:nil andRightItems:nil andSEL:@selector(btnClick:) andClass:self];
}
/** navigationBar按钮点击方法 */
-(void)btnClick:(UIButton *)btn
{
    
}

#pragma mark ------ UItableViewDelegate协议方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableBefore]) {
        return self.before.count;
    }else
    {
        return 10;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tableBefore]) {
        GuangBeforeTableViewCell * cell = [GuangBeforeTableViewCell cellWithTableView:tableView];
        
        GuangAllModle * model = self.before[indexPath.row];
        
        cell.model = model;
        return cell;

    }else
    {
        static NSString * ID = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 420;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ------ 刷新-----------
/**  结束刷新  */
-(void)endRefreshingReloadData
{
    [self.tableBefore.header endRefreshing];
    [self.tableBefore.footer endRefreshing];
    [self.tableBefore reloadData];
}
/**  下拉刷新  */
-(void)addDownFresh
{
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isFresh = YES;
            [self loadAllData];
        });
    }];
    self.tableBefore.header = header;
}
/**  上拉加载  */
-(void)addUpFresh
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isFresh = NO;
            [self loadAllData];
        });
    }];
    
    self.tableBefore.footer = footer;
}
@end
