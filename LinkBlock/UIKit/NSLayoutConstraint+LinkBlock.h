//
//  NSLayoutConstraint+LinkBlock.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 2018/6/20.
//  Copyright © 2018年 Meterwhite. All rights reserved.
//

#import "LinkBlockDefine.h"

@interface NSObject(NSLayoutConstraintLinkBlock)
#pragma mark - Foundation Mirror/镜像
@property LB_BK NSLayoutConstraint* (^constraintConstant)(CGFloat constant);
@end
