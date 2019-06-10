//
//  JSManagedValue+LinkBlock.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 16/6/21.
//  Copyright © 2016年 Meterwhite. All rights reserved.
//

#import "LinkBlockDefine.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface NSObject(JSManagedValueLinkBlock)
@property LB_BK JSManagedValue* (^jsManagedValueAddToManagedRef)(JSVirtualMachine* virtualMachine, id owner);
@end
