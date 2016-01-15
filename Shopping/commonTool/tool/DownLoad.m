//
//  DownLoad.m
//  Shopping
//
//  Created by qianfeng on 16/1/11.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "DownLoad.h"

@implementation DownLoad
-(void)downLoadRequest
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/javascript", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:_downLoadURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _downLoadData = [NSMutableData dataWithData:responseObject];
        [_delegate downLoadFinishWithDownLoad:self];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"fail");
    }];
}
@end
