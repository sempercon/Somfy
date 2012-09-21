//
//  DimmerDeviceView.h
//  Somfy
//
//  Created by Sempercon on 5/12/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface DimmerDeviceView : UIView <ParserCallback>{
	NSObject<SkinChooserCallback> *delegate;
	IBOutlet UIView			*trackView;
	IBOutlet UIImageView	*trackingImg;
    IBOutlet UILabel        *sceneValueChangedLbl;
	IBOutlet UILabel		*DimmerValueLbl,*DimmerValueLbl1;
	IBOutlet UIButton		*DimmerDeviceIncreaseBtn,*DimmerDeviceDecreasBtn;
	NSMutableDictionary *deviceDict;
	NSMutableArray	    *selectedRoomDeviceArray;
	NSMutableArray	    *tempDevicesArray;
	float	lastYPoint;
	UIView *loadingView;
	int sliderValue,lastSliderValue;
	int isFromScene;
	int curSceneID,curSceneIdx,curMetaData;
	NSTimer *commandTimer;
	ProcessEnum commandEnum;
	NSMutableArray  *loginArray;
	IBOutlet UIButton *btnDimmer;
	IBOutlet UIButton *applyALLBtn;
	
	NSTimer		*QueueTimer;
	ProcessEnum queueEnum;
	int			deviceIndex;
	
}

@property(nonatomic, assign) NSObject<SkinChooserCallback> *delegate;
@property(nonatomic, retain) UIView			*trackView;
@property(nonatomic, retain) UIImageView	*trackingImg;
@property(nonatomic, retain) UILabel        *sceneValueChangedLbl;
@property(nonatomic, retain) UILabel		*DimmerValueLbl,*DimmerValueLbl1;
@property(nonatomic, retain) UIButton		*DimmerDeviceIncreaseBtn,*DimmerDeviceDecreasBtn;
@property(nonatomic, retain) NSMutableDictionary  *deviceDict;
@property(nonatomic, retain) NSMutableArray	      *selectedRoomDeviceArray;
@property(nonatomic, retain) UIButton *btnDimmer;
@property(nonatomic, retain) UIButton *applyALLBtn;

+ (DimmerDeviceView*) dimmerDeviceview;
-(void) SetMainDelegate:(id<SkinChooserCallback>)callback;
-(void)setDeviceDict:(NSMutableDictionary*)dict;
-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr;
-(IBAction)CloseBtnClicked:(id)sender;
-(IBAction)DimmerDeviceIncreaseBtnClicked:(id)sender;
-(IBAction)DimmerDeviceDecreasBtnClicked:(id)sender;
-(void)setCurMetaData:(int)mData;
-(UIImage *) getDeviceImageForValue :(int)deviceValue;
-(IBAction)btnDimmerClicked:(id)sender;
-(IBAction)APPLYTOALLClicked:(id)sender;


@end
