//
//  CANetEngine.m
//  Ipoca_Card
//
//  Created by iMac on 14-6-20.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import "CANetEngine.h"
#import "DesUtil.h"
@implementation CANetEngine
{
    NSMutableData *requestData;
    CASuccessBlock finishBlock;
    CAErrorBlock errBlock;
    
    NSURLConnection *caConnection;
}
-(id)init
{
    self = [super init];
    if (self) {
        requestData = [[NSMutableData alloc]init];
        
    }
    return self;
}

-(void) requestWithURL:(NSString*)urlStr Params:(NSDictionary*)params HttpMothed:(NSString*)httpMethod isHttpForm:(BOOL)isForm Success:(CASuccessBlock)successBlock Error:(CAErrorBlock)errorBlock;
{
    finishBlock = successBlock;
    errBlock = errorBlock;
    [CAActivetyIndicator show];
    NSMutableURLRequest *request;
    if ([httpMethod isEqualToString:CA_POST]) {    //post
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [request setHTTPMethod:httpMethod];
        if (isForm) {
            request = [self formRequest:request Param:params];
        }else{
          NSString *str = [self mk_urlEncodedString:[self getParams:params]];
          NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
          [request setHTTPBody:data];
        }
    }else{                                         //get
        NSString *str = [self mk_urlEncodedString:[DesUtil encryptUseDES:[self getParams:params] key:CA_DESKEY]];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlStr,str]]];
        CALog(@"==%@",[NSString stringWithFormat:@"%@%@",urlStr,str]);
    }
    [caConnection cancel];
    caConnection = nil;
    caConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)cancelConnection
{
    [caConnection cancel];
}

-(NSMutableURLRequest*)formRequest:(NSMutableURLRequest*)request Param:(NSDictionary*)params
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"*****";
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    NSMutableString *body=[[NSMutableString alloc]init];
    NSArray *keys= [params allKeys];
    
    for(int i=0;i<[keys count];i++)
    {
        NSString *key=[keys objectAtIndex:i];
        if(![key isEqualToString:@"photoImage"])
        {
            [body appendFormat:@"%@\r\n",MPboundary];
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
   
    NSMutableData *myRequestData = [NSMutableData data];

    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary  *photoDic = [params objectForKey:@"photoImage"];
    
    NSArray *photoKeys = [photoDic allKeys];
    NSArray *photoSortedKeys = [photoKeys sortedArrayUsingSelector:@selector(compare:)];
    for (int i=0; i<[photoDic count]; i++) { //upload image_order
//        NSString *key=[photoKeys objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"add_image_order_%@",@(i+1)];
        NSMutableString *body0=[[NSMutableString alloc]init];
        [body0 appendFormat:@"%@\r\n",MPboundary];
        [body0 appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",name];
        [body0 appendFormat:@"%@\r\n",@(i+1)];
        [myRequestData appendData:[body0 dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for (int i=0; i<[photoDic count]; i++) { //upload image_data
        NSString *key=[photoSortedKeys objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"add_image_order_%@",@(i+1)];
        NSMutableString *body0=[[NSMutableString alloc]init];
        [body0 appendFormat:@"%@\r\n",MPboundary];
        [body0 appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",name];
        [body0 appendFormat:@"%@\r\n",@(i+1)];
        [myRequestData appendData:[body0 dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *filename = [NSString stringWithFormat:@"image_file_%@",@(i+1)];
        NSMutableString *body1=[[NSMutableString alloc]init];
        [body1 appendFormat:@"%@\r\n",MPboundary];
        [body1 appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image%@.jpeg\"\r\n",filename,@(i+1)];
        [body1 appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
        NSData *data = [photoDic objectForKey:key];
        [myRequestData appendData:[body1 dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData appendData:data];
    }
   
    
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%@", @([myRequestData length])] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:myRequestData];
    return request;
}

-(NSString*)getParams:(NSDictionary*)params
{
    NSArray *keyArr = [params allKeys];
    NSString *par = @"";
    for (int i=0; i<keyArr.count; i++) {
        NSString *key = [keyArr objectAtIndex:i];
        NSString *keyV = [params valueForKey:key];
        if (i == keyArr.count - 1) {
            par=[par stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,keyV]];
        }else{
            par=[par stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,keyV]];
        }
    }
    return par;
}

- (NSString*) mk_urlEncodedString:(NSString*)encodeString
{ // mk_ prefix prevents a clash with a private api
    
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (__bridge CFStringRef) encodeString,
                                                                          nil,
                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                          kCFStringEncodingUTF8);
    
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];
    
    if(!encodedString)
        encodedString = @"";
    
    return encodedString;
}


#pragma -mark  connection delegate --------------------------------------------
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (totalBytesExpectedToWrite > 0) {
//        [CAActivetyIndicator showProgress:(double)totalBytesWritten/(double)totalBytesExpectedToWrite];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [CAActivetyIndicator dismiss];
    CAALERT(CA_NET_ERROR);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [requestData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *receiveStr = [[NSString alloc]initWithData:requestData encoding:NSUTF8StringEncoding];
    receiveStr = [DesUtil decryptUseDES:receiveStr key:CA_DESKEY];
    if (!receiveStr) {
        return;
    }
    NSError *error;
    NSData *data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *receiveDic = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error]dictionaryByReplacingNullsWithStrings];
    CALog(@"%@=======receiveDic==%@",connection.currentRequest.URL,receiveDic);
   
    [CAActivetyIndicator dismiss];
    if (receiveDic) {
        NSString *is_maintain = [receiveDic objectForKey:@"is_maintain"];
        if (is_maintain) {
            if ([is_maintain isEqualToString:@"1"]) {
                CAALERT(CA_MAINTAIN);
                return;
            }
        }
        
        NSString *status = [receiveDic objectForKey:@"status"];
        if (status) {
            if ([status isEqualToString:@"0004"]) {
                CAALERT(CA_CONNECT_ERROR);
                return;
            }
        }
        finishBlock(receiveDic);
    }else{
        errBlock(error);
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    CALog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
        
    }
}
@end
