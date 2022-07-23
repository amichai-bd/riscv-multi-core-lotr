#include "LOTR_defines.h"
#define WRITE_REG(REG,VAL) (*REG) = VAL
#define READ_REG(VAL,REG)  VAL    = (*REG)
#define VGA_PTR(PTR,OFF)   PTR    = (volatile int *) (VGA_MEM_BASE + OFF)
/* Control registers addresses */
#define CR_MEM_BASE 0x00C00000
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
void set_table() {
    ASCII_TOP_BASE   [' '] = 0x00000000;
    ASCII_BOTTOM_BASE[' '] = 0x00000000;
    //ASCII_TOP_BASE   [','] = 0x00000000;
    //ASCII_BOTTOM_BASE[','] = 0x061E1818;
    //ASCII_TOP_BASE   ['.'] = 0x00000000;
    //ASCII_BOTTOM_BASE['.'] = 0x00181800;
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
    //ASCII_TOP_BASE   ['B'] = 0x3E221E00;
    //ASCII_BOTTOM_BASE['B'] = 0x001E223E;
    ASCII_TOP_BASE   ['C'] = 0x023E3C00;
    ASCII_BOTTOM_BASE['C'] = 0x003C3E02;
    //ASCII_TOP_BASE   ['D'] = 0x223E1E00;
    //ASCII_BOTTOM_BASE['D'] = 0x001E3E22;
    ASCII_TOP_BASE   ['E'] = 0x06067E00;
    ASCII_BOTTOM_BASE['E'] = 0x007E067E;
    //ASCII_TOP_BASE   ['F'] = 0x06067E00;
    //ASCII_BOTTOM_BASE['F'] = 0x0006067E;
    ASCII_TOP_BASE   ['G'] = 0x023E3C00;
    ASCII_BOTTOM_BASE['G'] = 0x003C223A;
    //ASCII_TOP_BASE   ['H'] = 0x66666600;
    //ASCII_BOTTOM_BASE['H'] = 0x0066667E;
    //ASCII_TOP_BASE   ['I'] = 0x18187E00;
    //ASCII_BOTTOM_BASE['I'] = 0x007E1818;
    //ASCII_TOP_BASE   ['J'] = 0x60606000;
    //ASCII_BOTTOM_BASE['J'] = 0x007C6666;
    //ASCII_TOP_BASE   ['K'] = 0x3E664600;
    //ASCII_BOTTOM_BASE['K'] = 0x0046663E;
    //ASCII_TOP_BASE   ['L'] = 0x06060600;
    //ASCII_BOTTOM_BASE['L'] = 0x007E0606;
    ASCII_TOP_BASE   ['M'] = 0x5A664200;
    ASCII_BOTTOM_BASE['M'] = 0x0042425A;
    //ASCII_TOP_BASE   ['N'] = 0x6E666200;
    //ASCII_BOTTOM_BASE['N'] = 0x00466676;
    ASCII_TOP_BASE   ['O'] = 0x66663C00;
    ASCII_BOTTOM_BASE['O'] = 0x003C6666;
    //ASCII_TOP_BASE   ['P'] = 0x66663E00;
    //ASCII_BOTTOM_BASE['P'] = 0x0006063E;
    //ASCII_TOP_BASE   ['Q'] = 0x42423C00;
    //ASCII_BOTTOM_BASE['Q'] = 0x007C6252;
    ASCII_TOP_BASE   ['R'] = 0x66663E00;
    ASCII_BOTTOM_BASE['R'] = 0x0066663E;
    ASCII_TOP_BASE   ['S'] = 0x1E067C00;
    ASCII_BOTTOM_BASE['S'] = 0x003E6078;
    //ASCII_TOP_BASE   ['T'] = 0x18187E00;
    //ASCII_BOTTOM_BASE['T'] = 0x00181818;
    //ASCII_TOP_BASE   ['U'] = 0x66666600;
    //ASCII_BOTTOM_BASE['U'] = 0x003C7E66;
    //ASCII_TOP_BASE   ['V'] = 0x66666600;
    //ASCII_BOTTOM_BASE['V'] = 0x00183C66;
    //ASCII_TOP_BASE   ['W'] = 0x42424200;
    //ASCII_BOTTOM_BASE['W'] = 0x00427E5A;
    ASCII_TOP_BASE   ['X'] = 0x3C666600;
    ASCII_BOTTOM_BASE['X'] = 0x0066663C;
    //ASCII_TOP_BASE   ['Y'] = 0x3C666600;
    //ASCII_BOTTOM_BASE['Y'] = 0x00181818;
    //ASCII_TOP_BASE   ['Z'] = 0x10207E00;
    //ASCII_BOTTOM_BASE['Z'] = 0x007E0408;
    ASCII_TOP_BASE   ['+'] = 0xFFFFFFFF;
    ASCII_BOTTOM_BASE['+'] = 0xFFFFFFFF;//temp for fill squre
}
void print_header(int y , int x) {
        draw_char('G', y , x+6);
        draw_char('A', y , x+7);
        draw_char('M', y , x+8);
        draw_char('E', y , x+9);
        draw_char(' ', y , x+10);
        draw_char('S', y , x+11);
        draw_char('C', y , x+12);
        draw_char('O', y , x+13);
        draw_char('R', y , x+14);
        draw_char('E', y , x+15);
        }
