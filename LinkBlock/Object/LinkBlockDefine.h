//
//  LinkBlockDefine.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 17/3/14.
//  Copyright © 2017年 Meterwhite. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/** Block */
#define LB_BK (nonatomic,copy,readonly)

/** Block */
#define LB_SBK (nonatomic,copy,readonly,class)

/** Function */
#define  LB_FN (nonatomic,readonly)

/** Block & Getter */
#define LB_BKG(getname) \
    \
    (nonatomic,copy,readonly,getter=getname)

#define LBC_BKG(getname) \
    \
    (nonatomic,class,readonly,getter=getname)

#define LB_MCopy_VAR(var) \
    \
    (var = [var mutableCopy])

#define LB_RespondsToSEL(var,sel) \
    \
    ([var respondsToSelector:@selector(sel)])

#define LB_IsKindOfClass(var,clazz) \
    \
    ([var isKindOfClass:[clazz class]])

//////////////////////////////////////////////////////////////////////
//MARK: Control
//////////////////////////////////////////////////////////////////////
//Return value is object type.
#ifndef LinkHandle_REF
#define LinkHandle_REF(currType)\
__kindof currType* _self = (currType*)self;\
if([_self isKindOfClass:[LinkInfo class]]){\
    if(((LinkInfo*)_self).infoType == LinkInfoError){\
        ((LinkError*)_self).throwCount++;\
        return (id)self;\
    }else if(((LinkInfo*)self).infoType == LinkInfoReturn){\
        return (id)self;\
    }\
}\
if(![_self isKindOfClass:[currType class]]&&\
![_self isKindOfClass:[LinkInfo class]]){\
    LinkError* error = [LinkError new];\
    error.needClass = NSStringFromClass([currType class]);\
    error.errorClass = NSStringFromClass([_self class]);\
    error.inFunc = [NSString stringWithUTF8String:__func__];\
    return (id)error;\
}
#endif

//Return value is value type.
#ifndef LinkHandle_VAL_IFNOT
#define LinkHandle_VAL_IFNOT(currType) \
__kindof currType* _self = (currType*)self;\
if([self isKindOfClass:[LinkError class]] || (![self isKindOfClass:[currType class]]&&![self isKindOfClass:[LinkGroup class]]))
#endif

//Handle link objects when return value is object type.
#ifndef LinkGroupHandle_REF
#define LinkGroupHandle_REF(blockName , ...)\
if([self isKindOfClass:[LinkGroup class]]){\
    LinkGroup* group = self.thisLinkObjs;\
    NSMutableArray* returnObjs = [NSMutableArray new];\
    for (int i=0; i<group.linkObjects.count; i++) {\
        id re = group.linkObjects[i].blockName(__VA_ARGS__);\
        [returnObjs addObject:re];\
    }\
    [group.linkObjects setArray:returnObjs];\
    return (id)group;\
}
#endif
//Handle link objects when return value is value type.
#ifndef LinkGroupHandle_VAL
#define LinkGroupHandle_VAL(blockName , ...) \
if([self isKindOfClass:[LinkGroup class]]){\
    LinkGroup* group = self.thisLinkObjs;\
    return [group.linkObjects firstObject].blockName(__VA_ARGS__);\
}
#endif


#define LB_SELAsString(sel) \
    \
    (NSStringFromSelector(@selector(sel)))

///MARK: Box value
#define LBBoxValue(value) _LinkBoxValue(@encode(__typeof__((value))), (value))
NS_INLINE id _LinkBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGRect)) == 0) {
        CGRect actual = (CGRect)va_arg(v, CGRect);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

#define LBObjcValue(value)\
    \
    _LinkObjcValue(@encode(__typeof__((value))), (value))
NS_INLINE id _LinkObjcValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGRect)) == 0) {
        CGRect actual = (CGRect)va_arg(v, CGRect);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj?obj:[NSNull null];
}

NS_INLINE CGRect LB_CGRectInsetMargin(CGRect rect, UIEdgeInsets insets) {
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top  + insets.bottom);
    return rect;
}

/**
 type encodings是否是数字类型
 */
NS_INLINE bool LB_ObjcTypeIsNumber(const char* objcType){
    /*
     *from:
     *https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
     */
    if(strcmp(objcType, "c") == 0) return true;
    if(strcmp(objcType, "i") == 0) return true;
    if(strcmp(objcType, "s") == 0) return true;
    if(strcmp(objcType, "l") == 0) return true;
    if(strcmp(objcType, "q") == 0) return true;
    if(strcmp(objcType, "C") == 0) return true;
    if(strcmp(objcType, "I") == 0) return true;
    if(strcmp(objcType, "S") == 0) return true;
    if(strcmp(objcType, "L") == 0) return true;
    if(strcmp(objcType, "Q") == 0) return true;
    if(strcmp(objcType, "f") == 0) return true;
    if(strcmp(objcType, "d") == 0) return true;
    if(strcmp(objcType, "B") == 0) return true;
    return false;
}

/**
 *fromType类型传值给toType时的类型兼容检测
 */
