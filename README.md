# reLaunch
Customize your launchpad experience or use one of the modes I've crafted.  You will need a chuck compiler (miniAudicle) and an internal midi channel (LoopBe)

# how to use
  use miniAudicle's window -> device browser to look at which devices are on which channels.  Make sure mout is opening your launchpad's MIDIOUT2, min is opening your launchpad's MIDIIN2, and malt is opening an internal midi channel.  If you don't have one, I recommend LoopBe, which is what I use on my machine.  I think this may require a restart.
  
  BEFORE YOU RUN THE PROGRAM, set your launchpad to programming mode.  You can do this by holding the session button for 2 seconds and pressing the orange button.  Double tap the session button to cancel the animation.  You can do the same thing but press the green button to return to normal operation.
    
# details
1.0 has 1 predifined mode, chordo, and 5 button functionalities.

# chordo
  The bottom 4 rows are for the palette.  the 4x8 pad is a 32 note chromatic scale with the C's colored green.  This scale can be moved higher with the blue buttons and lower with the red buttons, with the dark buttons moving it by and octave and the light buttons moving it by a note.
  The top 4 rows start with no midi value, but can be edited.  When you press a toggle play/edit button on the right, it will change a group of buttons purple, indicating that they can be edited. In this mode, when you press them, they will copy the last played note.  To set up a bunch of notes quickly, just play the note you want on the palette and then press the button you want to set.  Once you're done, press the toggle button again, setting the color of the editable notes back to normal, and play away.
    
# button functionalities
I've implemented 5 modes that a button can have.  All buttons change color when pressed
mode 1 is note-playing, meaning it will play a note and change color when pressed.
mode 2 is off.  It does nothing when pressed.
mode 3 is note setting.  The button will copy the midi value of the last mode 1 button pressed.
mode 10 is midi offset.  It changes every notes midi value by a set amount per note.  So far I've used it to offset the palette by notes or octaves.
mode 20 is set zone control.  This will switch buttons from note playing to setting and back.  Buttons are purple when editable.

# debugging
## Common problems.
If the buttons do not light up at all, check to make sure mout is opening MIDIOUT2(LP* MIDI).  You may also need to enter programming mode, which can be done

If the buttons do not change color when pressed, check to make sure min is opening MIDIIN2(LP* MIDI) and that no other program is stealing that input (your DAW, for example)

You need a digital midi cable for this to work.  I use LoopBe.  Make sure malt is set to that digital cable's channel and that your DAW or instrument is reading midi from that channel.
