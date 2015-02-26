//
//  CDVVideo.m
//  
//
//  Updated by Ross Martin 2015-02-26
//  Updated by Tom Krones 2013-09-30.
//  Created by Peter Robinett on 2012-10-15.
//
//

#import "CDVVideo.h"
#import "MediaPlayer/MPMoviePlayerViewController.h"
#import "MediaPlayer/MPMoviePlayerController.h"
#import "MovieViewController.h"
#import <Cordova/CDV.h>

@implementation CDVVideo
- (void) play:(CDVInvokedUrlCommand*)command
{
  movie = [command.arguments objectAtIndex:0];
  NSString *orient = [command.arguments objectAtIndex:1];
  NSRange range = [movie rangeOfString:@"http"];
  if(range.length > 0) {
    if ([@"YES" isEqualToString:orient]) {
      player = [[MovieViewController alloc] initWithContentURL:[NSURL URLWithString:movie] andOrientation:YES];
    } else {
      player = [[MovieViewController alloc] initWithContentURL:[NSURL URLWithString:movie] andOrientation:NO];
    }
    
  } else {
    NSURL *fileURL = [NSURL fileURLWithPath: movie];
    if ([@"YES" isEqualToString:orient]) {
      player = [[MovieViewController alloc] initWithContentURL:fileURL andOrientation:YES];
    } else {
      player = [[MovieViewController alloc] initWithContentURL:fileURL andOrientation:NO];
    }
  }
  if (player) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovieDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self.viewController presentMoviePlayerViewControllerAnimated:player];
  }
}

- (void)MovieDidFinish:(NSNotification *)notification {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
                                                object:nil];
  NSString* jsString = [NSString stringWithFormat:@"window.plugins.CDVVideo.finished(\"%@\");", movie];
  [self.webView stringByEvaluatingJavaScriptFromString:jsString];
  
}

- (void)dealloc {
  //[player release];
  //[movie release];
  //[super dealloc];
}

@end
