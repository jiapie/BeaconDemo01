//
//  AppDelegate.h
//  Beacon
//
//  Created by LeeChia-Pei on 2017/1/20.
//  Copyright © 2017年 Lee Chia-Pei. All rights reserved.
//
#import "common.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
@end

