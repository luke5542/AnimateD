module animate.animate.interpolator;

import std.math;

interface Interpolator
{
    /+
     + This takes a value from 0 to 1, and
     + returns an interpolated value from 0 to 1
     + based on the type of curve desired.
     +/
    double interpolate(double progress)
    in
    {
        assert(progress >= 0 && progress <= 1);
    }
    out
    {
        assert(progress >= 0 && progress <= 1);
    }
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
