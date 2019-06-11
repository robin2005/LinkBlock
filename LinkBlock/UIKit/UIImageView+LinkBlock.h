//
//  UIImageView+LinkBlock.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 15/8/30.
//  Copyright (c) 2015年 Meterwhite. All rights reserved.
//

#import "LinkBlockDefine.h"
#import <objc/runtime.h>


#define UIImageViewNew ([UIImageView new])

NS_ASSUME_NONNULL_BEGIN
@interface NSObject(UIImageViewLinkBlock)

#pragma mark - Foundation Mirror/镜像
@property LB_BK UIImageView*         (^img_viewImage)(UIImage* image);
@property LB_BK UIImageView*         (^img_viewImageHighlight)(UIImage* image);
@property LB_BK UIImageView*         (^img_viewImageStrHighlight)(NSString* imageStr);
@property LB_BK UIImageView*         (^img_viewHighlight)(BOOL b);
@property LB_BK UIImageView*         (^img_viewAnimationImages)( NSArray<UIImage *>* imgs);
@property LB_BK UIImageView*         (^img_viewHighlightedAnimationImages)( NSArray<UIImage *>* imgs);
#pragma mark - Foundation Speed/速度
/** set image */
@property LB_BK UIImageView*         (^img_viewImageWithName)(NSString* imageStr);


@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
@interface UIImageView(UIImageViewLinkBlock)
/**
 *  extend touch range
 */
@property LB_BK UIImageView* (^img_viewExtensionOfTouchSide)(UIEdgeInsets insets);
@property LB_BK UIImageView* (^img_viewExtensionOfTouchRects)(NSArray<NSString*>* rects);
@end
NS_ASSUME_NONNULL_END
