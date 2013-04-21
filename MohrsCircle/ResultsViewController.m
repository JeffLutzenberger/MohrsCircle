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

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)EndEditingInput:(NSNotification *)notification{
    
    [_resultsDrawing setNeedsDisplay];
    
}


@end
