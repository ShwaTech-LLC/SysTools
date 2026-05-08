# ################################################################################################# #
#                                                                                                   #
#  1. Getting Started                                                                               #
#                                                                                                   #
# ################################################################################################# #

# Welcome to the ShwaTech Python Primer!
# This primer was authored by hand by Christian Holslin and was last updated on February 15, 2026.
# 
# We will start with the basic syntax of the language and work our way up
# You will notice these lines that start with a hashtag
# These are comments in Python, they will be ignored by the interpreter
# Comments allow you to explain what your code is doing

# ###################################################### #
#   Syntax & Scope                                       #
# ###################################################### #

hello_world = 'Hello, world!'   # Python is a script language
print(hello_world)              # Each line is an instruction to the interpreter

# Python allows you to combine instructions onto a single line using the ; operator

hello_world = 'Hello again, world!'; print(hello_world)

# Python allows you to carry instructions onto subsequent lines with the \ operator

hello_world = \
'Hello again there, world!'
print(hello_world)

# Scope in Python is defined by indentation

the_number_seven = 7        # This is at the top scope
if the_number_seven != 7:   # Conditional scopes like ifs...
  print('Oops!')            # Get indented with tab or spaces

# Function variables do not persist outside of the function scope

def do_math(*a):
  math_result = sum(a)    # math_result goes out of scope after the function call
  return math_result      # Therefore we must return it to the caller

# ###################################################### #
#   Namespaces & External References                     #
# ###################################################### #

# Python defines everything you do in your base script as the local namespace

i_like_bacon = True    # i_like_bacon is defined in the local namespace
print(i_like_bacon)    # So we can pass it to print as-is

# When you import a module it gets assigned a namespace name

import math         # Here we import the math module which keeps the same namespace name
math.sqrt(654.23)   # Then we use the math namespace to call the sqrt function
                    # sqrt() is not a method because math is a namespace, not an object

# You can also alias the import of a module to avoid collisions

import statistics as stat_man                   # Here we import statistics with the alias stat_man
stat_man.mean([1,2,3,4,4,4,5,6,7,7,7,7,8,8])    # We can call statistics functions with the stat_man prefix

# Importing with the from keyword imports functions into the local namespace
# Importing using from can be limited or unlimited in scope

from base64 import *     # This imports everything from the base64 module into the local namespace
                         # Generally you would avoid doing this because it's almost always unnecessary

from json import dumps   # This imports only the dumps function from the json module
dumps([1,2,3,4,5])       # When you import a single function from a module it gets loaded into the local namespace

from json import dumps as convert_to_json   # As such, individual functions imported into the local
convert_to_json([1,2,3,4,5])                # namespace can also be aliased to avoid conflicts

from json import load, detect_encoding  # You can import multiple items with a single import statement

# Python scripts in the same directory can be imported using their filename without the file extension

from python_primer_refs import three_blind_mice   # This is python_primer_ref.py in the current directory
three_blind_mice()                                # We can import this function into the local namespace and call it

# ###################################################### #
#   Variables, Functions & Methods                       #
# ###################################################### #

# A variable is a name to which you assign a value using the assignment (=) operator

my_variable = 'Christian'

# Variables cannot start with a number or token, they should generally start with a letter

one_more_time = 'One More Time'  # This is legal
# 1_more_time = 'illegal'        # This is illegal, so we commented it out
# $_in_pocket = 42.50            # This is also illegal

# Variables declared at lower scopes persist at higher scopes

the_number_eight = 8                          # Here we declare the_number_eight
if the_number_eight == 8:                     #
  the_number_nine = 9                         # Here we declare the_number_nine inside an if scope
print('The number nine is:',the_number_nine)  # After the if we can still access the_number_nine

# This, however, does not apply to function scopes

def goes_out_of_scope(my_name):
  also_my_name = my_name
# print(also_my_name)             # also_my_name does out of scope because it was declared in a function scope

# Functions are invoked using parenthesis like this

sum( [3,5,2,7] )   # Calculates the sum of the numbers in the List
                   # sum() is called a built-in function

# Functions that are part of an object are called methods, they are invoked with the dot (.) operator

[3,5,2,7].append(4)           # Calling the append() method on a List literal
'Hello, {}!'.format('world')  # Calling the format() method on a String literal
one_more_time.count('One')    # Calling the count() method on a String variable

# Variables can be assigned and reassigned to any value at run-time regardless of type

some_thing = 12
some_thing = 'Twelve'
some_thing = 7.5
some_thing = [1,1,2,2,3,4,5]
some_thing = range(9)

# ###################################################### #
#   Primitives & Literals                                #
# ###################################################### #

# A primitive or literal in Python is a static value specified directly, such as the following:

