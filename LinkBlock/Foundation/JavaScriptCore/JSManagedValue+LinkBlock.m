//
//  JSManagedValue+LinkBlock.m
//  LinkBlockProgram
//
//  Created by Meterwhite on 16/6/21.
//  Copyright © 2016年 Meterwhite. All rights reserved.
//

#import "LinkBlock.h"

@implementation NSObject(JSManagedValueLinkBlock)
- (JSManagedValue *(^)(JSVirtualMachine *,id))jsManagedValueAddToManagedRef
{
    return ^id(JSVirtualMachine* virtualMachine,id owner){
        
        LinkHandle_REF(JSManagedValue)
        LinkGroupHandle_REF(jsManagedValueAddToManagedRef,virtualMachine,owner)
        [virtualMachine addManagedReference:_self withOwner:owner];
        return _self;
    };
}

@end
