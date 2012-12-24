ECUKES = $(shell find elpa/ecukes-*/ecukes | tail -1)

all: win script

win:
	carton exec ${ECUKES} features

script:
	carton exec ${ECUKES} --script features

carton:
	carton install

travis: carton win script
