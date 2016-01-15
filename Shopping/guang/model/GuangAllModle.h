//
//  GuangAllModle.h
//  Shopping
//
//  Created by qianfeng on 15/1/14.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuangAllModle : NSObject
/**  收藏  */
@property(nonatomic,copy)NSNumber * favoriteCount;
/**  图片张数  */
@property(nonatomic,copy)NSString * isShow;
/**  赞  */
@property(nonatomic,copy)NSNumber * praiseCount;
/**  标题  */
@property(nonatomic,copy)NSString * title;
/**  详细标题  */
@property(nonatomic,copy)NSString * content;
/**  id  */
//@property(nonatomic,copy)NSString * ID;
/**  图片  */
@property(nonatomic,copy)NSString * imgs;
@end
