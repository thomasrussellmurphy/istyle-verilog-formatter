# iStyle Makefile for GCC compiler on Linux or compatible OS
# For Windows, the mingw32 version of GCC 4.x is used

# cmd :   mingw32-make

CPPFLAGS = -Wall  -Wno-sign-compare -fno-rtti -fno-exceptions
LDFLAGS = -s

OBJS = ASResource.o  ASStreamIterator.o ASBeautifier.o ASFormatter.o  astyle_main.o

all: clean astyle

astyle: $(OBJS)
	g++ $(LDFLAGS) -o iStyle  $(OBJS)

.cpp.o:
	g++ $(CPPFLAGS) -c $<

clean:
	rm -f *.o
