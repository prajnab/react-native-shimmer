#ifdef RCT_NEW_ARCH_ENABLED
#import "RNShimmer.h"
#import "RNShimmeringView.h"

#import <React/RCTLog.h>
#import <react/renderer/components/RNShimmerSpecs/ComponentDescriptors.h>
#import <react/renderer/components/RNShimmerSpecs/EventEmitters.h>
#import <react/renderer/components/RNShimmerSpecs/Props.h>
#import <react/renderer/components/RNShimmerSpecs/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface RNShimmer () <RCTRNShimmeringViewViewProtocol>
@end

@implementation RNShimmer {
  RNShimmeringView *_view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<RNShimmeringViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RNShimmeringViewProps>();
    _props = defaultProps;

    _view = [[RNShimmeringView alloc] init];

    // Set default props to start shimmering.
    _view.shimmering = defaultProps->animating;
    _view.shimmeringAnimationOpacity = CGFloat(defaultProps->animationOpacity);
    _view.shimmeringPauseDuration = CFTimeInterval(defaultProps->pauseDuration) / 1000;
    _view.shimmeringDirection = FBShimmerDirection(defaultProps->shimmeringDirection);
    _view.shimmeringOpacity = CGFloat(defaultProps->shimmeringOpacity);
    _view.shimmeringHighlightLength = CGFloat(defaultProps->highlightLength);
    _view.shimmeringBeginFadeDuration = CFTimeInterval(defaultProps->beginFadeDuration) / 1000;
    _view.shimmeringEndFadeDuration = CFTimeInterval(defaultProps->endFadeDuration) / 1000;
    [_view setShimmeringDuration:defaultProps->duration/1000]; // set this at the end so that all the dependent props are already set

    // If a child component is not passed
    [self setDefaultSubview];

    self.contentView = _view;
  }

  return self;
}

- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index
{
  if (index > 0) {
    RCTLogError(@"Shimmer may only contain a single subview");
  } else {
    [super mountChildComponentView:childComponentView index:index];

    _view.contentView = [self.subviews objectAtIndex:index];
  }
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<RNShimmeringViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<RNShimmeringViewProps const>(props);

   if (oldViewProps.animating != newViewProps.animating) {
    _view.shimmering = newViewProps.animating;
  }

  if (oldViewProps.animationOpacity != newViewProps.animationOpacity) {
    _view.shimmeringAnimationOpacity = CGFloat(newViewProps.animationOpacity);
  }

  if (oldViewProps.pauseDuration != newViewProps.pauseDuration) {
    _view.shimmeringPauseDuration = CFTimeInterval(newViewProps.pauseDuration) / 1000;
  }

  if (oldViewProps.shimmeringDirection != newViewProps.shimmeringDirection) {
    _view.shimmeringDirection = FBShimmerDirection(newViewProps.shimmeringDirection);
  }

  if (oldViewProps.shimmeringOpacity != newViewProps.shimmeringOpacity) {
    _view.shimmeringOpacity = CGFloat(newViewProps.shimmeringOpacity);
  }

  if (oldViewProps.highlightLength != newViewProps.highlightLength) {
    _view.shimmeringHighlightLength = CGFloat(newViewProps.highlightLength);
  }

  if (oldViewProps.beginFadeDuration != newViewProps.beginFadeDuration) {
    _view.shimmeringBeginFadeDuration = CFTimeInterval(newViewProps.beginFadeDuration) / 1000;
  }

  if (oldViewProps.endFadeDuration != newViewProps.endFadeDuration) {
    _view.shimmeringEndFadeDuration = CFTimeInterval(newViewProps.endFadeDuration) / 1000;
  }

  if (oldViewProps.duration != newViewProps.duration) {
    [_view setShimmeringDuration:newViewProps.duration/1000]; // update this at the end
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)setDefaultSubview
{
  UIView *emptyBGView = [[UIView alloc] initWithFrame:_view.bounds];
  emptyBGView.backgroundColor = self.backgroundColor;
  UIView *maskView = [[UIView alloc] initWithFrame:_view.bounds];
  maskView.backgroundColor = [UIColor whiteColor];
  maskView.alpha = 0.5;
  [emptyBGView addSubview:maskView];
  [emptyBGView bringSubviewToFront:maskView];
  _view.contentView = maskView;
}

@end

Class<RCTComponentViewProtocol> RNShimmeringViewCls(void)
{
  return RNShimmer.class;
}
#endif