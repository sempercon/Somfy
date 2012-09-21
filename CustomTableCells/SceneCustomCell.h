//
//  SceneCustomCell.h
//  Somfy
//
//  Created by Sempercon on 5/13/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneCustomCell.h"

@class SceneCustomCell;

@protocol SceneCustomCellDelegate <NSObject>
-(void)ScenesSelected:(SceneCustomCell*)cell;
@end

@interface SceneCustomCell : UITableViewCell {
@private
	UIButton	*btnSceneName;
	UILabel		*lblSceneName;
	UILabel		*lblActivated;
	UIButton	*btnScene;
	UIButton	*btnActivated;
	UIImageView *imageIndicator,*imgBg;
	NSObject<SceneCustomCellDelegate> *delegate;
}

@property(nonatomic,retain) IBOutlet UIButton		*btnSceneName,*btnActivated;
@property(nonatomic,retain) IBOutlet UILabel *lblActivated,*lblSceneName;
@property(nonatomic,retain) IBOutlet UIButton		*btnScene;
@property(nonatomic,retain) IBOutlet UIImageView	*imageIndicator,*imgBg;
@property(nonatomic,assign) NSObject<SceneCustomCellDelegate> *delegate;


@end

