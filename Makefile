#
# CSE30 Makefile
#
# we declare the object we want to build in the variable EXE
# we list the objects we want to compile (from c) in OBJS
#
# we provide a phony target clean to rm all the .o files
#

EXE = life
OBJS = doRow.o
LIBS = -lplot -lcse30liferv -lcse30life
CFLAGS := -O0 -g --std=gnu99 -L/home/linux/ieng6/cs30wi20/public/local/arm/lib

.PHONY: clean

$(EXE): $(OBJS)
	gcc -Wall -Wextra -o $@ $(CFLAGS) $(OBJS) $(LIBS)

no_warnings: $(OBJS)
	gcc -o $(EXE) $(CFLAGS) $(OBJS) $(LIBS)

doRow.o: doRow.S
	gcc -c $(CFLAGS) -gstabs+ doRow.S

clean:
	rm $(EXE)

