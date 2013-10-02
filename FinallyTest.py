#!/usr/bin/python

"""
Illustrates how Python handles return variables when
a try-finally is used.

Output is:
test 1: inside try
test 2: inside finally, a=2
test 1: output is 1 
test 2: inside try
test 2: inside finally, a=2
test 2: output is 2 

"""
class FinallyTest:

    """
    Tests whether finally can modify the value
    being returned.
    """
    @staticmethod
    def test1():

        a=1

        try:

            print ("test 1: inside try" )

            return a

        finally:

            a += 1

            print ("test 1: inside finally, a=%s" % str(a) )

    """
    Demonstrates that finally overrides the
    value being returned.
    """
    @staticmethod
    def test2():

        a=1

        try:

            print "test 2: inside try"

            return a

        finally:

            a += 1

            print ("test 2: inside finally, a=%s" % str(a) )

            return a


print ("test 1: returned %s " % FinallyTest.test1() )

print ("test 2: returned %s " % FinallyTest.test2() )
