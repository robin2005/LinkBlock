//
//  LBComLib.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 2019/6/11.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinkBlockDefine.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define lb_objc_msgSend(RET, _self, _CMD, ...) \
((RET(*)\
    (   id,\
        SEL,\
        submacro_lb_concat(submacro_lb_tli, submacro_lb_argcount(__VA_ARGS__))(__VA_ARGS__)\
    )\
)\
objc_msgSend)\
(_self, _CMD, __VA_ARGS__)

#define LBSelectorDefined(chs) \
SEL _CMD = sel_getUid(chs);\
NSAssert(_CMD, @"LinkBlock : SEL %s dose not exsist in objc runtime!", chs);\

typedef NSString*_Nullable const LBComLibName;

FOUNDATION_EXPORT LBComLibName LBComLibSDWebImage;//Detected version : 4.0.0
FOUNDATION_EXPORT bool         LBComLibSDWebImageExsist;

extern inline bool lb_comlib_exsist(LBComLibName libname);


NS_ASSUME_NONNULL_BEGIN
@interface LBComLib : NSObject

+ (BOOL)contains:(LBComLibName)libname;


@end
NS_ASSUME_NONNULL_END
