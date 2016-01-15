//
//  GuangScollerView.h
//  Shopping
//
//  Created by qianfeng on 15/1/12.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuangScollerViewModel;
@class GuangPointsClassModel;
@interface GuangScollerView : UIView

/**  传入广告数据，并且提供回调  */
-(void)setAdsData:(NSArray *)allAds ClickCallBack:(void (^) (GuangScollerViewModel * model))click;
/**  传入分类数据，并且提供回调  */
-(void)setClassData:(NSArray *)allData ClickCallBack:(void (^) (GuangPointsClassModel * model))click;

@property(nonatomic,copy)void(^allBlock)(int);
@end