my_name = 'Christian Holslin' # String literal (word or words in single quotes)
my_company = "ShwaTech LLC"   # String literal (word or words in double quotes)
my_age = 43                   # Integer literal
my_favorite_number = 7.0      # Float literal
am_i_awesome = True           # Boolean literal (True/False)
this_is_null = None           # Null (Unassigned) literal
                              # Multiline String literal, below
my_life_story = """
A long, long time ago...
In an In'N'Out Burger far far away...
"""

# Python supports escape sequences in String literals

'\n'  # Newline
'\t'  # Tab
'\"'  # Double Quotation Mark
'\''  # Single Quotation Mark

# Python supports collection literals of four (4) different built-in types

my_parents = ['Mom','Dad']             # List (indexable & iterable)
my_hobbies = ('Golf','Motorcycles')    # Tuple (immutable, indexable & iterable)
my_friends = {'Alice':29,'Bob':41}     # Dictionary (key/value pairs, all keys must be unique)
my_skills = {'Python','C','C++','C#'}  # Set (immutable + all items MUST be unique)

# Collection literals can be combined into complex collections

my_parents = [{'Mom':'Alice','Age':65},{'Dad':'Bob','Age':67}]  # List of Dictionaries
my_parents = {'Mom':['Alice',65],'Dad':['Bob',67]}              # Dictionary of Lists

# Not all combinations are compatible
# You cannot create a Set of Lists or Dictionaries because neither a List nor Dictionary can be hashed
# my_skills = {['Python','C','C++','C#'],['Cooking','Baking','Sauce Prep']}
# my_skills = {{'Mom':'Alice','Age':65},{'Dad':'Bob','Age':67}}

# But you can create a Set of Tuples
my_skills = {('Python','C','C++','C#'),('Cooking','Baking','Sauce Prep')}

# ###################################################### #
#   Arithmetic                                           #
# ###################################################### #

# Common arithmetic operators include

x = 1 + 1   # Addition
x = 1 - 1   # Subtraction
x = 1 * 1   # Multiplication
x = 1 / 1   # Division
x = 1 % 1   # Modulo
x = 1 ** 1  # Exponentiation
x = 1 // 1  # Division with Floor

# The Python interpreter obeys PEMDAS

x = 2 * (2 + 2) + 2 + 2 - 2 * 2 / 2 ** 2  # This operation
x = 2 * 4 + 2 + 2 - 2 * 2 / 2 ** 2        # Simplfies to this
x = 8 + 2 + 2 - 2 * 2 / 2 ** 2            # Which simplifies to this
x = 12 - 2 * 2 / 2 ** 2                   # Which simplifies to this
x = 12 - 2 * 2 / 4                        # Which simplifies to...
x = 12 - 4 / 4                            # Which simplifies to...
x = 12 - 1                                # Which becomes...
x = 11                                    # x = 11

# Division will cause the expression to become a float

# ###################################################### #
#   Random Numbers                                       #
# ###################################################### #

# Python includes a random module with generators for random umbers

import random
random.choice([1,2,3,4,5,6])    # Choice picks a random item from the list
random.randint(0,99)            # Randint creates a random number between a and b

# This List comprehension fills a List with 1000 random integers between 0 and 99999
random_numbers = [random.randint(0,99999) for n in range(1000)]

# ###################################################### #
#   Boolean Logic                                        #
# ###################################################### #

# Python supports standard arithmetic boolean comparion operators

5 == 1   # Equality
5 > 1    # Greater than
5 < 1    # Less than
5 <= 5   # Less than or equal
5 >= 5   # Greater than or equal
5 != 5   # Not equal

# Python supports standard boolean logic operators and, or and not

(2 < 3) and (5 < 4)   # x is False
(2 < 3) or (5 < 4)    # x is True
not (2 < 3)           # x is False

# Comparison operators work on primitives and collections

5 == 5                   # Compare two Ints
'Christian' == 'Peter'   # Compare two Strings
['a','b'] == ['a','b']   # Compare two Lists
('a','b') == ('a','b')   # Compare two Tuples

# String comparisons are case-sensitive

'Christian' == 'cHrisTian'   # This is False
'Christian' == 'Christian'   # This is True

# Boolean expressions are evaluted conditionally from left to right

empty_list = []
if len(empty_list) > 0 and empty_list[0] % 2 == 0:   # There are two Boolean expressions here.
  print('empty_list should be empty')                # empty_list[0] is normally illegal, but because
                                                     # the first expression is False and the condition is
                                                     # 'and' then the right-hand expression is not
                                                     # evaluated, avoiding an IndexError

# ################################################################################################# #
#                                                                                                   #
#  2. Basic Operations                                                                              #
#                                                                                                   #
# ################################################################################################# #

# ###################################################### #
#   String Manipulation                                  #
# ###################################################### #

