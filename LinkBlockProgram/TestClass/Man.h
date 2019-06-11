//
//  Man.h
//  LinkBlockProgram
//
//  Created by Meterwhite on 16/8/24.
//  Copyright © 2016年 Meterwhite. All rights reserved.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN
@interface Man : Person<NSCopying>
@property (nonatomic,strong) Man* son;
@property (nonatomic,strong) NSArray<Person*>* family;
@property (nonatomic,copy) id(^computeAdd)(id a0,id a1);

@property (nonatomic,assign) SEL mySEL;

@end
NS_ASSUME_NONNULL_END
