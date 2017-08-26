//
// NSObject+MadLifeDB.m
// Copyright (c) 2017年 MadLifeSama. All rights reserved.
// https://github.com/MadLifeSama/MadLifeDB.git
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "NSObject+MadLifeDB.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSObject (MadLife)

-(BOOL)mad_addOrUpdateToDB{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:self];
    return [cache addOrUpdateObject:self];
}

-(BOOL)mad_addOrIgnoreToDB{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:self];
    return [cache addOrIgnoreObject:self];
}

+(BOOL)mad_addOrUpdateToDBWithDict:(NSDictionary *)dict{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:[[[self class] alloc] init]];
    return [cache addOrUpdateWithClass:self withDict:dict];
}

-(BOOL)mad_deleteFromDB{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:self];
    BOOL result = [cache deleteObject:self];
    return result;
}
+(BOOL)mad_deleteFromDBWithCondition:(NSString *)condition{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:[[[self class] alloc] init]];
    BOOL result = [cache deleteClass:[self class] where:condition];
    return result;
}

+(void)mad_inTransaction:(void (^)(MadLifeManager *, BOOL *))block{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:[[[self class] alloc] init]];
    [cache inTransaction:^(BOOL *rollback) {
        block(cache,rollback);
    }];
}

+(id)mad_queryObjectOnPrimary:(id)primaryValue{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:[[[self class] alloc] init]];
    return [cache queryWithClass:[self class] onPrimary:primaryValue];
}

+(NSArray*)mad_queryObjectsWithCondition:(NSString *)condition{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:[[[self class] alloc] init]];
    return [cache queryWithClass:[self class] condition:condition];
}

+(NSArray*)mad_queryObjectsWithConditions:(NSString *)conditionFromat,...{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:[[[self class] alloc] init]];
    if(conditionFromat != nil){
        va_list ap;
        va_start(ap, conditionFromat);
        NSString *predicateSql = [[NSString alloc] initWithFormat:conditionFromat arguments:ap];
        va_end(ap);
        return  [cache queryWithClass:[self class] conditions:predicateSql];
    }else{
        return  [cache queryWithClass:[self class] conditions:nil];
    }
}

+(NSInteger)mad_queryObjectCount{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:[[[self class] alloc] init]];
    return [cache queryCount:[self class]];
}
-(NSInteger)mad_queryObjectUpdateTime{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:self];
    return [cache queryUpdateTime:self];
}

-(NSInteger)mad_queryObjectCreateTime{
    MadLifeManager *cache = [[MadLifeManager alloc] initWithObject:self];
    return [cache queryCreateTime:self];
}

@end
