module animate.animate.animation;

import std.stdio;
import std.traits;
import core.time;

import animate.animate.interpolator;

immutable int INFINITE = -1;

enum RepeatMode
{
    REPEAT,
    REVERSE
}

enum AnimationSetMode
{
    PARALLEL,
    SEQUENTIAL
}

interface Animatable
{
    protected void updateProgress(double progress);
    public void update(Duration deltaTime);
    public bool isRunning();
}

class Animation : Animatable
{
    private
    {
        alias AnimListenerFunc = void delegate();

        Duration m_duration;
        Duration m_progress;
        bool m_isRunning;

        Interpolator m_interpolator;

        RepeatMode m_repeatMode;
        int m_repeatCount;
        int m_currentRunCount;

        bool m_isReverse;

        AnimListenerFunc[] m_animEndListeners;
        AnimListenerFunc[] m_animRepeatListeners;
    }

    this(Duration duration)
    {
        m_duration = duration;
        m_interpolator = new LinearInterpolator();
        m_isRunning = true;

        m_repeatMode = RepeatMode.REPEAT;
        m_isReverse = false;
    }

    /// This is called with the value (0.0 -> 1.0) of the
    /// amount that this animation has completed by.
    protected abstract void updateProgress(double progress);

    /// This takes the delta time since the last update call as the input.
    final void update(Duration deltaTime)
    {
        if(m_isRunning)
        {
            m_progress += deltaTime;
            double progress = cast(double)(m_progress.total!"usecs") / m_duration.total!"usecs";

            if(progress >= 1.0)
            {
                if(m_repeatCount != 0)
                {
                    while(progress >= 1.0)
                    {
                        progress -= 1.0;
                        ++m_currentRunCount;
                    }

                    //Check that we are still in a valid animation frame...
                    if(m_repeatCount > 0 && m_repeatCount < m_currentRunCount)
                    {
                        //We have run out of animation frames, so just leave this at the end animation...
                        final switch(m_repeatMode)
                        {
                            case RepeatMode.REPEAT:
                                progress = 1.0;
                                break;
                            case RepeatMode.REVERSE:
                                m_isReverse = m_repeatCount % 2 == 0;
                                m_progress = usecs(m_duration.total!"usecs");
                                break;
                        }
                        m_isRunning = false;
                        sendOnAnimationEnd();
                    }
                    else
                    {
                        //We ARE in a valid animation frame, so update the status accordingly
                        final switch(m_repeatMode)
                        {
                            case RepeatMode.REPEAT:
                                m_progress = usecs(m_progress.total!"usecs" % m_duration.total!"usecs");
                                break;
                            case RepeatMode.REVERSE:
                                m_isReverse = m_currentRunCount % 2 == 1;
                                m_progress = msecs(m_progress.total!"usecs" % m_duration.total!"usecs");
                                progress = cast(double)(m_progress.total!"usecs") / m_duration.total!"usecs";
                                break;
                        }

                        sendOnAnimationRepeat();
                    }
                }
                else
                {
                    progress = 1.0;
                    m_isRunning = false;
                    sendOnAnimationEnd();
                }
            }

            progress = m_isReverse ? 1.0 - progress : progress;

            // interpolate the current progress value
            progress = m_interpolator.interpolate(progress);

            // send the progress update call to this animation
            updateProgress(progress);
        }
    }

    void addOnAnimationEndListener(AnimListenerFunc listener)
    {
        m_listeners ~= m_animEndListeners;
    }

    private void sendOnAnimationEnd()
    {
        foreach(listener; m_animEndListeners)
        {
            listener();
        }
    }

    void addOnAnimationRepeatListener(AnimListenerFunc listener)
    {
        m_listeners ~= m_animRepeatListeners;
    }

    private void sendOnAnimationRepeat()
    {
        foreach(listener; m_animRepeatListeners)
        {
            listener();
        }
    }

    void setInterpolator(Interpolator interpolator)
    {
        if(interpolator)
        {
            m_interpolator = interpolator;
        }
        else if(!m_interpolator)
        {
            m_interpolator = new LinearInterpolator();
        }
    }

    final bool isRunning()
    {
        return m_isRunning;
    }

    /// This determines the style of our animation repeat
    @property
    {
        RepeatMode repeatMode(RepeatMode mode)
        {
            m_repeatMode = mode;
            return m_repeatMode;
        }

        RepeatMode repeatMode()
        {
            return m_repeatMode;
        }
    }

    /// If the repeat count is negative, then we repeat infinitely.
    /// Otherwise, we run the animation repeatCount number of times.
    @property
    {
        int repeatCount(int count)
        {
            m_repeatCount = count;
            return m_repeatCount;
        }

        int repeatCount()
        {
            return m_repeatCount;
        }
    }
}

class ValueAnimation(T) : Animation
if(isNumeric!T)
{
    private
    {
        T m_startVal;
        T m_difference;
        T* m_target;
    }

    this(Duration duration, T* target, T start, T end)
    {
        super(duration);
        m_target = target;
        m_startVal = start;
        m_difference = end - start;
    }

    override protected void updateProgress(double progress)
    {
        *m_target = cast(T) (m_startVal + (m_difference * progress));
    }

}

class DelegateAnimation : Animation
{
    private
    {
        void delegate(double) m_update;
    }

    this(Duration duration, void delegate(double) update)
    {
        super(duration);
        m_update = update;
    }

    override protected void updateProgress(double progress)
    {
        m_update(progress);
    }

}

///For now, all this class does is run a bunch of animations simultaneously.
class AnimationSet : Animatable
{
    private
    {
        Animation[] m_anims;
        int m_currentAnim;

        AnimationSetMode m_mode;
        bool m_isRunning;
    }

    this(Animation[] anims...)
    {
        m_anims = anims.dup;
        m_mode = AnimationSetMode.PARALLEL;
        m_isRunning = true;
    }

    void setMode(AnimationSetMode mode)
    {
        m_mode = mode;
    }

    //Does nothing because this doesn't need it...
    final void updateProgress(double progress) {};

    final void update(Duration deltaT)
    {
        if(m_isRunning)
        {
            final switch(m_mode)
            {
                case AnimationSetMode.PARALLEL:
                    m_isRunning = false;
                    foreach(anim; m_anims)
                    {
                        anim.update(deltaT);
                        m_isRunning = anim.isRunning() || m_isRunning;
                    }
                    break;
                case AnimationSetMode.SEQUENTIAL:
                    m_anims[m_currentAnim].update(deltaT);
                    if(!m_anims[m_currentAnim].isRunning())
                    {
                        m_currentAnim++;
                        m_isRunning = m_currentAnim < m_anims.length;
                    }
                    break;
            }
        }
    }

    final bool isRunning()
    {
        return m_isRunning;
    }
}
