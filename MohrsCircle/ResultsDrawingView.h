//
//  ResultsDrawingView.h
//  MohrsCircle
//
//  Created by Jeff.Lutzenberger on 4/16/13.
//
//

#import <UIKit/UIKit.h>

#import "BaseDrawingView.h"
#import "MohrsCircleModel.h"
#import "GraphicsStressBlock.h"

@interface ResultsDrawingView : BaseDrawingView {

    GraphicsStressBlock* stressBlock;
    GraphicsStressBlock* initialStressBlock;
    GraphicsStressBlock* principalStressBlock;
    GraphicsStressBlock* rotatedStressBlock;
    GraphicsStressBlock* maxShearStressBlock;
}

@property (nonatomic) StressBlockType stressBlockType;
@property (nonatomic, assign) MohrsCircleModel* circleModel;


@end
