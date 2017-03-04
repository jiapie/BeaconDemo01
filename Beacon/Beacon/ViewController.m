//
//  ViewController.m
//  Beacon
//
//  Created by LeeChia-Pei on 2017/1/20.
//  Copyright © 2017年 Lee Chia-Pei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
#pragma mark - 聲音設定
-(void) playMusic:(NSString *)sFilename and:(NSString *)sType
{
    //取得檔案的路徑
    NSString * musicPath = [[NSBundle mainBundle] pathForResource:sFilename ofType:sType];
    //NSLog(@"musicPath:%@",musicPath);
    //載入至NSData物件中
    NSData * musicData = [NSData dataWithContentsOfFile:musicPath];
    
    //建立AVAudioPlayer物件，
    //將資料檔交給AVAudioPlayer物件
    player = [[AVAudioPlayer alloc] initWithData:musicData error:nil];
    
    //檢查是否可播放
    if(player != nil && [player prepareToPlay] == YES)
    {
        //傳送play訊息，播放mp3
        [player play];
        [player setVolume:Default_Volume];
        thisProgressView.progress = Default_Volume;
        [bPlay setTitle:sStop forState:UIControlStateNormal];
    }
}

-(IBAction) playAudio_Action:(id)sender
{
    if(player.playing)
    {
        //NSLog(@"停止");
        [player stop];
        [bPlay setTitle:sPlay forState:UIControlStateNormal];
    }
    else
    {
        //NSLog(@"播放");
        [player play];
        [bPlay setTitle:sStop forState:UIControlStateNormal];
    }
}

-(IBAction) increaseVolume_Action:(id)sender
{
    //NSLog(@"increaseVolume_Action");
    [self setVolume:@"1"];
}

-(IBAction)decreaseVolume_Action:(id)sender
{
    //NSLog(@"decreaseVolume_Action");
    [self setVolume:@"0"];
}

-(void) setVolume:(NSString *)sType
{
    CGFloat Volume = player.volume;
    if([sType isEqualToString:@"0"])
    {
        Volume -= 0.05;
    }
    else
    {
        Volume += 0.05;
    }
    
    thisProgressView.progress = Volume;
    [player setVolume:Volume];
}

#pragma mark - BeaconDevice
-(void) getBeaconData
{
    //NSLog(@"getPageRight");
    NSString *sGetDeviceFile = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:sDeviceFile];
    
    NSData *dAllData = [NSData dataWithContentsOfFile:sGetDeviceFile];
    __autoreleasing NSError* error =nil;
    NSDictionary *dGetData = [NSJSONSerialization JSONObjectWithData:dAllData options:NSJSONReadingMutableContainers error: &error];
    NSDictionary *dDevice = [dGetData valueForKey:sJson_Device];
    //NSLog(@"dDevice:%@",dDevice);
    UUID = [dDevice valueForKey:sJson_UUID];
    aSECTION = [dDevice valueForKey:sJson_SECTION];
    /*
    for(id obj in aSECTION)
    {
        aTableArray = [obj valueForKey:sJson_Minor];
        NSLog(@"aTableArray:%@",aTableArray);
    }
    */
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Finding beacons.");
    // We entered a region, now start looking for our target beacons!
    //self.statusLabel.text = @"Finding beacons.";
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"None found.");
    // Exited the region
    //self.statusLabel.text = @"None found.";
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    NSLog(@"Beacon found!");
    // Beacon found!
    //self.statusLabel.text = @"Beacon found!";
    
    CLBeacon *foundBeacon = [beacons firstObject];
    // You can retrieve the beacon data from its properties
    NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
    NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
    
    for(id obj in aSECTION)
    {
        NSString *sMajor = [obj valueForKey:sJson_Major];
        if([sMajor isEqualToString:major])
        {
            NSArray *aTableArray = [obj valueForKey:sJson_Minor];
            for(id obj2 in aTableArray)
            {
                NSString *sMinor = [obj2 valueForKey:sJson_Minor];
                if([sMinor isEqualToString:minor])
                {
                    NSLog(@"UUID:%@, major:%@, minor:%@",uuid, major, minor);
                    
                    //Pic
                    [thisImageView setImage:[UIImage imageNamed:[obj2 valueForKey:sJson_Pic]]];
                    
                    //Voice
                    NSString *sMusic = [NSString stringWithFormat:@"%@",[obj2 valueForKey:sJson_Voice]];
                    NSArray *split = [sMusic componentsSeparatedByString:@"."];
                    [self playMusic:split[0] and:split[1]];
                    
                    /*
                    [self.locationManager stopUpdatingLocation];
                    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
                    */
                }
            }
        }
    }
}

