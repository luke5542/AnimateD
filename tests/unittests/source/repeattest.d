module unittests.repeattest;

import core.time;

import dunit;

import animate.d;

class RepeatTest
{
	mixin UnitTest;

    immutable MAX_VAL = 180;
	int m_val;
	Duration m_dur;

	DelegateAnimation m_anim;

	this()
	{
		duration = secs(2);
	}

    void updateFunction(double progress)
    {
        //Some simple function that uses the animation
        //progress to come up with some value...
        m_val = MAX_VAL * progress;
    }

	@Before
	void setupAnimation()
	{
		m_val = 0;
		m_anim = new DelegateAnimation(duration, &updateFunction);
	}

	@Test
	void testRepeatSingle()
	{
		m_anim.repeatMode = RepeatMode.REPEAT;
		m_anim.repeatCount = 1;

		m_anim.update(secs(1.0));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(.5));
		assertEquals(m_val, 135);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(.5));
		assertEquals(m_val, 0);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(1.0));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(1.0));
		assertEquals(m_val, 180);
		assertFalse(m_anim.isRunning());
	}

	@Test
	void testRepeatInfinite()
	{
		m_anim.repeatMode = RepeatMode.REPEAT;
		m_anim.repeatCount = INFINITE;

		m_anim.update(secs(1.0));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(1.0));
		assertEquals(m_val, 0);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(.5));
		assertEquals(m_val, 45);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(.5));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(199.0));
		assertEquals(m_val, 0);
		assertTrue(m_anim.isRunning());
	}

	@Test
	void testReverseSingle()
	{
		m_anim.repeatMode = RepeatMode.REVERSE;
		m_anim.repeatCount = 1;

		m_anim.update(secs(1.0));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(1.0));
		assertEquals(m_val, 180);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(1.0));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(1.0));
		assertEquals(m_val, 0);
		assertFalse(m_anim.isRunning());
	}

	@Test
	void testReverseInfinite()
	{
		m_anim.repeatMode = RepeatMode.REVERSE;
		m_anim.repeatCount = INFINITE;

		m_anim.update(secs(2));
		assertEquals(m_val, 180);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(0.5));
		assertEquals(m_val, 135);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(0.5));
		assertEquals(m_val, 90);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(1.0));
		assertEquals(m_val, 0);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(.5));
		assertEquals(m_val, 45);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(1.5));
		assertEquals(m_val, 180);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(.5));
		assertEquals(m_val, 135);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(1.5));
		assertEquals(m_val, 0);
		assertTrue(m_anim.isRunning());

		m_anim.update(secs(200.0));
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
		duration = secs(2.0);
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

		animSet.update(secs(.5));
		assertEquals(sprite.scale, Vector2f(2.5, 2.5));
		assertEquals(sprite.position, Vector2f(25, 25));

		animSet.update(secs(1));
		assertEquals(sprite.scale, Vector2f(7.5, 7.5));
		assertEquals(sprite.position, Vector2f(75, 75));

		animSet.update(secs(.5));
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

		animSet.update(secs(.5));
		assertEquals(sprite.scale, Vector2f(2.5, 2.5));

		animSet.update(secs(1));
		assertEquals(sprite.scale, Vector2f(7.5, 7.5));

		animSet.update(secs(.5));
		assertEquals(sprite.scale, Vector2f(10, 10));
		assertFalse(scaleAnim.isRunning());

		//The translation animation should get run now...
		animSet.update(secs(.5));
		assertEquals(sprite.position, Vector2f(25, 25));

		animSet.update(secs(1));
		assertEquals(sprite.position, Vector2f(75, 75));

		animSet.update(secs(.5));
		assertEquals(sprite.position, Vector2f(100, 100));

		assertFalse(translateAnim.isRunning());
		assertFalse(animSet.isRunning());
	}
}*/
