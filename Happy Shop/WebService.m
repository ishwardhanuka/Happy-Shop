//
//  WebService.m
//  Happy Shop
//
//  Created by Ishwar Dhanuka on 2/5/16.
//  Copyright © 2016 luxola. All rights reserved.
//

#import "WebService.h"

@implementation WebService
@synthesize data;
@synthesize connectionName;
@synthesize returnParam;
@synthesize urlConnection;

-(void)getDataFromUrl:(NSString*)stringUrl withParameters:(NSDictionary*)params
{
    NSLog(@"-----%s----", __FUNCTION__) ;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *result = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Params %@",result);
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(urlConnection)
        [urlConnection start];
    else{
        if([caller respondsToSelector:@selector(setReturnedFailed:)])
            [caller setReturnedFailed:self];
    }
}
-(void)getDataFromUrl:(NSString*)stringUrl withParameterData:(NSData*)jsonData
{
    NSLog(@"-----%s----", __FUNCTION__) ;
    
    NSString *result = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Params %@",result);
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(urlConnection)
        [urlConnection start];
    else{
        if([caller respondsToSelector:@selector(setReturnedFailed:)])
            [caller setReturnedFailed:self];
    }
}
-(void)getDataFromUrl:(NSString*)stringUrl withStringParameters:(NSString*)params
{
    NSLog(@"Params %@",params);
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(urlConnection)
        [urlConnection start];
    else{
        if([caller respondsToSelector:@selector(setReturnedFailed:)])
            [caller setReturnedFailed:self];
    }
}
-(void)getDataFromUrl:(NSString*)stringUrl
{
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(urlConnection)
        [urlConnection start];
    else{
        if([caller respondsToSelector:@selector(setReturnedFailed:)])
            [caller setReturnedFailed:self];
    }
    
}

-(void)getDataFromUrl:(NSString*)stringUrl withStringParameters:(NSMutableDictionary *)params withFile:(NSURL *)filedata
{
    NSLog(@"Params %@",params);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stringUrl]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    //[request setHTTPBody:[array dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableData *body = [NSMutableData data];
    
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"FileName\"; filename=\"%@\"\r\n",[params objectForKey:@"FileName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *dataObj = [NSData dataWithContentsOfURL:filedata];
    [body appendData:[NSData dataWithData:dataObj]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    for(NSString *tmp in params){
        // text parameter
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", tmp] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[params objectForKey:tmp] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(urlConnection)
        [urlConnection start];
    else{
        if([caller respondsToSelector:@selector(setReturnedFailed:)])
            [caller setReturnedFailed:self];
    }
    
}

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    expectedLength = [response expectedContentLength];
}
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)newData
{
    [self.data appendData:newData];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    long progress = (((float)totalBytesWritten/(float)totalBytesExpectedToWrite)*100);
    
    if([caller respondsToSelector:@selector(setPercentDone:)])
        [caller setPercentDone:progress];
}
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    self.data = nil;
    if([caller respondsToSelector:@selector(setReturnedFailed:)])
        [caller setReturnedFailed:self];
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    //NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"Result %@",result);
    
    if (self.completionHandler)
        self.completionHandler();
    
    [self returnData];
}
-(void)returnData
{
    NSLog(@"-----%s----", __FUNCTION__) ;
    if([caller respondsToSelector:@selector(setReturnedData:)])
        [caller setReturnedData:self];
}
-(void)setCaller:(id<Connectable>) vc
{
    caller = vc;
}
-(void)stopCaller{
    [urlConnection cancel];
}


@end