# Python allows you to combine strings together with concatenation

x = 'Christian' + ' Holslin'        # Concatenante two Strings
x += ' is awesome'                  # Append a String to a String
x = 'Christian'.join(['Holslin'])   # Append a List of Strings using the first String as the delimiter
x = '.'.join(['a','b','c'])         #   Results in 'a.b.c'

# Python has a syntax called f strings which are formatted strings

cash_on_hand = 32.75                               # Using a variable...
print(f'You have ${cash_on_hand} cash on hand.')   # embed that variable's value into a string using curly braces

# Python strings are Lists of characters, they are iterable and can be indexed

my_name = 'Christian'                   # Here is my first name
my_name_len = len(my_name)              # Get the length of my_name
my_first_initial = my_name[0]           # Index the first letter for my first initial
my_nick_name = my_name[0:5]             # Slice the first 5 letters for my nickname
jibberish = my_name[-5:-1]              # Negative indeces also work on strings
for letter in my_name: print(letter)    # Iterate the characters in my name
my_list = []                            # Make an empty List
my_list += my_name                      # Each letter in my name is added as an item in this List
fav_quote = "\"Elementary, my dear.\""  # Escape special characters with '\'
list(map(lambda x: x.upper(), 'test'))  # Strings can be mapped because they are iterable
'Chris' in my_name                      # The in operator will test for a substring

# Python strings are immutable, so changes are illegal
# my_name[0] = 'F'   # This throws a TypeError

# Python has methods for strings which perform actions on the string itself

'Hello, world!'.find('world')      # Find locates the index of a substring in a String
'{}, {}!'.format('Hello','world')  # Format creates a 'formatted' string => 'Hello, world!'
':'.join(['hello','world'])        # Join a List with a delimiter into a String => 'hello:world'
'Hello World'.lower()              # Lower converts all letters to lowercase
'Hello, world!'.replace('l','f')   # Replace replaces part of a String with another String
'sauce cheese pesto'.split()       # Split breaks a string into a List using spaces as the delimeter
'sauce:cheese:pesto'.split(':')    # Split accepts a delimiter to break a String into a List
' Hello, world! '.strip()          # Strip removes whitespace at the beginning and end of a string
'*Hello, world!*'.strip('*')       # Strip also accepts a String for leading and trailing removal
'enterprise architect'.title()     # Title creates a Title Case string => 'Enterprise Architect'
'Hello World'.upper()              # Upper converts all letters to UPPERCASE

# Python string formatting supports keyword parameters

def email_signature(n,t,pn):
  return '{name}, {title} ({phone_number})'.format(name=n,title=t,phone_number=pn)

# ###################################################### #
#   List Operations                                      #
# ###################################################### #

# Python Lists are dynamic collections of any item

backpack = ['laptop','charger',23.50,['gum','mints']]   # Make a List of stuff in my backpack
backpack = backpack + ['pen']                           # Add a pen to my backpack, note the pen is in a List
backpack += ['paper','phone']                           # Add two more things
backpack += ('earbuds','cashews')                       # Add two more things from a Tuple
backpack += {"breakfast":"eggs","lunch":"noodles"}      # Add the lunch menu, NOTE: Only the keys are added (not the values)
backpack += {'glasses','sweater','watch'}               # Add three more things from a Set
# backpack += 5                                         # Illegal: append operator only works with collections

# Python Lists use the index operator to fetch items or Lists of items

backpack[0]        # Get the first item in the List
backpack[3][0]     # Get the first item of the fourth item in the List
backpack[0:3]      # Get a new List with the first three items at indexes 0, 1, and 2
backpack[:3]       # Same as above, note the leading 0 is optional
backpack[:]        # Gets every item in the List
backpack[4:]       # Get the fifth item and all items after it in the List
backpack[-1]       # Get the last item in the List
backpack[-2]       # Get the second to last item in the List
backpack[-4:-2]    # Get the fourth-to-last and third-to-last items in the List
backpack[-3:]      # Get the third-to-last item and all subsequent items in the List

# Python Lists use methods to add, remove and find items. backpack is our List.

backpack.append(5)                                # Append will add anything to the backpack
how_many_pens = backpack.count('pen')             # Count will count how many pens are in the backpack
where_is_my_paper = backpack.index('paper')       # Index will find the first paper in the backpack
find_my_watch = backpack.index('watch',4)         # Index can find the watch but skip the first 4 items
find_my_earbuds = backpack.index('earbuds',5,8)   # Index will find earbuds but skip the first 5 items and only check the next 3 items
backpack.insert(4,'pen')                          # Insert will add another pen next to the current pen at index 4
backpack.insert(-2,'glasses')                     # Insert can add glasses next to the other glasses and the end of the List
five_bucks = backpack.pop()                       # Pop will take the 5 bucks back out of the backpack since they are the last item
laptop = backpack.pop(0)                          # Pop can also take the first (or any) item out of the backpack
backpack.remove('sweater')                        # Remove will delete the sweater from the backpack

