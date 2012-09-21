//
//  SceneConfigurator_Homeowner.h
//  Somfy
//
//  Created by Sempercon on 5/3/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"


@interface SceneConfigurator_Homeowner : UIViewController <ParserCallback,SkinChooserCallback>{
	IBOutlet UIButton		*DashboardBtn,*SceneConfigBtn,*ScheduleConfigBtn,*InstallerViewBtn;
	IBOutlet UIScrollView	*sceneScrollView;
	IBOutlet UITextField	*addTextField,*EditTextField;
	IBOutlet UIView			*AddsceneView,*EditSceneNameView;
	IBOutlet UILabel		*TimeLbl1,*TimeLbl2,*DateLbl,*ActivatedLabel;
	NSTimer					*DateTimeDisplayTimer,*ProcessTimer,*QueueTimer;
	CGPoint					LastOffsetPointScenes;
	ProcessEnum				sceneEnum,queueEnum;
	NSMutableArray			*selectedScenesArray;
	NSMutableArray			*ExcludedSceneDevicesArray,*SupportedMaskFilterArray;
	BOOL   issceneSelect,isSceneEdit;
	int    g_selectedSceneId,g_selectedsceneIndex,SceneInfoId,currDeviceMetaData;
	int    curSceneEditToggle,deleteSceneIndex;
	
	//Animation
	IBOutlet UIImageView	*animateImageView;
	IBOutlet UIScrollView	*animationScrollView;
	IBOutlet UILabel		*animationTitle;
	NSTimer					*openTimer,*closeTimer;
	int						yPosition,xposition;
	UIView					*loadingView;
	IBOutlet UIView			*popupView;
	CGPoint rightOffset;
	CGPoint editOffSetPoint;
	BOOL isAddDeleteScene;
	NSMutableArray	 *loginArray;
	int currentSceneEditIndex;

    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;

//Animation
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UIScrollView	*animationScrollView;
@property(nonatomic,retain) UILabel			*animationTitle;

@property(nonatomic,retain) UIButton		*DashboardBtn,*SceneConfigBtn,*ScheduleConfigBtn,*InstallerViewBtn;
@property(nonatomic,retain) UIScrollView	*sceneScrollView;
@property(nonatomic,retain) UIView			*AddsceneView,*EditSceneNameView;
@property(nonatomic,retain) UITextField		*addTextField,*EditTextField;
@property(nonatomic,retain) UILabel			*TimeLbl1,*TimeLbl2,*DateLbl,*ActivatedLabel;
@property(nonatomic,retain) UIView			*popupView;


//3 Tabs switching items
-(IBAction)LiveViewDashboard:(id)sender;
-(IBAction)SceneConfigurator:(id)sender;
-(IBAction)ScheduleConfigurator:(id)sender;
-(IBAction)InstallerView:(id)sender;
-(IBAction)LOGOUT:(id)sender;

//Add and refreshbutton click
-(IBAction)SceneAddBtnClicked:(id)sender;
-(IBAction)SceneRefreshBtnClicked:(id)sender;
//scene create and cancelbtn click
-(IBAction)SceneCreateBtnClicked:(id)sender;
-(IBAction)SceneCancelBtnClicked:(id)sender;
//scene edit save and cancel btn click
-(IBAction)SceneEditSaveBtnClicked:(id)sender;
-(IBAction)SceneEditCancelBtnClicked:(id)sender;

@end
