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
module animate.animate.animatable;

import core.time;

import animate.animate.animation;

interface Animatable
{
    void runAnimation(Updatable anim);
    void updateAnimations(Duration time);
    void update(Duration time);
}

mixin template NormalNode()
{
    import animate.animate.animation;

    private
    {
        Updatable[] m_animations;
    }

    /// Add the animation to the queue
    void runAnimation(Updatable anim)
    {
        m_animations ~= anim;
    }

    /// Update the currently running animations.
    void updateAnimations(Duration time)
    {
        int[] itemsToRemove;
        foreach(i, anim; m_animations)
        {
            if(anim.isRunning())
            {
                anim.update(time);
            }
            else
            {
                itemsToRemove ~= cast(int) i;
            }
        }

        foreach(index; itemsToRemove)
        {
            removeAtUnstable(m_animations, index);
        }

    }

    private static void removeAtUnstable(T)(ref T[] arr, size_t index)
    {
        if(index >= arr.length)
        {
            debug import std.stdio;
            debug stderr.writeln("YA DOOF, index(", index, ") >= arr.length(", arr.length, ")");
        }
        else
        {
            if(index != arr.length - 1)
            {
                arr[index] = arr[$-1];
            }
            arr = arr[0 .. $-1];

        }
    }

}
