//
//  Result.h
//
//  Created by allen  on 15-4-2
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LockListResult : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double count;
@property (nonatomic, strong) NSArray *lockList;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
