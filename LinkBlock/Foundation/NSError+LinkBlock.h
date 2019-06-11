//
//  NSError+LinkBlock.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 16/9/12.
//  Copyright © 2016年 Meterwhite. All rights reserved.
//

#import "LinkBlockDefine.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSObject(NSErrorLinkBlock)
@property LB_BK NSObject*           (^errorValueInUserInfo)(id key);
@end
NS_ASSUME_NONNULL_END
