//
//  LinkInfo.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 16/7/12.
//  Copyright © 2016年 Meterwhite. All rights reserved.
//

#import "LinkBlockDefine.h"

typedef enum LinkInfoType{
    LinkInfoNone,
    LinkInfoError,
    LinkInfoGroup,
    LinkInfoReturn
}LinkInfoType;

@interface LinkInfo : NSObject
{
    @protected
    LinkInfoType _infoType;
}
@property (nonatomic,assign,readonly) LinkInfoType infoType;
/** index of error/传递距离 */
@property (nonatomic,assign) NSInteger throwCount;
@property (nonatomic,strong) NSMutableDictionary* userInfo;
- (void)cleanUserInfo;

@end
