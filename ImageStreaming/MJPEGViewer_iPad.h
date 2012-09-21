//
//  MJPEGViewer_iPad.h
//  Somfy
//
//  Created by Karuppiah Annamalai on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPEGClient.h"
#import "AppDelegate_iPad.h"
#import "DeviceConfigurator_iPad.h"
#import "DeviceSkinChooser.h"


@interface MJPEGViewer_iPad : UIView <UIApplicationDelegate,MJPEGClientDelegate> {
    NSObject<SkinChooserCallback> *delegate;
    IBOutlet UIButton *btnStop;
    IBOutlet UIImageView *imgView;
	IBOutlet UILabel *cameraName;
    IBOutlet UILabel *loadingLbl;
    IBOutlet UIActivityIndicatorView *loadingActivity;
	NSMutableDictionary	*deviceDict;
    MJPEGClient *mjpegClient;
}

@property(nonatomic,retain) NSMutableDictionary *deviceDict;
@property(nonatomic,retain) UIImageView *imgView;
@property(nonatomic,retain) UILabel *loadingLbl;
@property(nonatomic,retain) UIActivityIndicatorView *loadingActivity;
@property(nonatomic,retain) UILabel *cameraName;
@property(nonatomic,assign) NSObject<SkinChooserCallback> *delegate;

+ (MJPEGViewer_iPad*) MJPEGViewer_iPadView;
-(void)setDeviceDict:(NSMutableDictionary*)dict;
-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr;
-(IBAction) stop:(id) sender;

@end
