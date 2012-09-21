//
//  EventConfigurator_iPad.h
//  Somfy
//
//  Created by Sempercon on 4/29/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface EventConfigurator_iPad : UIViewController <ParserCallback,SkinChooserCallback> {
	IBOutlet UIScrollView  *scrollView,*popupScrollView;
	IBOutlet UIView		   *popupEventView,*popupEventTimeView;
	IBOutlet UILabel	   *popupNameLabel,*messageLabel;
	IBOutlet UIButton      *RoomSelectBtn,*DeviceConfigBtn,*SceneConfigBtn,*EventConfigBtn,*ScheduleConfigBtn,*HomeownerBtn;
	NSMutableArray		*g_triggerDevicesList,*temp_infoArray,*g_popupEventsInfoArray,*localScenesArray;
	NSMutableArray	    *deviceONIdArray,*deviceOFFIdArray;
	NSMutableArray	   *getSceneControlsArray,*button1Array,*button2Array,*button3Array,*button4Array,*button5Array;
	NSTimer				*eventInfoTimer,*ProcessTimer,*eventSaveTimer,*includeTimer,*eventInitializeTimer;
	ProcessEnum			eventEnum,processEnum,eventSaveEnum,includeEnum,eventInitializeEnum;
	int					g_objectIndex,eventSelectedIndex,_changeMask,scenePickerRowIndex,selectedPickerIndex;
	UIView				*loadingView;
	BOOL				isSceneController,isSingleEventInfo;
	int					buttonCount;
	NSMutableArray	 *loginArray;
	IBOutlet  UIButton		*g_sunBtn,*g_monBtn,*g_tueBtn,*g_wedBtn,*g_thuBtn,*g_friBtn,*g_satBtn,*g_allBtn;
	IBOutlet  UIView		*pickerPopupView,*pickerPopupsubView;
	IBOutlet  UIButton		*saveBtn,*resetBtn,*closeBtn,*fromTimeBtn,*toTimeBtn;
	IBOutlet  UITextField	*fromTimeTextField,*toTimeTextField;
	IBOutlet  UIDatePicker	*fromTimePicker,*toTimePicker;
	IBOutlet  UIButton		*pickerOkBtn,*pickerCancelBtn;
	IBOutlet  UIPickerView	*scenesPicker;
	IBOutlet  UISegmentedControl	*segControl;
	IBOutlet  NSMutableArray		*maintenanceArray,*sceneMaintenanceArray;
	NSMutableDictionary				*maintenanceDictionary;
	BOOL  isFromTimePicker,isToTimePicker,isScenePicker,isLoadingTimeLineView;
	
	//Initialize screen
	IBOutlet UIView		*eventInitializeView;
	IBOutlet UILabel	*eventInitializeNameLabel,*eventInitializeStatusLabel;
	IBOutlet UIButton	*eventInitializeCloseBtn,*eventInitializeBtn;
	
	//Home occupancy 
	IBOutlet UIButton	*enableHomeOccupancyBtn;
	IBOutlet UILabel	*occupancyLabel;
	BOOL	 isEnableOccupancy;
	
	//Animation
	IBOutlet UIImageView	*animateImageView;
	IBOutlet UIScrollView	*animationScrollView;
	IBOutlet UILabel		*animationTitle;
	NSTimer					*openTimer,*closeTimer;
	int						yPosition;
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;

//Initialize screen
@property(nonatomic,retain) UIView		*eventInitializeView;
@property(nonatomic,retain) UILabel		*eventInitializeNameLabel,*eventInitializeStatusLabel,*messageLabel;
@property(nonatomic,retain) UIButton	*eventInitializeCloseBtn,*eventInitializeBtn;

@property(nonatomic,retain) UIView	   *pickerPopupView,*pickerPopupsubView;
@property(nonatomic,retain) UIButton	 *pickerOkBtn,*pickerCancelBtn;
@property(nonatomic,retain) UIDatePicker *fromTimePicker,*toTimePicker;
@property(nonatomic,retain) UIPickerView *scenesPicker;
@property(nonatomic,retain) NSMutableArray		*maintenanceArray,*sceneMaintenanceArray;
@property(nonatomic,retain) UISegmentedControl *segControl;
@property(nonatomic,retain) UILabel	   *popupNameLabel;
@property(nonatomic,retain) UIScrollView *scrollView,*popupScrollView;
@property(nonatomic,retain) UIView		 *popupEventView,*popupEventTimeView;
@property(nonatomic,retain) UIButton  *RoomSelectBtn,*DeviceConfigBtn,*SceneConfigBtn,*EventConfigBtn,*ScheduleConfigBtn,*HomeownerBtn;
@property(nonatomic,retain) NSMutableArray   *g_triggerDevicesList,*temp_infoArray,*g_popupEventsInfoArray,*localScenesArray;
@property(nonatomic,retain) UIButton *g_sunBtn,*g_monBtn,*g_tueBtn,*g_wedBtn,*g_thuBtn,*g_friBtn,*g_satBtn,*g_allBtn;
@property(nonatomic,retain) UIButton *saveBtn,*resetBtn,*closeBtn,*fromTimeBtn,*toTimeBtn;
@property(nonatomic,retain) UITextField *fromTimeTextField,*toTimeTextField;

//Home occupancy 
@property(nonatomic,retain) UIButton	*enableHomeOccupancyBtn;
@property(nonatomic,retain) UILabel		*occupancyLabel;

//Animation
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UIScrollView	*animationScrollView;
@property(nonatomic,retain) UILabel			*animationTitle;

-(IBAction)popupEventViewClose:(id)sender;
-(IBAction)popupEventTimeViewClose:(id)sender;
-(IBAction)popupEventTimeViewSave:(id)sender;
-(IBAction)popupEventTimeViewReset:(id)sender;
-(IBAction)ChangeSegmentAction:(id)sender;

-(IBAction)eventInitializeBtnClicked:(id)sender;
-(IBAction)eventInitializeCloseBtnClicked:(id)sender;
-(IBAction)enableHomeOccupancyBtnClicked:(id)sender;

-(IBAction)pickerOkClicked:(id)sender;
-(IBAction)pickerCancelClicked:(id)sender;

-(IBAction)fromTimeBtnClicked:(id)sender;
-(IBAction)toTimeBtnClicked:(id)sender;
-(IBAction)LOGOUT:(id)sender;

-(IBAction)sunBtnClicked:(id)sender;
-(IBAction)monBtnClicked:(id)sender;
-(IBAction)tueBtnClicked:(id)sender;
-(IBAction)wedBtnClicked:(id)sender;
-(IBAction)thuBtnClicked:(id)sender;
-(IBAction)friBtnClicked:(id)sender;
-(IBAction)satBtnClicked:(id)sender;
-(IBAction)allBtnClicked:(id)sender;

//5 Tabs switching items
-(IBAction)RoomSelector:(id)sender;
-(IBAction)DeviceConfigurator:(id)sender;
-(IBAction)SceneConfigurator:(id)sender;
-(IBAction)EventConfigurator:(id)sender;
-(IBAction)ScheduleConfigurator:(id)sender;
-(IBAction)Homeowner:(id)sender;

@end
