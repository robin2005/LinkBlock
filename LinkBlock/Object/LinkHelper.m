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

#pragma mark - 功能

- (id)blockPropertyFromObjectByPropertyName:(NSString *)propertyName
{
    if(LBEqualNil(self.target)) return nil;
    
    SEL sel = NSSelectorFromString(propertyName);
    //可响应
    if(![self.target respondsToSelector:sel]) return nil;
    
    NSMethodSignature* signature = [self.target methodSignatureForSelector:sel];
    
    //无参的
    if(signature.numberOfArguments != 2) return nil;
    //block的
    const char* returnType =  signature.methodReturnType;
    if(returnType[strlen(returnType) - 1] != '?') return nil;
    
    NSInvocation* blockPropertyInvocation = [NSInvocation invocationWithMethodSignature:signature];
    blockPropertyInvocation.target = self.target;
    blockPropertyInvocation.selector = sel;
    
    [blockPropertyInvocation invoke];
    
    id block;
    [blockPropertyInvocation getReturnValue:&block];
    CFBridgingRetain(block);
    return block;
}

- (NSArray<NSString *> *)actionCommandSplitFromLinkCode
{
    if(!self_target_is_type(NSString)) return nil;
    
    NSString* code = [self.target copy];
    if([code characterAtIndex:code.length-1] != '.'){
        code = [code stringByAppendingString:@"."];
    }
    NSMutableArray<NSString*>* blocksString = [NSMutableArray new];
    
    //函数名可空白(非贪婪个任意字符).
    //函数名.
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"[a-zA-Z_]+\\w*(\\s*\\(.*?\\)\\.|\\.)" options:0 error:nil];
    [regex enumerateMatchesInString:code options:0 range:NSMakeRange(0, code.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        [blocksString addObject: [code substringWithRange:NSMakeRange(result.range.location, result.range.length-1)]];
    }];
    
    return blocksString;
}

