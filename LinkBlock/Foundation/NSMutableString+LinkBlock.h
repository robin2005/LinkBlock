//
//  NSMutableString+LinkBlock.h

//
//  Created by Meterwhite on 15/8/12.
//  Copyright (c) 2015年 Meterwhite. All rights reserved.
//

#import "LinkBlockDefine.h"

#define NSMutableStringNew ([NSMutableString new])

NS_ASSUME_NONNULL_BEGIN
@interface NSObject(NSMutableStringLinkBlock)

#pragma mark - Foundation Mirror/镜像
@property LB_BK NSMutableString*     (^m_strInsertStrAt)(NSString* str, NSUInteger idx);
@property LB_BK NSMutableString*     (^m_strAppend)(id obj);
@property LB_BK NSMutableString*     (^m_strReplace)(NSString* replace, NSString* with);
@property LB_BK NSMutableString*     (^m_strDeleteInRange)(NSRange range);

#pragma mark - Foundation Speed/速度
/** @"" */
@property LB_BK NSMutableString*     (^m_strClear)(void);

@end
NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN
@interface NSMutableString (NSMutableStringLinkBlock)
/** Enumerate string by composed and modify. */
- (void)m_strEnumerateComposedModifiedUsingBlock:(void(^)(NSString*_Nonnull*_Nonnull string,NSRange range,BOOL *stop))block;
@end
NS_ASSUME_NONNULL_END
