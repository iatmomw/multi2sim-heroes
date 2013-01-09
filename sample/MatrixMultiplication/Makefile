TARGET = MatrixMultiplication

CC=gcc

EXT_SRC=.c
EXT_INC=.h
EXT_OBJ=.o

BINDIR=bin
INCDIR=include
SRCDIR=src

# SIMULATION
S_LIBS = -lm2s-opencl -lpthread -ldl
# NATIVE
N_LIBS = -lOpenCL
LIBS = $(N_LIBS)

LDFLAGS = -m32 -g -Wall -Werror
CFLAGS = -m32 -g -Wall -Werror -I$(INCDIR)

OBJECTS = $(patsubst $(SRCDIR)/%$(EXT_SRC), $(BINDIR)/%$(EXT_OBJ), $(wildcard $(SRCDIR)/*$(EXT_SRC)))
HEADERS = $(wildcard *$(EXT_INC))

default: $(TARGET)

all: default

$(BINDIR)/%.o: $(SRCDIR)/%$(EXT_SRC) $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@


$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) $(LDFLAGS) $(LIBS) -o $@

clean:
	rm -f $(BINDIR)/*$(EXT_OBJ)
	rm -f $(TARGET)