# Python Lists can be sorted forwards or backwards

primes = [11,7,13,2,5,3]         # Create an unsorted List of prime numbers
primes.sort()                    # Sort the List in ascending order
primes.sort(reverse = True)      # Sort the List in descending order
sorted(primes)                   # Use the built-in function sorted to sort the List instead
sorted(primes, reverse = True)   # Use the built-in function sorted to sort the List in reverse order

# Python has built-in functions for List arithmetic

digits = [2,5,8,3,7,2,4,5,5,6,7]   # Make a List of some numbers
sum(digits)                        # Calculate the sum of the List of numbers
max(digits)                        # Find the largest (max) number in the List
min(digits)                        # Find the smallest (min) number is the List

# Python has a statistics module for complex statistical analysis beyond simple arithmetic

from statistics import covariance,fmean,geometric_mean,harmonic_mean,kde   # Among others

# Python allows you to combine Lists and Tuples together with concatenantion

x = ['a','b','c'] + ['d','e','f']   # Concatenante two Lists
x = ('a','b','c') + ('d','e','f')   # Concatenante two Tuples

# ###################################################### #
#   List Comprehensions & Generators                     #
# ###################################################### #

# Python has a unique way to create a List of items from another List called comprehensions

positive_integers = list(range(100))                                    # Make a List of positive integers from a range
odd_numbers = [num for num in positive_integers if num % 2 == 1]        # Use a List comprehension to extract the odd numbers
doubles = [num * 2 for num in positive_integers]                        # Use a List comprehension to double each number
double_evens = [num * 2 for num in positive_integers if num % 2 == 0]   # Find all the even numbers and multiple them by 2

# Generators are useful for creating an iterator over a List especially in cases where the List is very large

double_evens_generator = (num * 2 for num in positive_integers if num % 2 == 0)

# ###################################################### #
#   Dictionary Operations                                #
# ###################################################### #

# Python dictionaries are hash tables with key: value pairs

locations = {'orlando':'123 Brook Ln','boston':'442 Green Pl','houston':'12054 Industry Way'}  # Address book Dictionary

boston_addy = locations['boston']       # Get the address of the boston location with the index operator
boston_addy = locations.get('boston')   # Get the address with the get method
locations['orlando'] = '133 Brook Ln'   # Update values with the assignment operator
locations['madison'] = '890 State St'   # Add new values with the assignment operator
locations.update(                       # Pass a Dictionary to update to add multiple values
  {'flagstaff':'7370 Crane Way','tempe':'9090 Locust St'}
)
locations.update(                       # We can pass a dictionary to update to change multiple values
  {'boston':'443 Green Pl','houston':'12054 Industry Blvd'}
)
boston = locations.pop('boston')        # We can remove a key value pair with the pop method fetching the value

# Python will throw a KeyError if we attempt to access a non-existent pair

if 'sarasota' in locations: print(locations['sarasota'])   # We can test for a key with the in keyword
sarasota = locations.get('sarasota')                       # We can also test using the get method (returns None)
sarasota = locations.get('sarasota','100 Nowhere Dr')      # We can also return a default value instead of None
boston = locations.pop('boston','100 Nowhere Dr')          # Pop also supports default values
list(locations)                                            # Gets a List of keys in the Dictionary
locations.keys()                                           # Gets an immutable set of keys in the Dictionary
locations.values()                                         # Gets an values iterator
locations.items()                                          # Gets a (key,value) Tuple iterator

for kvp in locations:                                      # Iterating the Dictionary returns the key strings
  value = locations[kvp]
for city,addr in locations.items():                        # Iterating the items returns key,value Tuples
  text = f'{city}: {addr}'
for city_addr in locations.items():                        # If you do not declare the Tuple parts, you can access
  key = city_addr[0]                                       # each Tuple point by index number
  value = city_addr[1]

# Dictionaries, like Lists, have comprehensions which can be used to create Dictionaries from Lists

students = ['Alice','Bob','Charlie','David','Ethan']
test_scores = [99,98,99,91,92]
zipped = zip(students,test_scores)                      # Zip is a class which can merge Lists into Tuples
student_scores = {key:value for key, value in zipped}   # Using a Dictionary comprehension we can merge students with test_scores

# Dictionary comprehensions require Tuples rather than items since Dictionary entries are key-value pairs

score_list = [['Alice',99],['Bob',98],['Charlie',99]]    # Here we have a two-dimensional array
student_scores = {n[0]:n[1] for n in score_list}         # Merge the two-dimensional array into a Dictionary

