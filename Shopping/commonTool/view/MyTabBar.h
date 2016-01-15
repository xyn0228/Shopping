
#import <UIKit/UIKit.h>

@protocol MyTabBarDelegate <NSObject>
/**
 *  @param from 从哪个视图(视图索引)
 *  @param to   到哪个视图(视图索引)
 */
- (void)tabBarDidSelectBtnFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface MyTabBar : UIView

@property (nonatomic, weak) id<MyTabBarDelegate> delegate;

+(instancetype)sharedMyTabBar;

@end
