//
//  LinkHelper.m
//  LinkBlockProgram
//
//  Created by Meterwhite on 2017/12/13.
//  Copyright © 2017年 Meterwhite. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import "LinkBlock.h"
#import "LinkHelper.h"
#import "LBNil.h"

@interface LinkHelper<__covariant ObjectType>()
@property (nonatomic,strong) id target;
@property (nonatomic,strong) JSContext* jscontext;
@end

@implementation LinkHelper

#define self_target_is_type(type) ([self.target isKindOfClass:[type class]])

+ (void) helpSwitchObjcType:(const char*)objcType
                   caseVoid:(void(^)(void))caseVoid
                     caseId:(void(^)(void))caseId
                  caseClass:(void(^)(void))caseClass
                    caseIMP:(void(^)(void))caseIMP
                    caseSEL:(void(^)(void))caseSEL
                 caseDouble:(void(^)(void))caseDouble
                  caseFloat:(void(^)(void))caseFloat
                casePointer:(void(^)(void))casePointer
            caseCharPointer:(void(^)(void))caseCharPointer
           caseUnsignedLong:(void(^)(void))caseUnsignedLong
       caseUnsignedLongLong:(void(^)(void))caseUnsignedLongLong
                   caseLong:(void(^)(void))caseLong
               caseLongLong:(void(^)(void))caseLongLong
                    caseInt:(void(^)(void))caseInt
            caseUnsignedInt:(void(^)(void))caseUnsignedInt
      caseBOOL_Char_xyShort:(void(^)(void))casecaseBOOL_Char_xyShort
                 caseCGRect:(void(^)(void))caseCGRect
                caseNSRange:(void(^)(void))caseNSRange
                 caseCGSize:(void(^)(void))caseCGSize
                caseCGPoint:(void(^)(void))caseCGPoint
               caseCGVector:(void(^)(void))caseCGVector
           caseUIEdgeInsets:(void(^)(void))caseUIEdgeInsets
               caseUIOffset:(void(^)(void))caseUIOffset
          caseCATransform3D:(void(^)(void))caseCATransform3D
      caseCGAffineTransform:(void(^)(void))caseCGAffineTransform
caseNSDirectionalEdgeInsets:(void(^)(void))caseNSDirectionalEdgeInsets
                    defaule:(void(^)(void))defaule
{
    if(!objcType) return;
    
    do{
        if(caseVoid && strcmp(objcType, @encode(void)) == 0){
            caseVoid();
            break;
        };
        //常量则位移到类型符
        if (objcType[0] == _C_CONST) objcType++;
        
        if (objcType[0] == '@') {                                //id and block
            caseId();
            break;
        }else if (caseClass && strcmp(objcType, @encode(Class)) == 0){       //Class
            caseClass();
            break;
        }else if (caseIMP && strcmp(objcType, @encode(IMP)) == 0 ){         //IMP
            caseIMP();
            break;
        }else if (caseSEL && strcmp(objcType, @encode(SEL)) == 0) {         //SEL
            caseSEL();
            break;
        }else if (caseDouble && strcmp(objcType, @encode(double)) == 0){       //double
            caseDouble();
            break;
        }else if (caseFloat && strcmp(objcType, @encode(float)) == 0){       //float
            caseFloat();
            break;
        }else if (casePointer && objcType[0] == '^'){                           //pointer ( and const pointer)
            casePointer();
            break;
        }else if (caseCharPointer && strcmp(objcType, @encode(char *)) == 0) {      //char* (and const char*)
            caseCharPointer();
            break;
        }else if (caseUnsignedLong && strcmp(objcType, @encode(unsigned long)) == 0) {
            caseUnsignedLong();
            break;
        }else if (caseUnsignedLongLong && strcmp(objcType, @encode(unsigned long long)) == 0) {
            caseUnsignedLongLong();
            break;
        }else if (caseLong && strcmp(objcType, @encode(long)) == 0) {
            caseLong();
            break;
        }else if (caseLongLong && strcmp(objcType, @encode(long long)) == 0) {
            caseLongLong();
            break;
        }else if (caseInt && strcmp(objcType, @encode(int)) == 0) {
            caseInt();
            break;
        }else if (caseUnsignedInt && strcmp(objcType, @encode(unsigned int)) == 0) {
            caseUnsignedInt();
            break;
        }else if (casecaseBOOL_Char_xyShort &&
                  (strcmp(objcType, @encode(BOOL)) == 0           ||
                   strcmp(objcType, @encode(bool)) == 0           ||
                   strcmp(objcType, @encode(char)) == 0           ||
                   strcmp(objcType, @encode(short)) == 0          ||
                   strcmp(objcType, @encode(unsigned char)) == 0  ||
                   strcmp(objcType, @encode(unsigned short)) == 0) ){
                      casecaseBOOL_Char_xyShort();
                      break;
                  }else{                  //struct union and array
                      
                      if (caseCGRect && strcmp(objcType, @encode(CGRect)) == 0){
                          caseCGRect();
                          break;
                      }else if(caseCGPoint && strcmp(objcType, @encode(CGPoint)) == 0){
                          caseCGPoint();
                          break;
                      }else if (caseCGSize && strcmp(objcType, @encode(CGSize)) == 0){
                          caseCGSize();
                          break;
                      }else if (caseNSRange && strcmp(objcType, @encode(NSRange)) == 0){
                          caseNSRange();
                          break;
                      }else if (caseUIEdgeInsets && strcmp(objcType, @encode(UIEdgeInsets)) == 0){
                          caseUIEdgeInsets();
                          break;
                      }else if (caseCGVector && strcmp(objcType, @encode(CGVector)) == 0){
                          caseCGVector();
                          break;
                      }else if (caseUIOffset && strcmp(objcType, @encode(UIOffset)) == 0){
                          caseUIOffset();
                          break;
                      }else if(caseCATransform3D && strcmp(objcType, @encode(CATransform3D)) == 0){
                          caseCATransform3D();
                          break;
                      }else if(caseCGAffineTransform && strcmp(objcType, @encode(CGAffineTransform)) == 0){
                          caseCGAffineTransform();
                          break;
                      }
                      
                      if (@available(iOS 11.0, *)){
                          if(strcmp(objcType, @encode(NSDirectionalEdgeInsets)) == 0){
                              caseNSDirectionalEdgeInsets();
                              break;
                          }
                      }
                      
                      if(defaule){
                          defaule();
                          break;
                      }
                  }
    }while(0);
}


