//Midi Controllers
MidiOut mout; //messages from this to launchpad
MidiIn min; //messages from launchpad to this
MidiOut malt; //messages from this to your DAW or use case

mout.open(3); //MIDIOUT2(LP* MIDI)
min.open(2); //MIDIIN2  (LP* MIDI)
malt.open(1); //MIDI output channel (use an internal midi channel.  LoopBe offers one)

//message holder
MidiMsg msg;
//msg.data1: signal type
//msg.data2: note location
//msg.data3: color

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//classes and functions
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

public class padGrid {
    /*launchpad has numbers 11 through 98
    normal buttons columns 1 through 8, rows 1 through 8
    side buttons column 9, rows 1 through 8
    top buttons row 9, columns 1 through 8*/
    
    //member variables
    //color 0 is off, 1-127 are pseudorandom
    int passiveColor[100];      // color this button displays by default
    int activeColor[100];       // color this button displays when pressed
    int cachedColor[100];
    int midi[100];              // what midi note to play when this button is pressed
    int buttonRole[100];        // what the button is supposed to do
    
    int midiOffsets[10][100];   // jump midi values by a set amounts
    int modifiableSets[10][100];   // jump midi values by a set amounts
    int harpOffsets[10];        //half steps up and down at each of the 7 notes
    int lastNote;
    /* buttonRole definition
    0:      default
    1:      note playing
    2:      off
    3:      note setting
    4:      pulsing color (functionality wip)
    5:      change presets
    10-19:  midi offset zone control (dumb offset)
    20-29:  midi set zone control (button will copy last played note when pressed)
    30-39:  harp offset setter
    40-49: harp offset reciever
    //*/
    
    //default setup
    public void clearGrid(){
        <<< "Setting Up" >>>;
        for (11 => int i; i < 99; i++){
            i/10 => int row;
            i%10 => int col;
            0 => lastNote;
            0 => cachedColor[i];
            if (col == 0){
                0 => passiveColor[i];
                0 => activeColor[i];
                0 => midi[i];
                0 => buttonRole[i];
            } else if (row == 9 || col == 9) {
                0 => passiveColor[i];
                0 => activeColor[i];
                0 => midi[i];
                2 => buttonRole[i];
            } else {
                0 => passiveColor[i];
                0 => activeColor[i];
                0 => midi[i];
                0 => buttonRole[i];
            }
            colorUpdate(i,0);
        }
    }
    clearGrid();
    
    public void chordoConfig(){
        <<< "chordo configuration activating" >>>;
        clearGrid();
        //preset swapping
        for (0 => int i; i < 4; i++){
            i + 95 => int v;
            i => midi[v];
            5 => buttonRole[v];
            v => passiveColor[v];
            87 => activeColor[v];
        }
        //because this is the starter mode
        colorUpdate(95, 0);
        
        //bottom 4x9
        55 => int tVal;
        for (1 => int i; i <= 4; i++){
            for (1 => int j; j <= 8; j++){
                i*10 + j => int index;
                tVal => midi[index];
                tVal + 1 => tVal;
                
                28 => activeColor[index];
                30 => passiveColor[index];
                22 => cachedColor[index];
                if (midi[index]%12 == 0){
                    22 => passiveColor[index];
                    30 => cachedColor[index];
                }
                colorUpdate(index,0);
                
                -12 => midiOffsets[0][index];
                -1 => midiOffsets[1][index];
                1 => midiOffsets[2][index];
                12 => midiOffsets[3][index];
                
            }
        }
        //dark red octave down
        10 => buttonRole[19];
        21 => activeColor[19];
        5 => passiveColor[19];
        colorUpdate(19,0);
        //light red note down
        11 => buttonRole[29];
        21 => activeColor[29];
        4 => passiveColor[29];
        colorUpdate(29,0);
        //light blue note up
        12 => buttonRole[39];
        21 => activeColor[39];
        40 => passiveColor[39];
        colorUpdate(39,0);
        //dark blue octave up
        13 => buttonRole[49];
        21 => activeColor[49];
        41 => passiveColor[49];
        colorUpdate(49,0);
        
        //row 5
        for (51 => int index; index < 59; index++){
            8 => activeColor[index];
            9 => passiveColor[index];
            -1 => midi[index];
            colorUpdate(index,0);
            1 => modifiableSets[0][index];
        }
        //dark orange editable toggle
        20 => buttonRole[59];
        21 => activeColor[59];
        11 => passiveColor[59];
        colorUpdate(59,0);
        
        //row 6
        for (61 => int index; index < 69; index++){
            12 => activeColor[index];
            13 => passiveColor[index];
            -1 => midi[index];
            colorUpdate(index,0);
            1 => modifiableSets[1][index];
        }
        //dark orange editable toggle
        21 => buttonRole[69];
        21 => activeColor[69];
        14 => passiveColor[69];
        colorUpdate(69,0);
        
        //double row 7+8
        for (71 => int index; index < 79; index++){
            44 => activeColor[index];
            45 => passiveColor[index];
            -1 => midi[index];
            colorUpdate(index,0);
            1 => modifiableSets[2][index];
        }
        for (81 => int index; index < 89; index++){
            48 => activeColor[index];
            49 => passiveColor[index];
            -1 => midi[index];
            colorUpdate(index,0);
            1 => modifiableSets[2][index];
        }
        //dark blue editable toggle
        22 => buttonRole[79];
        21 => activeColor[79];
        53 => passiveColor[79];
        colorUpdate(79,0);
        
        //chord movement too be added
        
        //"white" preset
        3 => passiveColor[99];
        colorUpdate(99,0);
    }
    
