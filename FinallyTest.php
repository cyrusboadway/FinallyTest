<?php
/**
 * Test's how PHP handles return statements
 * when a try-finally is used.
 *
 * The output of this is:
 * test 1: Inside try
 * test 1: Inside finally, a=2
 * test 1 returned: 1
 * test 2: Inside try
 * test 2: Inside finally, a=2
 * Test 2 returned: 2
 * test 3: Inside try, return 1 + 0
 * test 3: Inside finally, a=2
 * test 3: returned 1
 * 
 */
class FinallyTest{

	/**
	 * Tests whether finally can modify the value
	 * set to be returned by altering the associated variable.
	 */
	public static function test1(){

		$a = 1;

		try{

			print("test 1: Inside try\n");

			return $a;

		} finally {

			$a++;

			print("test 1: Inside finally, a=$a\n");

		}

	}

	/**
	 * Demonstrates that finally overrides the
	 * return value, as expected.
	 */
	public static function test2(){

		$a = 1;

		try{
			print("test 2: Inside try\n");

			return $a;

		} finally {

			$a++;

			print("test 2: Inside finally, a=$a\n");

			return $a;

		}

	}

	/**
	 * Demonstrates that PHP evaluates the return statement before
	 * the finally statement.
	 */
	public static function test3(){

		$a = 1;

		try{
			print("test 3: Inside try, return $a + 0\n");

			return $a + 0;

		} finally {

			$a = 2;

			print("test 3: Inside finally, a=$a\n");

		}

	}

}


print("test 1: returned ".FinallyTest::test1()."\n" );

print("test 2: returned ".FinallyTest::test2()."\n" );

print("test 3: returned ".FinallyTest::test3()."\n" );