static NSString* _lbEncodeFormate = @"_LB%@_";
- (BOOL)isCodeLinkBlockEncoded
{
    
    if(!self_target_is_type(NSString)) return NO;

    NSString* preString = self.target;
    preString = preString.strTrimLeft(@" ").strTrimRight(@" ");
    
    __block BOOL hasNonWDString = NO;//是否含有非数字或字母的串
    [self.target enumerateSubstringsInRange:NSMakeRange(0, [self.target length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        const char* chs = substring.UTF8String;
        if(strlen(chs)>1 ||
           chs[0]<48 ||
           (chs[0]>57 && chs[0]<65) ||
           (chs[0]>90 && chs[0]<95) ||
           chs[0]==96 || chs[0]>122
           ){
            hasNonWDString = YES;
            *stop = YES;
        }
    }];
    
    if(hasNonWDString) return NO;
    

    if([preString rangeOfString:@"NSString"].location == 0) return YES;
    if([preString rangeOfString:@"NSNumber"].location == 0) return YES;
    return NO;
}

- (NSString*)linkBlockEncodingNSStringAndNSNumberFromCode
{
    /*
     *LinkBlock编码
     *原理:将字符串和装箱数字的直接量@"..."和@(...)，硬编码成字母和下划线组成的编码形式
     *其中非函数名字符转为:_LB + Unicode编码数字部分 + _
     *如：@"..." => NSString_LB002e__LB002e__LB002e_ 和 @(...) => NSNumber_LB002e__LB002e__LB002e_
     */
    if(!self_target_is_type(NSString)) return nil;
    //预匹配
    NSString* code = self.target;
    //NSString: @可空白"
    BOOL hasNSString = [self.target rangeOfString:@"@\\s*\"" options:NSRegularExpressionSearch].length;
    
    //NSNumber: @可空白(
    BOOL hasNSNumber = [self.target rangeOfString:@"@\\s*\\(" options:NSRegularExpressionSearch].length;
    
    if(!hasNSString && !hasNSNumber)
        return self.target;
    
    __block NSInteger state= 0 ;//0-Non,1-NSString,2-chars,3-NSNumber
    __block NSInteger idx = 0;
    NSMutableArray<NSString*>* stack = [NSMutableArray new];
    if(hasNSString){
        
        [code enumerateSubstringsInRange:NSMakeRange(0, code.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
            
            //普通状态
            if(state == 0){
                
                if([substring isEqualToString:@"\""]){
                    
                    if(idx > 0){
                        
                        if([[code substringWithRange:[code rangeOfComposedCharacterSequenceAtIndex:idx-1]] isEqualToString:@"@"]){
                            //NSString
                            state = 1;
                            [stack removeLastObject];
                            [stack addObject:@"NSString"];
                            idx++;
                            return;
                        }else{
                            //chars
                            [stack addObject:@"chars"];
                            state = 2;
                            idx++;
                            return;
                        }
                    }else{
                        //chars
                        state = 2;
                        [stack addObject:@"chars"];
                        idx++;
                        return;
                    }
                }
                [stack addObject:substring];
                idx++;
                return;
            }
            /*
             *encode
             [0-9]=>[48-57]
             [A-Z]=>[65-90]
             _ => 95
             [a-z]=>[97-122]
             */
            /*
             * 识别
             * " => 34
             * ( => 40
             * ) => 41
             * @ => 64
             * \ => 92
             */
            
            //转码中
            if(state == 1 || state == 2){
                
                //是否是字符串结束符号"
                if([substring isEqualToString:@"\""]){
                    
                    NSUInteger countOf92 = 0;
                    for (NSInteger i = idx-1; i>-1; i--) {
                        
                        if([[code substringWithRange:[code rangeOfComposedCharacterSequenceAtIndex:i]] isEqualToString:@"\\"]){
                            countOf92++;
                        }else{
                            break;
                        }
                    }
                    //转码字符串中遇到",前面是偶数个\时结束转码
                    if(countOf92%2 == 0){
                        //转码结束
                        state = 0;
                        idx++;
                        return;
                    }else{
                        
                        [stack addObject:[NSString stringWithFormat:_lbEncodeFormate,[substring.strToUnicoding() substringFromIndex:2]]];
                    }
                }else{
                    
                    const char* chs = substring.UTF8String;
                    if(strlen(chs)>1 ||
                       chs[0]<48 ||
                       (chs[0]>57 && chs[0]<65) ||
                       (chs[0]>90 && chs[0]<95) ||
                       chs[0]==96 || chs[0]>122
                       ){
                        //需要转码
                        [stack addObject:[NSString stringWithFormat:_lbEncodeFormate,[substring.strToUnicoding() substringFromIndex:2]]];
                    }else{
                        //不需要转码
                        [stack addObject:substring];
                    }
                }
            }
            idx++;
        }];
        
        
        if(state != 0){
            NSLog(@"DynamicLink Error:Check inner string of %@ if is complete.",code);
            return nil;
        }
        
        NSMutableString* stackString = [NSMutableString new];
        [stack enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [stackString appendString:obj];
        }];
        
        code = stackString.copy;
        if(!hasNSNumber){
            return code;
        }
    }
    //NSNumber
    [stack removeAllObjects];
    state= 0 ;//0-Non,1-NSString,2-chars,3-NSNumber
    idx = 0;
    __block NSInteger pairValue = 0;

    [code enumerateSubstringsInRange:NSMakeRange(0, code.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        //普通状态
        if(state == 0){
            
            if([substring isEqualToString:@"("]){
                
                if(idx > 0 &&
                   [[code substringWithRange:[code rangeOfComposedCharacterSequenceAtIndex:idx-1]] isEqualToString:@"@"]){
                    
                    //NSNumber
                    pairValue -= 1;
                    state = 3;
                    [stack removeLastObject];
                    [stack addObject:@"NSNumber"];
                    idx++;
                    return;
                }else{
                    
                    [stack addObject:substring];
                    idx++;
                    return;
                }
            }else{
                
                [stack addObject:substring];
                idx++;
                return;
            }
        }
        
        //转码中
        if(state == 3){
            
            if([substring isEqualToString:@"("]){
                
                //需要转码
                [stack addObject:[NSString stringWithFormat:_lbEncodeFormate,[substring.strToUnicoding() substringFromIndex:2]]];
                pairValue -= 1;
                idx++;
                return;
            }else if([substring isEqualToString:@")"]){
                
                //是否是字符串结束符号"
                pairValue += 1;
                if(pairValue == 0){//匹配完成的)
                    //转码结束
                    state = 0;
                    idx++;
                    return;
                }else{
                    
                    //匹配途中的)
                    [stack addObject:[NSString stringWithFormat:_lbEncodeFormate,[substring.strToUnicoding() substringFromIndex:2]]];
                }
            }else{
                const char* chs = substring.UTF8String;
                
                if(strlen(chs)>1 ||
                   chs[0]<48 ||
                   (chs[0]>57 && chs[0]<65) ||
                   (chs[0]>90 && chs[0]<95) ||
                   chs[0]==96 || chs[0]>122
                   ){
                    //需要转码
                    [stack addObject:[NSString stringWithFormat:_lbEncodeFormate,[substring.strToUnicoding() substringFromIndex:2]]];
                }else{
                    //不需要转码
                    [stack addObject:substring];
                }
            }
        }
        idx++;
    }];
    
    if(state != 0){
        NSLog(@"DynamicLink Error:Check if there are unfinished '()' in %@",code);
        return nil;
    }
    
    NSMutableString* stackString = [NSMutableString new];
    [stack enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [stackString appendString:obj];
    }];
    
    return stackString.copy;
}


