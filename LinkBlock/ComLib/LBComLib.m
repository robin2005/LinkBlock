//
//  LBComLib.m
//  LinkBlockProgram
//
//  Created by Meterwhite on 2019/6/11.
//  Copyright © 2019 Meterwhite. All rights reserved.
//

#import "LBComLib.h"

static NSHashTable* _lb_comlib_tab;

LBComLibName    LBComLibSDWebImage          =   @"SDWebImage";
bool            LBComLibSDWebImageExsist    =   false;

inline bool lb_comlib_exsist(LBComLibName libname)
{
    return [_lb_comlib_tab containsObject:libname];
}

@implementation LBComLib

+ (BOOL)contains:(LBComLibName)libname
{
    return lb_comlib_exsist(libname);
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _lb_comlib_tab
        =
        [NSHashTable hashTableWithOptions:
                            NSPointerFunctionsWeakMemory |
                            NSPointerFunctionsOpaquePersonality];
        
        if(objc_getClass("SDWebImageManager")){
            
            LBComLibSDWebImageExsist = true;
            [_lb_comlib_tab addObject:LBComLibSDWebImage];
        }
        
        
        
    });
}

@end
