/**
 * Test's how javascript handles return statements
 * when a try-catch-finally is in play.
 *
 * Output is:
 * test 1: inside try
 * test 1: inside finally, a=2
 * test 1: return 1
 * test 2: inside try
 * test 2: inside finally, a=2
 * test 2: return 2
 *
 */
var FinallyTest = {

    /**
     * Tests whether finally can modify the value
     * set to be returned.
     */
    test1 : function(){

	var a = 1;

	try{

	    console.log("test 1: inside try");

	    return a;

	} finally {

	    a++;

	    console.log("test 1: inside finally, a="+ a );

	}

    },

    /**
     * Tests whether the return value of the class
     * can be overridden with a return in finally.
     */
    test2 : function(){

	var a = 1;

	try{

	    console.log("test 2: inside try");

	    return a;

	} finally {

	    a++;

	    console.log("test 2: inside finally, a="+ a );

	    return a;

	}


    }

}

console.log( "test 1: returned " + FinallyTest.test1() );

console.log( "test 2: returned " + FinallyTest.test2() );