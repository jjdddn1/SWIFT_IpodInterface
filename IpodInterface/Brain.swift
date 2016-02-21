//
//  File.swift
//  IpodInterface
//
//  Created by Huiyuan Ren on 16/2/20.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import Foundation

class Brain {
    
    
    // mark all the not prime numbers
    func calculatePrime(maxValue : Int) -> [Int]{
        
        var sieveArray = [Bool](count: maxValue+1, repeatedValue: true)
        sieveArray[0] = false
        if maxValue >= 1 {
            sieveArray[1] = false
        }
        
        //Find the first number greater than 1 in the list that is not marked. If there was no such number, stop. Otherwise, let p now equal this new number
        for (var i = 2; i < sieveArray.count; i++) {
            
            // if this number is have not been touched
            if (sieveArray[i]) {
                
                // Enumerate the multiples of p by counting to n from 2p in increments of p, and mark them in the list (these will be 2p, 3p, 4p, ... ; the p itself should not be marked). (from wiki)
                for (var j = i*i; j < sieveArray.count; j += i) {
                    sieveArray[j] = false
                }
            }
            
        }
        
        return addPrime(sieveArray)

    }
    
    //pick up all the prime number and return them
    func addPrime(sieveArray: [Bool]) -> [Int]{
        
        var primeNumber : [Int] = []
        
        for(var i = 2; i < sieveArray.count; i++){
            if( sieveArray[i] ){
                primeNumber.append(i)
            }
        }
        
        return primeNumber
    }
}