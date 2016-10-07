//
//  main.c
//  sudoku
//
//  Created by Xuanyu Wang on 2016-10-07.
//  Copyright © 2016 Default Profile. All rights reserved.
//

//made by Mokrzycki M. with assist by T.B.
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <curses.h>

//           Autor: Mokrzycki Michal vel Mokszyk
//        Sudoku Generator, and then it hides some fields

struct sudoku { //name of the structure
    int p;          //the number of stores
    int b;          //responsible for displaying / hiding the hidden numbers in the table
};

void printout(struct sudoku tablica[9][9]){
    int i=0,j=0;
    
    printf("U K R Y T A  T A B L I C A\n");
    for(i=0;i<9;++i){
        for(j=0;j<9;++j){
            if(tablica[i][j].b==0){
                printf(". ");
            } //nic nie ma
            else printf("%d ", tablica[i][j].p);
            if(j==2 || j==5) printf("| ");
            if(i==2 && j==8 || i==5 && j==8) printf("\n- - - - - - - - - - -");
        }
        printf("\n");
    }
}

int sudoku(struct sudoku tablica[9][9],int x, int y){
    int tab[9] = {1,1,1,1,1,1,1,1,1};//same ones
    int i,j;

    for(i=0;i<y;++i){//checks x;sy
        tab[tablica[x][i].p-1]=0; //if it is to give 0
    }
    
    for(i=0;i<x;++i){//checks y'ki
        tab[tablica[i][y].p-1]=0; //if it is to give 0
    }

    for(i=(3*(x/3));i<(3*(x/3)+3);++i){
        for(j=(3*(y/3));j<y;++j){
            tab[tablica[i][j].p-1]=0; //checks what the number is and inserts a 0 if it can no longer be put
        }
    }

    int n=0;
    for(i=0;i<9;++i){
        n=n+tab[i];//checks the size table
    }
    printf("n = %d\n", n);
    printout(tablica);
    
    int *tab2; //new array of size n
    tab2=(int*)malloc(sizeof(int)*n);
    
    j=0; //You will be required to indicate the point
    for(i=0;i<9;++i){
        if(tab[i]==1){
            tab2[j]=i+1;
            j++;
        }
    }
    
    int ny, nx;// They are responsible for the items
    
    if(x==8){
        ny=y+1; //larger y'k
        nx=0;   //resets x to move to the next line, "then"
    }
    else {
        ny=y; //no change
        nx=x+1;//We move to the right
    }
    
    while(n>0){
        int index = rand()%n;//draws index of the array of numbers
        tablica[x][y].p=tab2[index];//assigns to the array x y draw a number from Table 2 with the index []
        tab2[index]=tab2[n-1];
        
        n--;
        
        if(x==8 && y==8) {
            free(tab2);
            return 1;
        }
        
        if (sudoku(tablica,nx,ny)==1){
            free(tab2);
            return 1;
        } //It returns 1 if it means we did it again a new Random
    }
    free(tab2);
    return 0;
}

void show(struct sudoku tablica[9][9]){ //show tables in which you had not hidden numbers, enter a valid table
    int i=0,j=0;
    printf("\nP R A W I D L O W A  T A B L I C A\n\n");
    
    for(i=0;i<9;++i){
        for(j=0;j<9;++j){
            if(j==2 || j==5) printf("| ");
            if(i==2 && j==8 || i==5 && j==8) printf("\n- - - - - - - - - - -");
            
        }
        
        printf("\n");
    }
}


void hide(struct sudoku tablica[9][9]){//hide numbers
    int i=0,j=0;//zmienne potrzebne
    
    for(i=0;i<9;++i){//robie zeby ukryte pola byly zresetowane
        for(j=0;j<9;++j){
            tablica[i][j].b=1;
        }
    }
    
    for(i=0;i<28;++i){
        tablica[rand()%9][rand()%9].b=1;
    }
}






int main(){
    srand(time(NULL));
    struct sudoku tablica[9][9];//[x][y]
    int i, j;
    for (i = 0; i < 9; i++) {
        for (j = 0; j < 9; j++) {
            tablica[i][j].p = 0;
            tablica[i][j].b = 1;
        }
    }
    //hide(tablica);

    sudoku(tablica,0,0);
    //printf("wypisz\n");
    printout(tablica);
    //printf("pokazt\n");
    //show(tablica);
    
    //getch();
    return 0;
}