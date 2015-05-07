/*
AnimateD - An Animation framework for the D programming language.
Copyright (C) 2015 Devin Ridgway

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
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
