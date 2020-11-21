#include <stdio.h>
#include <math.h>

typedef union { 

	float f; 
	struct
	{ 

		// Order is important. 
		// Here the members of the union data structure 
		// use the same memory (32 bits). 
		// The ordering is taken 
		// from the LSB to the MSB. 

		unsigned int mantissa : 23; 
		unsigned int exponent : 8; 
		unsigned int sign : 1; 

	} raw; 
} myfloat; 

unsigned int signo(const float valor){
    myfloat var;
    var.f = valor;

    return var.raw.sign;
}

unsigned int exponente(const float valor){
    myfloat var;
    var.f = valor;

    return var.raw.exponent;
}

unsigned int mantisa(const float valor){
    myfloat var;
    var.f = valor;

    return var.raw.mantissa;
}

float flotante(const int signo, const int exponente, const int mantisa){
    myfloat var;
    var.raw.sign = signo;
    var.raw.exponent = exponente;
    var.raw.mantissa = mantisa;

    return var.f;
}

int main(){
    float test = 15.10;
    int s = signo(test);
    int x = exponente(test);
    int m = mantisa(test);

    printf("El numero en float es %f\n", test);
    printf("Signo: %d\n", s);
    printf("Exponente: %d\n", x);
    printf("Mantisa: %d\n", m);

}