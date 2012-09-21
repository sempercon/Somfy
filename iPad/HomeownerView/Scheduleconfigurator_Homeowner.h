//
//  Scheduleconfigurator_Homeowner.h
//  Somfy
//
//  Created by Sempercon on 5/3/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface Scheduleconfigurator_Homeowner : UIViewController<ParserCallback> {
	IBOutlet UIButton  *DashboardBtn,*SceneConfigBtn,*ScheduleConfigBtn,*InstallerViewBtn;
	IBOutlet UIScrollView	*scheduleScrollView;
	NSMutableArray			*selectedSchedulesArray;
	NSTimer					*DateTimeDisplayTimer,*ProcessTimer,*QueueTimer,*deleteScheduleTimer,*saveScheduleTimer,*scheduleTimerInfoTimer,*scheduleEventInfoTimer;
	IBOutlet UILabel		*TimeLbl1,*TimeLbl2,*DateLbl,*ActivatedLabel;
	ProcessEnum				scheduleEnum,queueEnum,deleteProcess,addScheduleEnum,saveScheduleEnum,scheduleTimerInfoEnum,scheduleEventInfoEnum;
	NSMutableArray			*g_scheduleList,*g_scheduleInfoList,*g_timerInfoList,*g_eventInfoList;
	NSMutableDictionary		*g_MutableDict,*saveDict;
	int    g_selectedScheduleId,g_selectedScheduleIndex,scheduleInfoId,g_objectIndex;
	NSString *strInfoType;
	int _cachedDays;
	BOOL isSaveSchedule;
	
	//Add schedule
	IBOutlet UIView		  *addScheduleView;
	IBOutlet UITextField  *addScheduleTextField;
	UIButton *g_sunBtn,*g_monBtn,*g_tueBtn,*g_wedBtn,*g_thuBtn,*g_friBtn,*g_satBtn,*g_allBtn;
	
	//Edit schedule Name
	IBOutlet UIView				*editScheduleView;
	IBOutlet UITextField		*editScheduleTextField;
	
	//Custom classes schedule subscrollview class files
	IBOutlet UIView		   *subcontainerView,*pickerPopupView,*pickerPopupsubView;
	IBOutlet UIButton	   *pickerOkBtn,*pickerCancelBtn;
	IBOutlet UIPickerView	*scenesPicker;
	IBOutlet UIDatePicker	*datePicker,*timePicker,*TodatePicker;
	
	CGPoint	LastOffsetPointSchedule,LastOffsetPointSubScrolling;
	BOOL  isWeekdaySelector,isTimeofday,isScheduleScrollSelect;
	BOOL  isDatePicker,isTimerPicker,isScenePicker,issunriseBool,isToDatePicker;
	int	  scenePickerRowIndex,selectedPickerIndex,saveScheduleIndex;
	
	NSMutableArray		*maintenanceArray;
	NSMutableDictionary *maintenanceDictionary;
	int currScheduleId,currEventId,_changeMask,enableorDisableIndex,deleteScheduleIndex;
	NSTimer	*addSchTimer;
	UIView  *loadingView;
	
	//Animation
	IBOutlet UIImageView  *imgView;
	IBOutlet UIScrollView *animationScrollView;
	IBOutlet UILabel  *label1,*label2;
	BOOL	 isAnimation,isLoadingSchedule;
	BOOL isTimerToEvent,isTimerorEventChange;
	
	IBOutlet UIImageView	*animateImageView;
	IBOutlet UILabel		*animationTitle;
	NSTimer					*openTimer,*closeTimer;
	int						yPosition,xposition;
	
	CGPoint					LastOffsetPointScenes,lastMovementPosition;
	int newScheduleId;
	NSMutableArray	 *loginArray;
	int currentSceneEditIndex;

	
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;

//Animation
@property(nonatomic,retain) UIImageView		*imgView;
@property(nonatomic,retain) UILabel			*label1,*label2;
@property(nonatomic,retain) UIScrollView	*animationScrollView;

@property(nonatomic,retain) UIPickerView	*scenesPicker;
@property(nonatomic,retain) UIDatePicker	*datePicker,*timePicker,*TodatePicker;

@property(nonatomic,retain) UIButton  *DashboardBtn,*SceneConfigBtn,*ScheduleConfigBtn,*InstallerViewBtn;
@property(nonatomic,retain) UIScrollView  *scheduleScrollView;
@property(nonatomic,retain) UILabel			*TimeLbl1,*TimeLbl2,*DateLbl,*ActivatedLabel;
@property(nonatomic,retain) NSMutableArray 	*g_scheduleList,*g_scheduleInfoList,*g_timerInfoList,*g_eventInfoList;

//Edit schedule Name
@property(nonatomic,retain) UIView				*editScheduleView;
@property(nonatomic,retain) UITextField			*editScheduleTextField;
//Add schedule Name
@property(nonatomic,retain) UIView			*addScheduleView;
@property(nonatomic,retain) UITextField		*addScheduleTextField;

//Custom classes schedule subscrollview class files
@property(nonatomic,retain) UIView			*subcontainerView,*pickerPopupView,*pickerPopupsubView;
@property(nonatomic,retain) UIButton	   *pickerOkBtn,*pickerCancelBtn;

//Animation
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UILabel			*animationTitle;
//TABS
-(IBAction)LiveViewDashboard:(id)sender;
-(IBAction)SceneConfigurator:(id)sender;
-(IBAction)ScheduleConfigurator:(id)sender;
-(IBAction)InstallerView:(id)sender;
-(IBAction)LOGOUT:(id)sender;


-(IBAction)pickerOkClicked:(id)sender;
-(IBAction)pickerCancelClicked:(id)sender;
//ADD SCHEDULE
-(IBAction)addScheduleClicked:(id)sender;
-(IBAction)addScheduleCreateClicked:(id)sender;
-(IBAction)addScheduleCancelClicked:(id)sender;
//EDIT SCHEDULE
-(IBAction)editScheduleSaveClicked:(id)sender;
-(IBAction)editScheduleCancelClicked:(id)sender;

//-(void)beginAddSchedule;
-(NSString*) FillLeadingZeros : (NSString *) eventId;

@end
