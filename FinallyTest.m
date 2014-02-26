/**
 * Tests how Objective-C handles return statements
 * when a try-finally is used.
 *
 * To execute, run:
 * $ llvm-gcc -framework Foundation -o FinallyTest FinallyTest.m && ./FinallyTest
 * 
 * The output of this is:
 * test 1: Inside try
 * test 1: Inside finally, a=2
 * test 1: returned 1
 * test 2: Inside try
 * test 2: Inside finally, a=2
 * test 2: returned 2
 * test 3: Inside try, return 1 + 0
 * test 3: Inside finally, a=2
 * test 3: returned 1
 *
 */

#import <Foundation/Foundation.h>

// "Because NSLog is too mainstream"
void printline(NSString *string){

	printf("%s", [[string stringByAppendingString:@"\n"] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
	
}


/**
 * Tests whether finally can modify the value
 * set to be returned by altering the associated variable.
 */
int test1(){
	
	int a	= 1;

	@try {

		printline(@"test 1: Inside try");

		return a;

	} @finally {
		
		a++;

		printline([NSString stringWithFormat:@"test 1: Inside finally, a=%i", a]);
		
	}
	
}

/**
 * Demonstrates that finally overrides the
 * return value, as expected.
 */
int test2(){
	
	int a	= 1;

	@try {
		
		printline(@"test 2: Inside try");

		return a;

	} @finally {

		a++;

		printline([NSString stringWithFormat:@"test 2: Inside finally, a=%i", a]);

		return a;

	}
	
}

/**
 * Demonstrates that Objective-C evaluates the return statement before
 * the finally statement.
 */
int test3(){

	int a	= 1;

	@try {
		printline([NSString stringWithFormat:@"test 3: Inside try, return %i + 0", a]);

		return a + 0;

	} @finally {

		a = 2;

		printline([NSString stringWithFormat:@"test 3: Inside finally, a=%i", a]);

	}
	
	
}



int main(int argc, char **argv){
	
	printline([NSString stringWithFormat:@"test 1: returned %i", test1()]);
	
	printline([NSString stringWithFormat:@"test 2: returned %i", test2()]);
	
	printline([NSString stringWithFormat:@"test 3: returned %i", test3()]);
	
	return 0;
	
}
