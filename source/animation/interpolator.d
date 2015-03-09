module animate.animate.interpolator;

import std.math;

interface Interpolator
{
    double interpolate(double progress);
}

class LinearInterpolator : Interpolator
{
    double interpolate(double progress)
    {
        return progress;
    }
}

class CosineInterpolator : Interpolator
{
    double interpolate(double progress)
    {
        return cos(PI * 2 * progress);
    }
}

class SineInterpolator : Interpolator
{
    double interpolate(double progress)
    {
        return sin(PI * 2 * progress);
    }
}

class AccelerationInterpolator : Interpolator
{
    double interpolate(double progress)
    {
        return progress * progress;
    }
}

class DecelerationInterpolator : Interpolator
{
    double interpolate(double progress)
    {
        return 1.0 - (1.0 - progress)^^2;
    }
}

class AccelerationDecelerationInterpolator : Interpolator
{
    double interpolate(double progress)
    {
        return ((cos(progress + 1) * PI) / 2.0) + .5;
    }
}