#pragma mark - 构造
- (instancetype)initWithTarget:(id)target
{
    _target = target;
    return self;
}
+ (id)help:(id)target
{
    return [[self alloc] initWithTarget:target];
}
- (JSContext *)jscontext
{
    if(!_jscontext){
        _jscontext = [[JSContext alloc] init];
    }
    return _jscontext;
}

#ifndef LB_BLOCK_GSPathWorkerV
#define LB_BLOCK_GSPathWorkerV(from,path,to)\
^(NSValue* value){\
    return [NSValue valueWith##to:[value from##Value].path];\
}
#endif

#ifndef LB_BLOCK_GSPathWorkerN
#define LB_BLOCK_GSPathWorkerN(from,path,to)\
^(NSValue* value){\
    return [NSNumber numberWith##to:[value from##Value].path];\
}
#endif

static NSDictionary* _link_block_struct_value_path_get_map;
+ (NSDictionary*)link_block_struct_value_path_get_map
{
    if(!_link_block_struct_value_path_get_map){
        
        _link_block_struct_value_path_get_map =
        @{
          @(@encode(CGRect))    :   @{
                  @"size":LB_BLOCK_GSPathWorkerV(CGRect,size,CGSize),
                  @"origin":LB_BLOCK_GSPathWorkerV(CGRect,origin,CGPoint)
                  }
          ,
          @(@encode(CGSize))    :   @{
                  @"width":LB_BLOCK_GSPathWorkerN(CGSize,width,Double),
                  @"height":LB_BLOCK_GSPathWorkerN(CGSize,height,Double)
                  }
          ,
          @(@encode(CGPoint))    :   @{
                  @"x":LB_BLOCK_GSPathWorkerN(CGPoint,x,Double),
                  @"y":LB_BLOCK_GSPathWorkerN(CGPoint,y,Double)
                  }
          ,
          @(@encode(NSRange))    :   @{
                  @"location":LB_BLOCK_GSPathWorkerN(range,location,UnsignedInteger),
                  @"length":LB_BLOCK_GSPathWorkerN(range,length,UnsignedInteger)
                  }
          ,@(@encode(UIEdgeInsets))    :   @{
                  @"top":LB_BLOCK_GSPathWorkerN(UIEdgeInsets,top,Double),
                  @"left":LB_BLOCK_GSPathWorkerN(UIEdgeInsets,left,Double),
                  @"bottom":LB_BLOCK_GSPathWorkerN(UIEdgeInsets,bottom,Double),
                  @"right":LB_BLOCK_GSPathWorkerN(UIEdgeInsets,right,Double),
                  }
          ,@(@encode(UIOffset))    :   @{
                  @"horizontal":LB_BLOCK_GSPathWorkerN(UIOffset,horizontal,Double),
                  @"vertical":LB_BLOCK_GSPathWorkerN(UIOffset,vertical,Double)
                  }
          ,@(@encode(CGVector))    :   @{
                  @"dx":LB_BLOCK_GSPathWorkerN(CGVector,dx,Double),
                  @"dy":LB_BLOCK_GSPathWorkerN(CGVector,dy,Double)
                  }
          ,@(@encode(CATransform3D))    :   @{
                  @"m11":LB_BLOCK_GSPathWorkerN(CATransform3D,m11,Double),
                  @"m12":LB_BLOCK_GSPathWorkerN(CATransform3D,m12,Double),
                  @"m13":LB_BLOCK_GSPathWorkerN(CATransform3D,m13,Double),
                  @"m14":LB_BLOCK_GSPathWorkerN(CATransform3D,m14,Double),
                  @"m21":LB_BLOCK_GSPathWorkerN(CATransform3D,m21,Double),
                  @"m22":LB_BLOCK_GSPathWorkerN(CATransform3D,m22,Double),
                  @"m23":LB_BLOCK_GSPathWorkerN(CATransform3D,m23,Double),
                  @"m24":LB_BLOCK_GSPathWorkerN(CATransform3D,m24,Double),
                  @"m31":LB_BLOCK_GSPathWorkerN(CATransform3D,m31,Double),
                  @"m32":LB_BLOCK_GSPathWorkerN(CATransform3D,m32,Double),
                  @"m33":LB_BLOCK_GSPathWorkerN(CATransform3D,m33,Double),
                  @"m34":LB_BLOCK_GSPathWorkerN(CATransform3D,m34,Double),
                  @"m41":LB_BLOCK_GSPathWorkerN(CATransform3D,m41,Double),
                  @"m42":LB_BLOCK_GSPathWorkerN(CATransform3D,m42,Double),
                  @"m43":LB_BLOCK_GSPathWorkerN(CATransform3D,m43,Double),
                  @"m44":LB_BLOCK_GSPathWorkerN(CATransform3D,m44,Double),
                  }
          ,@(@encode(CGAffineTransform))    :   @{
                  @"a":LB_BLOCK_GSPathWorkerN(CGAffineTransform,a,Double),
                  @"b":LB_BLOCK_GSPathWorkerN(CGAffineTransform,b,Double),
                  @"c":LB_BLOCK_GSPathWorkerN(CGAffineTransform,c,Double),
                  @"d":LB_BLOCK_GSPathWorkerN(CGAffineTransform,d,Double),
                  @"tx":LB_BLOCK_GSPathWorkerN(CGAffineTransform,tx,Double),
                  @"ty":LB_BLOCK_GSPathWorkerN(CGAffineTransform,ty,Double),
                  }
          };
        
        if (@available(iOS 11.0, *)) {
            
            NSMutableDictionary* map = _link_block_struct_value_path_get_map.mutableCopy;
            map[@(@encode(NSDirectionalEdgeInsets))] =
            @{
              @"top"     :LB_BLOCK_GSPathWorkerN(directionalEdgeInsets,top,Double),
              @"leading" :LB_BLOCK_GSPathWorkerN(directionalEdgeInsets,leading,Double),
              @"bottom"  :LB_BLOCK_GSPathWorkerN(directionalEdgeInsets,bottom,Double),
              @"trailing":LB_BLOCK_GSPathWorkerN(directionalEdgeInsets,trailing,Double),
              };
            _link_block_struct_value_path_get_map = map.copy;
        }
    }
    return _link_block_struct_value_path_get_map;
}

#ifndef LB_BLOCK_SSPathWorker
#define LB_BLOCK_SSPathWorker(type,path,vType)\
^(NSValue* _self,id value){\
    type identify = [_self type##Value];\
    identify.path = [value vType##Value];\
    return [NSValue valueWith##type:identify];\
}
#endif

static NSDictionary* _link_block_struct_value_path_set_map;
+ (NSDictionary*)link_block_struct_value_path_set_map
{
    if(!_link_block_struct_value_path_set_map){
        
        _link_block_struct_value_path_set_map =
        @{
          @(@encode(CGRect))    :   @{
                  @"size":LB_BLOCK_SSPathWorker(CGRect,size,CGSize),
                  @"origin":LB_BLOCK_SSPathWorker(CGRect,origin,CGPoint)
                  },
          @(@encode(CGSize))    :   @{
                  @"width":LB_BLOCK_SSPathWorker(CGSize,width,unsignedInteger),
                  @"height":LB_BLOCK_SSPathWorker(CGSize,height,unsignedInteger)
                  },
          @(@encode(CGPoint))    :   @{
                  @"x":LB_BLOCK_SSPathWorker(CGPoint,x,double),
                  @"y":LB_BLOCK_SSPathWorker(CGPoint,y,double)
                  },
          @(@encode(NSRange))    :   @{
                  @"location":^(NSValue* _self,id value){
                      NSRange identify = [_self rangeValue];
                      identify.location = [value unsignedIntegerValue];
                      return [NSValue valueWithRange:identify];
                  },
                  @"length":^(NSValue* _self,id value){
                      NSRange identify = [_self rangeValue];
                      identify.length = [value unsignedIntegerValue];
                      return [NSValue valueWithRange:identify];
                  }
                  },
          @(@encode(UIEdgeInsets))    :   @{
                  @"top":LB_BLOCK_SSPathWorker(UIEdgeInsets,top,double),
                  @"left":LB_BLOCK_SSPathWorker(UIEdgeInsets,left,double),
                  @"bottom":LB_BLOCK_SSPathWorker(UIEdgeInsets,bottom,double),
                  @"right":LB_BLOCK_SSPathWorker(UIEdgeInsets,right,double),
                  },
          @(@encode(UIOffset))    :   @{
                  @"horizontal":LB_BLOCK_SSPathWorker(UIOffset,horizontal,double),
                  @"vertical":LB_BLOCK_SSPathWorker(UIOffset,vertical,double),
                  },
          @(@encode(CGVector))    :   @{
                  @"dx":LB_BLOCK_SSPathWorker(CGVector,dx,double),
                  @"dy":LB_BLOCK_SSPathWorker(CGVector,dy,double),
                  },
          @(@encode(CATransform3D))    :   @{
                  @"m11":LB_BLOCK_SSPathWorker(CATransform3D,m11,double),
                  @"m12":LB_BLOCK_SSPathWorker(CATransform3D,m12,double),
                  @"m13":LB_BLOCK_SSPathWorker(CATransform3D,m13,double),
                  @"m14":LB_BLOCK_SSPathWorker(CATransform3D,m14,double),
                  @"m21":LB_BLOCK_SSPathWorker(CATransform3D,m21,double),
                  @"m22":LB_BLOCK_SSPathWorker(CATransform3D,m22,double),
                  @"m23":LB_BLOCK_SSPathWorker(CATransform3D,m23,double),
                  @"m24":LB_BLOCK_SSPathWorker(CATransform3D,m24,double),
                  @"m31":LB_BLOCK_SSPathWorker(CATransform3D,m31,double),
                  @"m32":LB_BLOCK_SSPathWorker(CATransform3D,m32,double),
                  @"m33":LB_BLOCK_SSPathWorker(CATransform3D,m33,double),
                  @"m34":LB_BLOCK_SSPathWorker(CATransform3D,m34,double),
                  @"m41":LB_BLOCK_SSPathWorker(CATransform3D,m41,double),
                  @"m42":LB_BLOCK_SSPathWorker(CATransform3D,m42,double),
                  @"m43":LB_BLOCK_SSPathWorker(CATransform3D,m43,double),
                  @"m44":LB_BLOCK_SSPathWorker(CATransform3D,m44,double),
                  },
          @(@encode(CGAffineTransform))    :   @{
                  @"a":LB_BLOCK_SSPathWorker(CGAffineTransform,a,double),
                  @"b":LB_BLOCK_SSPathWorker(CGAffineTransform,b,double),
                  @"c":LB_BLOCK_SSPathWorker(CGAffineTransform,c,double),
                  @"d":LB_BLOCK_SSPathWorker(CGAffineTransform,d,double),
                  @"tx":LB_BLOCK_SSPathWorker(CGAffineTransform,tx,double),
                  @"ty":LB_BLOCK_SSPathWorker(CGAffineTransform,ty,double),
                  },
          };
        
        if (@available(iOS 11.0, *)) {
            
            NSMutableDictionary* map = _link_block_struct_value_path_set_map.mutableCopy;
            map[@(@encode(NSDirectionalEdgeInsets))] =
            @{
              @"top":^(NSValue* _self,id value){
                  NSDirectionalEdgeInsets identify = [_self directionalEdgeInsetsValue];
                  identify.top = [value doubleValue];
                  return [NSValue valueWithDirectionalEdgeInsets:identify];
              },
              @"leading":^(NSValue* _self,id value){
                  NSDirectionalEdgeInsets identify = [_self directionalEdgeInsetsValue];
                  identify.leading = [value doubleValue];
                  return [NSValue valueWithDirectionalEdgeInsets:identify];
              },
              @"bottom":^(NSValue* _self,id value){
                  NSDirectionalEdgeInsets identify = [_self directionalEdgeInsetsValue];
                  identify.bottom = [value doubleValue];
                  return [NSValue valueWithDirectionalEdgeInsets:identify];
              },
              @"trailing":^(NSValue* _self,id value){
                  NSDirectionalEdgeInsets identify = [_self directionalEdgeInsetsValue];
                  identify.trailing = [value doubleValue];
                  return [NSValue valueWithDirectionalEdgeInsets:identify];
              },
              };
            _link_block_struct_value_path_set_map = map.copy;
        }
    }
    return _link_block_struct_value_path_set_map;
}
@end
