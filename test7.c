// Program to perform basic arithmetic and display results

int mainVar = 0;
float pi = 3.14159;
char letter = 'C';
char* greeting = "Hello World";

// Initialize some integers
int a = 10;
int b = 20;
int c = 0;

// Compute sum and difference
c = a + b;
c = c - 5;

// Increment and decrement
c++;
c--;

// Conditional statements
if (c > 20) {
    mainVar = c;
} else if (c == 15) {
    mainVar = 0;
} else {
    mainVar = -1;
}

// Loop examples
for (int i = 0; i < 5; i++) {
    c += i;
}

int j = 0;
while (j < 3) {
    mainVar += j;
    j++;
}

// Logical operations
int flag = 1;
if (flag && c != 0) {
    letter = 'D';
}

// More operations
float result = pi * a / b;
result += 2.5e2;   // floating-point with exponent

/* Multi-line comment
   with some explanation
   about the program
*/

// Print simulated outputs (just variable usage)
char* msg = "Computation done.";
int x = 100;
x = x / 2 + mainVar;
