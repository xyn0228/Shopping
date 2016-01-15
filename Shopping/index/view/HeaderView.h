

#import <UIKit/UIKit.h>
@class HeaderView;

@protocol HeaderViewDelegate <NSObject>

@optional
/** 协议方法 */
-(void)headerView:(HeaderView *)headerView didSelectImageView:(NSInteger)selectedImageView;
@end

@interface HeaderView : UIView

/** 计时器 */
@property(nonatomic,strong) NSTimer * timer;

/** 代理 */
@property(nonatomic ,weak) id <HeaderViewDelegate> delegate;

/** 初始化方法 */
-(instancetype)initWithFrame:(CGRect)frame andWithImageNames:(NSArray *)imageNames;
@end
