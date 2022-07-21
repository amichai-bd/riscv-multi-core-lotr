#include "LOTR_defines.h"


#define WRITE_REG(REG,VAL) (*REG) = VAL
#define READ_REG(VAL,REG)  VAL    = (*REG)
#define VGA_PTR(PTR,OFF)   PTR    = (volatile int *) (VGA_MEM_BASE + OFF)

/* Control registers addresses */
#define CR_MEM_BASE 0x00C00000
#define CR_CURSOR_H (volatile int *) (CR_MEM_BASE + 0x200) // Same as CR_SCRATCHPAD0 - FIXME add in RTL new CR
#define CR_CURSOR_V (volatile int *) (CR_MEM_BASE + 0x204) // Same as CR_SCRATCHPAD1 - FIXME add in RTL new CR


/* VGA defines */
#define VGA_MEM_BASE       0x03400000
#define VGA_MEM_SIZE_BYTES 38400
#define VGA_MEM_SIZE_WORDS 9600
#define LINE               320
#define BYTES              4
#define COLUMN             80 /* COLUMN between 0 - 79 (80x60) */
#define RAWS               60 /* RAWS between 0 - 59 (80x60) */

/* ASCII tables addresses */
#define ASCII_TOP_BASE       ((volatile int *) 0x00400900) //= 20'h2100 ; // RO 32 bit
#define ASCII_BOTTOM_BASE    ((volatile int *) 0x00400a00)

/* This function print a char note on the screen in (raw,col) position */
//void draw_char(char note, int raw, int col) ->FIXME use char
void draw_char(int note, int raw, int col)
{
    unsigned int vertical   = raw * LINE;
    unsigned int horizontal = col * BYTES;
    volatile int *ptr_top;
    volatile int *ptr_bottom;

    VGA_PTR(ptr_top    , horizontal + vertical);
    VGA_PTR(ptr_bottom , horizontal + vertical + LINE);

    WRITE_REG(ptr_top    , ASCII_TOP_BASE[note]);
    WRITE_REG(ptr_bottom , ASCII_BOTTOM_BASE[note]);
}
///* This function print a string on the screen in (CR_CURSOR_V,CR_CURSOR_H) position */
//void rvc_printf(const char *c)
void rvc_printf(const int *c)
{
    int i = 0;
    unsigned int raw = 0;
    unsigned int col = 0;

    READ_REG(col,CR_CURSOR_H);
    READ_REG(raw,CR_CURSOR_V);

    while(c[i] != '\0')
    {
        if(c[i] == '\n') // End of line
        {
            col = 0;
            raw = raw + 2 ;
            if(raw == (RAWS * 2)) // End of screen
            {
                raw = 0;
            }
            i++;
            continue;
        }

        draw_char(c[i], raw, col);
        col++;
        if(col == COLUMN) // End of line
        {
            col = 0;
            raw = raw + 2 ;
            if(raw == (RAWS * 2)) // End of screen
            {
                raw = 0;
            }
        }
        i++;
    }
    //Update CR_CURSOR 
    WRITE_REG(CR_CURSOR_H, col);
    WRITE_REG(CR_CURSOR_V, raw);

}

