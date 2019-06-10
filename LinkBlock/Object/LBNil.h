//
//  LBNil.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 2017/12/28.
//  Copyright © 2017年 Meterwhite. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *黑洞对象
 *该对象响应任何消息但不崩溃；是具有nil性质的对象；因此与同样是nil装箱形式的对象NSNull具有完全互补的性质；
 *由于objc不能重载"=="，所以注意"LBNil.value == nil"返回的是NO；使用"isEqual:"方法才能返回YES
 */
#ifndef LBNil
#define LBNil ([LBNilObject value])
#endif

/**
 *[NSObject* isEqual:nil]
 *LBBlankObject在和nil进行比较的时候返回YES。如果使用==则比较地址，结果返回NO。
 */
#ifndef LBEqualNil
#define LBEqualNil(value) (value ? [value isEqual:nil] : YES)
#endif



/**
 *  空对象
 *  该对象响应任何消息但不崩溃；是具有nil性质的对象；因此与同样是nil装箱形式的对象NSNull具有完全互补的性质；
 *  由于objc不能重载"=="，所以注意"LBNil.value == nil"返回的是NO；使用"isEqual:"方法才能返回YES
 */
@interface LBNilObject : NSProxy

+ (id)value;

@end
