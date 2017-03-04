//
//  ViewController.h
//  Beacon
//
//  Created by LeeChia-Pei on 2017/1/20.
//  Copyright © 2017年 Lee Chia-Pei. All rights reserved.
//

#import "common.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate>
{
    IBOutlet UISegmentedControl *sStatus;
    
    IBOutlet UIView         *thisView;
    IBOutlet UIImageView    *thisImageView;
    IBOutlet UITableView    *thisTableView;

    //Audio
    AVAudioPlayer * player;
    IBOutlet UIProgressView *thisProgressView;
    IBOutlet UIButton       *bMute;
    IBOutlet UIButton       *bSpeaker;
    IBOutlet UIButton       *bPlay;
    
    //Json Data
    NSString    *UUID;
    NSArray     *aSECTION;
    //NSArray     *aTableArray;
}

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

