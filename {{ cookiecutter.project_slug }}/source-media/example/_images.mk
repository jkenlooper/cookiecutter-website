# Non-clever Makefile

.PHONY : all clean

objects = $(shell cat source-media/example/_images.manifest)

all : $(objects)

clean :
	echo $(objects) | xargs rm -f

media/llama-crop.jpg : source-media/example/hayley-maxwell-1PTTadLRcLQ-unsplash.jpg
	convert $< -format jpg -crop 2286x1497+645+261 +repage $@;

media/llama-2-1.jpg : source-media/example/hayley-maxwell-1PTTadLRcLQ-unsplash.jpg
	convert $< -format jpg -crop 2000x1000+920+340 +repage $@;

media/llama-3-3.jpg : source-media/example/hayley-maxwell-1PTTadLRcLQ-unsplash.jpg
	convert $< -format jpg -crop 1810x1810+910+258 +repage $@;

media/llama-1-2.jpg : source-media/example/hayley-maxwell-1PTTadLRcLQ-unsplash.jpg
	convert $< -format jpg -crop 1000x2000+780+250 +repage $@;
