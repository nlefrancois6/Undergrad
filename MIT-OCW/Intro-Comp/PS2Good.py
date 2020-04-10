#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr  9 21:38:07 2020

@author: noahlefrancois
"""

import os
import re
import random
import string

os.chdir('/Users/maureenpollard/Documents/School/MITOCW/Comp1/ps2')

WORDLIST_FILENAME = "words.txt"


def load_words():
    """
    Returns a list of valid words. Words are strings of lowercase letters.
    
    Depending on the size of the word list, this function may
    take a while to finish.
    """
    print("Loading word list from file...")
    # inFile: file
    inFile = open(WORDLIST_FILENAME, 'r')
    # line: string
    line = inFile.readline()
    # wordlist: list of strings
    wordlist = line.split()
    print("  ", len(wordlist), "words loaded.")
    return wordlist



def choose_word(wordlist):
    """
    wordlist (list): list of words (strings)
    
    Returns a word from wordlist at random
    """
    return random.choice(wordlist)


def is_word_guessed(secret_word, letters_guessed):
    '''
    secret_word: string, the word the user is guessing; assumes all letters are
      lowercase
    letters_guessed: list (of letters), which letters have been guessed so far;
      assumes that all letters are lowercase
    returns: boolean, True if all the letters of secret_word are in letters_guessed;
      False otherwise
    '''
    for letter in secret_word:
        if letter not in letters_guessed:
            return False
    else:
        return True



def get_guessed_word(secret_word, letters_guessed):
    '''
    secret_word: string, the word the user is guessing
    letters_guessed: list (of letters), which letters have been guessed so far
    returns: string, comprised of letters, underscores (_), and spaces that represents
      which letters in secret_word have been guessed so far.
    '''
    secr = list(secret_word)
    stuff = ['_ ' ]* len(secret_word)
    for letter in letters_guessed:
        for i in range(len(secret_word)):
            if secr[i] == letter:
                stuff[i] = letter
    stuff = ' '.join(stuff)
    print(letters_guessed)
    return stuff
def get_available_letters(letters_guessed):
    '''
    letters_guessed: list (of letters), which letters have been guessed so far
    returns: string (of letters), comprised of letters that represents which letters have not
      yet been guessed.
    '''
    alph = string.ascii_lowercase
    alphabet = list(alph)
    for letter in letters_guessed:
        for i in range(len(alphabet)):
            if alphabet[i] == letter:
                alphabet[i] = ''
    alph = ''.join(alphabet)
    return alph

insults = ['sniveling sauerkraut snorting dumbass',
           'cotton headed ninnymuggins', 
           'four-eyed freakadelic fuzzmuzzler', 
           'nail polish-sniffing boot-licking KFC wannabe', 
           'froggy fresh hatin jimmy butler dunkin on lookin infant', 
           'Concordia student', 
           'illegitimate english muffin concocting boogerbutt',
           'incapably illuminated pollution interfered interface optical illusion',
           'tree-hugging cross-country ski incineration furnishing maple syrop wannabe',
           "sock wearing stamp collecting pony-obsessed momma's boy",
           'ballerina-dance benchwarmer tapeworm lover from Winnipeg',
           "saucy sheep-biting nuthook",
           "artless elf-skinned hedgepig",
           "bootless hell-hated mino",
           "frothy flat-mouthed fustilarian",
           "puny onion-eyed meatle"]
#print(insults)

def yo_mama():
    return random.choice(insults)

def hangman():
    
    wordlist = load_words()
    
    WORD = choose_word(wordlist)
    while len(WORD) > 6:
        WORD = choose_word(wordlist)
    guesses_left = 6
    alph = string.ascii_lowercase
    guessed = []
    insult = yo_mama()
    warning = 3
    vowels = 'aeiou'
    win = False
    unique = len(set(WORD))
    
    print("Welcome to the game Hangman!")
    print("I'm thinking of a word that is " + str(len(WORD)) + " letters long.")
    print("----------")
    while guesses_left > 0:
        skip = False
        available = get_available_letters(guessed)
        print("You have " + str(guesses_left) + " guesses left.")
        print("Available letters: " + available)
        guess = input('Please guess a letter:')
        guess = guess.lower()
        if guess in guessed:
            print("Oops! You have already guessed that letter.")
            skip = True
            if warning == 0:
                guesses_left -= 1
            if warning > 0:
                warning -= 1
            warnings = str(warning)
            print("You have " + warnings + " warnings left") 
            print(display)
        guessed.append(guess)
        display = get_guessed_word(WORD, guessed)
        if guess not in alph:
            print("Oops! That's not a valid letter! Please guess a letter")
            skip = True
            if warning == 0:
                guesses_left -= 1
            if warning > 0:
                warning -= 1
            warnings = str(warning)
            print("You have " + warnings + " warnings left")
            print(display)
        if guess in WORD and skip == False:
            skip = True
            print("Good guess: " + display)
        if guess not in WORD and skip == False:
            print("Oops! That letter is not in my word: " + display)
            if guess in vowels:
                guesses_left -= 2
            else:
                guesses_left -= 1
        if is_word_guessed(WORD, guessed) == True:
            print("The word is " + WORD + "!")
            print("Congratulations! You won! Does that make you feel slightly less insignificant in the face of the universe's unfathomable vastness and your resultant relative unimportance?")
            win = True
            score = guesses_left * unique
            print("Your score is " + str(score))
            break
    if win == False:
        print("Game Over! You ran out of guesses.")
        print("The word is " + WORD + " you " + insult)

def match_with_gaps(my_word, other_word):
    '''
    my_word: string with _ characters, current guess of secret word
    other_word: string, regular English word
    returns: boolean, True if all the actual letters of my_word match the 
        corresponding letters of other_word, or the letter is the special symbol
        _ , and my_word and other_word are of the same length;
        False otherwise: 
    '''
    my = my_word
    other = other_word
    my = re.sub('[ ]', '', my)
    my = re.sub('[_]', ' ', my)
    
    if len(my) != len(other):
        return False
    for i in range(len(my)):
        if my[i] != ' ':
            if my[i] != other[i]:
                return False
    else:
        return True

def show_possible_matches(my_word):
    '''
    my_word: string with _ characters, current guess of secret word
    returns: nothing, but should print out every word in wordlist that matches my_word
             Keep in mind that in hangman when a letter is guessed, all the positions
             at which that letter occurs in the secret word are revealed.
             Therefore, the hidden letter(_ ) cannot be one of the letters in the word
             that has already been revealed.

    '''
    possible = []
    wordlist = load_words()
    for x in wordlist:
        if match_with_gaps(my_word, x) == True:
            possible.append(x)
    print("There are " + str(len(possible)) + " possible matches:")
    print(possible)
    
def hangman_with_hints():
    '''
    secret_word: string, the secret word to guess.
    
    Starts up an interactive game of Hangman.
    
    * At the start of the game, let the user know how many 
      letters the secret_word contains and how many guesses s/he starts with.
      
    * The user should start with 6 guesses
    
    * Before each round, you should display to the user how many guesses
      s/he has left and the letters that the user has not yet guessed.
    
    * Ask the user to supply one guess per round. Make sure to check that the user guesses a letter
      
    * The user should receive feedback immediately after each guess 
      about whether their guess appears in the computer's word.

    * After each guess, you should display to the user the 
      partially guessed word so far.
      
    * If the guess is the symbol *, print out all words in wordlist that
      matches the current guessed word. 
    
    Follows the other limitations detailed in the problem write-up.
    '''
    wordlist = load_words()
    
    WORD = choose_word(wordlist)
    while len(WORD) > 6:
        WORD = choose_word(wordlist)
    guesses_left = 6
    alph = string.ascii_lowercase
    guessed = []
    insult = yo_mama()
    warning = 3
    vowels = 'aeiou'
    win = False
    unique = len(set(WORD))
    
    print("Welcome to the game Hangman!")
    print("I'm thinking of a word that is " + str(len(WORD)) + " letters long.")
    print("----------")
    while guesses_left > 0:
        skip = False
        available = get_available_letters(guessed)
        print("You have " + str(guesses_left) + " guesses left.")
        print("Available letters: " + available)
        guess = input('Please guess a letter:')
        guess = guess.lower()
        if guess in guessed and guess != '*':
            print("Oops! You have already guessed that letter.")
            skip = True
            if warning == 0:
                guesses_left -= 1
            if warning > 0:
                warning -= 1
            warnings = str(warning)
            print("You have " + warnings + " warnings left") 
            print(display)
        guessed.append(guess)
        display = get_guessed_word(WORD, guessed)
        if guess not in alph:
            skip = True
            if guess == '*':
                print("Here are the possible words matching your guesses:")
                matches = show_possible_matches(display)
                print(matches)
            else:
                print("Oops! That's not a valid letter! Please guess a letter")
                if warning == 0:
                    guesses_left -= 1
                if warning > 0:
                    warning -= 1
                warnings = str(warning)
                print("You have " + warnings + " warnings left")
                print(display)
        if guess in WORD and skip == False:
            skip = True
            print("Good guess: " + display)
        if guess not in WORD and skip == False:
            print("Oops! That letter is not in my word: " + display)
            if guess in vowels:
                guesses_left -= 2
            else:
                guesses_left -= 1
        if is_word_guessed(WORD, guessed) == True:
            print("The word is " + WORD + "!")
            print("Congratulations! You won! Does that make you feel slightly less insignificant in the face of the universe's unfathomable vastness and your resultant relative unimportance?")
            win = True
            score = guesses_left * unique
            print("Your score is " + str(score))
            break
    if win == False:
        print("Game Over! You ran out of guesses.")
        print("The word is " + WORD + " you " + insult)
        
hangman_with_hints()