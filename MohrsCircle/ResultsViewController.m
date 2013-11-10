//
//  ResultsViewController.m
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/15/13.
//
//

#import "ResultsViewController.h"
#import "MohrsCircleAppDelegate.h"
#import "RegexKitLite.h"

#import "ResultCell.h"
#import "InputCell.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

@synthesize resultTableView = _resultTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.resultTableView reloadData];
    
    //[self.circleDrawing zoomToExtents];
    
    //[self.circleDrawing setNeedsDisplay];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MohrsCircleAppDelegate* app = (MohrsCircleAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _circleModel = app.circleModel;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BeginEditingInput:) name:@"BeginEditingInput" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EndEditingInput:) name:@"EndEditingInput" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [super dealloc];
}



- (void)EndEditingInput:(NSNotification *)notification{
    
    [_resultsDrawing setNeedsDisplay];
    
}

#pragma mark UITableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if( indexPath.row == 2)
        return 130;
    else
        return 110;
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
    
    static NSString *CellIdentifier = @"Cell";
    
    NSInteger section = [indexPath section];
    
    if( section == 0 )
    {
        
        ResultCell *cell = (ResultCell*)[tableView
                                         dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            //cell = [[ResultCell alloc]
            //        initWithStyle:UITableViewCellStyleDefault
            //        reuseIdentifier:CellIdentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ResultCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        [cell.title setText:@""];
        
        if (indexPath.row == 0) {
            cell.resultDrawing.stressBlockType = InitialStress;
            [cell.title setText:@"Initial Stress"];
            NSString* str = @"<div style='margin-top: -8px; font-size: 16px; font-family: Helvetica, Arial, sans-serif; color: #555;'>";
            str = [str stringByAppendingFormat:
                   @"<div>&sigma;<sub>x</sub> = %0.2f</div>", _circleModel.sigmax];
            str = [str stringByAppendingFormat:
                   @"<div>&sigma;<sub>y</sub> = %0.2f</div>", _circleModel.sigmay];
            str = [str stringByAppendingFormat:
                   @"<div>&tau;<sub>xy</sub> = %0.2f</div></div>", _circleModel.tauxy];
            [cell.webView loadHTMLString:str baseURL:nil];
        }
        else if (indexPath.row == 1) {
            cell.resultDrawing.stressBlockType = PrincipalStress;
            [cell.title setText:@"Principal Stress"];
            NSString* str = @"<div style='margin-top: -8px; font-size: 16px; font-family: Helvetica, Arial, sans-serif; color: #555;'>";
            str = [str stringByAppendingFormat:
                   @"<div>&sigma;<sub>1</sub> = %0.2f</div>", _circleModel.sigma1];
            str = [str stringByAppendingFormat:
                   @"<div>&sigma;<sub>2</sub> = %0.2f</div>", _circleModel.sigma2];
            str = [str stringByAppendingFormat:
                   @"<div>&theta;<sub>p</sub> = %0.2f&deg;</div></div>", _circleModel.theta_p*180/M_PI];
            [cell.webView loadHTMLString:str baseURL:nil];
        }
        else if (indexPath.row == 2) {
            cell.resultDrawing.stressBlockType = RotatedStress;
            NSString* titleStr = @"Rotated Stress";
            [cell.title setText:titleStr];
            NSString* str = @"<div style='margin-top: -8px; font-size: 16px; font-family: Helvetica, Arial, sans-serif; color: #555;'>";
            str = [str stringByAppendingFormat:
                   @"<div>&theta; = %0.2f&deg;</div>", _circleModel.theta*180/M_PI];
            str = [str stringByAppendingFormat:
                   @"<div>&sigma;<sub>x</sub> = %0.2f</div>", _circleModel.sigmax_theta];
            str = [str stringByAppendingFormat:
                   @"<div>&sigma;<sub>y</sub> = %0.2f</div>", _circleModel.sigmay_theta];
            str = [str stringByAppendingFormat:
                   @"<div>&tau;<sub>xy</sub> = %0.2f</div></div>", _circleModel.tauxy_theta];
            [cell.webView loadHTMLString:str baseURL:nil];
        }
        else if (indexPath.row == 3) {
            cell.resultDrawing.stressBlockType = MaxShearStress;
            [cell.title setText:@"Max Shear"];
            NSString* str = @"<div style='margin-top: -8px; font-size: 16px; font-family: Helvetica, Arial, sans-serif; color: #555;'>";
            str = [str stringByAppendingFormat:
                   @"<div>&sigma;<sub>avg</sub> = %0.2f</div>", _circleModel.SigmaAvg];
            str = [str stringByAppendingFormat:
                   @"<div>&tau;<sub>max</sub> = %0.2f</div>", _circleModel.tau_max];
            str = [str stringByAppendingFormat:
                   @"<div>&theta;<sub>s</sub> = %0.2f&deg;</div></div>", _circleModel.theta_tau_max*180/M_PI];
            [cell.webView loadHTMLString:str baseURL:nil];
        }
        return cell;
    }
    return nil;
}

@end
