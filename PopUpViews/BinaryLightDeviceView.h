//
//  BinaryLightDeviceView.h
//  Somfy
//
//  Created by Sempercon on 5/11/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"
@interface BinaryLightDeviceView : UIView<ParserCallback> {
	IBOutlet UIImageView *imgView,*deskLampImg;
	NSObject<SkinChooserCallback> *delegate;
	IBOutlet UIButton *ONBtn,*OFFBtn;
	IBOutlet UIButton *BinaryDeviceToggleImgBtn;
	IBOutlet UIButton *applyALLBtn;
	IBOutlet UILabel  *DeviceNameLbl;
    IBOutlet UILabel  *sceneValueChangedLbl;
	BOOL	 isOn;
	NSMutableDictionary *deviceDict;
	NSMutableArray	    *selectedRoomDeviceArray;
	NSMutableArray	    *tempDevicesArray;
	UIView *loadingView;
	int isFromScene;
	int curSceneID,curSceneIdx,curMetaData;
	NSTimer *commandTimer;
	int currentValue,deviceIndex;
	ProcessEnum commandEnum,queueEnum;
	NSMutableArray  *loginArray;
	NSTimer	*QueueTimer;
}

@property(nonatomic, retain) UIImageView *imgView,*deskLampImg;
@property(nonatomic, assign) NSObject<SkinChooserCallback> *delegate;
@property(nonatomic, retain) UIButton *ONBtn,*OFFBtn;
@property(nonatomic, retain) UIButton *BinaryDeviceToggleImgBtn;
@property(nonatomic, retain) UILabel  *DeviceNameLbl;
@property(nonatomic, retain) UILabel  *sceneValueChangedLbl;
@property(nonatomic, retain) NSMutableDictionary  *deviceDict;
@property(nonatomic, retain) NSMutableArray	      *selectedRoomDeviceArray;
@property(nonatomic, retain) UIButton *applyALLBtn;

+ (BinaryLightDeviceView*) binarylightview;
-(void) SetMainDelegate:(id<SkinChooserCallback>)callback;
-(void)setDeviceDict:(NSMutableDictionary*)dict;
-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr;
-(void)setSceneId:(int)sceneId;
-(void)setSceneIndex:(int)sceneIdx;
-(void)setIsFromScene:(int)indicator;
-(IBAction)ONClicked:(id)sender;
-(IBAction)OFFClicked:(id)sender;
-(IBAction)BinaryDeviceToggleImgBtnClicked:(id)sender;
-(IBAction)APPLYTOALLClicked:(id)sender;
-(IBAction)CloseClicked:(id)sender;
-(void)SetDeviceStateValue:(int)Value;
-(void)setCurMetaData:(int)mData;
@end