NS_INLINE bool LB_TypeEncodingsPassingCheck(const char* fromType , const char* toType)
{
    if(strlen(fromType) == 0 || strlen(toType) == 0) return false;
    if(strcmp(fromType, toType) == 0) return true;
    if(LB_ObjcTypeIsNumber(fromType) && LB_ObjcTypeIsNumber(toType)) return true;
    
    NSMutableString* fromTypeStr = [[NSString stringWithUTF8String:fromType] mutableCopy];
    NSMutableString* toTypeStr = [[NSString stringWithUTF8String:toType] mutableCopy];
    
    
    /* https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html */
    [@[@"r",@"n",@"N",@"o",@"O",@"R",@"V"] enumerateObjectsUsingBlock:^(NSString*  _Nonnull typeEncodeOfMethod, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [fromTypeStr replaceOccurrencesOfString:typeEncodeOfMethod
                                    withString:@""
                                       options:NSAnchoredSearch
                                         range:NSMakeRange(0, 1)];
        [toTypeStr replaceOccurrencesOfString:typeEncodeOfMethod
                                    withString:@""
                                       options:NSAnchoredSearch
                                         range:NSMakeRange(0, 1)];
    }];
    //去方法部分
    if([fromTypeStr isEqualToString:toTypeStr]) return true;
    
    
    //objc类型
    if([toTypeStr characterAtIndex:0]   == '@' &&
       [fromTypeStr characterAtIndex:0] == '@'){
        
        if(toTypeStr.length < 3 || fromTypeStr.length < 3){//两者中有一个id类型
            return true;
        }
        
        //都不是id类型
        [toTypeStr deleteCharactersInRange:NSMakeRange(2, toTypeStr.length-3)];
        [fromTypeStr deleteCharactersInRange:NSMakeRange(2, fromTypeStr.length-3)];
        
        return [NSClassFromString(toTypeStr) isSubclassOfClass:NSClassFromString(fromTypeStr)];
    }
    
    //指针
    if([fromTypeStr characterAtIndex:0] == '^' && [toTypeStr characterAtIndex:0] == '^'){
        return [fromTypeStr isEqualToString:@"^v"] || [toTypeStr isEqualToString:@"^v"];
    }
    
    //id和void*
    if([fromTypeStr isEqualToString:@"^v"] && [toTypeStr isEqualToString:@"@"]) return true;
    if([fromTypeStr isEqualToString:@"@"] && [toTypeStr isEqualToString:@"^v"]) return true;
    
    //结构体 共用体 SEL IMP Class 数组 指针
    return false;
}

#define submacro_lb_tli0
#define submacro_lb_tli1(...)       __typeof__(submacro_lb_at(0,__VA_ARGS__))
#define submacro_lb_tli2(...)       submacro_lb_tli1(__VA_ARGS__),  __typeof__(submacro_lb_at(1,__VA_ARGS__))
#define submacro_lb_tli3(...)       submacro_lb_tli2(__VA_ARGS__),  __typeof__(submacro_lb_at(2,__VA_ARGS__))
#define submacro_lb_tli4(...)       submacro_lb_tli3(__VA_ARGS__),  __typeof__(submacro_lb_at(3,__VA_ARGS__))
#define submacro_lb_tli5(...)       submacro_lb_tli4(__VA_ARGS__),  __typeof__(submacro_lb_at(4,__VA_ARGS__))
#define submacro_lb_tli6(...)       submacro_lb_tli5(__VA_ARGS__),  __typeof__(submacro_lb_at(5,__VA_ARGS__))
#define submacro_lb_tli7(...)       submacro_lb_tli6(__VA_ARGS__),  __typeof__(submacro_lb_at(6,__VA_ARGS__))
#define submacro_lb_tli8(...)       submacro_lb_tli7(__VA_ARGS__),  __typeof__(submacro_lb_at(7,__VA_ARGS__))
#define submacro_lb_tli9(...)       submacro_lb_tli8(__VA_ARGS__),  __typeof__(submacro_lb_at(8,__VA_ARGS__))
#define submacro_lb_tli10(...)      submacro_lb_tli9(__VA_ARGS__),  __typeof__(submacro_lb_at(9,__VA_ARGS__))
#define submacro_lb_tli11(...)      submacro_lb_tli10(__VA_ARGS__), __typeof__(submacro_lb_at(10,__VA_ARGS__))
#define submacro_lb_tli12(...)      submacro_lb_tli11(__VA_ARGS__), __typeof__(submacro_lb_at(11,__VA_ARGS__))
#define submacro_lb_tli13(...)      submacro_lb_tli12(__VA_ARGS__), __typeof__(submacro_lb_at(12,__VA_ARGS__))
#define submacro_lb_tli14(...)      submacro_lb_tli13(__VA_ARGS__), __typeof__(submacro_lb_at(13,__VA_ARGS__))
#define submacro_lb_tli15(...)      submacro_lb_tli14(__VA_ARGS__), __typeof__(submacro_lb_at(14,__VA_ARGS__))
#define submacro_lb_tli16(...)      submacro_lb_tli15(__VA_ARGS__), __typeof__(submacro_lb_at(15,__VA_ARGS__))
#define submacro_lb_tli17(...)      submacro_lb_tli16(__VA_ARGS__), __typeof__(submacro_lb_at(16,__VA_ARGS__))
#define submacro_lb_tli18(...)      submacro_lb_tli17(__VA_ARGS__), __typeof__(submacro_lb_at(17,__VA_ARGS__))
#define submacro_lb_tli19(...)      submacro_lb_tli18(__VA_ARGS__), __typeof__(submacro_lb_at(18,__VA_ARGS__))



