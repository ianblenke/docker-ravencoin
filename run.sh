#!/bin/bash
NUM_FALLBACK_THREADS=${NUM_FALLBACK_THREADS:-$(( $(nproc) * 2 ))}

exec ccminer -a x16r --num-fallback-threads $NUM_FALLBACK_THREADS -o stratum+tcp://cryptopool.party:3636 -u RRgfXWgAXhzrYdA1Jn91iFNhjyhV4C7TJB
