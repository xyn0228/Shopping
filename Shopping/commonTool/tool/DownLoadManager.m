//
//  DownLoadManager.m
//  Shopping
//
//  Created by qianfeng on 16/1/11.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "DownLoadManager.h"
#import "DownLoad.h"

#import "InterfaceHeader.h"
#import "GunagHeaderUrl.h"

#import "IndexFirstModel.h"
#import "GuangScollerViewModel.h"
#import "GuangPointsClassModel.h"
#import "GuangAllModle.h"

@interface DownLoadManager()<DownLoadDelegate>

/** 数据缓存队列 */
@property(nonatomic,strong) NSMutableDictionary * dataSourceDict;
/** 下载任务队列 */
@property(nonatomic,strong) NSMutableDictionary * taskDataSource;

@end

@implementation DownLoadManager
+ (DownLoadManager *)sharedDownLoadManager
{
    
    static DownLoadManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownLoadManager alloc] init];
        });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSourceDict = [[NSMutableDictionary alloc] init];
        self.taskDataSource = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)addDownLoadMessageWithRUL:(NSString *)downLoadURL andType:(NSString *)downLoadType
{
    if([_dataSourceDict objectForKey:downLoadURL])
    {
        //有缓存直接读取
        [[NSNotificationCenter defaultCenter] postNotificationName:downLoadURL object:nil];
    }
    else
    {
        if([_taskDataSource objectForKey:downLoadURL])
        {
            NSLog(@"正在下载");
        }
        else
        {
            DownLoad * downLoad = [[DownLoad alloc] init];
            downLoad.downLoadURL = downLoadURL;
            downLoad.downLoadType = downLoadURL;
            downLoad.delegate = self;
            [downLoad downLoadRequest];
            [_taskDataSource setObject:downLoad forKey:downLoadURL];
            
        }
    }
}
#pragma mark --------下载咯-------该这个方法吧----
-(void)downLoadFinishWithDownLoad:(DownLoad *)downLoad
{
    //从下载队列中移除
    [_taskDataSource removeObjectForKey:downLoad.downLoadURL];
    //转载数据
    NSMutableArray * dataSource = [[NSMutableArray alloc] init];
    NSDictionary * JSONDict = [NSJSONSerialization JSONObjectWithData:downLoad.downLoadData options:NSJSONReadingMutableContainers error:nil];
    if([downLoad.downLoadType isEqualToString:Index_Search_URL])
    {
        NSDictionary * res = JSONDict[@"rp_result"];
        NSArray * hotkeys = res[@"hotKeys"];
        for (NSDictionary * key in hotkeys) {
            NSString * str = key[@"key"];
            [dataSource addObject:str];
        }
        
    }
    else if ([downLoad.downLoadType isEqualToString:Index_Message_URL])
    {
        NSArray * temData = JSONDict[@"temData"];
        
        for (NSDictionary * temDict in temData) {
            
            NSArray * listArr = temDict[@"list"];
            
            NSMutableArray * modelArr = [NSMutableArray array];
            for (NSDictionary * listDict in listArr) {
                IndexFirstModel * model = [[IndexFirstModel alloc] init];
                [model setValuesForKeysWithDictionary:listDict];
                
                if([model.mytitle isEqualToString:@""]||[model.imgUrl isEqualToString:@"无图片"]) continue;
                
                [modelArr addObject:model];
            }
            if(modelArr.count == 0) continue;
            [dataSource addObject:modelArr];
        }
    }else if ([downLoad.downLoadType isEqualToString:Guang_ScollView_URL])
    {
        NSArray *commentShowList = JSONDict[@"rp_result"][@"commentShowList"];
        for (NSDictionary * dict in commentShowList) {
            GuangScollerViewModel * model = [[GuangScollerViewModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [dataSource addObject:model];
        }
    
    }else if([downLoad.downLoadType isEqualToString:Guang_Classification_URL])
    {
        NSArray * categoryInfo = JSONDict[@"rp_result"][@"categoryInfo"];
        for (NSDictionary * dict in categoryInfo) {
            GuangPointsClassModel * model1 = [[GuangPointsClassModel alloc]init];
            [model1 setValuesForKeysWithDictionary:dict];
            [dataSource addObject:model1];
        }
    }else if ([downLoad.downLoadType isEqualToString:[NSString stringWithFormat:Guang_All_URL,self.allIndex,self.allID]])
    {
        NSArray * data = JSONDict[@"rp_result"][@"data"];
        for (NSDictionary *dict  in data) {
            GuangAllModle * model2 = [[GuangAllModle alloc]init];
            [model2 setValuesForKeysWithDictionary:dict];
            [dataSource addObject:model2];
        }
    
    }
    
    
    //缓存
    [_dataSourceDict setObject:dataSource forKey:downLoad.downLoadURL];
    //通知界面下载完成
    [[NSNotificationCenter defaultCenter] postNotificationName:downLoad.downLoadURL object:nil];
}

-(NSMutableArray *)getDownLoadData:(NSString *)downLoadURL
{
    return [_dataSourceDict objectForKey:downLoadURL];
}

@end
