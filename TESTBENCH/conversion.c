#include <math.h>
#include <stdio.h>

typedef union{
    float f;
    struct{
        // Order is important.
        // Here the members of the union data sstructure
        // use the same memory (32 bits).
        // The ordering is taken
        // form the LSB to the MSB
        unsigned int mantissa : 23;
        unsigned int exponent : 8;
        unsigned int sign : 1;
    } raw;
} myFloat;

// Function to convert a binary array
// to the corresponding intenger
myFloat  convert2int(unsigned int* arr){
    myFloat var;
    var.raw.sign = arr[0];
    f = 0;
    for(int i = 8; i>=1; i--){
        f += arr[i]*pow(2,8 - i);
    }
    var.raw.exponent = f;
    f = 0;
    for(int i = 31; i >= 9; i--){
        f += arr[i]*pow(2,31-i);
    }
    var.raw.mantissa = f;
    return var;
}

void convert2IEEE(myFloat var, unsigned int* arr){
    arr[0] = var.raw.sign;
    for(unsigned int k = 7; k>=0; k--){
        if((var.raw.exponent >> k) & 1)
            arr[8-k] = 1;
        else
            arr[8-k] = 0;
    }
    for(int k = 22; k >= 0; k--){
        if((var.rae.exponent >> k) & 1)
            arr[31-k] = 1;
        else
            arr[31-k] = 0;      
    }
}   
