//
//  JSValue+LinkBlock.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 16/6/21.
//  Copyright © 2016年 Meterwhite. All rights reserved.
//
#import "LinkBlockDefine.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface NSObject(JSValueLinkBlock)
@property LB_BK JSManagedValue*      (^jsValueToManagedValue)(id owner);
@property LB_BK JSValue*             (^jsValueAddToSelfManagedRef)(id owner);
@property LB_BK JSValue*             (^jsValueCallFunc)(NSArray* args);
@end
