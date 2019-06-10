//
//  LinkBlock.h
//
//  Created by Meterwhite on 15/8/13.
//  Copyright (c) 2015年 Meterwhite. All rights reserved.
//

#import "LinkObject.h"

#import "NSURL+LinkBlock.h"
#import "NSDate+LinkBlock.h"
#import "NSValue+LinkBlock.h"
#import "NSError+LinkBlock.h"
#import "NSArray+LinkBlock.h"
#import "NSObject+LinkBlock.h"
#import "NSString+LinkBlock.h"
#import "NSNumber+LinkBlock.h"
#import "NSIndexPath+LinkBlock.h"
#import "NSPredicate+LinkBlock.h"
#import "NSDictionary+LinkBlock.h"
#import "NSMutableArray+LinkBlock.h"
#import "NSMutableString+LinkBlock.h"
#import "NSAttributedString+LinkBlock.h"
#import "NSMutableDictionary+LinkBlock.h"
#import "NSMutableAttributedString+LinkBlock.h"

#import "JavaScriptCore+LinkBlock.h"

#import "UIFont+LinkBlock.h"
#import "UIView+LinkBlock.h"
#import "UIImage+LinkBlock.h"
#import "UILabel+LinkBlock.h"
#import "UIColor+LinkBlock.h"
#import "CALayer+LinkBlock.h"
#import "UIButton+LinkBlock.h"
#import "UIControl+LinkBlock.h"
#import "UIWebView+LinkBlock.h"
#import "UITextView+LinkBlock.h"
#import "UITextField+LinkBlock.h"
#import "UISearchBar+LinkBlock.h"
#import "UIImageView+LinkBlock.h"
#import "UITableView+LinkBlock.h"
#import "UIStackView+LinkBlock.h"
#import "UIBezierPath+LinkBlock.h"
#import "CAShapeLayer+LinkBlock.h"
#import "CAAnimations+LinkBlock.h"
#import "UIScrollView+LinkBlock.h"
#import "UITableViewCell+LinkBlock.h"
#import "UIViewController+LinkBlock.h"

//////////////////////////
//MARK:Basic
//////////////////////////

/**
 *  安全的链条
 *  Create linkObject.Make a safe object for link.
 */
#define linkObj(object) \
    \
    ((typeof(object))_LB_MakeObj(object))

/**
 *  ~ = linkObj...linkEnd;
 *  1.Used to get return value when needed.
 *  2.convert <LinkError || NSNull> to nil.
 */
#define linkEnd linkEnd

///For type of id
#define linkObj_id(object)  \
    \
    ((NSObject*)_LB_MakeObj(object))

//////////////////////////////////
//MARK:link objects/多对象的链条
//////////////////////////////////

/**
 * linkObjs(a,b,c...)
 *  安全的多对象的链条
 *  Craete link objects.Each one should not be nil.
 */
