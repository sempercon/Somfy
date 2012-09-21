//
//  ILTMotorView.h
//  Somfy
//
//  Created by Sempercon on 6/2/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface ILTMotorView : UIView  <ParserCallback>{
	NSObject<SkinChooserCallback> *delegate;
	NSMutableDictionary		*deviceDict;
	NSMutableArray			*selectedRoomDeviceArray;
	NSMutableArray			*tempDevicesArray;
	IBOutlet UIImageView	*deviceImage;
    IBOutlet UILabel        *sceneValueChangedLbl;
    IBOutlet UILabel		*lblDeviceName;
	IBOutlet UIView			*trackView;
	IBOutlet UIImageView	*trackingImg,*trackBottomImg,*iltSliderBg;
	UIView					*loadingView;
	IBOutlet UILabel		*valueLabel;
	IBOutlet UIScrollView	*deviceScrollView;
	IBOutlet UIButton		*applyALLBtn;
	
	float	lastYPoint;
	int sliderValue,lastSliderValue;
	int isFromScene;
	int curSceneID,curSceneIdx,curMetaData;
	NSTimer *commandTimer;
	ProcessEnum commandEnum;
	NSMutableArray  *loginArray;
	
	NSTimer		*QueueTimer;
	ProcessEnum queueEnum;
	int			deviceIndex;
}

@property(nonatomic, assign) NSObject<SkinChooserCallback> *delegate;
@property(nonatomic, retain) NSMutableDictionary *deviceDict;
@property(nonatomic, retain) NSMutableArray	      *selectedRoomDeviceArray;
@property(nonatomic, retain) UIImageView  *deviceImage;
@property(nonatomic, retain) UIView			*trackView;
@property(nonatomic, retain) UIImageView	*trackingImg,*trackBottomImg,*iltSliderBg;
@property(nonatomic, retain) UILabel	    *lblDeviceName;
@property(nonatomic, retain) UILabel        *sceneValueChangedLbl;
@property(nonatomic, retain) UILabel		*valueLabel;
@property(nonatomic, retain) UIScrollView	*deviceScrollView;
@property(nonatomic, retain) UIButton		*applyALLBtn;

+ (ILTMotorView*) iLTMotorView;
-(void) SetMainDelegate:(id<SkinChooserCallback>)callback;
-(void)setDeviceDict:(NSMutableDictionary*)dict;
-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr;
-(IBAction)ILTMotorIncreaseClicked:(id)sender;
-(IBAction)ILTMotorDecreaseClicked:(id)sender;
-(IBAction)ILTMotorOpenClicked:(id)sender;
-(IBAction)ILTMotorCloseClicked:(id)sender;
-(IBAction)ILTMotorApplyAllClicked:(id)sender;
-(IBAction)CloseBtnClicked:(id)sender;
-(void)setCurMetaData:(int)mData;


@end
