//
//  jsonEX_h
//  Beacon
//
//  Created by Lee, Chia-Pei on 2017/1/20.
//  Copyright (c) 2017年 Lee, Chia-Pei. All rights reserved.
//


#ifndef Beacon_jsonEX_h
#define Beacon_jsonEX_h

#import "common.h"

@interface NSDictionary(JSONCategories)
+(NSDictionary*) dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;
+(NSDictionary*) dictionaryWithContentsOfJSONFile:(NSString*)jsonFile;
+(NSDictionary*) dictionaryWithJSONData:(NSData *)jsonData;
+(NSString *) NSDictionarytoJSON:(NSDictionary *)myDictionary;
@end

@interface  NSArray(JSONCategories)
+(NSArray*) arrayWithContentsOfJSONURLString:(NSString*)urlAddress;
+(NSArray*) arrayWithContentsOfJSONFile:(NSString*)jsonFile;
+(NSArray*) arrayWithJSONData:(NSData *)jsonData;
+(NSString *)NSArraytoJSON:(NSMutableArray *)myArray;
@end
#endif
