# Reverse Engineering Project README

### Author: Andrew Skelly
### Student Number: C00261511

### Project Description:
>This project is a simple assembly program that can be run from the terminal that prompts the  
>user to input some random text with a max length of 23 characters. This text can be a mix of  
>upper and lowercase characters. When the user enters the text, the assembly program will take  
>in the text and reverse the case of any valid characters contained in the text. The case swapped
>text is then returned to the user.
 
### Producing the executable:
> - To produce an executable from  the .asm file, open a terminal and ensure nasm is installed
> - Navigate to the directory that the .asm file is located in
> - Run the following command:
> 
>
>   ``nasm -f elf64 swapCase.asm -o swapCase.o``
>
>  - This command should execute properly. It will not give any visual confirmation that it has worked directly, but this  
>   can be checked by using the ``ls`` command and checking to see if a swapCase.o file has been created.
>  - Next, run the following command to link the object file:
> 
>
> ``ld swapCase.o -o swapCase``
> 
> - This will create an executable file called swapCase in the directory that the command was executed
> - Run the file like so:
> 
> 
> ``./swapCase``
