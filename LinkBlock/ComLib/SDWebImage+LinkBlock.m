//
//  SDWebImage+LinkBlock.m
//  LinkBlockProgram
//
//  Created by Meterwhite on 2019/6/11.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import "SDWebImage+LinkBlock.h"
#import "LinkBlock.h"
#import "LBComLib.h"
#import "LBNil.h"

@implementation NSObject(SDWebImageLinkBlock)

- (UIButton * (^)(NSURL *, UIControlState))btn_sd_setImageWithURLForState
{
    return ^ id(NSURL * url, UIControlState state){
        
        if(!LBComLibSDWebImageExsist) return [LinkError new];
        
        LinkHandle_REF(UIButton)
        LinkGroupHandle_REF(btn_sd_setImageWithURLForState,url,state)
        LBSelectorDefined("sd_setImageWithURL:forState:")
        
        lb_objc_msgSend(void, _self, _CMD,
                        url, state);
        return _self;
    };
}

- (UIButton * (^)(NSURL * _Nonnull, UIControlState, UIImage *))btn_sd_setImageWithURLForStatePlaceholderImage
{
    return ^ id(NSURL * url, UIControlState state,UIImage * placeholderImage){
        
        if(!LBComLibSDWebImageExsist) return [LinkError new];
        
        LinkHandle_REF(UIButton)
        LinkGroupHandle_REF(btn_sd_setImageWithURLForStatePlaceholderImage,url,state,placeholderImage)
        LBSelectorDefined("sd_setImageWithURL:forState:placeholderImage:")
        
        lb_objc_msgSend(void, _self, _CMD,
                        url, state, placeholderImage);
        
        return _self;
    };
}

- (UIButton * (^)(NSURL *, UIControlState))btn_sd_setBackgroundImageWithURLForState
{
    return ^ id(NSURL * url, UIControlState state){
        
        if(!LBComLibSDWebImageExsist) return [LinkError new];
        
        LinkHandle_REF(UIButton)
        LinkGroupHandle_REF(btn_sd_setBackgroundImageWithURLForState,url,state)
        LBSelectorDefined("sd_setBackgroundImageWithURL:forState:")
        
        lb_objc_msgSend(void, _self, _CMD,
                        url, state);
        return _self;
    };
}

- (UIButton * (^)(NSURL *, UIControlState, UIImage * ))btn_sd_setBackgroundImageWithURLForStatePlaceholderImage
{
    return ^ id(NSURL * url, UIControlState state,UIImage *placeholderImage){
        
        if(!LBComLibSDWebImageExsist) return [LinkError new];
        
        LinkHandle_REF(UIButton)
        LinkGroupHandle_REF(btn_sd_setBackgroundImageWithURLForStatePlaceholderImage,url,state,placeholderImage)
        LBSelectorDefined("sd_setBackgroundImageWithURL:forState:placeholderImage:")
        
        lb_objc_msgSend(void, _self, _CMD,
                        url, state, placeholderImage);
        return _self;
    };
}

- (UIImageView *(^)(NSURL *, UIImage*, NSUInteger))img_view_sd_setImageWithURLPlaceholderImageOptions
{
    return ^ id(NSURL* url,UIImage* placeholder, NSUInteger aSDWebImageOptions){
        
        if(!LBComLibSDWebImageExsist) return [LinkError new];
        
        LinkHandle_REF(UIButton)
        LinkGroupHandle_REF(img_view_sd_setImageWithURLPlaceholderImageOptions,url,placeholder,aSDWebImageOptions)
        LBSelectorDefined("sd_setImageWithURL:placeholderImage:options:")
        
        lb_objc_msgSend(void, _self, _CMD,
                        url, placeholder, aSDWebImageOptions);
        return _self;
    };
}

- (UIImageView * _Nonnull (^)(NSURL * _Nonnull, UIImage * _Nonnull))img_view_sd_setImageWithURLPlaceholderImage
{
    return ^ id(NSURL* url,UIImage* placeholder){
        
        if(!LBComLibSDWebImageExsist) return [LinkError new];
        
        LinkHandle_REF(UIButton)
        LinkGroupHandle_REF(img_view_sd_setImageWithURLPlaceholderImage,url,placeholder)
        LBSelectorDefined("sd_setImageWithURL:placeholderImage:")
        
        lb_objc_msgSend(void, _self, _CMD,
                        url, placeholder);
        return _self;
    };
}

- (UIImageView * _Nonnull (^)(NSURL * _Nonnull))img_view_sd_setImage
{
    return ^ id(NSURL* url){
        
        if(!LBComLibSDWebImageExsist) return [LinkError new];
        
        LinkHandle_REF(UIButton)
        LinkGroupHandle_REF(img_view_sd_setImage,url)
        LBSelectorDefined("sd_setImageWithURL:")
        
        lb_objc_msgSend(void, _self, _CMD,
                        url);
        return _self;
    };
}

- (UIImageView * _Nonnull (^)(UIImageView * _Nonnull, UIImage * _Nonnull))url_sd_setImageWithURLPlaceholderImageToImageViewAsWhatSet
{
    return ^ id(UIImageView* imgv,UIImage* placeholder){
        
        if(!LBComLibSDWebImageExsist) return [LinkError new];
        
        LinkHandle_REF(NSURL)
        LinkGroupHandle_REF(url_sd_setImageWithURLPlaceholderImageToImageViewAsWhatSet,imgv,placeholder)
        LBSelectorDefined("sd_setImageWithURL:placeholderImage:")
        
        lb_objc_msgSend(void, imgv, _CMD,
                        _self, placeholder);
        return linkObj(imgv);
    };
}

- (UIButton * _Nonnull (^)(UIButton * _Nonnull, UIControlState, UIImage * _Nonnull))url_sd_setImageWithURLForStatePlaceholderImageToButtonAsWhatSet
{
    return ^ id(UIButton* btn, UIControlState state,UIImage *placeholderImage){
        
        if(!LBComLibSDWebImageExsist) return [LinkError new];
        
        LinkHandle_REF(NSURL)
        LinkGroupHandle_REF(url_sd_setImageWithURLForStatePlaceholderImageToButtonAsWhatSet
                            ,btn,state,placeholderImage)
        LBSelectorDefined("sd_setBackgroundImageWithURL:forState:placeholderImage:")
        
        lb_objc_msgSend(void, btn, _CMD,
                        _self, state, placeholderImage);
        return linkObj(btn);
    };
}

@end