void clear_screen () {
    for(int x = 0; x<80; x++) {
        for(int y = 0; y<60 ; y++){
            draw_char(' ', 2*y, x);
        }
    }
}
void print_sqr () {
    for(int x = 0; x<80; x++) {
        draw_char('+', 0  , x);
        draw_char('+', 2*59, x);
    }
    for(int y = 0; y<60; y++) {
        draw_char('+', 2*y,  0);
        draw_char('+', 2*y, 79);
    }
}
void delay (int delay){
    while (delay>0)  { delay--;}
}

#define SNK_RIGHT 1
#define SNK_DOWN  2
#define SNK_UP    4
#define SNK_LEFT  8
#define SNK_SIZE  15
int new_direction(int cur_direction){
    int new_direction;
    new_direction = ARDUINO_IO_FGPA_STICKY[0];
    //if read a value that is not LEFT,RIGT,UP.DOWN
    if((new_direction != SNK_RIGHT) && (new_direction != SNK_UP) && (new_direction != SNK_LEFT) && (new_direction != SNK_DOWN)){
        new_direction = cur_direction;
    }
    // Cant go right from lest
    if((cur_direction == SNK_RIGHT) && (new_direction == SNK_LEFT)){
        new_direction = cur_direction;
    }
    // Cant go left from right
    if((cur_direction == SNK_LEFT) && (new_direction == SNK_RIGHT)){
        new_direction = cur_direction;
    }
    // Cant go donw from up
    if((cur_direction == SNK_UP) && (new_direction == SNK_DOWN)){
        new_direction = cur_direction;
    }
    // Cant go up from down
    if((cur_direction == SNK_DOWN) && (new_direction == SNK_UP)){
        new_direction = cur_direction;
    }

    return new_direction;
}
void snk_move (int direction, int *snk_x_pos, int *snk_y_pos, int size){
    for (int i =(size-1); i>0 ; i--){
        snk_x_pos[i] = snk_x_pos[i-1];
        snk_y_pos[i] = snk_y_pos[i-1];
    } //for
    if(direction == SNK_UP) {
        snk_x_pos[0] = snk_x_pos[1];
        snk_y_pos[0] = snk_y_pos[1] -1;
    } //if SNK_UP
    if(direction == SNK_DOWN) {
        snk_x_pos[0] = snk_x_pos[1];
        snk_y_pos[0] = snk_y_pos[1] + 1;
    } //if SNK_DOWN
    if(direction == SNK_LEFT) {
        snk_x_pos[0] = snk_x_pos[1] - 1;
        snk_y_pos[0] = snk_y_pos[1];
    } //if SNK_LEFT
    if(direction == SNK_RIGHT) {
        snk_x_pos[0] = snk_x_pos[1] + 1;
        snk_y_pos[0] = snk_y_pos[1];
    } //if SNK_RIGHT
    if(direction == 0) {
        snk_x_pos[0] = snk_x_pos[1] + 1;
        snk_y_pos[0] = snk_y_pos[1];
    } //if NO direction set
}
void print_snake (int hit, int *snk_valid, int *snk_x_pos, int *snk_y_pos, int size) {
    for(int i = 0; i<size; i++) {
        if(snk_valid[i]){
            draw_char('+', 2*snk_y_pos[i],  snk_x_pos[i]);
            if(snk_valid[i+1] == 0) {
                if(hit) {
                    snk_valid[i+1] = 1;
                    hit = 0;
                } else {
                    draw_char(' ', 2*snk_y_pos[i+1],  snk_x_pos[i+1]);
                }
            } 
        }
    }
}
int eat(int *snk_valid, int snk_x_pos, int snk_y_pos, int apple_x, int apple_y , int *apple_indx){
    int hit = ((snk_x_pos == apple_x) && (snk_y_pos == apple_y)) ? 1 : 0;
    if (hit) {
         *apple_indx = *apple_indx +1;
    }
    return hit;
}
int check_hit (int snk_x_pos, int snk_y_pos) {
    int kill = 0;
    if(snk_x_pos == 0)  kill = 1;
    if(snk_x_pos == 79) kill = 1;
    if(snk_y_pos == 0)  kill = 1;
    if(snk_y_pos == 59) kill = 1;
    return kill;
}
void new_apple (int * apple_x, int *apple_y){
    *apple_x = ((*apple_y/3)*(*apple_x) % 64) + 1;
    *apple_y = ((*apple_x/4)*(*apple_y) % 32) + 1;
}

