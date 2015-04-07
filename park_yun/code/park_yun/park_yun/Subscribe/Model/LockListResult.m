//
//  Result.m
//
//  Created by allen  on 15-4-2
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "LockListResult.h"
#import "LockListInfo.h"


#define kResultCount  @"count"
#define kResultLockList  @"lockList"


@interface LockListResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LockListResult

@synthesize count = _count;
@synthesize lockList = _lockList;


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
            self.count = [[self objectOrNilForKey:kResultCount fromDictionary:dict] doubleValue];
    NSObject *receivedLockList = [dict objectForKey:kResultLockList];
    NSMutableArray *parsedLockList = [NSMutableArray array];
    if ([receivedLockList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLockList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLockList addObject:[LockListInfo modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLockList isKindOfClass:[NSDictionary class]]) {
       [parsedLockList addObject:[LockListInfo modelObjectWithDictionary:(NSDictionary *)receivedLockList]];
    }

    self.lockList = [NSArray arrayWithArray:parsedLockList];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.count] forKey:kResultCount];
    NSMutableArray *tempArrayForLockList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.lockList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForLockList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForLockList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLockList] forKey:kResultLockList];

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

    self.count = [aDecoder decodeDoubleForKey:kResultCount];
    self.lockList = [aDecoder decodeObjectForKey:kResultLockList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_count forKey:kResultCount];
    [aCoder encodeObject:_lockList forKey:kResultLockList];
}

- (id)copyWithZone:(NSZone *)zone
{
    LockListResult *copy = [[LockListResult alloc] init];
    
    if (copy) {

        copy.count = self.count;
        copy.lockList = [self.lockList copyWithZone:zone];
    }
    
    return copy;
}


@end
