Instructor: Dr. Thacker

University: Winthrop

Spring 2017 - CSCI 211

Due: Monday, April 10 2017

# Program

Write a program that reports how many instructions are executed between keyboard presses.
Outline of algorithm.

1. Poll the keyboard until a key is pressed.
2. Save the character pressed.
3. Initialize a counter with the number of instructions executed after the key was pressed and now.
4. Create a keyboard polling loop that increments a counter by the number of statements executed in the loop until another key is pressed.
5. Save the character pressed.
6. Output the 2 characters and the value of the counter.
 
Note: While testing, remember the counter can hold a value no greater than 231 - 1 (about 2 billion).  So, if you wait too long between presses, the counter will overflow and wrap around and give you strange answers.  That is ok and expected for now.
 
Extra credit: take care of the overflow/wraparound issue - be creative.
