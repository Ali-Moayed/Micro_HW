/*
 * Elevator.c
 *
 * Created: 3/6/2019 11:12:32 PM
 * Author: MSI
 */
//#include <mega16.h>
#include <io.h>

int chosenFloor;
int currentFloor;

int up[4] = {0,0,0,0};
int down[4] = {0,0,0,0};

int condition;

void GoUp(){
    PORTD.0 = 1;
    PORTD.1 = 0;            
}
void GoDown(){
    PORTD.0 = 0;
    PORTD.1 = 1;            
}
int isGoingUp(){
    if((PORTD.0 == 1) && (PORTD.1 == 0) && (currentFloor != 3))
        return 1;
    return 0;
}
int isGoingDown(){
    if((PORTD.0 == 0) && (PORTD.1 == 1) && (currentFloor != 1))
        return 1;
    return 0;
}

void main(void)
{
    DDRA = 0xF0;
    DDRB = 0x00;
    DDRC = 0x00;
    DDRD = 0xFF; 
    
    chosenFloor = 0;

    if(PINB.2 == 1){
        currentFloor = 3;
    }else if(PINB.1 == 1){
        currentFloor = 2;
    }else if(PINB.0 == 1){
        currentFloor = 1;
    }
    
    if(PINC.0 == 1){
        condition = 1;   
    }else if(PINC.1 == 1){
        condition = 2;
    }else if(PINC.2 == 1){
        condition = 3;
    }

    while (1){
        //Check current floor
        if(PINB.2 == 1){
            currentFloor = 3;
        }else if(PINB.1 == 1){
            currentFloor = 2;
        }else if(PINB.0 == 1){
            currentFloor = 1;
        }
        
        //Check current condition
        if(PINC.0 == 1){
            condition = 1;   
        }else if(PINC.1 == 1){
            condition = 2;
        }else if(PINC.2 == 1){
            condition = 3;
        }
        
        //Check chosen floor
        if(PINA.0 == 1 || PINC.3 == 1){
            chosenFloor = 3;
            if((currentFloor != chosenFloor) && (PINA.0 == 1))
                PORTA.4 = 1;
        }else if(PINA.1 == 1 || PINA.2 == 1 || PINC.4 == 1){
            chosenFloor = 2;
            if(currentFloor != chosenFloor){
                if(PINA.1 == 1)
                    PORTA.5 = 1;
                else if(PINA.2 == 1)
                    PORTA.6 = 1;
            }
        }else if(PINA.3 == 1 || PINC.5 == 1){
            chosenFloor = 1;
            if((currentFloor != chosenFloor) && (PINA.3 == 1))
                PORTA.7 = 1;
        }
        
        if((isGoingUp() == 1) && (currentFloor == 2)){
            up[2] = 0;
            PORTA.5 = 0;
        }else if((isGoingDown() == 1) && (currentFloor == 2)){
            down[2] = 0;
            PORTA.6 = 0;
        }else if(currentFloor == 1){
            down[1] = 0;
            up[1] = 0;
            PORTA.7 = 0;
        }else if(currentFloor == 3){
            down[3] = 0;
            up[3] = 0;
            PORTA.4 = 0;
        } 

        if((up[0]+up[1]+up[2]+up[3]+down[0]+down[1]+down[2]+down[3]) == 0){
            PORTD.0 = 0;
            PORTD.1 = 0;                                                                      
        }
        
        if(chosenFloor != 0){
            if(currentFloor != chosenFloor){
                switch (currentFloor > chosenFloor) {
                case 1 :
                    down[chosenFloor] = 1;
                    break;
                case 0 :
                    up[chosenFloor] = 1;
                    break;
                break;
                       
                default:
                }
            }
            chosenFloor = 0;
        }
        
        if(PORTA.5 == 1)
            up[2] = 1;
        if(PORTA.6 == 1)
            down[2] = 1; 
        
        if((isGoingUp() == 0) && (isGoingDown() == 0) && (condition != 3)){
            if(currentFloor == 1){
                if((up[2] == 1) || (up[3] == 1))
                    GoUp();
            }else if(currentFloor == 2){
                PORTA.5 = 0;
                PORTA.6 = 0;
                if(up[3] == 1)
                    GoUp();
                else if(down[1] == 1)
                    GoDown();
            }else if(currentFloor == 3){
                if((down[1] == 1) || (down[2] == 1))
                    GoDown();
            }
        }
        
        
        
        //Display
        if(PINB.2 == 1){
            PORTD.6 = 1;
            PORTD.7 = 1;
        }else if(PINB.1 == 1){
            PORTD.6 = 1;
            PORTD.7 = 0;
        }else if(PINB.0 == 1){
            PORTD.6 = 0;
            PORTD.7 =1;
        } 
    }
}
