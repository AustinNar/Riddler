# How Many Numbers Contain the Numbers of their Numbers

Blog Post: https://www.austinnar.com/blog/2019/3/8/riddler1

## This Week's Riddle
This week I chose to tackle the Riddler Express. 

> From Daz Voss, numbers of numbers with numbers of their numbers:
> 
> The number 21322314 acts as its own inventory. That is, it contains two 1s, three 2s, two 3s and one 4. Another example is 22 — it contains two 2s.
> 
> These numbers consist of alternating tallies and numerals. First comes the tally, then the numeral being tallied, then another tally, and so on.
> 
> How many numbers of this kind exist?
> 
> (Assume the numerals have to be tallied in increasing order, so you can’t create new numbers simply by rearranging: 21321423, for example, doesn’t count.)

[SOURCE: Five Thirty Eight](https://fivethirtyeight.com/features/how-many-numbers-contain-the-numbers-of-their-numbers/)


## My Approach
All code can be found in [express.R](./express.R)

Something about this problem just smelled like recursiont to me, so I decided to
take that exact approach in solving this problem. I treated the number as two
distinct entities:

* The list of unique digits in the number (the numerals)
* The list of how many times each number appears (the tallies)

One quick observation is that the search space is finite -- only the digits 1-9
can be included as numerals, and thus are number is no more than 18 digits long.
Though this search space would take a very long time to brute-force search, it 
can be trimmed down using some clever tricks.

The method that I followed was as such: take a list of numerals, and find the
tally (or tallies!) that make this numeral a so-called *inventory number*, if
any exist. Start with the largest numeral in the set, find the possible tallies
for it, and recursively work backwards until you find the tally for the smallest
numeral, and thus a complete list.

Again, there are a few observations which allow us to speed this up

* Other than the special case of "22", the last numeral cannot be tallied
more than once. This is because, if the largest numeral is n,
there are at most n tallies. If n is tallied twice, that
means n itself must be a tally for some other numeral, and that numeral
thus appears n times, n-1 of which are tallies. All in all we have that 
n itself is a tally atleast once, and the number it tallies is a tally 
n-1 times, which takes up all n tallies without room for any of the other
numbers to be appear.
* As we move down the list of numerals, we can limit the search of potential
tallies for the next numeral to only those numbers which themselves are numerals,
and those who have not yet been assigned a tally that is full (the number appears
as many times as the tally already.) This allows us to filter out more and more 
digits the further into the recursion we get, which is a great speed boost.

I created a function in R that does exactly this, recursively taking a list of 
numerals and seraching for any possible lists of tallies that meet the 
*inventory number* criteria. I then called this for every possible subset of
integers between 1 and 9.

## The Result
In total, 59 of these *inventory numbers* can be found, which are listed in increasing 
order in [inventory_numbers.txt](./inventory_numbers.txt).

