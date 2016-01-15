//
//  DownLoadManager.h
//  Shopping
//
//  Created by qianfeng on 16/1/11.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadManager : NSObject

/** 下载管理单例 */
+ (DownLoadManager *)sharedDownLoadManager;
/** 添加下载任务 */
-(void)addDownLoadMessageWithRUL:(NSString *)downLoadURL andType:(NSString *)downLoadType;
/** 取得下载数据 */
-(NSMutableArray *)getDownLoadData:(NSString *)downLoadURL;
/**  接收改变的数值  */
@property(nonatomic,assign) int allIndex;
/**  接收改变的ID  */
//@property(nonatomic,copy)NSString * otherIndex;
@property(nonatomic,assign) int allID;

@end
