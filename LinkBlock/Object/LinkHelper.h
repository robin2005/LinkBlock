//
//  LinkHelper.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 2017/12/13.
//  Copyright © 2017年 Meterwhite. All rights reserved.
//

#import "LinkBlockDefine.h"

NS_ASSUME_NONNULL_BEGIN
@interface LinkHelper<__covariant ObjectType> : NSProxy

+ (id)help:(id)target;

+ (void)  helpSwitchObjcType:(const char*)objcType
                    caseVoid:(void(^_Nullable)(void))caseVoid
                      caseId:(void(^_Nullable)(void))caseId
                   caseClass:(void(^_Nullable)(void))caseClass
                     caseIMP:(void(^_Nullable)(void))caseIMP
                     caseSEL:(void(^_Nullable)(void))caseSEL
                  caseDouble:(void(^_Nullable)(void))caseDouble
                   caseFloat:(void(^_Nullable)(void))caseFloat
                 casePointer:(void(^_Nullable)(void))casePointer
             caseCharPointer:(void(^_Nullable)(void))caseCharPointer
            caseUnsignedLong:(void(^_Nullable)(void))caseUnsignedLong
        caseUnsignedLongLong:(void(^_Nullable)(void))caseUnsignedLongLong
                    caseLong:(void(^_Nullable)(void))caseLong
                caseLongLong:(void(^_Nullable)(void))caseLongLong
                     caseInt:(void(^_Nullable)(void))caseInt
             caseUnsignedInt:(void(^_Nullable)(void))caseUnsignedInt
       caseBOOL_Char_xyShort:(void(^_Nullable)(void))casecaseBOOL_Char_xyShort
                  caseCGRect:(void(^_Nullable)(void))caseCGRect
                 caseNSRange:(void(^_Nullable)(void))caseNSRange
                  caseCGSize:(void(^_Nullable)(void))caseCGSize
                 caseCGPoint:(void(^_Nullable)(void))caseCGPoint
                caseCGVector:(void(^_Nullable)(void))caseCGVector
            caseUIEdgeInsets:(void(^_Nullable)(void))caseUIEdgeInsets
                caseUIOffset:(void(^_Nullable)(void))caseUIOffset
           caseCATransform3D:(void(^_Nullable)(void))caseCATransform3D
       caseCGAffineTransform:(void(^_Nullable)(void))caseCGAffineTransform
 caseNSDirectionalEdgeInsets:(void(^_Nullable)(void))caseNSDirectionalEdgeInsets
                     defaule:(void(^_Nullable)(void))defaule;

+ (NSDictionary*)link_block_struct_value_path_get_map;
+ (NSDictionary*)link_block_struct_value_path_set_map;
@end
NS_ASSUME_NONNULL_END
