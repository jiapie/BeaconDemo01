//
//  Hash.h
//  Beacon
//
//  Created by Lee, Chia-Pei on 2017/1/20.
//  Copyright (c) 2017年 Lee, Chia-Pei. All rights reserved.
//

#ifndef Beacon_Hash_h
#define Beacon_Hash_h
#import "common.h"

@interface NSString (hash)

@property (nonatomic, readonly) NSString *md5;
@property (nonatomic, readonly) NSString *sha1;
@property (nonatomic, readonly) NSString *sha224;
@property (nonatomic, readonly) NSString *sha256;
@property (nonatomic, readonly) NSString *sha384;
@property (nonatomic, readonly) NSString *sha512;

@end
#endif
