
#import "MyTabBar.h"
#import "TabBarButton.h"

#define SCREENT_Main ([UIScreen mainScreen].bounds.size)

@interface MyTabBar ()

// 定义变量记录当前选中的按钮
@property (nonatomic, weak) UIButton *selectBtn;
// 定义变量记录当前选中的按钮标签
@property(nonatomic,weak) UILabel * selectLabel;

@end

@implementation MyTabBar

/**
 *  设置布局
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //解析plist文件
        [self createMyTabbar];
    }
    return self;
}
/**
 *  创建单例
 *
 */
+(instancetype)sharedMyTabBar
{
    static MyTabBar *_sharedMyTabbar;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMyTabbar = [[MyTabBar alloc] initWithFrame: CGRectMake(0, 0, SCREENT_Main.width, 49)];
        _sharedMyTabbar.backgroundColor = [UIColor blackColor];
        
    });
    
    return _sharedMyTabbar;
}
/**
 *  读取plist
 */
- (void)createMyTabbar
{
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/MyTabbar.plist",[[NSBundle mainBundle] resourcePath]]];
    // 创建按钮
    int index = 0;
    for(NSDictionary *itemDict in [plistDict objectForKey:@"items"])
    {
        [self createItemWithItemDict:itemDict andIndex:index andCount:(int)[[plistDict objectForKey:@"items"] count]];
        index++;
    }
}

/**
 *  创建tabBar上的按钮
 *
 *  @param itemDict 每组图片所用到的数组
 *  @param index    第几个按钮
 *  @param count    一共有几个按钮
 */
- (void)createItemWithItemDict:(NSDictionary *)itemDict andIndex:(int)index andCount:(int)count
{
    //背景view
    UIView * baseView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / count * index, 0, SCREEN_WIDTH / count, self.frame.size.height)];
    baseView.userInteractionEnabled = YES;
    [self addSubview:baseView];
    
    
    //设置tabbar的文字标题
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 0.8, SCREEN_WIDTH / count, self.frame.size.height * 0.2 - 5)];
    //label的属性设置
    label.text = [itemDict objectForKey:@"title"];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10.f];
    [baseView addSubview:label];
    
    // 3.1创建按钮
    TabBarButton *btn = [[TabBarButton alloc] init];
    
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH / count, self.frame.size.height * 0.8);
    // 3.2设置按钮上显示的图片
    // 3.2.1设置默认状态图片
    [btn setImage:[UIImage imageNamed:[itemDict objectForKey:@"imagename"]] forState:UIControlStateNormal];
    
    // 3.2.2设置不可用状态图片
    [btn setImage:[UIImage imageNamed:[itemDict objectForKey:@"selectimagename"]] forState:UIControlStateDisabled];
    
    btn.tag = index;
    
    // 3.4添加按钮到自定义TabBar
    [baseView addSubview:btn];
    
    // 3.5监听按钮点击事件
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchDown];
    
    // 3.6设置默认选中按钮
    if(index == 0)
    {
        btn.enabled = NO;
        //记录选中的button
        self.selectBtn = btn;
        //记录选中的label
        self.selectLabel = label;
    }
    
    // 3.7设置按钮高亮状态不调整图片
    btn.adjustsImageWhenHighlighted = NO;
}

/**
 *  按钮点击事件
 *
 *  @param btn 点击的按钮
 */
- (void)btnOnClick:(UIButton *)btn
{
    /** 取得button下对应的label */
    UILabel * label = btn.superview.subviews.firstObject;
    /** 取得button的frame */
    CGRect btnRect = btn.frame;
    /** 得到button的中心，并重新设置 */
    CGPoint center = btn.center;
    center.y = self.frame.size.height * 0.5;
    /** 取得选中按钮的frame */
    CGRect selectBtnRect = CGRectMake(btnRect.origin.x, btnRect.origin.y, btnRect.size.width, self.frame.size.height);
    /** 放大的frame */
    CGRect rect = CGRectMake(btnRect.origin.x - 3, btnRect.origin.y - 3, btnRect.size.width + 6, self.frame.size.height + 3);
    
    // 3.切换子控制器
    // 通知TabBarController切换控制器
    if ([self.delegate respondsToSelector:@selector(tabBarDidSelectBtnFrom:to:)]) {
        [self.delegate tabBarDidSelectBtnFrom:self.selectBtn.tag to:btn.tag];
    }

    // 按钮取消选中动画
    [UIView animateWithDuration:0.5 animations:^{
        self.selectBtn.frame = btnRect;
    }];
    //恢复label的透明度
    self.selectLabel.alpha = 1.0;
    // 0.取消上一次选中的按钮
    self.selectBtn.enabled = YES;

    // 2.记录当前选中的按钮
    /** 缩小 */
    void(^changeMid)(void) = ^{
      [UIView animateWithDuration:0.1 animations:^{
          btn.frame = selectBtnRect;
      }];
    };
    /** 放大 */
    void(^changeSize)(void) = ^{
        [UIView animateWithDuration:0.2 animations:^{
            btn.frame = rect;
        } completion:^(BOOL finished) {
            changeMid();
        }];
    };
    /** 向下移动 */
    [UIView animateWithDuration:0.2 animations:^{
        btn.center = center;
    }completion:^(BOOL finished) {
        // 1.设置当前被点击按钮为选中状态
        btn.enabled = NO;
        changeSize();
    }];
    //设置label的透明度为1
    label.alpha = 0.0;
    //记录选中的button
    self.selectBtn = btn;
    //记录选中的label
    self.selectLabel = label;
    
}
@end
