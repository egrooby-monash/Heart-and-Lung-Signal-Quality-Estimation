# file: Makefile		G. Moody	1 November 2004

# 'make' or 'make sampen': compile the program in the current directory
sampen:		sampen.c
	$(CC) $(CFLAGS) -o sampen sampen.c -lm

test.txt:
	ann2rr -r nsrdb/16265 -a atr >test.txt

testfiles:	test.txt
	head -100 <test.txt >test.100
	head -1000 <test.txt >test.1000
	head -10000 <test.txt >test.10000
	head -100000 <test.txt >test.100000

# 'make check': check that the program works properly
check:		sampen testfiles
	./sampen -m 5 -n -r .2 -v sampentest.txt >sampen.out
	@if diff sampen.out expected.out; \
	 then echo Test 1 passed ; else echo Test 1 failed ; fi
	./sampen test.100 >sampen.100
	@if diff sampen.100 expected.100; \
	 then echo Test 2 passed ; else echo Test 2 failed ; fi
	./sampen test.1000 >sampen.1000
	@if diff sampen.1000 expected.1000; \
	 then echo Test 3 passed ; else echo Test 3 failed ; fi
	./sampen test.10000 >sampen.10000
	@if diff sampen.10000 expected.10000; \
	 then echo Test 4 passed ; else echo Test 4 failed ; fi
	./sampen -v -n test.10000 >sampen.10000vn
	@if diff sampen.10000vn expected.10000vn; \
	 then echo Test 5 passed ; else echo Test 5 failed ; fi
	@echo "Test 6 may require several minutes -- please be patient!"
	./sampen -m 10 test.100000 >sampen.100000
	@if diff sampen.100000 expected.100000; \
	 then echo Test 6 passed ; else echo Test 6 failed ; fi

clean:
	rm -f sampen sampen.out sampen.1* test.1* *~ 
