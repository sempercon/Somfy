//
//  ScheduleListings.h
//  Somfy
//
//  Created by Sempercon on 4/25/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"


@interface ScheduleListings : UIViewController <UITextFieldDelegate,ParserCallback>{
	IBOutlet UIScrollView	*scrollView;
	IBOutlet UILabel	    *sceneNameLbl,*scheduleNameLbl;
	NSString				*selectedIndex,*strInfoType;
	int						selectedIntIndex,g_objectIndex;
	int						_cachedDays;
	NSMutableArray			*maintenanceArray;
	NSMutableDictionary		*maintenanceDictionary;
	NSTimer					*DateTimeDisplayTimer,*ProcessTimer,*QueueTimer,*deleteScheduleTimer,*saveScheduleTimer,*scheduleTimerInfoTimer,*scheduleEventInfoTimer;
	
	//Edit schedule Name
	IBOutlet UIView				*editScheduleView;
	IBOutlet UITextField		*editScheduleTextField;
	ProcessEnum				scheduleEnum,queueEnum,deleteProcess,addScheduleEnum,saveScheduleEnum,scheduleTimerInfoEnum,scheduleEventInfoEnum;
	
	//Custom classes schedule subscrollview class files
	IBOutlet UIView			*subcontainerView,*pickerPopupView,*pickerPopupsubView;
	IBOutlet UIButton		*activationDayBtn,*activationTimeBtn,*sunriseBtn,*sunsetBtn;
	IBOutlet UIPickerView	*scenesPicker;
	IBOutlet UIDatePicker	*datePicker,*TodatePicker,*timePicker;
	IBOutlet UISlider		*eventSlider;
	IBOutlet UILabel		*lblEventSliderValue,*lblsunrise,*lblsunset,*lblWeekorYear,*lblYearlySelector;
	IBOutlet UIButton	    *sunBtn,*monBtn,*tueBtn,*wedBtn,*thuBtn,*friBtn,*satBtn,*allBtn;
	
	IBOutlet UITextField   *dateTextField,*timerTextField,*scenesTextField,*TodateTextField;
	IBOutlet UIButton      *datePickerBtn,*timePickerBtn,*scenesPickerBtn,*TodatePickerBtn;
	IBOutlet UIButton	   *pickerOkBtn,*pickerCancelBtn,*randomizeBtn;
	IBOutlet UILabel       *fromLabel,*toLabel,*lblDateString,*randomizeLbl;
	BOOL  isWeekdaySelector,isTimeofday,issunriseBool,isLoadingSchedule;
	BOOL  isDatePicker,isTimerPicker,isScenePicker,isToDatePicker,isScheduleScrollSelect;
	int	  scenePickerRowIndex,_changeMask,currScheduleId;
	CGPoint	LastOffsetPointSchedule;
	BOOL isTimerToEvent,isTimerorEventChange,isDeleteSchedule,isSaveSchedule;
	int newScheduleId;
	
	IBOutlet UISegmentedControl *activationWeekdaySegment,*activationTimeofdaySegment;
	IBOutlet UIImageView *imgRandomize;
	IBOutlet UILabel *runat,*sunRiseOffset,*minutes,*minus60,*plus60;
	UIView	*loadingView;
	
	//Animation
	IBOutlet UIImageView	*animateImageView;
	IBOutlet UIScrollView	*animationScrollView;
	IBOutlet UILabel		*animationTitle1,*animationTitle2;
	NSTimer					*openTimer,*closeTimer;
	int						yPosition;
	BOOL	 isOn,isAnimation;
	NSMutableArray  *loginArray;
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;


@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UILabel	    *sceneNameLbl,*scheduleNameLbl;
@property(nonatomic,retain) NSString	 *selectedIndex;
@property(nonatomic,retain) UISegmentedControl *activationWeekdaySegment,*activationTimeofdaySegment;
@property(nonatomic,retain) UIImageView *imgRandomize;
@property(nonatomic,retain) UILabel *sunRiseOffset,*minutes,*minus60,*plus60,*runat;

//Edit schedule Name
@property(nonatomic,retain) UIView				*editScheduleView;
@property(nonatomic,retain) UITextField			*editScheduleTextField;
@property(nonatomic,retain) UILabel				*fromLabel,*toLabel,*lblDateString,*randomizeLbl;

//Custom classes schedule subscrollview class files
@property(nonatomic,retain) UIView			*subcontainerView,*pickerPopupView,*pickerPopupsubView;
@property(nonatomic,retain) UIButton		*activationDayBtn,*activationTimeBtn,*sunriseBtn,*sunsetBtn;
@property(nonatomic,retain) UIPickerView	*scenesPicker;
@property(nonatomic,retain) UIDatePicker	*datePicker,*TodatePicker,*timePicker;
@property(nonatomic,retain) UISlider		*eventSlider;
@property(nonatomic,retain) UILabel			*lblEventSliderValue,*lblsunrise,*lblsunset,*lblWeekorYear,*lblYearlySelector;
@property(nonatomic,retain) UIButton	    *sunBtn,*monBtn,*tueBtn,*wedBtn,*thuBtn,*friBtn,*satBtn,*allBtn;

@property(nonatomic,retain) UITextField   *dateTextField,*timerTextField,*scenesTextField,*TodateTextField;
@property(nonatomic,retain) UIButton      *datePickerBtn,*timePickerBtn,*scenesPickerBtn,*TodatePickerBtn;
@property(nonatomic,retain) UIButton	   *pickerOkBtn,*pickerCancelBtn,*randomizeBtn;

//Animation
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UIScrollView	*animationScrollView;
@property(nonatomic,retain) UILabel			*animationTitle1,*animationTitle2;

-(IBAction)LOGOUT:(id)sender;
-(IBAction)EDITScheduleName:(id)sender;
-(IBAction)EDITScheduleNameSave:(id)sender;
-(IBAction)EDITScheduleNameSaveCancel:(id)sender;

-(IBAction)ScheduleDelete:(id)sender;
-(IBAction)ScheduleReset:(id)sender;
-(IBAction)ScheduleSave:(id)sender;

//Custom classes schedule subscrollview class files
-(IBAction)RandomizeBtnClicked:(id)sender;
-(IBAction)sunriseBtnClicked:(id)sender;
-(IBAction)sunsetBtnClicked:(id)sender;

-(IBAction)activationWeekdaySegmentChanged:(id)sender;
-(IBAction)activationTimeofdaySegmentChanged:(id)sender;

-(IBAction)sunBtnClicked:(id)sender;
-(IBAction)monBtnClicked:(id)sender;
-(IBAction)tueBtnClicked:(id)sender;
-(IBAction)wedBtnClicked:(id)sender;
-(IBAction)thuBtnClicked:(id)sender;
-(IBAction)friBtnClicked:(id)sender;
-(IBAction)satBtnClicked:(id)sender;
-(IBAction)allBtnClicked:(id)sender;

//picker popup ok and cancel
-(IBAction)pickerOkClicked:(id)sender;
-(IBAction)pickerCancelClicked:(id)sender;
-(IBAction)eventSliderValueChanged:(id)sender;

-(IBAction)datePickerBtnClicked:(id)sender;
-(IBAction)TodatePickerBtnClicked:(id)sender;
-(IBAction)datePickerBtnClicked:(id)sender;
-(IBAction)timePickerBtnClicked:(id)sender;
-(IBAction)scenesPickerBtnClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;



@end
