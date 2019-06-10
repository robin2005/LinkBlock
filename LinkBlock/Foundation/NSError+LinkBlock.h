//
//  NSError+LinkBlock.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 16/9/12.
//  Copyright © 2016年 Meterwhite. All rights reserved.
//

#import "LinkBlockDefine.h"

@interface NSObject(NSErrorLinkBlock)
@property LB_BK NSObject*           (^errorValueInUserInfo)(id key);
@end