#define submacro_lb_concat_(A, B) A ## B

#define submacro_lb_concat(A, B) \
submacro_lb_concat_(A, B)

#define submacro_lb_at(N, ...) \
submacro_lb_concat(submacro_lb_at, N)(__VA_ARGS__)

#define submacro_lb_argcount(...) \
submacro_lb_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

#define submacro_lb_if_eq(A, B) \
submacro_lb_concat(submacro_lb_if_eq, A)(B)

#define submacro_lb_head_(FIRST, ...) FIRST

#define submacro_lb_head(...) \
submacro_lb_head_(__VA_ARGS__, 0)

// submacro_lb_at expansions
#define submacro_lb_at0(...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at1(_0, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at2(_0, _1, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at3(_0, _1, _2, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at4(_0, _1, _2, _3, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at5(_0, _1, _2, _3, _4, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at6(_0, _1, _2, _3, _4, _5, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at7(_0, _1, _2, _3, _4, _5, _6, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at9(_0, _1, _2, _3, _4, _5, _6, _7, _8, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at10(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at11(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at12(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at13(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at14(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at15(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at16(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at17(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at18(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at19(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, ...) submacro_lb_head(__VA_ARGS__)
#define submacro_lb_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) submacro_lb_head(__VA_ARGS__)


#define submacro_lb_consume_(...)

#define submacro_lb_expand_(...) __VA_ARGS__

#define submacro_lb_dec(VAL) \
submacro_lb_at(VAL, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)

// ak_if_eq expansions
#define submacro_lb_if_eq0(VALUE) \
submacro_lb_concat(submacro_lb_if_eq0_, VALUE)

#define submacro_lb_if_eq0_0(...) __VA_ARGS__ submacro_lb_consume_
#define submacro_lb_if_eq0_1(...) submacro_lb_expand_
#define submacro_lb_if_eq0_2(...) submacro_lb_expand_
#define submacro_lb_if_eq0_3(...) submacro_lb_expand_
#define submacro_lb_if_eq0_4(...) submacro_lb_expand_
#define submacro_lb_if_eq0_5(...) submacro_lb_expand_
#define submacro_lb_if_eq0_6(...) submacro_lb_expand_
#define submacro_lb_if_eq0_7(...) submacro_lb_expand_
#define submacro_lb_if_eq0_8(...) submacro_lb_expand_
#define submacro_lb_if_eq0_9(...) submacro_lb_expand_
#define submacro_lb_if_eq0_10(...) submacro_lb_expand_
#define submacro_lb_if_eq0_11(...) submacro_lb_expand_
#define submacro_lb_if_eq0_12(...) submacro_lb_expand_
#define submacro_lb_if_eq0_13(...) submacro_lb_expand_
#define submacro_lb_if_eq0_14(...) submacro_lb_expand_
#define submacro_lb_if_eq0_15(...) submacro_lb_expand_
#define submacro_lb_if_eq0_16(...) submacro_lb_expand_
#define submacro_lb_if_eq0_17(...) submacro_lb_expand_
#define submacro_lb_if_eq0_18(...) submacro_lb_expand_
#define submacro_lb_if_eq0_19(...) submacro_lb_expand_
#define submacro_lb_if_eq0_20(...) submacro_lb_expand_

#define submacro_lb_if_eq1(VALUE) submacro_lb_if_eq0(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq2(VALUE) submacro_lb_if_eq1(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq3(VALUE) submacro_lb_if_eq2(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq4(VALUE) submacro_lb_if_eq3(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq5(VALUE) submacro_lb_if_eq4(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq6(VALUE) submacro_lb_if_eq5(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq7(VALUE) submacro_lb_if_eq6(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq8(VALUE) submacro_lb_if_eq7(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq9(VALUE) submacro_lb_if_eq8(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq10(VALUE) submacro_lb_if_eq9(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq11(VALUE) submacro_lb_if_eq10(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq12(VALUE) submacro_lb_if_eq11(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq13(VALUE) submacro_lb_if_eq12(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq14(VALUE) submacro_lb_if_eq13(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq15(VALUE) submacro_lb_if_eq14(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq16(VALUE) submacro_lb_if_eq15(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq17(VALUE) submacro_lb_if_eq16(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq18(VALUE) submacro_lb_if_eq17(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq19(VALUE) submacro_lb_if_eq18(submacro_lb_dec(VALUE))
#define submacro_lb_if_eq20(VALUE) submacro_lb_if_eq19(submacro_lb_dec(VALUE))

