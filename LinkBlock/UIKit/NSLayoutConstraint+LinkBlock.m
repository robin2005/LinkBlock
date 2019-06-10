//
//  NSLayoutConstraint+LinkBlock.m
//  LinkBlockProgram
//
//  Created by Meterwhite on 2018/6/20.
//  Copyright © 2018年 Meterwhite. All rights reserved.
//

#import "LinkBlock.h"

@implementation NSObject(NSLayoutConstraintLinkBlock)
- (NSLayoutConstraint* (^)(CGFloat constant))constraintConstant
{
    return ^id(CGFloat constant){
        LinkHandle_REF(NSLayoutConstraint)
        LinkGroupHandle_REF(constraintConstant,constant)
        _self.constant = constant;
        return _self;
    };
}
@end
