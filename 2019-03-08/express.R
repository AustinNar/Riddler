# This is a way of recursively finding "inventory numbers", which are numbers 
# describe that themselves (see https://fivethirtyeight.com/features/how-many-numbers-contain-the-numbers-of-their-numbers/),
# in Riddler Express section. We will provide a list of numerals to be tallied,
# and the function will build the list of tallies from the largest numeral to
# the smallest, weeding out impossible tally options along the way wherever it
# can. A few key insights to speed things up is that
#  - Outside of the case "22", there arent enough digits in the number for the
#     last numeral to be tallied more than once. If the largest numeral is n,
#     there are at most n tallies in the number. If n is tallied twice, that
#     means n itself must be a tally for some other numeral, and that numeral
#     thus appears n times, n-1 of which are tallies. All in all we have that 
#     n itself is a tally atleast once, and the number it tallies is a tally 
#     n-1 times, which takes up all n tallies without room for any of the other
#     numbers to be appear.
#  - Before we continue our recursion to build the list, we can throw out any
#     any numeral which has already appeared as many times as its tally. This
#     speed boost becomes greater the deeper we get into the recursion, which
#     is very helpful.


# We will use this to check base case of a completed tally
inventory_validate <- function(tally, numerals){
  all(sapply(1:length(numerals), 
             function(i){
               sum(c(numerals, tally) == numerals[i]) == tally[i]
             }))
}

# Recursive function for discovering inventory numbers
inventory_number <- function(tally, numerals){
  # We may potentially have multiple possible inventory numbers for a given
  # set of numerals. If so, we return them in a list, and analyze each
  if(is.list(tally)){
    return(lapply(tally, function(t) inventory_number(t, numerals)))
  }
  # If we have tallied each numeral, check if it is a valid inventory number!
  # if not, return an NA (can cascade up as no valid inventory number for these 
  # numerals), else return the tally itself
  if(length(tally) == length(numerals)){
    if(inventory_validate(tally, numerals))
      return(tally)
    else
      return(NA)
  }else{
    # If we have not yet tallied each numeral, try to effieciently, find the 
    # tally of the next digit. In most cases, if we have no tallied digits,
    # the last digit must be a 1 (a matter of the number of digits available).
    # Otherwise, we check over all digits in the numerals in which we have not
    # yet used them as many times as their tally.
    if(length(tally) == 0 & length(numerals) > 1 & 1 %in% numerals){
      tally <- c(1)
    }
    numerals_left <- c()
    tallies_left <- length(numerals) - length(tally)
    # Only check digits which we have not tallied (after the if block), or that 
    # we could use again without going over their assigned tally (in if block)
    if(length(tally > 0)){
      numerals_left <- numerals[which(sapply(1:length(tally), function(i){
        j <- tallies_left + i
        sum(c(numerals, tally) == numerals[j]) < tally[i]
      })) + tallies_left]
    }
    numerals_left <- c(numerals[1:tallies_left], numerals_left)
    
    # Check every digit we've identified and see if we can build an inventory 
    # number using it
    next_tallies <- lapply(numerals_left, function(n){
      inventory_number(c(n, tally), numerals)
    })
    
    # Which of the digits that we checked came back as NA
    na_tallies <- sapply(next_tallies, function(x)any(is.na(x)))
    
    # If all of the digits we checked ar NA, we return NA. Otherwise, we return
    # the tally as a vector if one was non-NA, or a list of tallies if multiple
    # were not NA
    if(all(na_tallies))
      return(NA)
    else{
      if(length(which(!na_tallies)) > 1)
        next_tallies[which(!na_tallies)]
      else
        next_tallies[[which(!na_tallies)[1]]]
    }
      
  }
}

# This is the code that checks over every possible combination of the digits 
# between 1 and 9 and finds the inventory number(s) for them
N <- 9
inventory_numbers <- unlist(lapply(1:(2^N-1),function(i){
  #print(paste0(i, ' / ', 2^N-1))
  t1 <- Sys.time()
  nu
  merals <- (1:N)[intToBits(i)[1:N] > 0]
  val <- inventory_number(c(), numerals)
  if(!all(is.na(val))){
    if(is.list(val))
      val <- sapply(val, function(v) paste0(v, numerals, collapse = ''))
    else
      val <- paste0(val, numerals, collapse = '')
    print(val)
  }
  #print(Sys.time()-t1)
  return(val)
}))

# Filter out NA and reorder
inventory_numbers <- inventory_numbers[!is.na(inventory_numbers)]
inventory_numbers <- inventory_numbers[order(as.numeric(inventory_numbers))]


print(length(inventory_numbers))
cat(paste0(inventory_numbers, collapse = '\n'))
