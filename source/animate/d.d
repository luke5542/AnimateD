module animate.d;

public import animate.animate.animation;
public import animate.animate.animatable;


unittest
{
    import dunit;

    import animate.test.animationsettest;

    string[] args = ["", "-v"];
    dunit_main(args);
}