void snake_game (){
    int snk_x_pos [SNK_SIZE];
    int snk_y_pos [SNK_SIZE];
    int snk_valid [SNK_SIZE];
    int direction = SNK_RIGHT;
    int apple_x = 5;
    int apple_y = 5;
    int apple_indx = 0;
    int hit_apple;
    int score = 0;
    int kill = 0;
    print_sqr();
    for(int i = 0; i < SNK_SIZE ; i ++) {
        snk_x_pos[i] = i+20;
        snk_y_pos[i] = 20;
        snk_valid[i] = (i<5) ? 1 : 0;
    }
    
    while (1)
    { 
        direction = new_direction(direction);
        if(kill == 0 ){
            snk_move(direction, snk_x_pos, snk_y_pos, SNK_SIZE);
        }
        hit_apple = eat(snk_valid, snk_x_pos[0], snk_y_pos[0], apple_x, apple_y, &apple_indx);
        if( hit_apple == 1 ) {
            new_apple(&apple_x, &apple_y);
            score++;
        }
        print_header(3,20);
        //print_apple
        draw_char('O', 2*apple_y,  apple_x);
        print_snake(hit_apple, snk_valid, snk_x_pos, snk_y_pos, SNK_SIZE);   
        //print_score
        draw_char((score+'0'), 3,  39);
        kill = check_hit(snk_x_pos[0], snk_y_pos[0]);
        hit_apple =0;

        delay(20000);
    }
    
}
int main() {
    int UniqeId  = CR_WHO_AM_I[0];
    set_table(); //temp - untill we can load backdoor the D_MEM the ascii table in FPGA
    clear_screen();
    switch (UniqeId) //the CR Address
    {
        case 0x4 : // Core 0 Thread 1
            snake_game();
        default :
            while(1); 
        break;
    }// case
return 0;

}
