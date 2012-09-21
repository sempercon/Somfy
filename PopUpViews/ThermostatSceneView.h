//
//  ThermostatSceneView.h
//  Somfy
//
//  Created by macuser on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface ThermostatSceneView : UIView<ParserCallback> {
	NSObject<SkinChooserCallback> *delegate;
	IBOutlet UIButton *btnModeOFF,*btnModeCool,*btnModeHeat,*btnEnergySaving,*btnChangeTemp,*btnUp,*btnDown,*btnClose;
	IBOutlet UILabel *lblTemp,*lblDeg,*lblThermoStat;
	NSMutableDictionary *deviceDict;
	NSMutableDictionary *thermostatDeviceDict;
	UIView *loadingView;
	int unpackedArray[4];
	int _setPoint,_proposedSetPoint,_thermostatCurrentSetPoint;
	BOOL _enabledSetPoint;
	NSTimer	*commandTimer;
	ProcessEnum	commandEnum;
	int curSceneID,curSceneIdx,currDeviceZwaveId;
	BOOL isChecked;
	int isFromScene,curMetaData;
	NSMutableArray  *loginArray;
	NSMutableArray	*selectedRoomDeviceArray;
}

@property(nonatomic, retain) UILabel *lblTemp,*lblDeg,*lblThermoStat;
@property(nonatomic, assign) NSObject<SkinChooserCallback> *delegate;
@property(nonatomic, retain) UIButton  *btnModeOFF,*btnModeCool,*btnModeHeat,*btnEnergySaving,*btnChangeTemp,*btnUp,*btnDown,*btnClose;
@property(nonatomic, retain) NSMutableDictionary  *deviceDict;
@property(nonatomic, retain) NSMutableArray	      *selectedRoomDeviceArray;


+ (ThermostatSceneView*) thermostatSceneView;
-(IBAction)thermostatModeOffClicked:(id)sender;
-(IBAction)thermostatModeCoolClicked:(id)sender;
-(IBAction)thermostatModeHeatClicked:(id)sender;
-(IBAction)energySavingModeBtnClicked:(id)sender;
-(IBAction)btnChangeTempClicked:(id)sender;
-(IBAction)btnTempDownClicked:(id)sender;
-(IBAction)btnTempUpClicked:(id)sender;
-(IBAction)CloseBtnClicked:(id)sender;

-(void)setDeviceDict:(NSMutableDictionary*)dict;
-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr;
-(void)setSceneId:(int)nSceneID;
-(void)setSceneIndex:(int)idx;
-(void)setCurMetaData:(int)mData;
@end
