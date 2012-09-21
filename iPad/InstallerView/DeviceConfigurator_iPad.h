//
//  DeviceConfigurator_iPad.h
//  Somfy
//
//  Created by Sempercon on 4/29/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "SendStatusCommand.h"
#import "Constants.h"
#import "Globals.h"

@interface DeviceConfigurator_iPad : UIViewController <ParserCallback,SkinChooserCallback>{
	UIView	 *loadingView;
	NSTimer	 *advancedTimer,*EventInfoTimer,*eventRemoveTimer,*sceneControllerTimer,*removalDoneTimer;
	IBOutlet UIScrollView *scrollView,*sceneControllerScrollView;
	IBOutlet UITextView	  *statusMessageTextView;
	IBOutlet UIButton  *RoomSelectBtn,*DeviceConfigBtn,*SceneConfigBtn,*EventConfigBtn,*ScheduleConfigBtn,*HomeownerBtn;
	IBOutlet UIButton  *pickerOkBtn,*pickerCancelBtn;
	IBOutlet UIView	   *popupView,*popupSceneControllerView;
	IBOutlet UIView	   *pickerPopupView,*pickerPopupsubView;
	IBOutlet UILabel   *sceneControllerDeviceName;
	IBOutlet UIPickerView *scenesPicker;
	NSMutableArray	   *getSceneControlsArray,*globalScenesArray,*orphanedEventsArray,*rediscoveredArray;
	int    sceneLastPickerRowIndex,buttonIndex,deviceIndex,g_objectIndex;
	BOOL   isStartListeningADD;
	BOOL   isFirstBool,isSecondBool,isDeviceRemoval,isStatus,isAdvancedTools,isRestartDeviceRemoval,isRestartStartListening;
	ProcessEnum advancedEnum,EventInfoEnum,eventRemoveEnum,sceneControllerEnum,removalDoneEnum;
	NSMutableArray	 *loginArray;
	NSMutableArray	 *filterDeviceRoomsArray;
	
	//DEVICE CONFIGURATOR EDIT SCREEN
	int      editDeviceIndex,metaDataValue;
	BOOL	 isEditScreen,isDeviceMetaDataChanged,isDeviceToolsOpen;
	BOOL	_nameChanged,_roomChanged;
	IBOutlet UIScrollView *editAnimationScrollView;
	IBOutlet UIView		  *editAnimationView;
	NSMutableDictionary	  *maintenanceDict;
	NSMutableArray		  *selectedRoomListArray;
	IBOutlet UIView	      *editView;
	IBOutlet UIView		  *devicesTableSubView;
	IBOutlet UITableView  *devicesListView;
	IBOutlet UIButton	  *deviceGridBtn,*deviceTableListBtn;
	IBOutlet UIButton	  *somfyImgView;
	IBOutlet UILabel	  *lblSomfyDeviceName;
	IBOutlet UIButton	  *editSaveBtn,*editCancelBtn,*editComboBtn;
	IBOutlet UIPickerView *roomNamePicker;
	IBOutlet UITextField  *editDeviceNameTextField,*editRoomNameTextField;
	//DEVICE TOOLS
	BOOL     isDeviceToolsEnabled,isrediscoverEnabled;
	BOOL	 isSomfyILT,isSomfyRTS;
	IBOutlet UIButton	  *rediscoverDeviceBtn,*deviceSetupBtn,*replaceFailedBtn,*removeFailedBtn,*zwaveCancelBtn,*deviceToolsBtn;
	IBOutlet UIView		  *somfyRTSView,*somfyILTView;
	IBOutlet UILabel	  *statusMessageLbl1,*statusMessageLbl2;
	IBOutlet UIImageView  *indicatorImageView;
	NSMutableArray		  *ToolTipArray;
	
	//DEVICE REMOVAL SCREENS
	IBOutlet UIView		*deviceRemovalView,*deviceRemovalSupportView;
	IBOutlet UIButton	*removalRestartBtn,*removalSupportBtn,*removalDoneBtn,*removalCancelBtn,*removalCloseBtn;
	IBOutlet UILabel	*removalMainLbl,*removalSubLbl1,*removalSubLbl2;
	
