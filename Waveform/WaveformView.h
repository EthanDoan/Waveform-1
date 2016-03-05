//
//  WaveformView.h
//  Waveform
//
//  Created by Adam Kaplan on 3/5/16.
//  Copyright © 2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveformView : UIView

@property (nonatomic, readonly) NSUInteger numberOfBars;

@property (nonatomic) CGSize barCornerRadius;

@property (nonatomic) CGSize barSize;

@property (nonatomic) CGFloat barSpacing;

@property (nonatomic) UIColor *barColor;

@property (nonatomic) CFTimeInterval minimumBarAnimationDuration;

@property (nonatomic) CFTimeInterval maximumBarAnimationDuration;

@property (nonatomic) UIControlContentVerticalAlignment barVerticalAlignment;

- (instancetype)initWithBarCount:(NSUInteger)barCount NS_DESIGNATED_INITIALIZER;

- (void)stopAnimating;

- (void)startAnimating;

@end