# ###################################################### #
#   Dates & Times                                        #
# ###################################################### #

# Python date and time operations are implemented in the datetime module

from datetime import datetime                     # Datetime is a class in the datetime module
back_then = datetime(2025,7,5,9,38,25)            # Construct a datetime with its constituent parts
right_now = datetime.now()                        # Get the current time and date
right_now - back_then                             # Get the difference between two datetimes
a_while_ago = \
  datetime.strptime('Mar 10, 1993','%b %d, %Y')   # Parse a String into a datetime
welcome_to_now = right_now.strftime('%d/%m/%Y')   # Format the current time and date into a String

# ################################################################################################# #
#                                                                                                   #
#  3. Control Flow                                                                                  #
#                                                                                                   #
# ################################################################################################# #

# ###################################################### #
#   If Statements                                        #
# ###################################################### #

# Python conditional control flow uses the if, elif, and else keywords where indentation tells the Python
# interpreter which instructions to run if the condition is met

my_name = 'Bob'
if my_name == 'Christian':            # If this is True
  print('My name is Christian')       # Run this line

if my_name == 'Christian':            # If this is True
  print('My name is Christian')       # Run this line
else:                                 # Otherwise...
  print('My name is not Christian')   # Run this line instead

if my_name == 'Christian':            # If this is True
  print('My name is Christian')       # Run this
elif my_name == 'Bob':                # Or if this is True, and the previous expression was False
  print('My name is Bob')             # Run this line
else:                                 # Otherwise...
  print('Who am I?')                  # Run this line instead

# ###################################################### #
#   Loops                                                #
# ###################################################### #

# Python loop control includes for loops and while loops

for item in backpack:                # Iterate over all items in a collection
  my_item = item

x = 0
while x < len(backpack):             # Loop while a condition is True
  x += 1

# Python loops support break and continue statements which will stop the loop or skip steps, respectively

for item in backpack:    # This will loop through the backpack until we find paper
  if item == 'paper':
    break
  else:
    not_paper = item

for item in backpack:    # This will loop through the entire backpack but will not print any paper
  if item == 'paper':
    continue
  print(item)

# The pass keyword is used for doing a no-op (No Operation)

for item in backpack:    # This will loop through the entire backpack and do nothing with each item
  pass

# ###################################################### #
#   Branching / Switching                                #
# ###################################################### #

# Python uses the match statement to create a switch case branch

letter = 'q'                         # The letter is q
match letter:                        # Create a 'ladder' of matches for what the letter might be
  case 'a':                          # If letter is a ...
    print('a is for aardvark')
  case 'b':                          # If letter is b ...
    print('b is for boysenberry')
  case default:                      # Use default to do something if there is no match
    print(letter)

# The match statement was added recently in Python 3.10, the above code will fail if you run this on older Python runtimes

# ################################################################################################# #
#                                                                                                   #
#  4. Functions                                                                                     #
#                                                                                                   #
# ################################################################################################# #

# ###################################################### #
#   User-Defined Functions                               #
# ###################################################### #

# Python allows you to define your own functions which are blocks of reusable code

def my_function():
  print('Hello, world!')

# Python user-defined functions can return zero, one or more values

def returns_nothing(): print('Hello, world!')             # Returns nothing
def returns_something(): return 'Hello, world!'           # Returns a String
def returns_three_values(): return 'Hello', 'world', '!'  # Returns three separate values

# Return values are assigned to one or more variables using the assignment (=) operator

returns_nothing()
hello_world = returns_something()
hello, world, exclaim = returns_three_values()

# Function arguments and their parameters can be passed in positional or keyword format

def calc_product(a, b, c): return a * b * c
calc_product(1,2,3)                            # These parameters are passed by position
calc_product(b = 2, c = 3, a = 1)              # These parameters are passed by keyword
calc_product(4, c = 12, b = 7)                 # These parameters are mixed between position and keyword
                                               # This makes Python functions more versatile than many other languages
                                               # You can specify only the parameters relevant to you
print('No line break', end = '')               # For example, you can print text with no line break

# Function definitions can have default argument values

def say_my_name(name = 'Christian'): print(name)  # This function's name argument is defaulted

say_my_name()                # Calling it this way prints the default value
say_my_name('Alice')         # Calling it this way prints Alice
say_my_name(name = 'Bob')    # Calling it this way prints Bob

# Functions also support arbitrary positional arguments

def add_numbers(*nums):          # Using *nums means you can specify an unlimited number of nums
  result = 0                     # as the first positional argument which will be passed as a List
  for i in nums:                 # Here we iterate the nums List
    result += i
  return result
add_numbers(3,7,4,2,8,3,4,5,6)   # We call the function with a bunch of numbers

# Functions also support abritrary keyword arguments

