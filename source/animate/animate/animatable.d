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