- (NSString *)functionNameSplitFromFunctionCode
{
    if(!self_target_is_type(NSString)) return nil;
    
    NSRange rangeOfBlockName = [self.target rangeOfString:@"[a-zA-Z_]+\\w*\\s*\\(" options:NSRegularExpressionSearch];
    if(!rangeOfBlockName.length) return nil;
    NSString* functionName = [self.target substringWithRange:rangeOfBlockName];
    functionName = [functionName stringByReplacingOccurrencesOfString:@" " withString:@""];
    functionName = [functionName substringToIndex:functionName.length-1];
    return functionName;
}

- (NSString *)propertyNameFromPropertyCode
{
    if(!self_target_is_type(NSString)) return nil;
    NSRange rangeOfPropertyName = [self.target rangeOfString:@"[a-zA-Z_]+\\w*" options:NSRegularExpressionSearch];
    if(!rangeOfPropertyName.length) return nil;
    NSString* propertyName = [self.target substringWithRange:rangeOfPropertyName];
    propertyName = [propertyName stringByReplacingOccurrencesOfString:@" " withString:@""];
    return propertyName;
}



- (NSNumber *)numberEvalFromCode
{
    if(!self_target_is_type(NSString)) return nil;
    //纯数字
    NSScanner* scanner = [[NSScanner alloc] initWithString:self.target];
    if([scanner scanInteger:NULL] && [scanner isAtEnd]){
        return [NSNumber numberWithInteger:[self.target intValue]];
    }
    scanner.scanLocation = 0;
    if([scanner scanDouble:NULL] && [scanner isAtEnd]){
        return [NSNumber numberWithDouble:[self.target doubleValue]];
    }
    
    //不能出现 } ; { 防止定义函数
    if([self.target containsString:@"{"]||
       [self.target containsString:@"}"]||
       [self.target containsString:@";"]){
        return nil;
    }
    
    //需要计算的情况交给JSCore
    JSValue* jsV = [self.jscontext evaluateScript:self.target];
    if(jsV.isNumber){
        return jsV.toNumber;
    }
    NSLog(@"DynamicLink Error:Unrecognized value %@",self.target);
    return nil;
}


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
static NSArray* _listOfLinkBlockIsIndefiniteParameters;
- (NSArray*)listOfLinkBlockIsIndefiniteParameters
{
    if(!_listOfLinkBlockIsIndefiniteParameters){
        _listOfLinkBlockIsIndefiniteParameters
        = @[@"objPerformSelectors",@"objPerformSelectorsWithArgs",
            @"strToPredicateWidthFormatArgs",@"viewAddSubviews",
            @"strAppendFormat",
            @"objPerformSelectorsWithArgsAsWhatReturns",
            @"objIsEqualToSomeone",@"objIsEqualToSomeoneAs",
            @"objPerformSelectorsAsWhatReturns",
            @"objIsEqualToEach",@"objIsEqualToEachAs",
            @"arrFilter"];
    }
    return _listOfLinkBlockIsIndefiniteParameters;
}

static NSArray* _listOfLinkBlockUnavailableAction;
- (NSArray*)listOfLinkBlockUnavailableAction{
    if(!_listOfLinkBlockUnavailableAction){
        _listOfLinkBlockUnavailableAction
        = @[@"linkObj",@"linkObj_id",@"linkObjs"];
    }
    return _listOfLinkBlockUnavailableAction;
}

#pragma mark - 消息转发
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//+ (BOOL)resolveClassMethod:(SEL)sel
//快速转发
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}

//普通转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [self.target methodSignatureForSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    //...
}

#pragma mark - NSObject
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (Class)superclass {
    return [_target superclass];
}

- (Class)class {
    return [_target class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}

#pragma mark - 配置
static bool _link_block_configuration_get_is_show_warning = true;
+ (BOOL)link_block_configuration_get_is_show_warning
{
    return _link_block_configuration_get_is_show_warning;
}
+ (void)link_block_configuration_set_is_show_warning:(BOOL)b
{
    _link_block_configuration_get_is_show_warning = b;
}

//- (void)dealloc
//{
//    @"end of help".nslog();
//}

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
