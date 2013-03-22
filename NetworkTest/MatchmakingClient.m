//
//  MatchmakingClient.m
//  Snap
//
//  Created by Mohammad Jeragh on 12/28/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "MatchmakingClient.h"

typedef enum{
    ClientStateIdle,
    ClientStateSearchingForServers,
    ClientStateConnecting,
    ClientStateConnected
} ClientState;

@implementation MatchmakingClient{
    NSMutableArray *_availableServers;
    ClientState _clientState;
    NSString *_serverPeerID;
}


-(id)init{
    if ((self= [super init])) {
        _clientState = ClientStateIdle;
    }
    return self;
}

-(void)startSearchingForServersWithSessionID:(NSString *)sessionID{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (_clientState != ClientStateIdle) {
        return;
    }
    _clientState = ClientStateSearchingForServers;
    _availableServers = [NSMutableArray arrayWithCapacity:10];
    
    _session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeClient];
    
    _session.delegate = self;
    
    _session.available = YES;
}

-(NSArray *)availableServers{
    return _availableServers;
}


-(NSUInteger)availableServerCount{
    return [self.availableServers count];
}
-(NSString *)peerIDForAvailableServerAtIndex:(NSUInteger)index{
    return [self.availableServers objectAtIndex:index];
}
-(NSString *)displayNameForPeerID:(NSString *)peerID{
    return [self.session displayNameForPeer:peerID];
}

-(void)connectToServerWithPeerID:(NSString *)peerID{
    NSAssert(_clientState==ClientStateSearchingForServers, @"Wrong State");
    _clientState = ClientStateConnecting;
    _serverPeerID = peerID;
    [_session connectToPeer:peerID withTimeout:_session.disconnectTimeout];
    
}

-(void)disconnectFromServer{
    NSAssert(_clientState != ClientStateIdle, @"Wrong State");
    _clientState = ClientStateIdle;
    
    [_session disconnectFromAllPeers];
    _session.available = NO;
    _session.delegate = nil;
    _session = nil;
    _availableServers = nil;
    
    [self.delegate matchmakingClient:self didDisconnectFromServer:_serverPeerID];
    _serverPeerID = nil;
}


#pragma mark - GKSessionDelegate
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: peer %@ changed state %d", peerID, state);
    NSLog(@"%s",__PRETTY_FUNCTION__);
#endif
    
    switch (state)
	{
            // The client has discovered a new server.
		case GKPeerStateAvailable:
            if (_clientState == ClientStateSearchingForServers) {
                if (![_availableServers containsObject:peerID]) {
                    [_availableServers addObject:peerID];
                    [self.delegate matchmakingClient:self serverBecameAvailable:peerID];
                }

            }
            
            break;
            
            // The client sees that a server goes away.
		case GKPeerStateUnavailable:
			if (_clientState == ClientStateSearchingForServers) {
                if ([_availableServers containsObject:peerID]){
                    [_availableServers removeObject:peerID];
                    [self.delegate matchmakingClient:self serverBecameUnavailable:peerID];
                }
            }
            
            if (_clientState == ClientStateConnecting && [peerID isEqualToString:_serverPeerID]) {
                [self disconnectFromServer];
            }
            
			break;
            
		case GKPeerStateConnected:
            if (_clientState == ClientStateConnecting) {
                _clientState = ClientStateConnected;
                [self.delegate matchmakingClient:self didConnectFromServer:peerID];
            }
			break;
            
		case GKPeerStateDisconnected:
            if (_clientState == ClientStateConnected) {
                [self disconnectFromServer];
            }
			break;
            
		case GKPeerStateConnecting:
			break;
	}	
}


- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: connection request from peer %@", peerID);
#endif
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: connection with peer %@ failed %@", peerID, error);
#endif
    
    [self disconnectFromServer];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: session failed %@", error);
#endif
    if ([[error domain] isEqualToString:GKSessionErrorDomain]) {
        if ([error code] == GKSessionCannotEnableError) {
            [self.delegate matchmakingClientNoNetwork:self];
            [self disconnectFromServer];
        }
    }
}

@end
