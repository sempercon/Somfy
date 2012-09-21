//
//  ThermostatView.h
//  Somfy
//
//  Created by Sempercon on 5/12/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface ThermostatView : UIView <ParserCallback>{
	NSObject<SkinChooserCallback> *delegate;
	NSMutableArray  *_thermostatInfo,*themostatDesiredTempArray;
	NSTimer	 *ProcessTimer,*initTimer;
	ProcessEnum	 thermostatEnum;
	IBOutlet UILabel *lblCurrentTemperature,*lblPointTemperature,*lblEsSetPoint;
	IBOutlet UIButton *thermostatModeBtn,*thermostatFanModeBtn,*thermostatScheduleBtn;
	IBOutlet UIButton *energySavingModeBtn,*btnEsSetPointDown,*btnEsSetPointUp;
	IBOutlet UIButton *btnPointTemperatureUp,*btnPointTemperatureDown;
	IBOutlet UILabel  *lblEsPointDeg,*lblTemperatureDeg,*lblThermostat;
	NSMutableDictionary *deviceDict;
	NSMutableArray		*selectedRoomDeviceArray;
	UIView *loadingView;
	int esModeValue,curMetaData;
	NSMutableArray  *loginArray;
}

@property(nonatomic, assign) NSObject<SkinChooserCallback> *delegate;
@property(nonatomic, retain) NSMutableArray  *_thermostatInfo,*themostatDesiredTempArray;
@property(nonatomic, retain) UILabel *lblCurrentTemperature,*lblPointTemperature,*lblEsSetPoint;
@property(nonatomic, retain) UIButton *thermostatModeBtn,*thermostatFanModeBtn,*thermostatScheduleBtn;
@property(nonatomic, retain) UIButton *energySavingModeBtn,*btnEsSetPointDown,*btnEsSetPointUp;
@property(nonatomic, retain) UIButton *btnPointTemperatureUp,*btnPointTemperatureDown;
@property(nonatomic, retain) UILabel  *lblEsPointDeg,*lblTemperatureDeg,*lblThermostat;
@property(nonatomic, retain) NSMutableDictionary  *deviceDict;
@property(nonatomic, retain) NSMutableArray	      *selectedRoomDeviceArray;


+ (ThermostatView*) thermostatview;
-(void) SetMainDelegate:(id<SkinChooserCallback>)callback;
-(void)setDeviceDict:(NSMutableDictionary*)dict;
-(IBAction)CloseBtnClicked:(id)sender;
-(void)setSelectedRoomDevicesArray:(NSMutableArray*)arr;
-(IBAction)thermostatModeBtnClicked:(id)sender;
-(IBAction)thermostatFanModeBtnClicked:(id)sender;
-(IBAction)thermostatScheduleBtnClicked:(id)sender;
-(IBAction)energySavingModeBtnClicked:(id)sender;
-(IBAction)btnEsSetPointDownClicked:(id)sender;
-(IBAction)btnEsSetPointUpClicked:(id)sender;
-(IBAction)btnPointTemperatureUpClicked:(id)sender;
-(IBAction)btnPointTemperatureDownClicked:(id)sender;
-(void)setCurMetaData:(int)mData;

@end
