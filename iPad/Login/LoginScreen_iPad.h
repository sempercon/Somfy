//
//  LoginScreen_iPad.h
//  Somfy
//
//  Created by Sempercon on 5/31/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SendCommand.h"
#import "MJPEGClient.h"

@interface LoginScreen_iPad : UIViewController <UIApplicationDelegate,ParserCallback> {

	IBOutlet UITextField *txtUsername,*txtPassword;
	NSTimer		   *authenticateTimer,*loadGobalValueTimer,*sceneInfoTimer,*scheduleTimerInfoTimer,*scheduleEventInfoTimer;
	IBOutlet UIActivityIndicatorView *authenticationProcessing;
	IBOutlet UIButton *btnLogin;
	ProcessEnum	   authenticateEnum,initEnum,sceneInfoEnum,scheduleTimerInfoEnum,scheduleEventInfoEnum;
	IBOutlet UIButton	*rememberMeBtn;
	BOOL	 isremember;
	int sceneInfoCount,g_objectIndex;
	NSMutableArray	  *loginArray;
	UIView			  *loadingView;
	BOOL			  isLoadingError;
	
	//TAHOMA CONTROLLER
	IBOutlet UIView			*tahomaControllerView;
	IBOutlet UITableView	*tahomaControllerTable;
    
    IBOutlet UIButton *btnStart; //
    IBOutlet UIButton *btnStop;
    IBOutlet UIImageView *imgView;
    IBOutlet UILabel *lblError;
    IBOutlet UIButton *btnRelogin;
	IBOutlet UIButton *btnRetry;
    IBOutlet UIButton *btnControllers;
}
@property (nonatomic, retain) UIButton *btnRelogin,*btnRetry,*btnControllers;
@property (nonatomic, retain) UIButton	*rememberMeBtn;
@property (nonatomic, retain) UITextField *txtUsername,*txtPassword;
@property (nonatomic, retain) UIButton *btnLogin;
@property (nonatomic, retain) UIActivityIndicatorView *authenticationProcessing;

//TAHOMA CONTROLLER
@property (nonatomic, retain) UIView			*tahomaControllerView;
@property (nonatomic, retain) UITableView	*tahomaControllerTable;

-(void)loadGobalValues;

-(IBAction)btnLoginClicked:(id)sender;
-(IBAction)rememberMeBtnClicked:(id)sender;

@end
