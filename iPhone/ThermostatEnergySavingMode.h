//
//  ThermostatEnergySavingMode.h
//  Somfy
//
//  Created by mac user on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface ThermostatEnergySavingMode : UIViewController<ParserCallback> {
	IBOutlet UILabel  *temperatureLbl,*temperatureLblDeg,*deviceNameLbl,*roomNameLbl,*lblTempEnergySaving,*lblTempEnergySavingDeg;
	IBOutlet UIButton *increaseBtn,*decreaseBtn,*backwardBtn,*btnEnergySavingIncrease,*btnEnergySavingDecrease;
	IBOutlet UIButton *applyButton;
	NSMutableDictionary *deviceDict;
	NSTimer	 *ProcessTimer,*initTimer,*saveThermostatTimer;
	ProcessEnum	 thermostatEnum,saveThermostatEnum;
	NSString			*roomNameString;
	NSMutableArray  *_thermostatInfo,*themostatDesiredTempArray;
	IBOutlet UISegmentedControl *btnThermostatMode,*btnFanMode,*btnScheduleMode,*btnEnergySavingMode;
	IBOutlet UIScrollView *mainScroll;
	BOOL	 isLoadingSegment,isSaveThermostat;
	int esSetpoint,resultEssetPoint,noofTimes;
	NSMutableArray  *loginArray;
	
	NSMutableArray		*maintenanceArray;
	NSMutableDictionary	*maintenanceDictionary;
	
	//Animation
	IBOutlet UIImageView	*animateImageView;
	IBOutlet UIScrollView	*animationScrollView;
	IBOutlet UILabel		*animationTitle1,*animationTitle2;
	NSTimer					*openTimer,*closeTimer;
	int						yPosition;
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;


//Animation
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UIScrollView	*animationScrollView;
@property(nonatomic,retain) UILabel			*animationTitle1,*animationTitle2;


@property(nonatomic,retain) UIButton *applyButton;
@property(nonatomic,retain) UILabel  *temperatureLbl,*temperatureLblDeg,*deviceNameLbl,*roomNameLbl,*lblTempEnergySaving,*lblTempEnergySavingDeg;
@property(nonatomic,retain) UIButton *increaseBtn,*decreaseBtn,*backwardBtn,*btnEnergySavingIncrease,*btnEnergySavingDecrease;
@property(nonatomic,retain) NSMutableDictionary *deviceDict;
@property(nonatomic,retain) NSString			*roomNameString;
@property(nonatomic,retain) NSMutableArray  *_thermostatInfo,*themostatDesiredTempArray;
@property(nonatomic,retain) UISegmentedControl *btnThermostatMode,*btnFanMode,*btnScheduleMode,*btnEnergySavingMode;
@property(nonatomic,retain) UIScrollView *mainScroll;

-(IBAction)thermostatIncrease:(id)sender;
-(IBAction)thermostatDecrease:(id)sender;
-(IBAction)ApplyClicked:(id)sender;
-(IBAction)backwardBtnClicked:(id)sender;
-(IBAction)btnThermostatModeClicked:(id)sender;
-(IBAction)btnFanMode:(id)sender;
-(IBAction)btnScheduleMode:(id)sender;
-(IBAction)btnEnergySavingMode:(id)sender;
-(IBAction)btnEnergySavingIncrease:(id)sender;
-(IBAction)btnEnergySavingDecrease:(id)sender;
-(IBAction)LOGOUT:(id)sender;





@end
