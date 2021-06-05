import Foundation

public extension Int {
    
    var roman: String? {
        let value = self                                                // take the given integer
        var result: [String] = []                                       // prepare empty array to collect Roman letters
        
        let thousands = value / 1000                                    // take 1st digit of the largest number (e.g. 3 in 3789)
        let hundreds = (value - 1000 * thousands) / 100                 // take 2nd digit of the largest number (e.g. 7 in 3789)
        let tens = (value - 1000 * thousands - 100 * hundreds) / 10     // take 3rd digit of the largest number (e.g. 8 in 3789)
        let last = value % 10                                           // take 4th digit of the largest number (e.g. 9 in 3789)
        
        let digitArray = [thousands, hundreds, tens, last]              // prepare digits to convert
        var divisioner = 1000                                           // calculate by dividing number by divisioner
        
        let romanSymbol = [                                             // take the data of different numbers conforming to different Roman letters
            1000 : "M",
            500 : "D",
            100 : "C",
            50 : "L",
            10 : "X",
            5 : "V",
            1 : "I",
        ]
        
        if value < 1 || value > 3999 {
            return nil                                                  // return nothing if number is not in the range of 1 to 3999 inclusive
        }
        
        for everyDigit in digitArray {                                  // take every digit of the number
            
            if everyDigit != 0 {                                        // if digit is not zero
                
                switch everyDigit {                                     // consider different cases for every digit
                case 1..<4:                                             // from 1 to 3 inclusive
                    for _ in 0..<everyDigit {
                        result.append(romanSymbol[divisioner] ?? "")    // append a symbol of the letter (e.g. 3 is III)
                    }
                case 4:                                                 // for digit - 4
                    result.append(romanSymbol[divisioner] ?? "")        // append a symbol of lower value first (e.g. I before V for 4 )
                    result.append(romanSymbol[5 * divisioner] ?? "")    // append a symbol of higher value afterwards (e.g. V after I for 4)
                case 5:                                                 // for digit - 5
                    result.append(romanSymbol[5 * divisioner] ?? "")    // append a symbol of the letter (e.g. 5 is V)
                case 6..<9:                                             // for digit - 6
                    result.append(romanSymbol[5 * divisioner] ?? "")    // append a symbol of the lower value first (e.g. 5 is V)
                    for _ in 0..<(everyDigit - 5) {                     // for next values add up other letters
                        result.append(romanSymbol[divisioner] ?? "")    // append a symbol of the letter afterwards (e.g. 7 is II after V -> VII)
                    }
                case 9:                                                 // for digit - 9
                    result.append(romanSymbol[divisioner] ?? "")        // append a symbol of lower value first (e.g. I before X for 9 )
                    result.append(romanSymbol[10 * divisioner] ?? "")   // append a symbol of higher value afterwards (e.g. X after I for 9 )
                default:
                    result.append("")                                   // do not add anything by default
                }
            }
            divisioner = divisioner / 10                                // divide by ten times lower value every cycle
        }
        
        return result.joined()      // join all letters of the array to see the Roman style of the number
        
    }
}
