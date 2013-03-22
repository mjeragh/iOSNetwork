//
//  Network.h
//  NetworkTest
//
//  Created by Mohammad Jeragh on 3/22/13.
//  Copyright (c) 2013 Mohammad Jeragh. All rights reserved.
//

#import "Packet.h"
#import "PacketSignInResponse.h"

@class Network;

@protocol NetworkDelegate <NSObject>

-(void)appendStringToViewWith:(NSString *)text;

@end


@interface Network : NSObject<GKSessionDelegate>
@property(nonatomic) BOOL isServer;
@property(nonatomic, strong) GKSession *session;
@property (nonatomic, weak) id<NetworkDelegate> delegate;
-(void)sendPacketSignInRequestTo:(NSString *)peerID;
-(void)sendPacketSignInResponseTo:(NSString *)peerID;

@end
