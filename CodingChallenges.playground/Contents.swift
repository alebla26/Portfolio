// These challenges are derived from a book containing a myriad of problems and solutions. All challenges are solved (sometimes poorly) alone initially and then researched and confirmed by the book afterwards, in order to learn the most effecient solution.


import UIKit

// Challenge 1: Write a function that accepts a String as its only parameter, and returns true if the string has only unique letters, taking letter case into account.

func uniqueLetterStringChecker(str: String) -> Bool {
  return Set(str).count == str.count
}

uniqueLetterStringChecker(str: "AaBbCc")
uniqueLetterStringChecker(str: "AaAa")


// Challenge 2: Write a function that accepts a String as its only parameter, and returns true if the string reads the same when reversed, ignoring case.
func palindromeCheck(word: String) -> Bool {
  return String(word.lowercased().reversed()) == word.lowercased()
}

palindromeCheck(word: "Racecar")
palindromeCheck(word: "Racecars")

// Challenge 3: Write a function that accepts two String parameters, and returns true if they contain the same characters in any order taking into account letter case.

func uniqueLetterStringPairChecker(str1: String, str2: String) -> Bool {
  let arr1 = Array(str1.characters)
  let arr2 = Array(str2.characters)
  
  return arr1.sorted() == arr2.sorted()
}

uniqueLetterStringPairChecker(str1: "abc", str2: "cba")
uniqueLetterStringPairChecker(str1: "abc", str2: "cbAa")

// Challenge 4: Write your own version of the contains() method on String that ignores letter case, and without using the existing contains() method.

extension String {
  func myContains(_ string: String) -> Bool {
    return range(of: string, options: .caseInsensitive) != nil
  }
}

"Hello World".myContains("Hello")
"Hello World".myContains("Swift is Fun!")

// Challenge 5: Write a function that accepts a string, and returns how many times a specific character appears, taking case into account.

func characterInStringCount(string: String, character: Character) -> Int {
  var charCount = 0
  
  if string.contains(character) {
    for letter in string {
      if letter == "o" {
        charCount += 1
      }
    }
  }
  
    return charCount
}

characterInStringCount(string: "How now brown cow", character: "o")

// Challenge 6: Write a function that accepts a string as its input, and returns the same string just with duplicate letters removed.











