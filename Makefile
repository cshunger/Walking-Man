CC = g++
CFLAGS = -g -Wall -m32
MKDEP=/usr/X11R6/bin/makedepend -Y
#INCLUDES = -I./common/include
ifeq ($(shell uname), Darwin)
	GLLIBS = -framework OpenGL -framework GLUT
else
	GLLIBS = -lGL -lGLU -lglut
endif
LIBS = -lc -lm -lexpat -lpng -ljpeg $(GLLIBS)

HDRS = xvec.h parseX3D.h image.h scene.h 
SRCS = parseX3D.cpp image.cpp view3D.cpp
HDRS_SLN = 
SRCS_SLN = scene.cpp
OBJS = $(patsubst %.cpp, %.o, $(SRCS)) $(patsubst %.cpp,%.o,$(SRCS_SLN))

view3D: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBS)

%.o: %.cpp Makefile
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

.PHONY: clean
clean: 
	-rm -f -r $(OBJS) *.o *~ *core* view3D

depend: $(SRCS) $(SRCS_SLN) $(HDRS) $(HDRS_SLN) Makefile
	$(MKDEP) $(CFLAGS) $(SRCS) $(SRCS_SLN) $(HDRS) $(HDRS_SLN) >& /dev/null

# prepare release folder: generate release srcs, hdrs, spec, and Makefile
$(ASGN):
	-mkdir

# DO NOT DELETE

parseX3D.o: parseX3D.h scene.h xvec.h image.h
image.o: image.h
view3D.o: parseX3D.h scene.h xvec.h image.h
scene.o: image.h scene.h xvec.h
parseX3D.o: scene.h xvec.h image.h
scene.o: xvec.h image.h
