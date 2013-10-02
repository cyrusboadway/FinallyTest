/**
 * Test's how Java handles return statements
 * when a try-catch-finally is in play.
 * 
 * The output of this is:
 * test 1: Inside try
 * test 1: Inside finally, a=2
 * test 1 returned: 1
 * test 2: Inside try
 * test 2: Inside finally, a=2
 * Test 2 returned: 2
 * Return statements: http://docs.oracle.com/javase/specs/jls/se7/html/jls-14.html#jls-14.17
 * Try-finally statements: http://docs.oracle.com/javase/specs/jls/se7/html/jls-14.html#jls-14.20.2
 *
 */
public class FinallyTest{

	/**
	 * Tests whether finally can modify the value
	 * set to be returned.
	 */
	public static int test1(){

		int a = 1;

		try{

			System.out.println("test 1: Inside try");

			return a;

		} finally {

			a++;

			System.out.println("test 1: Inside finally, a=" + a);

		}

	}

	/**
	 * Demonstrates that finally still overrides the
	 * return value.
	 */
	public static int test2(){

		int a = 1;

		try{
			System.out.println("test 2: Inside try");

			return a;

		} finally {

			 a++;

			 System.out.println("test 2: Inside finally, a=" + a);

			 return a;

		}

	}


	public static void main(String[] args){

		System.out.println("test 1: returned " + test.test1() );

		System.out.println("test 2: returned " + test.test2() );

	}

}