void set_table() {
    ASCII_TOP_BASE   ['A'] = 0x663C1800;
    ASCII_BOTTOM_BASE['A'] = 0x00667E66;
    ASCII_TOP_BASE   ['B'] = 0x3E221E00;
    ASCII_BOTTOM_BASE['B'] = 0x001E223E;
    ASCII_TOP_BASE   [' '] = 0x00000000;
    ASCII_BOTTOM_BASE[' '] = 0x00000000;
    ASCII_TOP_BASE   [','] = 0x00000000;
    ASCII_BOTTOM_BASE[','] = 0x061E1818;
    ASCII_TOP_BASE   ['.'] = 0x00000000;
    ASCII_BOTTOM_BASE['.'] = 0x00181800;
    ASCII_TOP_BASE   ['0'] = 0x52623C00;
    ASCII_BOTTOM_BASE['0'] = 0x003C464A;
    ASCII_TOP_BASE   ['1'] = 0x1A1C1800;
    ASCII_BOTTOM_BASE['1'] = 0x007E1818;
    ASCII_TOP_BASE   ['2'] = 0x40423C00;
    ASCII_BOTTOM_BASE['2'] = 0x007E023C;
    ASCII_TOP_BASE   ['3'] = 0x40423C00;
    ASCII_BOTTOM_BASE['3'] = 0x003C4238;
    ASCII_TOP_BASE   ['4'] = 0x24283000;
    ASCII_BOTTOM_BASE['4'] = 0x0020207E;
    ASCII_TOP_BASE   ['5'] = 0x3E027E00;
    ASCII_BOTTOM_BASE['5'] = 0x003C4240;
    ASCII_TOP_BASE   ['6'] = 0x02423C00;
    ASCII_BOTTOM_BASE['6'] = 0x003C423E;
    ASCII_TOP_BASE   ['7'] = 0x30407E00;
    ASCII_BOTTOM_BASE['7'] = 0x00080808;
    ASCII_TOP_BASE   ['8'] = 0x42423C00;
    ASCII_BOTTOM_BASE['8'] = 0x003C423C;
    ASCII_TOP_BASE   ['9'] = 0x42423C00;
    ASCII_BOTTOM_BASE['9'] = 0x003E407C;
    ASCII_TOP_BASE   ['A'] = 0x663C1800;
    ASCII_BOTTOM_BASE['A'] = 0x00667E66;
    ASCII_TOP_BASE   ['B'] = 0x3E221E00;
    ASCII_BOTTOM_BASE['B'] = 0x001E223E;
    ASCII_TOP_BASE   ['C'] = 0x023E3C00;
    ASCII_BOTTOM_BASE['C'] = 0x003C3E02;
    ASCII_TOP_BASE   ['D'] = 0x223E1E00;
    ASCII_BOTTOM_BASE['D'] = 0x001E3E22;
    ASCII_TOP_BASE   ['E'] = 0x06067E00;
    ASCII_BOTTOM_BASE['E'] = 0x007E067E;
    ASCII_TOP_BASE   ['F'] = 0x06067E00;
    ASCII_BOTTOM_BASE['F'] = 0x0006067E;
    ASCII_TOP_BASE   ['G'] = 0x023E3C00;
    ASCII_BOTTOM_BASE['G'] = 0x003C223A;
    ASCII_TOP_BASE   ['H'] = 0x66666600;
    ASCII_BOTTOM_BASE['H'] = 0x0066667E;
    ASCII_TOP_BASE   ['I'] = 0x18187E00;
    ASCII_BOTTOM_BASE['I'] = 0x007E1818;
    ASCII_TOP_BASE   ['J'] = 0x60606000;
    ASCII_BOTTOM_BASE['J'] = 0x007C6666;
    ASCII_TOP_BASE   ['K'] = 0x3E664600;
    ASCII_BOTTOM_BASE['K'] = 0x0046663E;
    ASCII_TOP_BASE   ['L'] = 0x06060600;
    ASCII_BOTTOM_BASE['L'] = 0x007E0606;
    ASCII_TOP_BASE   ['M'] = 0x5A664200;
    ASCII_BOTTOM_BASE['M'] = 0x0042425A;
    ASCII_TOP_BASE   ['N'] = 0x6E666200;
    ASCII_BOTTOM_BASE['N'] = 0x00466676;
    ASCII_TOP_BASE   ['O'] = 0x66663C00;
    ASCII_BOTTOM_BASE['O'] = 0x003C6666;
    ASCII_TOP_BASE   ['P'] = 0x66663E00;
    ASCII_BOTTOM_BASE['P'] = 0x0006063E;
    ASCII_TOP_BASE   ['Q'] = 0x42423C00;
    ASCII_BOTTOM_BASE['Q'] = 0x007C6252;
    ASCII_TOP_BASE   ['R'] = 0x66663E00;
    ASCII_BOTTOM_BASE['R'] = 0x0066663E;
    ASCII_TOP_BASE   ['S'] = 0x1E067C00;
    ASCII_BOTTOM_BASE['S'] = 0x003E6078;
    ASCII_TOP_BASE   ['T'] = 0x18187E00;
    ASCII_BOTTOM_BASE['T'] = 0x00181818;
    ASCII_TOP_BASE   ['U'] = 0x66666600;
    ASCII_BOTTOM_BASE['U'] = 0x003C7E66;
    ASCII_TOP_BASE   ['V'] = 0x66666600;
    ASCII_BOTTOM_BASE['V'] = 0x00183C66;
    ASCII_TOP_BASE   ['W'] = 0x42424200;
    ASCII_BOTTOM_BASE['W'] = 0x00427E5A;
    ASCII_TOP_BASE   ['X'] = 0x3C666600;
    ASCII_BOTTOM_BASE['X'] = 0x0066663C;
    ASCII_TOP_BASE   ['Y'] = 0x3C666600;
    ASCII_BOTTOM_BASE['Y'] = 0x00181818;
    ASCII_TOP_BASE   ['Z'] = 0x10207E00;
    ASCII_BOTTOM_BASE['Z'] = 0x007E0408;
    ASCII_TOP_BASE   ['+'] = 0xFFFFFFFF;
    ASCII_BOTTOM_BASE['+'] = 0xFFFFFFFF;//temp for fill squre
}
void print_hello(int offset) {
        draw_char('H', offset, 5+0);
        draw_char('E', offset, 5+1);
        draw_char('L', offset, 5+2);
        draw_char('L', offset, 5+3);
        draw_char('O', offset, 5+4);
        draw_char(' ', offset, 5+5);
        draw_char('W', offset, 5+6);
        draw_char('O', offset, 5+7);
        draw_char('R', offset, 5+8);
        draw_char('L', offset, 5+9);
        draw_char('D', offset, 5+10);
        draw_char('.', offset, 5+11);
        draw_char(' ', offset, 5+12);
        draw_char('F', offset, 5+13);
        draw_char('R', offset, 5+14);
        draw_char('O', offset, 5+15);
        draw_char('M', offset, 5+16);
        draw_char(' ', offset, 5+17);
        draw_char(' ', offset, 5+18);
        draw_char('T', offset, 5+19);
        draw_char('H', offset, 5+20);
        draw_char('R', offset, 5+21);
        draw_char('E', offset, 5+22);
        draw_char('A', offset, 5+23);
        draw_char('D', offset, 5+24);
        draw_char(' ', offset, 5+25);
        if(CR_WHO_AM_I[0] ==4)  draw_char('0', offset, 5+26);
        if(CR_WHO_AM_I[0] ==5)  draw_char('1', offset, 5+26);
        if(CR_WHO_AM_I[0] ==6)  draw_char('2', offset, 5+26);
        if(CR_WHO_AM_I[0] ==7)  draw_char('3', offset, 5+26);
        if(CR_WHO_AM_I[0] ==8)  draw_char('4', offset, 5+26);
        if(CR_WHO_AM_I[0] ==9)  draw_char('5', offset, 5+26);
        if(CR_WHO_AM_I[0] ==10) draw_char('6', offset, 5+26);
        if(CR_WHO_AM_I[0] ==11) draw_char('7', offset, 5+26);

        }
