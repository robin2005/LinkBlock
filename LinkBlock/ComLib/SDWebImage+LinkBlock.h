//
//  SDWebImage+LinkBlock.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 2019/6/11.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import "LinkBlockDefine.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSObject(SDWebImageLinkBlock)

#pragma mark - API Mirror/镜像
@property LB_BK UIButton*
(^btn_sd_setImageWithURLForState)(NSURL* url,UIControlState state);

@property LB_BK UIButton*
(^btn_sd_setImageWithURLForStatePlaceholderImage)
(NSURL* url,UIControlState state, UIImage*_Nullable placeholder);

@property LB_BK UIButton*
(^btn_sd_setBackgroundImageWithURLForState)
(NSURL* url,UIControlState state);

@property LB_BK UIButton*
(^btn_sd_setBackgroundImageWithURLForStatePlaceholderImage)
(NSURL* url,UIControlState state, UIImage*_Nullable placeholder);

@property LB_BK UIImageView*
(^img_view_sd_setImage)(NSURL* url);

@property LB_BK UIImageView*
(^img_view_sd_setImageWithURLPlaceholderImage)
(NSURL* url,UIImage*_Nullable placeholder);

@property LB_BK UIImageView*
(^img_view_sd_setImageWithURLPlaceholderImageOptions)
(NSURL* url,UIImage* placeholder, NSUInteger aSDWebImageOptions);

#pragma mark - API Speed/速度
@property LB_BK UIImageView*
(^url_sd_setImageWithURLPlaceholderImageToImageViewAsWhatSet)
(UIImageView* imgv, UIImage*_Nullable placeholder);

@property LB_BK UIButton*
(^url_sd_setImageWithURLForStatePlaceholderImageToButtonAsWhatSet)
(UIButton* btn, UIControlState state, UIImage*_Nullable placeholder);

@end
NS_ASSUME_NONNULL_END

