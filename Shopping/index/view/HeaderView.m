
#import "HeaderView.h"

#define VIEW_BOUNDS self.bounds.size
#define INTERVAL 5
#define SCROLLVIEW_WIDTH  (_scrollView.frame.size.width)
#define SCROLLVIEW_HEIGHT (_scrollView.frame.size.height)
#define ImageBaseTag 100

@interface HeaderView ()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic,strong) UIPageControl * pageControl;
@property(nonatomic,strong) UIImageView * imageView;
@end

@implementation HeaderView

#pragma mark - 视图加载

/** 初始化 */
-(instancetype)initWithFrame:(CGRect)frame andWithImageNames:(NSArray *)imageNames
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 初始化加载控件 */
        [self loadHeaderViewWithImageNames:imageNames];
    }
    return self;
}
/** 初始化加载控件 */
-(void)loadHeaderViewWithImageNames:(NSArray *)imageNames
{
    /** 加载scrollView控件 */
    [self loadScrollViewWithImageNames:imageNames];
    [self loadPageControl];
    [self addTimer];
}

/** 加载scrollView控件 */
-(void)loadScrollViewWithImageNames:(NSArray *)imageNames
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(INTERVAL, INTERVAL, VIEW_BOUNDS.width - INTERVAL * 2, VIEW_BOUNDS.height - INTERVAL * 2)];
    _scrollView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH * (imageNames.count + 2), SCROLLVIEW_HEIGHT);
    for (int i = 0; i<imageNames.count + 2; i++) {

        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH * i, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];;
        if(i == 0)
        {
            [_imageView sd_setImageWithURL:imageNames.lastObject placeholderImage:[UIImage imageNamed:@"loading"]];
        }
        else if (i == imageNames.count + 1)
        {
            [_imageView sd_setImageWithURL:imageNames.firstObject placeholderImage:[UIImage imageNamed:@"loading"]];
        }
        else
        {
            [_imageView sd_setImageWithURL:imageNames[i - 1] placeholderImage:[UIImage imageNamed:@"loading"]];
        }
        
        _imageView.userInteractionEnabled = YES;
        _imageView.tag = i + ImageBaseTag;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedImageTap:)];
        [_imageView addGestureRecognizer:tap];
        
        [_scrollView addSubview:_imageView];
    }
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
    
    [self addSubview:_scrollView];
}

/** 加载pageControl控件 */
-(void)loadPageControl
{
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(INTERVAL , VIEW_BOUNDS.height - INTERVAL * 4, VIEW_BOUNDS.width - 2 * INTERVAL, 2 * INTERVAL)];
    _pageControl.numberOfPages = _scrollView.subviews.count - 2;
    //pageControl被选中的颜色和没有被选中的颜色的设置
    _pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
    _pageControl.pageIndicatorTintColor = [UIColor clearColor];
    _pageControl.enabled = NO;
    
    [self addSubview:_pageControl];
}

/** 添加定时器 */
-(void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

#pragma mark - 触发事件

/** 跳转到下一张图 */
-(void)nextImage
{
    CGFloat x = _scrollView.contentOffset.x;
    [_scrollView setContentOffset:CGPointMake(x + SCROLLVIEW_WIDTH, 0) animated:YES];
}

/** 移除计时器 */
-(void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
    
}

/** 图片手势点击事件 */
-(void)selectedImageTap:(UITapGestureRecognizer *)tap
{
    if([self.delegate respondsToSelector:@selector(headerView:didSelectImageView:)])
    {
        [self.delegate headerView:self didSelectImageView:tap.view.tag];
    }
}

#pragma mark - 滚动视图的协议方法

/** 当有动画执行时调用该方法 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewJudge:scrollView];
}

/** 当手指离开滚动视图上的操作 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self addTimer];
    [self scrollViewJudge:scrollView];
}

/** 滚动页数判断 */
-(void)scrollViewJudge:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / SCROLLVIEW_WIDTH;
    if(page == _pageControl.numberOfPages + 1)
    {
        [_scrollView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH, 0) animated:NO];
        _pageControl.currentPage = 0;
    }
    else if(page == 0)
    {
        [_scrollView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH * _pageControl.numberOfPages, 0) animated:NO];
        _pageControl.currentPage = _pageControl.numberOfPages - 1;
    }
    else
    {
        _pageControl.currentPage = page - 1;
    }
}

/** 当手指触到滚动视图上的操作 */
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self removeTimer];
}
@end