def print_brochure(**tags):        # The double asterisk (**) token means we accept arbitrary named parameters
  for key, value in tags.items():  # The tags argument will come in as a Dictionary
    print(f"{key} = {value}")
print_brochure( breakfast = 'eggs', lunch = 'salad', dinner = 'pasta')  # This is what they look like

# ###################################################### #
#   Anonymous Functions (Lambda)                         #
# ###################################################### #

# Python supports anonymous functions called lambda functions

positive_integers = list(range(100))
odd_numbers = [num for num in positive_integers if num % 2 == 1]
odd_numbers = list(filter(lambda x: x % 2 == 1, positive_integers)) # Here we use a lambda function to find all the
                                                                    # odd numbers in a list of numbers using the filter
                                                                    # function which accepts a function as the first parameter

# Lambda functions can have multiple arguments that can map into the caller parameters
# In the example below we are passing two iterables to the map function thus our
# Lambda function will be defined with two arguments, in order, one for the first
# And one for the second iterable

products = list(map(lambda x, y: x * y, odd_numbers, odd_numbers))

# Here is another examples with two different lists

menu_items = ['Eggs','Sausage','Toast','Coffee']
menu_prices = ['2.99','3.99','1.99','2.00']

menu = list(map(lambda x, y: f'{x}: ${y}', menu_items, menu_prices)) # Makes a List of menu items by name and price
print(menu)

# ################################################################################################# #
#                                                                                                   #
#  5. I/O                                                                                           #
#                                                                                                   #
# ################################################################################################# #

# ###################################################### #
#   File System                                          #
# ###################################################### #

# Let's setup some data we can use for these examples

data_dump_text = 'Task,Estimate,Notes\nDo laundry,3,Three loads of lights darks and colds\nEat breakfast,1,Eggs and toast with coffee\nMake the bed,0.25,Change the sheets and fluff the pillows'
data_dump_task = 'Drink water,8,Stay hydrated'

# Python uses the open function to access local files on the file system

with open('python_primer.py') as primer_file:
  python_primer = primer_file.read()

# Python has a readlines method for reading text files line by line

with open('python_primer.py') as primer_file:  # By default, files are opened in read mode
  line_count = 0
  for line in primer_file.readlines():
    new_line = f': {line}'
    line_count += 1

# You'll notice that the variables declared inside the with block persist outside

print(f'python_primer.py contains {line_count} lines')

# Python supports writing to files with the same function

with open('data_dump.csv', 'w') as primer_copy:  # The 'w' argument indicates write mode
  primer_copy.write(data_dump_text)

# Python uses the mode parameter to determine how the file is opened:

with open('data_dump.csv') as data_dump:       # No argument defaults to read
  data = data_dump.read()
with open('data_dump.csv','r') as data_dump:   # Passing r is for read
  data = data_dump.read()
with open('data_dump.csv','w') as data_dump:   # Passing w is for write (overwrite)
  data_dump.write(data_dump_text)
with open('data_dump.csv','a') as data_dump:   # Passing a is for append
  data_dump.write(f'\n{data_dump_task}')

# ###################################################### #
#   File System: CSV Format                              #
# ###################################################### #

# Python has a clever way to read CSV data from the file system

import csv
with open('data_dump.csv',newline='') as data_dump:
  reader = csv.DictReader(data_dump)                 # The DictReader parses the header and treats each line
  for dict in reader:                                # of data as a Dictionary for access via named property
    task = dict['Task']
    estimate = dict['Estimate']
    notes = dict['Notes']
    print(f'{task}: ({estimate} hours) - {notes}')

# In the example above the DictReader function from the CSV module returns an iterable
# Dictionary reader for the CSV file which converts each line of the CSV file into a Dictionary
# object which we can then use to access each value by name from the current line in the file

# Let's make a PSV file (pipe-separated values) for our next example

psv_data = 'Ingredient|Amount|Prep\nBeef|2 lbs|Thaw, cook then set aside\nPotatoes|12 large|Skin, boil, mash then let cool\nCream|2 cups|Warm then stir into beef and potatoes'
with open('hotdish_recipe.psv','w') as psv: psv.write(psv_data)

# What's nice about csv.DictReader is it will accept arbitrary delimiters so we do not have
# to use commas to separate values in files, we can use less common text characters such as
# pipes (|) or semicolons (;)

with open('hotdish_recipe.psv',newline='') as recipe:
  reader = csv.DictReader(recipe,delimiter='|')        # The delimiter keyword parameter lets us use the pipe character
  for dict in reader:
    ingredient = dict['Ingredient']
    amount = dict['Amount']
    prep = dict['Prep']
    print(f'{ingredient}: ({amount}) - {prep}')

# Python allows us to write to CSV files just as easily with the csv module
# Notice how we can use keyword parameters to set the delimiter to a pipe (|) instead of a comma