#pragma mark - tableView 事件
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return aSECTION.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *aTableArray = [aSECTION[section] valueForKey:sJson_Minor];
    return aTableArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sTableItem];
    
    NSArray *aTableArray = [aSECTION[indexPath.section] valueForKey:sJson_Minor];
    NSDictionary *dData = aTableArray[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@", [dData valueForKey:sJson_Voice]];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *aTableArray = [aSECTION[indexPath.section] valueForKey:sJson_Minor];
    NSDictionary *dData = aTableArray[indexPath.row];
    //Pic
    [thisImageView setImage:[UIImage imageNamed:[dData valueForKey:sJson_Pic]]];
    
    //Voice
    NSString *sMusic = [NSString stringWithFormat:@"%@",[dData valueForKey:sJson_Voice]];
    NSArray *split = [sMusic componentsSeparatedByString:@"."];
    [self playMusic:split[0] and:split[1]];
}

#pragma mark - segmentedControl 事件
- (void) segmentedControlIndexChanged:(id)sender
{
    switch ([sender selectedSegmentIndex])
    {
        case 0: //自動
            [thisView bringSubviewToFront:thisImageView];
            [thisView sendSubviewToBack:thisTableView];
            [thisTableView setHidden:YES];
            break;
            
        case 1: //手動
            [thisView sendSubviewToBack:thisImageView];
            [thisView bringSubviewToFront:thisTableView];
            [thisTableView setHidden:NO];
            break;
            
        default:
            break;
    }

    [thisImageView setImage:[UIImage imageNamed:sDefaultPic]];
    [player stop];
    [bPlay setTitle:sPlay forState:UIControlStateNormal];
}

#pragma mark - Display
/*
-(void) DisplayScreen
{
    [thisView setFrame:CGRectMake(UI_SCREEN_X, UI_SCREEN_Y, UI_SCREEN_W, UI_SCREEN_H)];

    CGFloat SPACE = 5.0;
    
    CGFloat X = UI_SCREEN_W * 0.1;
    CGFloat Y = UI_SCREEN_H * 0.05;
    CGFloat W = UI_SCREEN_W * 0.8;
    CGFloat H = 30.0;
    [sStatus setFrame:CGRectMake(X, Y, W, H)];

    Y += H;
    Y += SPACE;
    CGFloat ImageViewH  = UI_SCREEN_H * 0.75;
    [thisImageView setFrame:CGRectMake(X, Y, W, ImageViewH)];
    [thisTableView setFrame:CGRectMake(X, Y, (W * 0.3), ImageViewH)];

    Y += ImageViewH;
    Y += SPACE;
    CGFloat ButtonH = UI_SCREEN_W * 0.1;
    [bMute setFrame:CGRectMake(X, Y, ButtonH, ButtonH)];
    CGFloat ButtonRX = UI_SCREEN_W * 0.9 - ButtonH;
    [bSpeaker setFrame:CGRectMake(ButtonRX, Y, ButtonH, ButtonH)];

    CGFloat ProX = X + ButtonH;
    CGFloat ProY = Y + 0.5 * ButtonH;
    CGFloat ProW = ButtonRX - X - ButtonH;
    CGFloat ProH = ButtonH * 0.1;
    [thisProgressView setFrame:CGRectMake(ProX, ProY, ProW, ProH)];
    
    Y += ButtonH;
    Y += SPACE;
    [bPlay setFrame:CGRectMake(X, Y, W, ButtonH)];
}
*/
#pragma mark - view 事件
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Screen
    //[self DisplayScreen];
    //取得 Beacon資料
    [self getBeaconData];
    
    //Detect Beacon
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //NSLog(@"Turning on ranging...");
    //NSLog(@"UUID:%@",UUID);
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:UUID];
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
    {
        //NSLog(@"Monitoring not available");
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"無法偵測 Beacon" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            //OK
            UIAlertAction *okAction =
            [UIAlertAction actionWithTitle:@"確定"
                                     style:UIAlertActionStyleDefault
                                   handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:NO completion:nil];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [sStatus addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    CGFloat Volume = player.volume;
    thisProgressView.progress = Volume;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
