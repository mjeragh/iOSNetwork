//
//  MatchmakingServer.h
//  Snap
//
//  Created by Mohammad Jeragh on 12/26/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

@class MatchmakingServer;
@protocol MatchmakingServerDelegate  <NSObject>

- (void)matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID;

- (void)matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID;

-(void)matchmakingServerSessionDidEnd:(MatchmakingServer *)server;
-(void)matchmakingServerNoNetwork:(MatchmakingServer *)server;

@end

#import <Foundation/Foundation.h>

@interface MatchmakingServer : NSObject<GKSessionDelegate>

@property(nonatomic,assign) int maxClients;
@property(nonatomic, strong, readonly) NSArray *connectedClients;
@property(nonatomic, strong, readonly) GKSession *session;
@property(nonatomic, weak) id <MatchmakingServerDelegate> delegate;

-(void) startAcceptingConnectionsForSessionID:(NSString *) sessionID;
-(void)endSession;
- (void)stopAcceptingConnections;

-(NSUInteger)connectedClientCount;
-(NSString *)peerIDForConnectedClientAtIndex:(NSUInteger)index;
-(NSString *)displayNameForPeerID:(NSString *)peerID;

@end
