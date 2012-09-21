//
//  ThermostatDevice.h
//  Somfy
//
//  Created by Sempercon on 4/28/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"


@interface ThermostatDevice : UIViewController <ParserCallback>{
	IBOutlet UIButton *heatBtn,*autoBtn,*holdBtn,*btnBack;
	IBOutlet UIButton *increaseBtn,*decreaseBtn,*forwardBtn;
	IBOutlet UILabel  *temperatureLbl,*temperatureLblDeg,*deviceNameLbl,*roomNameLbl,*lblCurrenttemp,*lblEnergyTemp,*lblEnergyTempDeg,*lblSetTempDeg;
	NSMutableDictionary *deviceDict;
	NSString			*roomNameString;
	NSTimer	 *ProcessTimer,*initTimer;
	ProcessEnum	 thermostatEnum;
	NSMutableArray  *_thermostatInfo,*themostatDesiredTempArray;
	NSMutableArray  *loginArray;
	
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;


@property(nonatomic,retain) UIButton *heatBtn,*autoBtn,*holdBtn,*btnBack;
@property(nonatomic,retain) UIButton *increaseBtn,*decreaseBtn,*forwardBtn;
@property(nonatomic,retain) UILabel  *temperatureLbl,*temperatureLblDeg,*deviceNameLbl,*roomNameLbl,*lblCurrenttemp,*lblEnergyTemp,*lblEnergyTempDeg,*lblSetTempDeg;
@property(nonatomic,retain) NSMutableDictionary *deviceDict;
@property(nonatomic,retain) NSString			*roomNameString;
@property(nonatomic,retain) NSMutableArray  *_thermostatInfo,*themostatDesiredTempArray;

-(IBAction)thermostatHeat:(id)sender;
-(IBAction)thermostatAuto:(id)sender;
-(IBAction)thermostatHold:(id)sender;
-(IBAction)thermostatIncrease:(id)sender;
-(IBAction)thermostatDecrease:(id)sender;
-(IBAction)ApplyClicked:(id)sender;
-(IBAction)forwardBtnClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)LOGOUT:(id)sender;

@end
