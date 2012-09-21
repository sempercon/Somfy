//
//  HTTPClient.m
//  TestPrj
//
//  Created by Hao Hu on 28.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MJPEGClient.h"


@implementation MJPEGClient

@synthesize url = _url;
@synthesize user = _user;
@synthesize password = _password;
@synthesize delegate = _delegate;
@synthesize timeout = _timeout;
@synthesize name = _name;


- (void) stop
{
    //Stop the URL Connection.
    if (_urlConn)
        [_urlConn cancel];
    _urlConn = nil;
}

-(id) initWithURL:(NSString *)url delegate:(id<MJPEGClientDelegate>)delegate timeout:(NSTimeInterval)timeout
{
    self = [super init];
    if (self != nil)
    {
        self.url = url;
        self.delegate = delegate;
        self.timeout = timeout;
    }
    return self;
}


- (void) start
{
    if (_url)
    {
        NSURL * nsUrl = [[NSURL alloc] initWithString:_url];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:nsUrl];
        [nsUrl release];
        
        [request setTimeoutInterval:_timeout];
        
    if (self.user != nil && self.password != nil)
        {
            NSString *authString = [[NSString alloc] initWithFormat:@"%@:%@",self.user,self.password];
            NSString *authedString = [Base64 encodePlaintText:authString];
            [authString release];
            
            NSString *value = [[NSString alloc] initWithFormat:@"Basic %@",authedString];
            [request addValue:value forHTTPHeaderField:@"Authorization"];  
            [value release];
        }
        
        _urlConn = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
        [request release];
        if (_urlConn)
            recvData = [[NSMutableData data] retain];
        
        [_urlConn start];

    }
}


/*
 Once the client receives the response.
 */
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        httpResponse = (NSHTTPURLResponse *) response;
    }
    
    if (httpResponse)
    {
        int statusCode = [httpResponse statusCode];
        if (statusCode < 200 || statusCode >= 300)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
            [userInfo setObject:@"Non 200 response code." forKey:NSLocalizedDescriptionKey];
            NSError *error = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:statusCode userInfo:userInfo] autorelease];
        
            if (self.delegate)
            {
                [self.delegate mjpegClient:self didReceiveError:error];

            }
            _urlConn = nil;
            [userInfo release];
        }

    }
    
    if ([recvData length] != 0)
    {

        //It removes the /r/n (0xFF,0x0D, 0x0A)
        [recvData setLength:(recvData.length - 3)];
        
        NSData *imgData = [[NSData alloc] initWithData:recvData];
        UIImage *uiImage = [[[UIImage alloc] initWithData:imgData ] autorelease];
        [imgData release];
            
        timeoutCount = 0;
        if (self.delegate)
            [self.delegate mjpegClient:self didReceiveImage:uiImage];
            
    }
    [recvData setLength:0];
    
}


-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [recvData appendData:data];
    
}

//When error occurs, reports to the delegate.
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _urlConn = nil;
    if (self.delegate)
         [self.delegate mjpegClient:self didReceiveError:error];

}

-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    _urlConn = nil;
    
    //A NSError object should be created and send to delegate.
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:@"Authentication Error!" forKey:NSLocalizedDescriptionKey];
    NSError* error = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:ERROR_AUTH userInfo:userInfo] autorelease];
    if (self.delegate)
    {
         [self.delegate mjpegClient:self didReceiveError:error];
    }
    [userInfo release];
}



-(void) dealloc
{
    [recvData release];
    [_name release];
    [_url release];
    [_user release];
    [_password release];
    [super dealloc];
}
@end
