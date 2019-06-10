//
//  LBNil.m
//  LinkBlockProgram
//
//  Created by Meterwhite on 2017/12/28.
//  Copyright © 2017年 Meterwhite. All rights reserved.
//


#import <objc/runtime.h>
#import "LBNil.h"


#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_10_0 \
|| MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_12 \
|| __TV_OS_VERSION_MIN_REQUIRED >= __TVOS_10_0

#import <os/lock.h>
#define lb_spinlock_unlock os_unfair_lock_unlock
#define lb_spinlock_lock os_unfair_lock_lock
#define lb_spinlock_init OS_UNFAIR_LOCK_INIT
#define lb_spinlock os_unfair_lock
#define lb_spinlock_trylock os_unfair_lock_trylock
#else

#import <libkern/OSAtomic.h>
#define lb_spinlock_unlock OSSpinLockUnlock
#define lb_spinlock_init OS_SPINLOCK_INIT
#define lb_spinlock_lock OSSpinLockLock
#define lb_spinlock OSSpinLock
#define lb_spinlock_trylock OSSpinLockTry
#endif

//系统结构体objc_method_description定义
typedef struct {
    SEL name;
    const char *types;
} lb_methodDescription;

Class *lb_copyClassList (unsigned *count) {
    //获取runtime注册的类的数目
    int classCount = objc_getClassList(NULL, 0);
    if (!classCount) {
        if (count)
            *count = 0;
        
        return NULL;
    }
    
    //为所有类分配空间，包括NULL
    Class *allClasses = (Class *)malloc(sizeof(Class) * (classCount + 1));
    if (!allClasses) {
        
        fprintf(stderr, "NSBlackHole ERROR: 内存不足\n");
        if (count) *count = 0;
        return NULL;
    }
    
    classCount = objc_getClassList(allClasses, classCount);
    allClasses[classCount] = NULL;
    
    @autoreleasepool {
        //排除不符合的类
        for (int i = 0;i < classCount;) {
            Class class = allClasses[i];
            BOOL keep = YES;
            
            if (keep)
                keep &= class_respondsToSelector(class, @selector(methodSignatureForSelector:));
            
            if (keep) {
                if (class_respondsToSelector(class, @selector(isProxy)))
                    keep &= ![class isProxy];
            }
            
            if (!keep) {
                if (--classCount > i) {
                    memmove(allClasses + i, allClasses + i + 1, (classCount - i) * sizeof(*allClasses));
                }
                
                continue;
            }
            
            ++i;
        }
    }
    
    if (count)
        *count = (unsigned)classCount;
    
    return allClasses;
}

NSMethodSignature *lb_globalMethodSignatureForSelector (SEL aSelector) {
    NSCParameterAssert(aSelector != NULL);
    
    //创建缓存散列
    static const size_t selectorCacheLength = 1 << 8;
    static const uintptr_t selectorCacheMask = (selectorCacheLength - 1);
    static lb_methodDescription volatile methodDescriptionCache[selectorCacheLength];
    
    uintptr_t hash = (uintptr_t)((void *)aSelector) & selectorCacheMask;
    lb_methodDescription methodDesc;
    
    static lb_spinlock lock = lb_spinlock_init;
    
    lb_spinlock_lock(&lock);
    methodDesc = methodDescriptionCache[hash];
    lb_spinlock_unlock(&lock);
    
    if (methodDesc.name == aSelector) {
        return [NSMethodSignature signatureWithObjCTypes:methodDesc.types];
    }
    
    methodDesc = (lb_methodDescription){.name = NULL, .types = NULL};
    
    uint classCount = 0;
    Class *classes = lb_copyClassList(&classCount);
    
    if (classes) {
        @autoreleasepool {
            //autorelease防止所有Cocoa类执行+initialize
            for (uint i = 0;i < classCount;++i) {
                Class cls = classes[i];
                
                Method method = class_getInstanceMethod(cls, aSelector);
                if (!method)
                    method = class_getClassMethod(cls, aSelector);
                
                if (method) {
                    
                    methodDesc = (lb_methodDescription){.name = aSelector
                        , .types = method_getTypeEncoding(method)};
                    
                    break;
                }
            }
        }
        free(classes);
    }
    
    //如果没有找到,通过protocol optional去找
    if (!methodDesc.name) {
        uint protocolCount = 0;
        Protocol * __unsafe_unretained *protocols = objc_copyProtocolList(&protocolCount);
        if (protocols) {
            struct objc_method_description objcMethodDesc;
            for (uint i = 0;i < protocolCount;++i) {
                objcMethodDesc = protocol_getMethodDescription(protocols[i], aSelector, NO, YES);
                if (!objcMethodDesc.name)
                    objcMethodDesc = protocol_getMethodDescription(protocols[i], aSelector, NO, NO);
                
                if (objcMethodDesc.name) {
                    methodDesc = (lb_methodDescription){.name = objcMethodDesc.name, .types = objcMethodDesc.types};
                    break;
                }
            }
            free(protocols);
        }
    }
    
    if (methodDesc.name) {
        
        if (lb_spinlock_trylock(&lock)) {
            methodDescriptionCache[hash] = methodDesc;
            lb_spinlock_unlock(&lock);
        }
        
        
        
        /*
         有一些复杂的系统类型编码会导致-signatureWithObjCTypes:调用失败。
         例如：-[NSDecimalNumber -initWithDecimal:]
        */
        return [NSMethodSignature signatureWithObjCTypes:methodDesc.types];
    } else {
        
        return nil;
    }
}

@implementation LBNilObject

static id _self = nil;

+ (void)initialize
{
    if(self == [LBNilObject class]){
        if(!_self){
            _self = [self alloc];
        }
    }
}

+ (id)value
{
    return _self;
}

+ (id)new
{
    return nil;
}

- (id)init
{
    return nil;
}

- (NSString *)description
{
    return nil;
}

- (NSString *)debugDescription
{
    return nil;
}

#pragma mark 消息转发

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return lb_globalMethodSignatureForSelector(selector);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
    if (!returnLength) {
        return;
    }
    
    //返回值填充0
    char buffer[returnLength];
    memset(buffer, 0, returnLength);
    
    [anInvocation setReturnValue:buffer];
}

- (BOOL)respondsToSelector:(SEL)selector
{
    return NO;
}
#pragma mark NSObject protocol

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    return NO;
}

- (NSUInteger)hash
{
    return 0;
}

- (BOOL)isEqual:(id)obj
{
    return obj == nil || obj == _self ;
}

- (BOOL)isKindOfClass:(Class)class
{
    return NO;
}

- (BOOL)isMemberOfClass:(Class)class
{
    return NO;
}

- (BOOL)isProxy
{
    return NO;
}

#pragma mark 特别的
- (instancetype)initWithDecimal:(NSDecimal)dcm
{
    return nil;
}
@end
