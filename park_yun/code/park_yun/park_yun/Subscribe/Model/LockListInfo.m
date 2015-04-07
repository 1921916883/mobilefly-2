//
//  LockList.m
//
//  Created by allen  on 15-4-2
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "LockListInfo.h"


#define kLockListLockId  @"lockId"
#define kLockListLockParkcode  @"lockParkcode"
#define kLockListLockNo  @"lockNo"
#define kLockListLockSeatcode  @"lockSeatcode"
#define kLockListLockParkid  @"lockParkid"
#define kLockListLockCode  @"lockCode"
#define kLockListLockUtime  @"lockUtime"
#define kLockListLockStatus  @"lockStatus"
#define kLockListLockFlag  @"lockFlag"


@interface LockListInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LockListInfo

@synthesize lockId = _lockId;
@synthesize lockParkcode = _lockParkcode;
@synthesize lockNo = _lockNo;
@synthesize lockSeatcode = _lockSeatcode;
@synthesize lockParkid = _lockParkid;
@synthesize lockCode = _lockCode;
@synthesize lockUtime = _lockUtime;
@synthesize lockStatus = _lockStatus;
@synthesize lockFlag = _lockFlag;


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
            self.lockId = [self objectOrNilForKey:kLockListLockId fromDictionary:dict];
            self.lockParkcode = [self objectOrNilForKey:kLockListLockParkcode fromDictionary:dict];
            self.lockNo = [self objectOrNilForKey:kLockListLockNo fromDictionary:dict];
            self.lockSeatcode = [self objectOrNilForKey:kLockListLockSeatcode fromDictionary:dict];
            self.lockParkid = [self objectOrNilForKey:kLockListLockParkid fromDictionary:dict];
            self.lockCode = [self objectOrNilForKey:kLockListLockCode fromDictionary:dict];
            self.lockUtime = [self objectOrNilForKey:kLockListLockUtime fromDictionary:dict];
            self.lockStatus = [self objectOrNilForKey:kLockListLockStatus fromDictionary:dict];
            self.lockFlag = [self objectOrNilForKey:kLockListLockFlag fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lockId forKey:kLockListLockId];
    [mutableDict setValue:self.lockParkcode forKey:kLockListLockParkcode];
    [mutableDict setValue:self.lockNo forKey:kLockListLockNo];
    [mutableDict setValue:self.lockSeatcode forKey:kLockListLockSeatcode];
    [mutableDict setValue:self.lockParkid forKey:kLockListLockParkid];
    [mutableDict setValue:self.lockCode forKey:kLockListLockCode];
    [mutableDict setValue:self.lockUtime forKey:kLockListLockUtime];
    [mutableDict setValue:self.lockStatus forKey:kLockListLockStatus];
    [mutableDict setValue:self.lockFlag forKey:kLockListLockFlag];

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

    self.lockId = [aDecoder decodeObjectForKey:kLockListLockId];
    self.lockParkcode = [aDecoder decodeObjectForKey:kLockListLockParkcode];
    self.lockNo = [aDecoder decodeObjectForKey:kLockListLockNo];
    self.lockSeatcode = [aDecoder decodeObjectForKey:kLockListLockSeatcode];
    self.lockParkid = [aDecoder decodeObjectForKey:kLockListLockParkid];
    self.lockCode = [aDecoder decodeObjectForKey:kLockListLockCode];
    self.lockUtime = [aDecoder decodeObjectForKey:kLockListLockUtime];
    self.lockStatus = [aDecoder decodeObjectForKey:kLockListLockStatus];
    self.lockFlag = [aDecoder decodeObjectForKey:kLockListLockFlag];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lockId forKey:kLockListLockId];
    [aCoder encodeObject:_lockParkcode forKey:kLockListLockParkcode];
    [aCoder encodeObject:_lockNo forKey:kLockListLockNo];
    [aCoder encodeObject:_lockSeatcode forKey:kLockListLockSeatcode];
    [aCoder encodeObject:_lockParkid forKey:kLockListLockParkid];
    [aCoder encodeObject:_lockCode forKey:kLockListLockCode];
    [aCoder encodeObject:_lockUtime forKey:kLockListLockUtime];
    [aCoder encodeObject:_lockStatus forKey:kLockListLockStatus];
    [aCoder encodeObject:_lockFlag forKey:kLockListLockFlag];
}

- (id)copyWithZone:(NSZone *)zone
{
    LockListInfo *copy = [[LockListInfo alloc] init];
    
    if (copy) {

        copy.lockId = [self.lockId copyWithZone:zone];
        copy.lockParkcode = [self.lockParkcode copyWithZone:zone];
        copy.lockNo = [self.lockNo copyWithZone:zone];
        copy.lockSeatcode = [self.lockSeatcode copyWithZone:zone];
        copy.lockParkid = [self.lockParkid copyWithZone:zone];
        copy.lockCode = [self.lockCode copyWithZone:zone];
        copy.lockUtime = [self.lockUtime copyWithZone:zone];
        copy.lockStatus = [self.lockStatus copyWithZone:zone];
        copy.lockFlag = [self.lockFlag copyWithZone:zone];
    }
    
    return copy;
}


@end