	//Start Listening screen
	int zwaveAddID;
	IBOutlet UIView    *startListeningView,*supportView;
	IBOutlet UIButton  *startListeningBtn;
	IBOutlet UIButton  *startListeningRestartBtn,*startListeningSupportBtn,*startListeningCancelBtn;
	BOOL	 isStartListening,_poll;
	IBOutlet UILabel   *nameLbl,*roomLbl,*message1Lbl,*message2Lbl;
	IBOutlet UITextField *ListeningDeviceNameText,*ListeningRoomNameText;
	IBOutlet UIButton	 *ListeningSaveBtn,*ListeningCancelBtn,*ListeningComboBtn;
	
	//Animation 
	IBOutlet UIScrollView *animationScrollView;
	IBOutlet UIView		  *animationView;
	IBOutlet UIImageView  *runningImageView;
	IBOutlet UIButton	  *advacnedToolsBtn,*advancedArrowImgBtn,*advancedArrowImg1Btn;
	NSTimer				  *openTimer,*closeTimer;
	int					  yPosition;
	BOOL				  isOpen,isAnimationProcessing;
	int					  homeOccupancyStateMachineCount;
    
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;


//DEVICE TOOLS
@property(nonatomic,retain) UIButton	  *rediscoverDeviceBtn,*deviceSetupBtn,*replaceFailedBtn,*removeFailedBtn,*zwaveCancelBtn,*deviceToolsBtn;
@property(nonatomic,retain) UILabel		  *statusMessageLbl1,*statusMessageLbl2;
@property(nonatomic,retain) UIImageView   *indicatorImageView;
@property(nonatomic,retain) UIButton	  *deviceGridBtn,*deviceTableListBtn;

//DEVICE REMOVAL SCREENS
@property(nonatomic,retain) UIView		*deviceRemovalView,*deviceRemovalSupportView;
@property(nonatomic,retain) UIButton	*removalRestartBtn,*removalSupportBtn,*removalDoneBtn,*removalCancelBtn,*removalCloseBtn;
@property(nonatomic,retain) UILabel	*removalMainLbl,*removalSubLbl1,*removalSubLbl2;

//DEVICE CONFIGURATOR EDIT SCREEN
@property(nonatomic,retain)	UITableView   *devicesListView;
@property(nonatomic,retain) UIView		  *devicesTableSubView;
@property(nonatomic,retain) UIScrollView *editAnimationScrollView;
@property(nonatomic,retain) UIView		  *editAnimationView;
@property(nonatomic,retain) UIView	      *editView;
@property(nonatomic,retain) UIButton      *somfyImgView;
@property(nonatomic,retain) UIPickerView *roomNamePicker;
@property(nonatomic,retain) UILabel	  *lblSomfyDeviceName;
@property(nonatomic,retain) UIButton	  *editSaveBtn,*editCancelBtn,*editComboBtn;
@property(nonatomic,retain) UITextField  *editDeviceNameTextField,*editRoomNameTextField;

//Start Listening screen 
@property(nonatomic,retain) UIView    *startListeningView,*supportView;
@property(nonatomic,retain) UIButton  *startListeningBtn;
@property(nonatomic,retain) UIButton  *startListeningRestartBtn,*startListeningSupportBtn,*startListeningCancelBtn;
@property(nonatomic,retain) UILabel   *nameLbl,*roomLbl,*message1Lbl,*message2Lbl;
@property(nonatomic,retain) UITextField *ListeningDeviceNameText,*ListeningRoomNameText;
@property(nonatomic,retain) UIButton	 *ListeningSaveBtn,*ListeningCancelBtn,*ListeningComboBtn;

//Animation 
@property(nonatomic,retain) UIScrollView *animationScrollView;
@property(nonatomic,retain) UIView		  *animationView;
@property(nonatomic,retain) UIImageView   *runningImageView;
@property(nonatomic,retain) UIButton	  *advacnedToolsBtn,*advancedArrowImgBtn,*advancedArrowImg1Btn;

@property(nonatomic,retain) UIScrollView *scrollView,*sceneControllerScrollView;
@property(nonatomic,retain) UITextView	  *statusMessageTextView;
@property(nonatomic,retain) UIButton  *RoomSelectBtn,*DeviceConfigBtn,*SceneConfigBtn,*EventConfigBtn,*ScheduleConfigBtn,*HomeownerBtn;
@property(nonatomic,retain) UIButton  *pickerOkBtn,*pickerCancelBtn;
@property(nonatomic,retain) UIView	  *popupView,*popupSceneControllerView;
@property(nonatomic,retain) UIView	   *pickerPopupView,*pickerPopupsubView;
@property(nonatomic,retain) UILabel   *sceneControllerDeviceName;
@property(nonatomic,retain) UIPickerView *scenesPicker;
@property(nonatomic,retain) NSMutableArray	   *getSceneControlsArray,*globalScenesArray,*orphanedEventsArray,*rediscoveredArray;



//SOMFY RTS
-(IBAction)AwingClicked:(id)sender;
-(IBAction)BlindClicked:(id)sender;
-(IBAction)CellularShadeClicked:(id)sender;
-(IBAction)DraperyClicked:(id)sender;
-(IBAction)RollarShadeClicked:(id)sender;
-(IBAction)RollarShutterClicked:(id)sender;
-(IBAction)RomanShadeClicked:(id)sender;
-(IBAction)ScreenClicked:(id)sender;
-(IBAction)SolarScreenClicked:(id)sender;

//SOMFY ILT
-(IBAction)ILTRollarShaderClicked:(id)sender;
-(IBAction)ILTRomanShadeClicked:(id)sender;
-(IBAction)ILTScreenClicked:(id)sender;
-(IBAction)ILTSolarScreenClicked:(id)sender;

//DEVICE CONFIGURATOR EDIT SCREEN
-(IBAction)editCancelBtnClicked:(id)sender;
-(IBAction)editSaveBtnClicked:(id)sender;
-(IBAction)editComboBtnClicked:(id)sender;
-(IBAction)somfyDeviceTypeSelected:(id)sender;

//Device REMOVAL 
-(IBAction)deviceRemovalClicked:(id)sender;
-(IBAction)removalRestartBtnClicked:(id)sender;
-(IBAction)removalSupportBtnClicked:(id)sender;
-(IBAction)removalDoneBtnClicked:(id)sender;
-(IBAction)removalCancelBtnClicked:(id)sender;
-(IBAction)removalCloseBtnClicked:(id)sender;

-(void)rediscoverDeviceBtnClicked:(id)sender;
-(void)deviceSetupBtnClicked:(id)sender;
-(void)replaceFailedBtnClicked:(id)sender;
-(void)removeFailedBtnClicked:(id)sender;
-(void)zwaveCancelBtnClicked:(id)sender;
-(void)deviceToolsBtnClicked:(id)sender;

-(IBAction)sceneControllerClose:(id)sender;
-(IBAction)pickerOkClicked:(id)sender;
-(IBAction)pickerCancelClicked:(id)sender;

-(IBAction)advacnedTools:(id)sender;
-(IBAction)clearStatus:(id)sender;
-(IBAction)rediscoverNetworkClicked:(id)sender;
-(IBAction)optimizeNetworkClicked:(id)sender;
-(IBAction)learnNetworkClicked:(id)sender;
-(IBAction)sendNodeInformationClicked:(id)sender;
-(IBAction)cancelRunningCommandClicked:(id)sender;

-(IBAction)deviceListViewSelected:(id)sender;
-(IBAction)deviceGridViewSelected:(id)sender;

-(IBAction)startListeningBtnClicked:(id)sender;
-(IBAction)startListeningCancel:(id)sender;
-(IBAction)startListeningRestart:(id)sender;
-(IBAction)startListeningSupport:(id)sender;
-(IBAction)supportClose:(id)sender;

-(IBAction)ListeningSaveBtnClicked:(id)sender;
-(IBAction)ListeningCancelBtnClicked:(id)sender;
-(IBAction)ListeningComboBtnClicked:(id)sender;

-(IBAction)deviceConfiguratorRefresh:(id)sender;
-(IBAction)LOGOUT:(id)sender;

//5 Tabs switching items
-(IBAction)RoomSelector:(id)sender;
-(IBAction)DeviceConfigurator:(id)sender;
-(IBAction)SceneConfigurator:(id)sender;
-(IBAction)EventConfigurator:(id)sender;
-(IBAction)ScheduleConfigurator:(id)sender;
-(IBAction)Homeowner:(id)sender;

@end
