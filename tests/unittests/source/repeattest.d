module unittests.repeattest;

import core.time;

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

		m_anim.update(seconds(1));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(msecs(500));
		assertEquals(m_val, 135);
		assertTrue(m_anim.isRunning());

		m_anim.update(msecs(500));
		assertEquals(m_val, 0);
		assertTrue(m_anim.isRunning());

		m_anim.update(seconds(1));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(seconds(1));
		assertEquals(m_val, 180);
		assertFalse(m_anim.isRunning());
	}

	@Test
	void testRepeatInfinite()
	{
		m_anim.repeatMode = RepeatMode.REPEAT;
		m_anim.repeatCount = INFINITE;

		m_anim.update(seconds(1));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(seconds(1));
		assertEquals(m_val, 0);
		assertTrue(m_anim.isRunning());

		m_anim.update(msecs(500));
		assertEquals(m_val, 45);
		assertTrue(m_anim.isRunning());

		m_anim.update(msecs(500));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(seconds(199));
		assertEquals(m_val, 0);
		assertTrue(m_anim.isRunning());
	}

	@Test
	void testReverseSingle()
	{
		m_anim.repeatMode = RepeatMode.REVERSE;
		m_anim.repeatCount = 1;

		m_anim.update(seconds(1));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(seconds(1));
		assertEquals(m_val, 180);
		assertTrue(m_anim.isRunning());

		m_anim.update(seconds(1));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(seconds(1));
		assertEquals(m_val, 0);
		assertFalse(m_anim.isRunning());
	}

	@Test
	void testReverseInfinite()
	{
		m_anim.repeatMode = RepeatMode.REVERSE;
		m_anim.repeatCount = INFINITE;

		m_anim.update(seconds(2));
		assertEquals(m_val, 180);
		assertTrue(m_anim.isRunning());

		m_anim.update(msecs(500));
		assertEquals(m_val, 135);
		assertTrue(m_anim.isRunning());

		m_anim.update(msecs(500));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(seconds(1));
		assertEquals(m_val, 0);
		assertTrue(m_anim.isRunning());

		m_anim.update(msecs(500));
		assertEquals(m_val, 45);
		assertTrue(m_anim.isRunning());

		m_anim.update(msecs(1500));
		assertEquals(m_val, 180);
		assertTrue(m_anim.isRunning());

		m_anim.update(msecs(500));
		assertEquals(m_val, 135);
		assertTrue(m_anim.isRunning());

		m_anim.update(msecs(1500));
		assertEquals(m_val, 0);
		assertTrue(m_anim.isRunning());

		m_anim.update(seconds(200));
		assertEquals(m_val, 0);
		assertTrue(m_anim.isRunning());
	}
}

/*class AnimationSetTest
{
	mixin UnitTest;

	Sprite sprite;
	Time duration;

	ScaleAnimation scaleAnim;
	TranslationAnimation translateAnim;

	AnimationSet animSet;

	this()
	{
		sprite = new Sprite();
		duration = seconds(2.0);
	}

	@Before
	void setupAnimationSet()
	{

		sprite.scale = Vector2f(0, 0);
		sprite.position = Vector2f(0, 0);

		scaleAnim = new ScaleAnimation(sprite, duration,
					sprite.scale, Vector2f(10, 10));

		translateAnim = new TranslationAnimation(sprite, duration,
						sprite.position, Vector2f(100, 100));

		animSet = new AnimationSet(scaleAnim, translateAnim);
	}

	@Test
	void testParallelAnimationSet()
	{
		animSet.setMode(AnimationSetMode.PARALLEL);

		animSet.update(msecs(500));
		assertEquals(sprite.scale, Vector2f(2.5, 2.5));
		assertEquals(sprite.position, Vector2f(25, 25));

		animSet.update(seconds(1));
		assertEquals(sprite.scale, Vector2f(7.5, 7.5));
		assertEquals(sprite.position, Vector2f(75, 75));

		animSet.update(msecs(500));
		assertEquals(sprite.scale, Vector2f(10, 10));
		assertEquals(sprite.position, Vector2f(100, 100));
		assertFalse(scaleAnim.isRunning());
		assertFalse(translateAnim.isRunning());
		assertFalse(animSet.isRunning());
	}

	@Test
	void testSequentialAnimationSet()
	{
		animSet.setMode(AnimationSetMode.SEQUENTIAL);

		animSet.update(msecs(500));
		assertEquals(sprite.scale, Vector2f(2.5, 2.5));

		animSet.update(seconds(1));
		assertEquals(sprite.scale, Vector2f(7.5, 7.5));

		animSet.update(msecs(500));
		assertEquals(sprite.scale, Vector2f(10, 10));
		assertFalse(scaleAnim.isRunning());

		//The translation animation should get run now...
		animSet.update(msecs(500));
		assertEquals(sprite.position, Vector2f(25, 25));

		animSet.update(seconds(1));
		assertEquals(sprite.position, Vector2f(75, 75));

		animSet.update(msecs(500));
		assertEquals(sprite.position, Vector2f(100, 100));

		assertFalse(translateAnim.isRunning());
		assertFalse(animSet.isRunning());
	}
}*/