with open('hotdish_recipe.psv','w') as output_file:
  schema = ['Ingredient','Amount','Prep']
  data = [
    {'Ingredient':'beef','Amount':'2 lbs','Prep':'Thaw, cook then set aside'},
    {'Ingredient':'Potatoes','Amount':'12 large','Prep':'Skin, boil, mash then let cool'},
    {'Ingredient':'Cream','Amount':'2 cups','Prep':'Warm then stir into beef and potatoes'}
  ]
  csv_writer = csv.DictWriter(output_file,schema,delimiter='|',lineterminator='\n')
  csv_writer.writeheader()
  for item in data:
    csv_writer.writerow(item)

# This example above is not the most efficient method. The data variable is a List of Dictionaries which works well
# but relies on the header values being duplicated on each row.

# ###################################################### #
#   File System: JSON Format                             #
# ###################################################### #

# Python also supports reading and writing JSON data with the json module
# Let's create some sample data for the next examples

def json_payload(data: str) -> None:                 # : str and -> None are called type hints
  with open('python_primer.json','w') as json_file:
    json_file.write(data)

# Python's json module has a load function which will read JSON from disk and output a data
# structure for us from the contents

json_payload('{"hello":"world"}')              # Save some JSON to disk
from json import load as json_load             # Import the load function from json as json_load
with open('python_primer.json') as json_file:  # Open the JSON file in read mode
  json_data = json_load(json_file)             # Load the JSON into a variable

# Python's json module returns JSON data in a list or dictionary format depending on the
# schema of the JSON itself

print('Hello, {}!'.format(json_data['hello']))

# Let's define json_get so we don't have to copy the JSON read code over and over again for the next examples

def json_get():
  with open('python_primer.json') as json_file:
    return json_load(json_file)

# Let's show some other examples of how Python processes JSON

json_payload('[{"hello":"world"}]')            # This JSON is an array of objects
json_output = json_get()                       # Python returns a List with one Dictonary item
json_output[0]['hello']

json_payload('{"hello":{"place":"world"}}')    # This JSON is an object with a subobject
json_output = json_get()                       # Python returns a Dictionary with one Dictionary value
json_output['hello']['place']

json_payload('{"hello":[{"place":"world"}]}')  # This JSON is an object with a subarray of objects
json_output = json_get()                       # Python returns a Dictionary with one List value of Dictionary type
json_output['hello'][0]['place']

# What you'll notice about Python and JSON is how Python deserializes native JSON into native Python
# data structures. Any JSON can be expressed as a Dictionary, List, or Dictionary of Lists or
# List of Dictionaries.

# Conversely, the JSON module let's us serialize native Python Dictionary and List types to JSON

from json import dump
def json_out(data,filename: str = 'python_primer.json'):
  with open(filename,'w') as json_file:
    dump(data,json_file)                                  # The dump function writes JSON to a file from an object

# We can now write various Python data structures out to native JSON

list_of_letters = ['a','b','c','d','e','f','g','h','i','j','k','l']        # Serialized as-is
list_of_tuples = [('a','b'),('c','d'),('e','f'),('g','h')]                 # Tuples are serialized as arrays
list_of_dictionaries = [{'a':'b'},{'c':'d'},{'e':'f'},{'g':'h'}]           # Serialized as a list of objects
dictionary_of_lists = {'a':['b','c','d'],'e':['f','g','h']}                # Serialized as an object with array properties
dictionary_of_dictionaries = {'a':{'b':'c'},'d':{'e':'f'},'g':{'h':'i'}}   # Serialized as an object with object properties

json_out(list_of_letters,'py_list_of_letters.json')
json_out(list_of_tuples,'py_list_of_tuples.json')
json_out(list_of_dictionaries,'py_list_of_dictionaries.json')
json_out(dictionary_of_lists,'py_dictionary_of_lists.json')
json_out(dictionary_of_dictionaries,'py_dictionary_of_dictionaries.json')

# In Python, any serializable object can be written into JSON

# ################################################################################################# #
#                                                                                                   #
#  6. Classes                                                                                       #
#                                                                                                   #
# ################################################################################################# #

# Python is a typed language, every object in Python has a type which you can get using the type function

type(5)                       # 5 is an int
type('five')                  # 'five is an str (String)
type([5,'five'])              # [] is a List
type({5:'five'})              # {} is a Dictionary
type(('five',5))              # () is a Tuple
type({'five','six','seven'})  # {1,2,3} is a Set

# Python allows you to check run-time types using the is keyword

if type(5) is int: print(f'5 is an int')

# The defined type of an object is called its class

# ###################################################### #
#   User-Defined Classes                                 #
# ###################################################### #