#define linkObjs(object,args...)    \
    \
    (_LB_MakeObjs(object,##args,nil))

/**
 <NSArray>.makeLinkObjs = linkObjs(...)
 as well as linkObjs/等同于linkObjs
 */
#define makeLinkObjs makeLinkObjs
/**
 Add a new into link objects
 ...linkPush(object)
 */
#define linkPush linkPush
/**
 Remove last object at specified index from link objects
 ...linkPop()
 */
#define linkPop linkPop

/**
 Fileter link objects.
 ...linkSelect(@"age > %@",age);
 */
#define linkSelect linkSelect

/**
 *  重复执行
 *  Repeat the following link code by copy link objects
 *  ...linkLoop(count)...
 */
#define linkLoop linkLoop
/**
 *  ~ = linkObjs......linkEnds;
 *  1.used to get return values for link objects.
 *  2.convert <LinkError||NSNull> to nil.
 */
#define linkEnds linkEnds
/**
 *  1.used to get a return value of link objects at specified index.
 *  2.convert <LinkError||NSNull> to nil.
 *  ~ = linkObjs...linkEndsAt(index);
 */
#define linkEndsAt linkEndsAt

///////////////////////////////////
//MARK:Link Condition/简单条件
///////////////////////////////////
/**
 Get linkObj from linkObjs and return it as next linkObj.
 ...linkAt(~)...
 */
#define linkAt linkAt
/**
 *  if-else in link
 *  :
 *  ...<linkIf(~)...>...<LinkElse...linkIf(~)...linkIf(~...)>
 *  `linkElse` has a higher priority.If execute <A> means that <B> would not be execut;
 */
#define linkIf linkIf
/** Refer to : linkIf */
#define linkElse linkElse
/** It is similar to linkIf.`YES` means @YES or !NSNull */
#define linkIf_YES linkIf_YES
/** It is similar to linkIf.`NO` means @NO or NSNull */
#define linkIf_NO linkIf_NO
/** It is similar to linkIf.`Null` means @NO or NSNull.It is the same as linkIf_NO */
#define linkIfNull linkIfNull
/** It is similar to linkIf.`NonNull` means @YES or !NSNull.It is the same as linkIf_YES */
#define linkIfNonNull linkIfNonNull

/**
 Return value immediately.Following block would not be execute.
 Then use `linkEnd` to get the result.
 id getValue = ...linkReturn...linkEnd;
 */
#define linkReturn linkReturn

/////////////////////////////////
//MARK: Link Indicate/链条指示
//Refer to `NSObject+LinkBlock.h`
/////////////////////////////////
#define whatSet                     whatSet
#define thisLinkObjs                thisLinkObjs
#define thisLinkObj                 thisLinkObj
#define thisValue                   thisValue
#define thisValues                  thisValues
#define thisNumber                  thisNumber
#define aBOOLValue                  aBOOLValue
#define aFloatNumber                aFloatNumber
#define aDoubleNumber               aDoubleNumber
#define anIntNumber                 anIntNumber
#define anIntegerNumber             anIntegerNumber
#define anUnsignedIntNumber         anUnsignedIntNumber
#define anUnsignedIntegerNumber     anUnsignedIntegerNumber
#define aLongNumber                 aLongNumber
#define aLongLongNumber             aLongLongNumber
#define aUnsignedLongNumber         aUnsignedLongNumber
#define aUnsignedLongLongNumber     aUnsignedLongLongNumber
#define aCGRectValue                aCGRectValue
#define aCGSizeValue                aCGSizeValue
#define aCGPointValue               aCGPointValue
#define aNSRangeValue               aNSRangeValue

//////////////////////////////////
//MARK: Other function
/////////////////////////////////
/** Default value for object */
#define linkObjDefault(object,default)  \
    \
    ((typeof(object))_LB_DefaultObj(object,default))

#define linkObjNotNil(object)   \
    \
    ((typeof(object))_LB_NotNilObj(object))

#define objIsEqualToEach(obj, args...)  \
    \
    objIsEqualToEach(obj,##args,nil)

#define objIsEqualToEachAs(obj, args...)    \
    \
    objIsEqualToEachAs(obj,##args,nil)

#define objIsEqualToSomeone(obj, args...)   \
    \
    objIsEqualToSomeone(obj,##args,nil)

#define objIsEqualToSomeoneAs(obj, args...) \
    \
    objIsEqualToSomeoneAs(obj,##args,nil)

#define strAppendFormat(formatStr, args...) \
    \
    strAppendFormat(formatStr , ##args , nil)

#define numIsEqualToNum(...)    \
    \
    numIsEqualToNum(LBBoxValue((__VA_ARGS__)))

#define numIsEqualToNumAs(...)  \
    \
    numIsEqualToNumAs(LBBoxValue((__VA_ARGS__)))

#define numIsGreatThan(...) \
    \
    numIsGreatThanNum(LBBoxValue((__VA_ARGS__)))

#define numIsGreatThanNumAs(...)    \
    \
    numIsGreatThanNumAs(LBBoxValue((__VA_ARGS__)))

#define numIsGreatEqualNum(...) \
    \
    numIsGreatEqualNum(LBBoxValue((__VA_ARGS__)))

#define numIsGreatEqualNumAs(...)   \
    \
    numIsGreatEqualNumAs(__VA_ARGS__)

#define numIsLessThanNum(...)   \
    \
    numIsLessThanNum(LBBoxValue((__VA_ARGS__)))

#define numIsLessThanNumAs(...) \
    \
    numIsLessThanNumAs(LBBoxValue((__VA_ARGS__)))


#define numIsLessEqualNum(...)  \
    \
    numIsLessEqualNum(LBBoxValue((__VA_ARGS__)))

#define numIsLessEqualNumAs(...)    \
    \
    numIsLessEqualNumAs(LBBoxValue((__VA_ARGS__)))

#define objPerformSelectors(sel , args...)  \
    \
    objPerformSelectors(sel, ##args , nil)


#define objPerformsSelectorArguments(sel0,args0,args...)    \
    \
    objPerformsSelectorArguments(sel0,args0,##args,nil)

#define objPerformSelectorsAsWhatReturns(sel,args...)   \
    \
    objPerformSelectorsAsWhatReturns(sel,##args,nil)

#define objPerformsSelectorArgumentsAsWhatReturns(sel0,arg0,args...)    \
    \
    objPerformsSelectorArgumentsAsWhatReturns(sel0,arg0,##args,nil)

#define viewAddSubviews(view0,args...)  \
    \
    viewAddSubviews(view0,##args,nil)
