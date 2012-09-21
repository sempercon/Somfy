//
//  OnewayMotorView.h
//  Somfy
//
//  Created by Sempercon on 5/11/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface OnewayMotorView : UIView <ParserCallback>{
	NSObject<SkinChooserCallback> *delegate;
	IBOutlet UIButton *BlindOpenBtn,*BlindCloseBtn,*MypositionBtn,*CloseBtn;
	IBOutlet UILabel  *DeviceNameLbl;
    IBOutlet UILabel  *sceneValueChangedLbl;
	NSMutableDictionary *deviceDict;
	NSMutableArray		*selectedRoomDeviceArray;
	UIView *loadingView;
	int isFromScene;
	int curSceneID,curSceneIdx;
	NSTimer *commandTimer;
	ProcessEnum commandEnum;
	int currentValue,curMetaData;
	NSMutableArray  *loginArray;
	IBOutlet UIImageView *imgDevice;
}

@property(nonatomic, assign) NSObject<SkinChooserCallback> *delegate;
@property(nonatomic, retain) UIButton *BlindOpenBtn,*BlindCloseBtn,*MypositionBtn,*CloseBtn;
@property(nonatomic, retain) UILabel  *sceneValueChangedLbl;
@property(nonatomic, retain) UILabel  *DeviceNameLbl;
@property(nonatomic, retain) NSMutableDictionary  *deviceDict;
@property(nonatomic, retain) NSMutableArray	      *selectedRoomDeviceArray;
@property(nonatomic, retain) UIImageView *imgDevice;

+ (OnewayMotorView*) onewaymotorview;
-(void) SetMainDelegate:(id<SkinChooserCallback>)callback;
-(void)setDeviceDict:(NSMutableDictionary*)dict;
-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr;
-(IBAction)CloseBtnClicked:(id)sender;
-(IBAction)BlindOpenBtnClicked:(id)sender;
-(IBAction)BlindCloseBtnClicked:(id)sender;
-(IBAction)MypositionBtnClicked:(id)sender;
-(void)setCurMetaData:(int)mData;


@end
