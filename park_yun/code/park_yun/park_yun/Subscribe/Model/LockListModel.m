//
//  LockListModel.m
//
//  Created by allen  on 15-4-2
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "LockListModel.h"
#import "LockListResult.h"


#define kLockListModelFlag  @"flag"
#define kLockListModelResult  @"result"


@interface LockListModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LockListModel

@synthesize flag = _flag;
@synthesize result = _result;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.flag = [self objectOrNilForKey:kLockListModelFlag fromDictionary:dict];
            self.result = [LockListResult modelObjectWithDictionary:[dict objectForKey:kLockListModelResult]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.flag forKey:kLockListModelFlag];
    [mutableDict setValue:[self.result dictionaryRepresentation] forKey:kLockListModelResult];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.flag = [aDecoder decodeObjectForKey:kLockListModelFlag];
    self.result = [aDecoder decodeObjectForKey:kLockListModelResult];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_flag forKey:kLockListModelFlag];
    [aCoder encodeObject:_result forKey:kLockListModelResult];
}

- (id)copyWithZone:(NSZone *)zone
{
    LockListModel *copy = [[LockListModel alloc] init];
    
    if (copy) {

        copy.flag = [self.flag copyWithZone:zone];
        copy.result = [self.result copyWithZone:zone];
    }
    
    return copy;
}


@end