    public void harpConfig(){
        clearGrid();
        //preset swapping
        for (0 => int i; i < 4; i++){
            i + 95 => int v;
            i => midi[v];
            5 => buttonRole[v];
            v => passiveColor[v];
            87 => activeColor[v];
        }
        
        //first five rows are pedals
        for (0 => int i; i < 8; i++){
            for (1 => int j; j < 6; j++){
                j*10+i => int pos;
                30+i => buttonRole[pos];
                j-3 => midi[pos];
                0 => passiveColor[pos];
                74 => cachedColor[pos];
                87 => activeColor[pos];
                if (j-3 == harpOffsets[i]) colorUpdate(pos, 2);
            }
        }
        
        //last three rows are notes
        for (0 => int i; i < 8; i++){
            for (6 => int j; j < 9; j++){
                j*10+i => int pos;
                40+i => buttonRole[pos];
                50 + (i*15)/9 + (j-6)*12 => midi[pos]; //automatically assigning approximately major scales
                38 => passiveColor[pos];
                87 => activeColor[pos];
                colorUpdate(pos,0);
            }
        }
    }
    
    public void setOColor(int pos, int color){
        color => passiveColor[pos];
    }
    
    public void setIColor(int pos, int color){
        color => activeColor[pos];
    }
    
    public void colorUpdate(int pos, int pressed){
        int color;
        if (pressed == 1){
            activeColor[pos] => color;
        } else if (pressed == 2) {
            cachedColor[pos] => color;
        } else {
            passiveColor[pos] => color;
        }
        0x90 => msg.data1;
        pos => msg.data2;
        color => msg.data3;
        mout.send(msg);
    }
    
    public int interpret(int note, int velocity){
        if (velocity == 0){
            colorUpdate(note, 0);
            if (buttonRole[note] == 1){
                midi[note] => lastNote;
                return lastNote;
            } else if (buttonRole[note] >= 40 && buttonRole[note] < 50){
                midi[note] + harpOffsets[buttonRole[note]%10] => lastNote;
                return lastNote;
            }
        } else {
            colorUpdate(note, 1);
            if (buttonRole[note] == 1){
                midi[note] => lastNote;
                return lastNote;
            } else if (buttonRole[note] == 3) {
                lastNote => midi[note];
                return -1;
            } else if (buttonRole[note] == 5) {
                if (midi[note] == 0) {
                    chordoConfig();
                } else if (midi[note] == 1) {
                    harpConfig();
                }                
            } else if (buttonRole[note] >= 10 && buttonRole[note] < 20){
                buttonRole[note] - 10 => int offNum;
                for (11 => int i; i < 99; i++){
                    (midi[i]%12 == 0) => int check;
                    midi[i] + midiOffsets[offNum][i] => midi[i];
                    if ((midi[i]%12 == 0)!= check){
                        passiveColor[i] => int temp;
                        cachedColor[i] => passiveColor[i];
                        temp => cachedColor[i];
                        colorUpdate(i, 0);
                    }
                }
                return -1;
            } else if (buttonRole[note] >= 20 && buttonRole[note] < 30){
                buttonRole[note] - 20 => int keyNum;
                for (11 => int i; i < 99; i++){
                    if (modifiableSets[keyNum][i] == 1){
                        if (buttonRole[i] == 1){
                            passiveColor[i] => cachedColor[i];
                            69 => passiveColor[i];
                            colorUpdate(i, 0);
                            3 => buttonRole[i];
                        } else if (buttonRole[i] == 3){
                            cachedColor[i] => passiveColor[i];
                            colorUpdate(i, 0);
                            1 => buttonRole[i];
                        }
                    }
                }
                return -1;
            } else if (buttonRole[note] >= 30 && buttonRole[note] < 40){
                midi[note] => harpOffsets[buttonRole[note]%10];
                74 => passiveColor[note];
                for (1 => int i; i < 9; i++){
                    note%10 + i*10 => int pos;
                    if (buttonRole[pos] >= 30 && buttonRole[pos] < 40 && pos != note){
                        0 => passiveColor[pos];
                        colorUpdate(pos, 0);
                    }
                }
                return -1;
            } else if (buttonRole[note] >= 40 && buttonRole[note] < 50){
                midi[note] + harpOffsets[buttonRole[note]%10] => lastNote;
                return lastNote;
            }
        }
    }
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//start of "main"
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

padGrid testgrid;
testgrid.chordoConfig();

//test loop #1
// infinite time-loop
while( true )
{
    // wait on the event 'min'
    min => now;

    // get the message(s)
    while( min.recv(msg) )
    {
        // print out midi message
        <<< msg.data1, msg.data2, msg.data3 >>>;
        
        //preserve value
        msg.data1 => int minType;
        msg.data2 => int minNote;
        msg.data3 => int minVelocity;
        
        
        
        //send to ancilliary midi channel
        //prep message
        minType => msg.data1;
        testgrid.interpret(msg.data2, msg.data3) => msg.data2;
        minVelocity => msg.data3;
        
        //message on the way out
        <<< msg.data1, msg.data2, msg.data3 >>>;
        malt.send(msg); //send out
    }
}