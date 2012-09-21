//
//  SceneThermostatView.h
//  Somfy
//
//  Created by Sempercon on 6/4/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface SceneThermostatView : UIView <ParserCallback>{
	NSObject<SkinChooserCallback> *delegate;
	IBOutlet UIButton *btnModeOFF,*btnModeCool,*btnModeHeat,*btnEnergySaving,*btnChangeTemp,*btnUp,*btnDown,*btnClose;
	IBOutlet UILabel *lblTemp,*lblSceneThermo;
	NSMutableDictionary *deviceDict;
	NSMutableDictionary *thermostatDeviceDict;
	UIView *loadingView;
	int unpackedArray[4];
	int _setPoint,_proposedSetPoint,_thermostatCurrentSetPoint;
	BOOL _enabledSetPoint;
	NSTimer	*commandTimer;
	ProcessEnum	commandEnum;
	int curSceneID,curSceneIdx,currDeviceZwaveId,curMetaData;
	NSMutableArray  *loginArray;
}

@property(nonatomic, retain) UILabel *lblTemp,*lblSceneThermo;
@property(nonatomic, assign) NSObject<SkinChooserCallback> *delegate;
@property(nonatomic, retain) UIButton  *btnModeOFF,*btnModeCool,*btnModeHeat,*btnEnergySaving,*btnChangeTemp,*btnUp,*btnDown,*btnClose;
@property(nonatomic, retain) NSMutableDictionary  *deviceDict,*thermostatDeviceDict;

+ (SceneThermostatView*) sceneThermostatview;
-(IBAction)thermostatModeOffClicked:(id)sender;
-(IBAction)thermostatModeCoolClicked:(id)sender;
-(IBAction)thermostatModeHeatClicked:(id)sender;
-(IBAction)energySavingModeBtnClicked:(id)sender;
-(IBAction)btnChangeTempClicked:(id)sender;
-(IBAction)btnTempDownClicked:(id)sender;
-(IBAction)btnTempUpClicked:(id)sender;
-(IBAction)CloseBtnClicked:(id)sender;

-(void)setDeviceDict:(NSMutableDictionary*)dict;
-(void)setSceneId:(int)nSceneID;
-(void)setSceneIndex:(int)idx;
-(void)setCurMetaData:(int)mData;

@end
