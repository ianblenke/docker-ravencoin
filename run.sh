#!/bin/bash
NUM_FALLBACK_THREADS=${NUM_FALLBACK_THREADS:-$(( $(nproc) * 2 ))}

exec ccminer -a x16r --num-fallback-threads $NUM_FALLBACK_THREADS -o $URL -u $USER -p $PASS $@
