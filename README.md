# Pstrings Library - Assignment

This project implements a simple string library in Assembly, designed for a Data Structures course. The main goal of the assignment is to create a set of functions that operate on custom "Pstring" types. These functions will be called by the `run_func` function based on user input, and the library will provide operations such as calculating string lengths, swapping case, copying substrings, and concatenating strings.

## File Structure

- **pstrings.h**: Header file where the main structure of the program and the library functions are declared.
- **main.c**: Contains the main function which interacts with the user and calls the appropriate functions.
- **Makefile**: Build script to compile the project.
- **pstring.s**: Assembly file where core string operations are implemented.
- **func_select.s**: Assembly file responsible for executing functions based on user input.

## Functions Implemented in Assembly

### 1. `pstrlen`
- **Input**: Pointer to a Pstring.
- **Output**: Returns the length of the string.

### 2. `swapCase`
- **Input**: Pointer to a Pstring.
- **Output**: Modifies the string by swapping its case (capital to lowercase and vice versa).

### 3. `pstrijcpy`
- **Input**: Two Pstring pointers, `i` and `j` indices for the substring.
- **Output**: Copies a substring from one Pstring to another, with indices `i` and `j`. If invalid indices are provided, prints an error message.

### 4. `pstrcat`
- **Input**: Two Pstring pointers.
- **Output**: Concatenates the second string to the first, provided the combined length does not exceed 254 characters. Prints an error if the concatenation is not possible.

## `run_func` Behavior

The `run_func` function, implemented in `func_select.s`, receives the user’s choice and performs one of the following operations:

- **Choice 31**: Calls `pstrlen` and prints the lengths of both Pstrings.
- **Choice 33**: Calls `swapCase` and prints the modified Pstrings.
- **Choice 34**: Prompts the user for start and end indices, then calls `pstrijcpy` and prints the modified Pstrings.
- **Choice 37**: Calls `pstrcat` to concatenate the strings and prints the result.
- **Other choices**: Prints `"invalid option!"`.

## How It Works

1. **Input**: The user provides two Pstrings, specifying their length and characters. Then, a menu with options for string operations is displayed.
2. **Operations**: Based on the user’s choice, one of the functions (e.g., `pstrlen`, `swapCase`, etc.) is called, and the result is printed.
3. **Output**: Depending on the choice, the output will display the length of the strings, the modified strings, or an error message.


## Notes

- All functions are implemented in Assembly language.
- The library does not use `string.h` functions, relying only on basic C library functions (`scanf`, `printf`).
- Strings have a maximum length of 254 characters.
- The stack is used for storing variable values (no dynamic memory allocation).
- Ensure correct handling of calling conventions, and make sure each function includes a prolog and epilog.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/pstrings-library.git

2. Compile the code:
 ```bash
      make
   

3. Run the program:
 ```bash
   ./pstrings
