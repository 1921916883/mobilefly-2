//
//  LockList.h
//
//  Created by allen  on 15-4-2
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LockListInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *lockId;
@property (nonatomic, strong) NSString *lockParkcode;
@property (nonatomic, strong) NSString *lockNo;
@property (nonatomic, strong) NSString *lockSeatcode;
@property (nonatomic, strong) NSString *lockParkid;
@property (nonatomic, strong) NSString *lockCode;
@property (nonatomic, strong) NSString *lockUtime;
@property (nonatomic, strong) NSString *lockStatus;
@property (nonatomic, strong) NSString *lockFlag;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
