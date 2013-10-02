Try-Finally Variable Access
===========================

The goal of these tests is to explore how different languages (and their runtime environments) handle return statements in try-finally blocks, and specifically what level of access the finally has to a value being returned by the finally. If in a given method, a variable's scope extends to both blocks of a try-finally (i.e. the variable is initialized immediately before the try-finally block in the method), and the finally block modifies the variable which the try intends to return, will the method return the value the try intended to return, or the value of the variable after the finally block modifies it?

My expectation is that any changes by the finally block to the value of the variable the try block is returning should not affect the value the try block intends to return. If the specification of the API is that the finally block is performed when the _execution_ of the finally block has been completed (as is the case in the [Java 7 API](http://docs.oracle.com/javase/specs/jls/se7/html/jls-14.html#jls-14.20.2)) then I would suggest that includes the variable's value-access operation of the return statement. That being said, I find the behaviour still sufficiently ill-defined by the specifications to merit some tests.

__tl;dr Java, Javascript, and Python operate as expected, while PHP does not.__

Implementation and Testing
--------------------------

I've written code to explore the behaviour for the following languages, tested on a 64bit linux 3.8 operating system:

- __Java__: test in two runtime environments
	- Java Version 1.6.0_22 from Sun Microsystems Inc
	- Java Version 1.7.0_25 from OpenJDK (IcedTea 2.3.10)
- __Javascript__: version 1.8.5 in two engines
	- V8 Javascript Engine 3.20.12 (in Google Chrome)
	- SpiderMonkey Javascript Engine 17 (in Firefox)
- __Python__: version 2.7.4
- __PHP__: version 5.5.3 (support for finally introduced in version 5.5)
 
I've written two test methods, with the following procedures:

- __"test 1"__:
	1. create a variable and assign to it the value 1.
	2. enter a ```try``` block and return the variable.
	3. in an attached ```finally``` block, increment the value of the variable.
	4. test whether the method has return the original value (1), or the modified value (2).
- __"test 2"__: the behaviour of this case is, at least for the Java 7 specification, well defined by the specification. I've included it as a point of comparison.
	1. create a variable and assign to it the value 1.
	2. enter a ```try``` block and return the variable.
	3. in an attached ```finally``` block, increment and return the value of the variable.
	4. test whether the method has returned the value from the ```try``` or from the ```finally```.


I would also like to note that the code in these test cases are, in my opion, poor coding practices. Modification of values to be returned, as in test 1, or flow control from a finally block, as in test 2, are not good programming practices. I've written this code to explore the implementations.

Results
-------

Java, Javascript, and Python each return the value computed in the try block and modifications to the variable which contained the value have no effect. As previously stated, I think this is consistent with the try-finally block's stated purpose: to complete excution of the try block, including the variable's value access in the return call, before the finally block is evaluated.

PHP 5.5, however, operates differently. If a method returns a variable, the value returned can be changed by altering the variable's value in a finally block. This might suggest that a ```return``` statement, not being a method call but a language construct, isn't considered by the implementors of PHP, as part of the execution phase of a try block. Alternately (and perhaps more likely), it is an artifact of an implementation that tries to skip the memory assignment that would be necessary to store the return statement's return value while allowing the variable to be modified independently and without affecting the returned value, in the finally block.

This seems to be supported by the following test, which illustrates what is ultimately inconsistent behaviour if thought of in terms of "when the return statement's value is evaluated":

- __"test 3"__:
	1. create a variable and assign to it the value 1.
	2. enter a ```try``` block and return the variable + 0 (i.e. ```return $variable + 0;```).
	3. in an attached ```finally``` block, increment the value of the variable.
	4. test whether the method has returned the original value (1) or the modified value (2).

In this test, PHP returns the original value of the variable plus zero (1 + 0), not the modified value of the variable plus zero (2 + 0). This would suggest that the language considers the evaluation of the return value to happen before the finally block is executed, and modifications to the variables after the return statement is evaluated _shouldn't_ in fact have an affect on the function's return value. The outcome demonstrated in test 1 of 'exposing' the return value in the finally block is likely an artifact of an attempt to save an additional memory assignment.

Conclusion
----------

Java, Javascript, and Python operate in accordance with my expectations that the evaluation of the value being returned is part of the execution of a ```try``` block, and since a ```finally``` statement's execution begins only after execution (successful or otherwise) of the try block completes, any changes it makes to the variables used to calculate the try's return value have no effect on the method's return.


Future Work
-----------

Headings like this one are really starting to feel like an undergrad paper. But if this were an undergrad paper, I'd probably have to look at source code. In any case...

As well, I'd like to test other languages which support try-finally, including C# and Objective-C.

I would like to look at how Java, Javascript, and Python manage memory on a return statement inside of a try. To keep the return value independent from the variables evaluated in the return statement, each would have to allocate additional memory.

I would also like to look at how each of these languages would operate when the returned variable references an object, rather than a primitive. My intuition suggests that while primitive integers operated as expected, a returned Javascript object might be alterable from a finally block (is the finally a part of an object's execution context?). If not, then there are memory penalties as the object must be duplicated for the return context as well as the finally context (a strange outcome); with a sufficiently large object this could be expensive and there are interesting opportunities for optimization, only duplicating if the object is accessed.
