//
//  UITextField+LinkBlock.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 16/1/29.
//  Copyright © 2016年 Meterwhite. All rights reserved.
//

#import "LinkBlockDefine.h"

#define UITextFieldNew ([UITextField new])

NS_ASSUME_NONNULL_BEGIN
@interface NSObject(UITextFieldLinkBlock)

#pragma mark - Foundation Mirror/镜像

@property LB_BK UITextField*        (^txtFieldText)(NSString* text);
@property LB_BK UITextField*        (^txtFieldAttributedText)(NSAttributedString* attributedText);
@property LB_BK UITextField*        (^txtFieldTextColor)(UIColor* textColor);
@property LB_BK UITextField*        (^txtFieldFont)(UIFont* font);
@property LB_BK UITextField*        (^txtFieldTextAlignment)(NSTextAlignment textAlignment);
@property LB_BK UITextField*        (^txtFieldPlaceholder)(NSString* placeholder);
@property LB_BK UITextField*        (^txtFieldAttributedPlaceholder)(NSAttributedString* attributedPlaceholder);


#pragma mark - Foundation Speed/速度

@property LB_BK UITextField*        (^txtFieldPlaceholdColor)(UIColor* color);
@property LB_BK UITextField*        (^txtFieldSelectRangeSet)(NSRange range);
@property LB_BK NSRange             (^txtFieldSelectRangeGet)(void);


@end
NS_ASSUME_NONNULL_END