void clear_screen () {
    for(int x = 0; x<80; x++) {
        for(int y = 0; y<120 ; y++){
            draw_char(' ', y, x);
        }
    }
}

int main() {
    int ThreadId = CR_THREAD[0];
    int UniqeId = CR_WHO_AM_I[0];
    int counter = 0 ;
    int round = 0 ;
    //This works in simulation! - but adds data to the D_MEM which we dont support yet in FPGA
    //int hello []  = {'H','E','L','L','O',' ','P','R','I','N','T',',','\n','\0'};
    int hello []  = {'H','I','\0'};
    int zero  []  = {' ','\n','\0'};
    int one   []  = {'1','\n','\0'};
    int two   []  = {'2','\n','\0'};
    int three []  = {'3','\n','\0'};
    int new_press = 0;
    int old_press = 0;
    int x_pos = 0;
    int y_pos = 0;
    int up_old_press = 0;
    int down_old_press = 0;
    int left_old_press = 0;
    int right_old_press = 0;
    set_table(); //temp - untill we can load backdoor the D_MEM the ascii table in FPGA
    clear_screen();
    print_hello(20); //just to make sure things are working

    switch (UniqeId) //the CR Address
    {
        case 0x4 : // 
            //print hello from thread 0
            while (1) { // loop forever            
                if((SWITCH_FGPA[0] == 1) || (SWITCH_FGPA[0] == 5)) print_hello(0);
                if((SWITCH_FGPA[0] == 2) || (SWITCH_FGPA[0] == 5)) print_hello(2);
                if((SWITCH_FGPA[0] == 3) || (SWITCH_FGPA[0] == 5)) print_hello(4);
                if((SWITCH_FGPA[0] == 4) || (SWITCH_FGPA[0] == 5)) print_hello(6);
                //new butten press
                if ((BUTTON2_FGPA[0] == 0) && (old_press == 0)) { //new press
                    new_press = 1;
                    counter ++;
                    old_press = 1;
                    draw_char('+', 15, (counter+1));// draw a squere on screen - every press should add a new squere to the right
                    draw_char(' ', 15, (counter));
                } else  if(BUTTON2_FGPA[0] == 1) { //button is not pressed
                    new_press = 0;
                    old_press = 0;
                }
                while ( SWITCH_FGPA[0] > 5) {  //Just a hack to clear the screen with a switch
                    clear_screen();
                } 

                if ((ARDUINO_IO_FGPA[0] == 14) && (right_old_press == 0)){ //4'b1110
                    x_pos++;
                    right_old_press = 1;
                } else if ((ARDUINO_IO_FGPA[0] == 13) && (up_old_press == 0))  { //4'b1101
                    y_pos++;
                    up_old_press = 1;
                } else if ((ARDUINO_IO_FGPA[0] == 11) && (down_old_press == 0))  { //4'b1011
                    y_pos--;
                    down_old_press = 1;
                } else if ((ARDUINO_IO_FGPA[0] == 7) && (left_old_press == 0)) { //4'b0111
                    x_pos--;
                    left_old_press = 1;
                } else if(ARDUINO_IO_FGPA[0] == 15) { //button is not pressed
                    right_old_press = 0;
                    up_old_press    = 0;
                    down_old_press  = 0;
                    left_old_press  = 0;
                }
                draw_char('+', (2*y_pos), x_pos);// draw a squere on screen
            }
        //draw_char('+', 15, counter);
        //counter++;
        //rvc_printf(hello); //couser updates automatacly -> can only work from a single thread (unliss we enable multiple courser per thread)
        //rvc_printf(zero);
        //rvc_printf(one);
        //rvc_printf(two);
        //rvc_printf(three);
        //rvc_printf(three);
        //break;
        //case 0x5 : // 
        //    if((SWITCH_FGPA[0] == 2) || (SWITCH_FGPA[0] == 5)) print_hello(2);
        //    if((SWITCH_FGPA[0] == 2) || (SWITCH_FGPA[0] == 5)) print_hello(2);
        //break;
        //case 0x6 : // 
        //    if((SWITCH_FGPA[0] == 3) || (SWITCH_FGPA[0] == 5)) print_hello(4);
        //    if((SWITCH_FGPA[0] == 3) || (SWITCH_FGPA[0] == 5)) print_hello(4);
        //break;
        //case 0x7 : // 
        //    if((SWITCH_FGPA[0] == 4) || (SWITCH_FGPA[0] == 5)) print_hello(6);
        //    if((SWITCH_FGPA[0] == 4) || (SWITCH_FGPA[0] == 5)) print_hello(6);
        //break;
        //case 0x8 : // 
        //print_hello(8);
        //break;
        //case 0x9 : // 
        //print_hello(10);
        //break;
        //case 0xA : // 
        //print_hello(12);
        //break;
        //case 0xB : // 
        //print_hello(14);
        //break;
        default :
            while(1); 
        break;
       
    }// case
    round++ ;

return 0;

}
