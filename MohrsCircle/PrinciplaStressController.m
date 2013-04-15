//
//  PrinciplaStressController.m
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/8/13.
//
//

#import "PrinciplaStressController.h"
#import "MohrsCircleAppDelegate.h"
#import "InputCell.h"
#import "RegexKitLite.h"

@implementation PrinciplaStressController

@synthesize inputTableView = _inputTableView;
@synthesize circleModel = _circleModel;
@synthesize circleDrawing = _circleDrawing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
        if( cell.label == @"sigma_1")
            _circleModel.sigma1 = newValue;
        else if( cell.label == @"sigma_2")
            _circleModel.sigma2 = newValue;
        else if( cell.label == @"theta_p")
            _circleModel.theta_p = newValue*M_PI/180;
        else if( cell.label == @"theta")
            _circleModel.theta = newValue*M_PI/180;
        [_circleModel CalculateRotatedStressFromPrincipalStressAndThetaP];
        [_circleDrawing zoomToExtents];
        [_circleDrawing setNeedsDisplay];
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
            cell.inputTextField.text = [NSString stringWithFormat:@"%0.2f", _circleModel.sigma1];
            cell.label = @"sigma_1";
            [cell.webView loadHTMLString:@"<div style='margin-top: -8px;font-size: 18px;'>&sigma;<sub>1</sub></div>" baseURL:nil];
        }
        else if(indexPath.row == 1){
            cell.inputTextField.text = [NSString stringWithFormat:@"%0.2f", _circleModel.sigma2];
            cell.label = @"sigma_2";
            [cell.webView loadHTMLString:@"<div style='margin-top: -8px;font-size: 18px;'>&sigma;<sub>2</sub></div>" baseURL:nil];
        }
        else if(indexPath.row == 2){
            cell.inputTextField.text = [NSString stringWithFormat:@"%0.2f", _circleModel.theta_p*180/M_PI];
            cell.label = @"theta_p";
            [cell.webView loadHTMLString:@"<div style='margin-top: -8px;font-size: 18px;'>&theta;<sub>p</sub>(&deg;)</div>" baseURL:nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    /*NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
     NSArray *array = [dictionary objectForKey:@"Countries"];
     NSString *selectedCountry = [array objectAtIndex:indexPath.row];
     
     //Initialize the detail view controller and display it.
     DetailViewController *dvController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:[NSBundle mainBundle]];
     dvController.selectedCountry = selectedCountry;
     [self.navigationController pushViewController:dvController animated:YES];
     [dvController release];
     dvController = nil;
     
     
     // open a alert with an OK and cancel button
     NSString *alertString = [NSString stringWithFormat:@"Clicked on row #%d", [indexPath row]];
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
     [alert show];
     [alert release];*/
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
