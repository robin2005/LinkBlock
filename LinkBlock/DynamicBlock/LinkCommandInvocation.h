//
//  LinkCommandInvocation.h
//  LinkBlockProgram
//
//  Created by NOVO on 2017/12/26.
//  Copyright © 2017年 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LinkCommandInvocation : NSObject

/**
 构造方法
 */
+ (instancetype)invocationWithCommand:(NSString*)command;

#pragma mark - override NSInvocation
- (id)invokeWithTarget:(id)target;
@end
NS_ASSUME_NONNULL_END
