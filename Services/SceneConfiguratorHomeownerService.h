//
//  SceneConfiguratorHomeownerService.h
//  Somfy
//
//  Created by Sempercon on 5/13/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"

@interface SceneConfiguratorHomeownerService : NSObject {
	NSString *command;
}

+ (SceneConfiguratorHomeownerService *)getSharedInstance;
-(void) removeScene :(NSString*)sceneid  :(id<ParserCallback>)delegate;
-(void) addScene:(NSMutableDictionary *)dict :(id<ParserCallback>)delegate;
-(void) ChangeSceneName:(NSString *)sceneName :(NSString*)sceneid  :(id<ParserCallback>)delegate;
-(void) getSceneInfo:(NSString*)sceneid  :(id<ParserCallback>)delegate;
-(void)includeSceneMember:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate;
-(void) setMemberSetting:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate;
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate;

@end
