QUACK_STEP=`cat /home/buster/dotfiles/quack/quack_step.txt`
if [ $QUACK_STEP -lt -10 ] ; then
	QUACK_STEP=-10
elif [ $QUACK_STEP -gt 10 ] ; then
	QUACK_STEP=10
fi

QUACK_PITCH=$((-1500 + ($QUACK_STEP + 10)*150))

if [ $(($RANDOM % 1000)) -gt 950 ] ; then
	# Special event
	NUM_OF_QUACK_SOUNDS=$(ls /home/buster/dotfiles/quack/suprise_sounds | wc -l)
	QUACK_INDEX=$(($RANDOM % $NUM_OF_QUACK_SOUNDS))
	QUACK_SOUNDS=(/home/buster/dotfiles/quack/suprise_sounds/*)
	play ${QUACK_SOUNDS[$QUACK_INDEX]} pitch $QUACK_PITCH
else
	# Normal quack
	NUM_OF_QUACK_SOUNDS=$(ls /home/buster/dotfiles/quack/quack_sounds | wc -l)
	QUACK_INDEX=$(($RANDOM % $NUM_OF_QUACK_SOUNDS))
	QUACK_SOUNDS=(/home/buster/dotfiles/quack/quack_sounds/*)
	play ${QUACK_SOUNDS[$QUACK_INDEX]} pitch $QUACK_PITCH
fi
