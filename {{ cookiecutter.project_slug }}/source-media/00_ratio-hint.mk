# Resizes jpgs that have a hint ratio in their name to multiple sizes.
# For example the llama-2-3.jpg will create resized jpgs:
# llama.280x420.jpg, llama.600x900.jpg, llama.1200x1800.jpg
unit_sizes := 140 300 600

# Find all hinted jpgs in media/ that have the ratio hint suffix (-2-2.jpg)
hinted := $(shell find media/ -name '*-[0-9]-[0-9].jpg')

# Init with nothing and allow each RESIZE_TARGET_template to append to this var.
resized :=

# clear out any suffixes
.SUFFIXES:

.SECONDEXPANSION:

.PHONY : all clean

all : $$(resized)

define RESIZE_TARGET_template
resized += $$(patsubst %-$(1).jpg,%.$(2).jpg,$$(filter %-$(1).jpg,$$(hinted)))
%.$(2).jpg : %-$(1).jpg
	convert $$< -resize $(2) $$@
endef

define UNIT_template
$$(eval $$(call RESIZE_TARGET_template,1-1,$$(strip $$(shell echo "1*$(1)" | bc))x$$(strip $$(shell echo "1*$(1)" | bc))))
$$(eval $$(call RESIZE_TARGET_template,1-2,$$(strip $$(shell echo "1*$(1)" | bc))x$$(strip $$(shell echo "2*$(1)" | bc))))
$$(eval $$(call RESIZE_TARGET_template,1-3,$$(strip $$(shell echo "1*$(1)" | bc))x$$(strip $$(shell echo "3*$(1)" | bc))))

$$(eval $$(call RESIZE_TARGET_template,2-1,$$(strip $$(shell echo "2*$(1)" | bc))x$$(strip $$(shell echo "1*$(1)" | bc))))
$$(eval $$(call RESIZE_TARGET_template,2-2,$$(strip $$(shell echo "2*$(1)" | bc))x$$(strip $$(shell echo "2*$(1)" | bc))))
$$(eval $$(call RESIZE_TARGET_template,2-3,$$(strip $$(shell echo "2*$(1)" | bc))x$$(strip $$(shell echo "3*$(1)" | bc))))

$$(eval $$(call RESIZE_TARGET_template,3-1,$$(strip $$(shell echo "3*$(1)" | bc))x$$(strip $$(shell echo "1*$(1)" | bc))))
$$(eval $$(call RESIZE_TARGET_template,3-2,$$(strip $$(shell echo "3*$(1)" | bc))x$$(strip $$(shell echo "2*$(1)" | bc))))
$$(eval $$(call RESIZE_TARGET_template,3-3,$$(strip $$(shell echo "3*$(1)" | bc))x$$(strip $$(shell echo "3*$(1)" | bc))))
endef

$(foreach size,$(unit_sizes),$(eval $(call UNIT_template,$(size))))

clean :
	echo $(resized) | xargs rm -f
