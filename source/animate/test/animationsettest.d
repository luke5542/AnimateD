module animate.test.animationsettest;

import core.time;
import std.stdio;

import dunit;

import animate.d;


package class AnimationSetTest
{
    mixin UnitTest;

    int m_val1;
    int m_val2;

    static immutable MAX_V1 = 44;
    static immutable MAX_V2 = 256;

    Duration duration;

    ValueAnimation!(int) m_anim1;
    ValueAnimation!(int) m_anim2;

    AnimationSet animSet;

    this()
    {
        duration = seconds(2);
    }

    @Before
    void setupAnimationSet()
    {

        m_val1 = 0;
        m_val2 = 0;

        m_anim1 = new ValueAnimation!(int)(duration, &m_val1, 0, MAX_V1);
        m_anim2 = new ValueAnimation!(int)(duration, &m_val2, 0, MAX_V2);

        animSet = new AnimationSet(m_anim1, m_anim2);
    }

    @Test
    void testParallelAnimationSet()
    {
        animSet.setMode(AnimationSetMode.PARALLEL);

        foreach(i; 0..3)
        {
            animSet.update(msecs(500));
            assertTrue(animSet.isRunning());
            assertEquals(m_val1, (11*(i+1)) % MAX_V1);
            assertEquals(m_val2, (64*(i+1)) % MAX_V2);
        }

        animSet.update(msecs(500));
        assertEquals(m_val1, MAX_V1);
        assertEquals(m_val2, MAX_V2);
        assertFalse(m_anim1.isRunning());
        assertFalse(m_anim2.isRunning());
        assertFalse(animSet.isRunning());
    }

    @Test
    void testSequentialAnimationSet()
    {
        animSet.setMode(AnimationSetMode.SEQUENTIAL);

        foreach(i; 0..3)
        {
            animSet.update(msecs(500));
            assertTrue(animSet.isRunning());
            assertEquals(m_val1, (11*(i+1)) % MAX_V1);
        }

        animSet.update(msecs(500));
        assertEquals(m_val1, MAX_V1);
        assertEquals(m_val2, 0);
        assertFalse(m_anim1.isRunning());
        assertTrue(m_anim2.isRunning());

        foreach(i; 0..3)
        {
            animSet.update(msecs(500));
            assertTrue(animSet.isRunning());
            assertEquals(m_val2, (64*(i+1)) % MAX_V2);
        }

        animSet.update(msecs(500));
        assertEquals(m_val1, MAX_V1);
        assertEquals(m_val2, MAX_V2);
        assertFalse(m_anim1.isRunning());
        assertFalse(m_anim2.isRunning());
        assertFalse(animSet.isRunning());
    }
}
