//
//  NSError+LinkBlock.m
//  LinkBlockProgram
//
//  Created by Meterwhite on 16/9/12.
//  Copyright © 2016年 Meterwhite. All rights reserved.
//

#import "LinkBlock.h"

@implementation NSObject(NSErrorLinkBlock)
- (NSObject *(^)(id))errorValueInUserInfo
{
    return ^id(id key){
        LinkHandle_REF(NSError)
        LinkGroupHandle_REF(errorValueInUserInfo,key)
        return _self.userInfo[key];
    };
}
@end
