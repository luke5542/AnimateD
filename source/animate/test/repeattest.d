module animate.test.repeattest;

import core.time;
import std.stdio;

import dunit;

import animate.d;

class RepeatTest
{
    mixin UnitTest;

    static immutable MAX_VAL = 180;
    int m_val;
    Duration m_dur;

    DelegateAnimation m_anim;

    this()
    {
        m_dur = seconds(2);
    }

    void updateFunction(double progress)
    {
        //Some simple function that uses the animation
        //progress to come up with some value...
        m_val = cast(int) (MAX_VAL * progress);
    }

    @Before
    void setupAnimation()
    {
        m_val = 0;
        m_anim = new DelegateAnimation(m_dur, &updateFunction);
    }

    @Test
    void testRepeatSingle()
    {
        m_anim.repeatMode = RepeatMode.REPEAT;
        m_anim.repeatCount = 1;

        foreach(i; 0..7)
        {
            m_anim.update(msecs(500));
            assertTrue(m_anim.isRunning());
            assertEquals(m_val, (45*(i+1)) % MAX_VAL);
        }

        m_anim.update(msecs(500));
        assertEquals(m_val, 180);
        assertFalse(m_anim.isRunning());
    }

    @Test
    void testRepeatInfinite()
    {
        m_anim.repeatMode = RepeatMode.REPEAT;
        m_anim.repeatCount = INFINITE;

        foreach(i; 0..200)
        {
            m_anim.update(msecs(500));
            assertTrue(m_anim.isRunning());
            assertEquals(m_val, (45*(i+1)) % MAX_VAL);
        }
    }

    @Test
    void testReverseSingle()
    {
        m_anim.repeatMode = RepeatMode.REVERSE;
        m_anim.repeatCount = 1;

        int compVal = m_val;
        int offset = -45;
        foreach(i; 0..7)
        {
            //Calculate the value that it should be at now
            if(compVal == 0 || compVal == 180)
            {
                offset *= -1;
            }
            compVal += offset;

            m_anim.update(msecs(500));
            assertTrue(m_anim.isRunning());
            assertEquals(m_val, compVal);
        }

        m_anim.update(msecs(500));
        assertEquals(m_val, 0);
        assertFalse(m_anim.isRunning());
    }

    @Test
    void testReverseInfinite()
    {
        m_anim.repeatMode = RepeatMode.REVERSE;
        m_anim.repeatCount = INFINITE;

        int compVal = m_val;
        int offset = -45;
        foreach(i; 0..200)
        {
            //Calculate the value that it should be at now
            if(compVal == 0 || compVal == 180)
            {
                offset *= -1;
            }
            compVal += offset;

            m_anim.update(msecs(500));
            assertTrue(m_anim.isRunning());
            assertEquals(m_val, compVal);
        }
    }
}
