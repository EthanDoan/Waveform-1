//
//  WaveformViewController.m
//  Waveform
//
//  Created by Adam Kaplan on 3/5/16.
//  Copyright © 2016. All rights reserved.
//

#import "WaveformViewController.h"
#import "WaveformView.h"

@interface WaveformViewController ()

@property (nonatomic) NSMutableArray *controls;
@property (nonatomic) NSMutableArray *controlTitles;

@property (nonatomic) WaveformView *waveformView;
@property (nonatomic) UISegmentedControl *verticalAlignControl;
@property (nonatomic) UIStepper *barWidthStepper;
@property (nonatomic) UIStepper *barHeightStepper;
@property (nonatomic) UIStepper *barSpacingStepper;
@property (nonatomic) UIStepper *barCornerStepper;
@property (nonatomic) UIStepper *minDurationStepper;
@property (nonatomic) UIStepper *maxDurationStepper;

@end

@implementation WaveformViewController {
    NSMutableArray *_localConstraints;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WaveCellId"];
    
    _waveformView = [[WaveformView alloc] initWithFrame:CGRectZero];
    _waveformView.translatesAutoresizingMaskIntoConstraints = NO;
    _waveformView.layer.cornerRadius = 5.0;
    _waveformView.barSize = CGSizeMake(7.0, 15.0);
    _waveformView.maximumBarAnimationDuration = 0.55;
    _waveformView.layoutMargins = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    _waveformView.barVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _controls = [NSMutableArray array];
    _controlTitles = [NSMutableArray array];
    
    _verticalAlignControl = [[UISegmentedControl alloc] initWithItems:@[ @"Center", @"Top", @"Bottom" ]];
    _verticalAlignControl.selectedSegmentIndex = _waveformView.barVerticalAlignment;
    [_verticalAlignControl addTarget:self action:@selector(verticalAlignmentDidChange:) forControlEvents:UIControlEventValueChanged];
    [_controls addObject:_verticalAlignControl];
    [_controlTitles addObject:@"Alignment"];
    
    _barHeightStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    _barHeightStepper.minimumValue = self.waveformView.barCornerRadius.height * 2.0;
    _barHeightStepper.maximumValue = 30.0;
    _barHeightStepper.stepValue = 0.5;
    _barHeightStepper.value = self.waveformView.barSize.width;
    [_barHeightStepper addTarget:self action:@selector(barHeightStepperDidChange:) forControlEvents:UIControlEventValueChanged];
    [_controls addObject:_barHeightStepper];
    [_controlTitles addObject:@"Height"];
    
    _barWidthStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    _barWidthStepper.minimumValue = self.waveformView.barCornerRadius.width * 2.0;
    _barWidthStepper.maximumValue = 15.0;
    _barWidthStepper.stepValue = 0.5;
    _barWidthStepper.value = self.waveformView.barSize.width;
    [_barWidthStepper addTarget:self action:@selector(barWidthStepperDidChange:) forControlEvents:UIControlEventValueChanged];
    [_controls addObject:_barWidthStepper];
    [_controlTitles addObject:@"Width"];
    
    _barSpacingStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    _barSpacingStepper.minimumValue = 0;
    _barSpacingStepper.maximumValue = 5.0;
    _barSpacingStepper.stepValue = 0.1;
    _barSpacingStepper.value = self.waveformView.barSpacing;
    [_barSpacingStepper addTarget:self action:@selector(barSpacingStepperDidChange:) forControlEvents:UIControlEventValueChanged];
    [_controls addObject:_barSpacingStepper];
    [_controlTitles addObject:@"Spacing"];
    
    _barCornerStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    _barCornerStepper.minimumValue = 0;
    _barCornerStepper.maximumValue = MIN(self.waveformView.barSize.height, self.waveformView.barSize.width) / 2.0;
    _barCornerStepper.stepValue = 0.1;
    _barCornerStepper.value = self.waveformView.barCornerRadius.width;
    [_barCornerStepper addTarget:self action:@selector(barCornerStepperDidChange:) forControlEvents:UIControlEventValueChanged];
    [_controls addObject:_barCornerStepper];
    [_controlTitles addObject:@"Corner Radius"];
    
    _minDurationStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    _minDurationStepper.minimumValue = 0.1;
    _minDurationStepper.maximumValue = self.waveformView.maximumBarAnimationDuration;
    _minDurationStepper.stepValue = 0.1;
    _minDurationStepper.value = self.waveformView.minimumBarAnimationDuration;
    [_minDurationStepper addTarget:self action:@selector(minDurationStepperDidChange:) forControlEvents:UIControlEventValueChanged];
    [_controls addObject:_minDurationStepper];
    [_controlTitles addObject:@"Min Duration"];
    
    _maxDurationStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    _maxDurationStepper.minimumValue = self.waveformView.minimumBarAnimationDuration;
    _maxDurationStepper.maximumValue = 5.0;
    _maxDurationStepper.stepValue = 0.1;
    _maxDurationStepper.value = self.waveformView.maximumBarAnimationDuration;
    [_maxDurationStepper addTarget:self action:@selector(maxDurationStepperDidChange:) forControlEvents:UIControlEventValueChanged];
    [_controls addObject:_maxDurationStepper];
    [_controlTitles addObject:@"Max Duration"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.waveformView startAnimating];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.waveformView stopAnimating];
    [super viewDidDisappear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.controls.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !indexPath.row ? 200.0 : 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaveCellId" forIndexPath:indexPath];
        [cell.contentView addSubview:self.waveformView];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    
    cell.textLabel.text = self.controlTitles[indexPath.row - 1];
    
    UIControl *control = self.controls[indexPath.row - 1];
    cell.accessoryView = control;
    if ([control isKindOfClass:[UIStepper class]]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.4f", ((UIStepper *)control).value];
    } else {
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        return;
    }
    
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.waveformView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:cell.contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.waveformView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:cell.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0]];
    [cell.contentView setNeedsLayout];
}