# In Python, like in many languages, every object has a type and the class keyword lets you define your own

class Person:                                                  # The class keyword defines a class by name

  name = 'George Costanza'                                     # Variables at the class scope are called attributes

  def __init__(self,name):                                     # The __init__ dunder method defines the constructor
    self.name = name                                           # The new instance itself must always be the first argument

  def __repr__(self):                                          # The dunder method that converts this to a string
    return self.name                                           # Python classes have many dunder methods (built-ins)

  def greet(self,greeter: Person) -> str:                      # This is an instance method, note how self is an argument
    return f'Hello, {greeter.name}. My name is {self.name}.'   # self is not an ephemeral variable like 'this' in other
                                                               # object-oriented languages, it must be declared

  def sayhello(this):                                          # The fun part is that 'self' is not a keyword, it's only
    return f'Hello, my name is {this.name}.'                   # a convention, so you can technically use any name for
                                                               # the argument to reference the current instance

  def echo():         # Every instance method of a class is required to have 1 argument and that one first argument will
    return 'Hello'    # always be set to the instance of the class itself calling the method. This method definition, while
                      # it can be defined, will actually throw a TypeError if you try to invoke it because the run-time is
                      # passing the instance of itself as the first argument automatically, but this definition does not
                      # accept any arguments at all.

# The class definition ends when we outdent back to the local namespace
# Let's instantiate some instances of our new class and do things with them

# ###################################################### #
#   User-Defined Class Variables                         #
# ###################################################### #

# Python lets you declare & create (instantiate) any class you define by "calling" the class like a function
# This calls the __init__ method on the class and gives you a new instance of the class

alice = Person('Alice')   # Make a new Person named Alice
bob = Person('Bob')       # Make a new Person named Bob

# Python lets you access class attributes and call methods using the dot (.) operator

print(alice.sayhello())   # Make Alice say Hello
print(bob.sayhello())     # Make Bob say Hello

print(alice.greet(bob))   # Have Alice greet Bob
print(bob.greet(alice))   # Have Bob greet Alice

# alice.echo()            # If you try to run this, you'll generate a TypeError because echo() has no arguments

# ###################################################### #
#   Attribute Testing                                    #
# ###################################################### #

# Python run-time allows you to test objects for their attributes to avoid run-time errors

alice.name = 'Alice'    # Our class Person has a name attribute
hasattr(alice,'name')   # We can test for it using the hasattr function
getattr(alice,'name')   # We can use the getattr function to get alice.name
getattr(alice,'name','Alice')   # This is useful if we don't know if alice has a name, we can get a default value instead

# Python provides a directory list using the dir function allowing you to get every attribute in a List

scope_list = dir()         # Gets every attribute in the current scope
person_list = dir(alice)   # Gets every attribute of the alice instance of Person

print([a for a in dir(alice) if a.find('__') < 0])  # A List Comprehension removing dunder methods so we can find all the
                                                    # user-defined attributes and methods of a Person

# ###################################################### #
#   Type Hints                                           #
# ###################################################### #

# Up until now we have been defining functions with simple declaration statements

def add_two_numbers(a,b):   # We expect two numbers, but that's not explicitly stated
  return a + b              # We add them together and return the result
                            # This won't behave as expected if a or b are not a number

# Type hints allow the Python interpreter to tell the developer what type is expected

def add_two_numbers(a: int, b: int) -> int:  # Here we use type hints to tell the developer that we
  return a + b                               # are expecting integers for a and b and that we'll be
                                             # returning an integer as well

# ################################################################################################# #
#                                                                                                   #
#  7. Error Handling                                                                                #
#                                                                                                   #
# ################################################################################################# #

# Python, like most languages, allows you to trap run-time errors at run-time using the try/except syntax

try:
  alice.echo()                                         # Let's call our broken method on the Person class
except TypeError:                                      # Here we define the expected error TypeError
  print('alice.echo() generated expected TypeError')   # This will run if alice.echo() generates a TypeError
                                                       # and the TypeError will not stop our script

# Your code can also raise errors using the raise keyword if you need to halt execution

try:
  raise NameError(name='kwyjibo')
except:
  print('Caught error')

# Finally, here is an example of a full try/except block with all possible operations
# Except blocks are not mutually exclusive, both except blocks below will execute because
# the error raised is a NameError, so the NameError block runs, and the any error block
# also runs. This is by design.

try:                              # Here we initiate the error trap
  print(kwyjibo)
except NameError:                 # Here we trap a specific NameError
  print('Caught NameError')
except:                           # Here we trap any error, regardless of type
  print('Caught error')
else:                             # Here we run some code if there were no errors
  print('No error')
finally:                          # And finally, we always run this code to make sure everything is cleaned up
  print('Always runs, for cleanup of issues/open handles, etc.')