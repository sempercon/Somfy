//
//  HTTPClient.h
//  TestPrj
//
//  Created by Hao Hu on 28.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base64.h"



typedef enum
{
    ERROR_AUTH
    
} NSMJPEGErrorCode;

@class MJPEGClient;

@protocol MJPEGClientDelegate <NSObject>

- (void) mjpegClient:(MJPEGClient*) client didReceiveImage:(UIImage*) image;
/*
 @Discussion 
 Once the delegate receives this message, it will receive no further messages for connection.
 */
- (void) mjpegClient:(MJPEGClient*) client didReceiveError:(NSError*) error;

@end


@interface MJPEGClient : NSObject {
    NSString * _name;
    NSString * _url;
    NSMutableData * recvData;
    NSString * _user;
    NSString *_password;
    id<MJPEGClientDelegate> _delegate;
    NSURLConnection *_urlConn;
    NSTimeInterval _timeout;
    int timeoutCount;
    
}



/*!
 The URL of MJPEG Server, where the MJPEG stream can be got.
 */
@property (nonatomic, retain) NSString *url;
/*!
If authentication required, user must be assigned, otherwise keep it as nil.
*/
@property (nonatomic,retain)  NSString *user;
/*!
If authentication required, password must be assigned, otherwise keep it as nil.
*/
@property (nonatomic, retain) NSString *password;
/*!

*/
@property (nonatomic,retain) id<MJPEGClientDelegate> delegate;
/*!
HTTP Request timeout.
*/
@property (nonatomic) NSTimeInterval timeout;

/*!
The name of MJPEG cliet which is used to identify the different MJPEG clients.
*/
@property(nonatomic,retain) NSString* name;
/*!
@method start
 It starts the MJPEG Client and receives the MJPEG stream.
*/
- (void) start;
/*!
It stops receiving the MJPEG stream.
*/
- (void) stop;
- (id) initWithURL:(NSString*) url delegate:(id<MJPEGClientDelegate>) delegate timeout:(NSTimeInterval) timeout;


@end

