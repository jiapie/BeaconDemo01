//
//  common.h
//  Beacon
//
//  Created by Lee, Chia-Pei on 2017/1/20.
//  Copyright (c) 2017年 Lee, Chia-Pei. All rights reserved.
//

#ifndef Beacon_common_h
#define Beacon_common_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
//Crypto
#import <CommonCrypto/CommonDigest.h>
#import "Hash.h"
//Beacon
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
//Audio
#import <AVFoundation/AVFoundation.h>
//Data
#import "jsonEX.h"

static NSString *sDeviceFile    = @"Device.json";
static NSString *sDefaultPic    = @"ibeacon.png";
//JSON
static NSString *sJson_Device   = @"Device";
static NSString *sJson_UUID     = @"UUID";
static NSString *sJson_SECTION  = @"SECTION";
static NSString *sJson_Major    = @"Major";
static NSString *sJson_Minor    = @"Minor";
static NSString *sJson_Title    = @"Title";
static NSString *sJson_Pic      = @"Pic";
static NSString *sJson_Voice    = @"Voice";

//Display
#define UI_SCREEN_X 0.0
#define UI_SCREEN_Y 0.0
#define UI_SCREEN_W [[UIScreen mainScreen] bounds].size.width
#define UI_SCREEN_H [[UIScreen mainScreen] bounds].size.height

//Voice
#define Default_Volume  0.35

//TableView
static NSString *sTableItem = @"TableItem";

//Button
static NSString *sPlay          = @"播放";
static NSString *sStop          = @"停止";
#endif
