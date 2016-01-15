//
//  GuangPointsClassModel.m
//  Shopping
//
//  Created by qianfeng on 15/1/13.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "GuangPointsClassModel.h"

@implementation GuangPointsClassModel
/**  替换  */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.ID = value;
    }
}
@end