- (void)verticalAlignmentDidChange:(UISegmentedControl *)segmentedControl
{
    self.waveformView.barVerticalAlignment = segmentedControl.selectedSegmentIndex;
}

- (void)barHeightStepperDidChange:(UIStepper *)stepper
{
    CGSize barSize = self.waveformView.barSize;
    barSize.height = stepper.value;
    self.waveformView.barSize = barSize;
    [self updateCellValueForStepper:stepper];
    
    self.barCornerStepper.maximumValue = MIN(barSize.width, barSize.height) / 2.0;
    [self updateCellValueForStepper:self.barCornerStepper];
}

- (void)barWidthStepperDidChange:(UIStepper *)stepper
{
    CGSize barSize = self.waveformView.barSize;
    barSize.width = stepper.value;
    self.waveformView.barSize = barSize;
    [self updateCellValueForStepper:stepper];
    
    self.barCornerStepper.maximumValue = MIN(barSize.width, barSize.height) / 2.0;
    [self updateCellValueForStepper:self.barCornerStepper];
}

- (void)barSpacingStepperDidChange:(UIStepper *)stepper
{
    self.waveformView.barSpacing = stepper.value;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self updateCellValueForStepper:stepper];
}

- (void)barCornerStepperDidChange:(UIStepper *)stepper
{
    self.waveformView.barCornerRadius = CGSizeMake(stepper.value, stepper.value);
    stepper.value = self.waveformView.barCornerRadius.width; // it may be capped
    [self updateCellValueForStepper:stepper];
    
    self.barWidthStepper.minimumValue = stepper.value * 2.0;
    [self updateCellValueForStepper:self.barWidthStepper];
    
    self.barHeightStepper.minimumValue = stepper.value * 2.0;
    [self updateCellValueForStepper:self.barHeightStepper];
}

- (void)minDurationStepperDidChange:(UIStepper *)stepper
{
    if (stepper.value > self.waveformView.maximumBarAnimationDuration) {
        stepper.value = self.waveformView.maximumBarAnimationDuration;
    }
    
    self.maxDurationStepper.minimumValue = stepper.value;
    
    self.waveformView.minimumBarAnimationDuration = stepper.value;
    
    [self updateCellValueForStepper:stepper];
    [self updateCellValueForStepper:self.maxDurationStepper];
}

- (void)maxDurationStepperDidChange:(UIStepper *)stepper
{
    if (stepper.value < self.waveformView.minimumBarAnimationDuration) {
        stepper.value = self.waveformView.minimumBarAnimationDuration;
    }
    
    self.minDurationStepper.maximumValue = stepper.value;
    
    self.waveformView.maximumBarAnimationDuration = stepper.value;
    
    [self updateCellValueForStepper:stepper];
    [self updateCellValueForStepper:self.minDurationStepper];
}

- (void)updateCellValueForStepper:(UIStepper *)stepper
{
    NSInteger controlRow = [self.controls indexOfObjectIdenticalTo:stepper];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:controlRow + 1
                                                                                     inSection:0]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.4f", stepper.value];
}

@end
