//
//  DownLoad.h
//  Shopping
//
//  Created by qianfeng on 16/1/11.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DownLoad;
/** 网络下载协议 */
@protocol DownLoadDelegate <NSObject>

-(void)downLoadFinishWithDownLoad:(DownLoad *)downLoad;

@end

@interface DownLoad : NSObject

/** 下载网址 */
@property(nonatomic,copy) NSString * downLoadURL;
/** 下载类型 */
@property(nonatomic,strong) NSString * downLoadType;
/** 下载的数据 */
@property(nonatomic,strong) NSMutableData * downLoadData;
/** 下载代理 */
@property(nonatomic,weak) id<DownLoadDelegate> delegate;
/** 网络请求 */
-(void)downLoadRequest;

@end
