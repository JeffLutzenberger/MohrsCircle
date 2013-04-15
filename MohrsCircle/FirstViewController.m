//
//  FirstViewController.m
//  MohrsCircle
//
//  Created by Jeff Lutzenberger on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "MohrsCircleAppDelegate.h"
#import "InputCell.h"
#import "RegexKitLite.h"


@implementation FirstViewController

@synthesize inputTableView = _inputTableView;
@synthesize circleModel = _circleModel;
@synthesize circleDrawing = _circleDrawing;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MohrsCircleAppDelegate* app = (MohrsCircleAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _circleModel = app.circleModel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BeginEditingInput:) name:@"BeginEditingInput" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EndEditingInput:) name:@"EndEditingInput" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.inputTableView reloadData];
    
    [self.circleDrawing zoomToExtents];
    
    [self.circleDrawing setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc
{
    [super dealloc];
}


- (void)BeginEditingInput:(NSNotification *)notification{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    _inputTableView.frame = CGRectMake(_inputTableView.frame.origin.x, (_inputTableView.frame.origin.y - 156.0), _inputTableView.frame.size.width, _inputTableView.frame.size.height);
    [UIView commitAnimations];
    
}

- (void)EndEditingInput:(NSNotification *)notification{
    
    double newValue = 0;
    InputCell* cell = (InputCell*)[notification object];
    
    if( [self validateTextIsNumber:cell.inputTextField.text value:&newValue ] ){
        [cell.inputTextField setTextColor:[UIColor blackColor]];
        if( cell.label == @"sigma_x")
            _circleModel.sigmax = newValue;
        else if( cell.label == @"sigma_y")
            _circleModel.sigmay = newValue;
        else if( cell.label == @"tau_xy")
            _circleModel.tauxy = newValue;
        else if( cell.label == @"theta")
            _circleModel.theta = newValue*M_PI/180;
        [_circleModel CalculatePrinciplaAndRotatedStress];
        [_circleDrawing zoomToExtents];
        [_circleDrawing setNeedsDisplay];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAfterEditNotification" object:self];
    } else {
		[cell.inputTextField setTextColor:[UIColor redColor]];
    }

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    _inputTableView.frame = CGRectMake(_inputTableView.frame.origin.x, (_inputTableView.frame.origin.y + 156.0), _inputTableView.frame.size.width, _inputTableView.frame.size.height);
    [UIView commitAnimations];
    
}

#pragma mark UITableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if( section == 0 )
    {
        return 4;
    }
    return 0;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Input";
    return @"";
}
*/
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"InputCell";
    
    // Set up the cell...
    NSInteger section = [indexPath section];
    
    if( section == 0 )
    {
        InputCell *cell = (InputCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if(indexPath.row == 0){
            cell.inputTextField.text = [NSString stringWithFormat:@"%0.2f", self.circleModel.sigmax];
            cell.label = @"sigma_x";
            
            [cell.webView loadHTMLString:@"<div style='margin-top: -8px;font-size: 18px;'>&sigma;<sub>x</sub></div>" baseURL:nil];
            
        }
        else if(indexPath.row == 1){
            cell.inputTextField.text = [NSString stringWithFormat:@"%0.2f", _circleModel.sigmay];
            cell.label = @"sigma_y";
            [cell.webView loadHTMLString:@"<div style='margin-top: -8px;font-size: 18px;'>&sigma;<sub>y</sub></div>" baseURL:nil];
        }
        else if(indexPath.row == 2){
            cell.inputTextField.text = [NSString stringWithFormat:@"%0.2f", _circleModel.tauxy];
            cell.label = @"tau_xy";
            [cell.webView loadHTMLString:@"<div style='margin-top: -8px;font-size: 18px;'>&tau;<sub>xy</sub></div>" baseURL:nil];
        }
        else if(indexPath.row == 3){
            cell.inputTextField.text = [NSString stringWithFormat:@"%0.2f", _circleModel.theta*180/M_PI];
            cell.label = @"theta";
            [cell.webView loadHTMLString:@"<div style='margin-top: -8px;font-size: 18px;'>&theta;\'(&deg;)</div>" baseURL:nil];
        }
        
        return cell;
    }
    return nil;
}

- (BOOL)validateTextIsNumber:(NSString*)newText value:(double*)value {
    
	BOOL result = FALSE;
    
	if ( [newText isMatchedByRegex:@"^-{0,1}(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"] ) {
		result = TRUE;
		*value = [newText doubleValue];
	}
	return result;
}

@end
