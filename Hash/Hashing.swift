//
//  Hash.swift
//  Hash
//
//  Created by Mac on 4.12.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class Hashing: UIViewController {
    private var hashArray = [Hash]()
    private var Ptable = [Word]()
    private var ruleOfWord = 4 // en fazla kaç girilecek ise
    private var LastPlaceMentLastSeenArray = [LastSeenWord]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        hashArray = loadArray()
        let CountWord = findWords(with: hashArray)
        print("Haflerin sayısı")
        for item in CountWord{
            print(item.word)
            print(item.count)
            print("----")
        }
        print("---------------")
        print("Frekansları")
        hashArray = findFrequency(withWords: CountWord, andHashs: hashArray)
        hashArray.sort(by: {$0.frekens > $1.frekens}) // sorting
        for item in hashArray{
            print(item.PerfectString)
            print(item.frekens)
            print(item.currentIndex)
            print("----")
        }
        print("---------------")
        print("En son geçtiği index")
       let lastSeenArray = replaceObjectDependsWord(with: hashArray)
       for item in lastSeenArray{
            print(item.word)
            print(item.lastSeenIndex)
            print("----")
        }
        print("---------------")
        print("Hash arrayin en son hali")
        for item in self.hashArray{
            print(item.PerfectString)
        }
        for item in CountWord{
            Ptable.append(Word(GetWord: item.word, GetCount: 0))
        }
        print("---------------")
        lastPlacement()
        print("Yerleşimleri")
        for item in self.hashArray{
            print(item.PerfectString)
            print(item.currentIndex)
            print("-----")
        }
        print("---------------")
        print("----Process Table")
        for item in self.Ptable{
            print(item.word)
            print(item.count)
            print("---")
        }
    }
    //MARK:->En son geçtiği satırların doldurulması
    private func replaceObjectDependsWord(with hasharray:[Hash])->[LastSeenWord]{
        var lastSeenArray = [LastSeenWord]()
        for item in hasharray{
            guard let firstChar = item.PerfectString.first else {fatalError()}
            guard let lastChar = item.PerfectString.last else {fatalError()}
            guard let index = hasharray.firstIndex(where: {$0.PerfectString == item.PerfectString}) else {fatalError()}
            if lastSeenArray.count > 0 {
                let firstCharIfExists = lastSeentIfExists(with: lastSeenArray, andChar: String(firstChar))
                let lastCharIfExists = lastSeentIfExists(with: lastSeenArray, andChar: String(lastChar))
                //
                if firstCharIfExists != -1 && lastCharIfExists != -1 {
                    if firstCharIfExists > lastCharIfExists{
                        print("\(item.PerfectString) değişmesi gerekn yer  \(firstCharIfExists)")
                        self.changePlace(whichOne: item, andnewIndex: firstCharIfExists)
                    }else {
                         print("\(item.PerfectString) değişmesi gerekn yer  \(lastCharIfExists)")
                        self.changePlace(whichOne: item, andnewIndex: lastCharIfExists)
                    }
                }
                if firstCharIfExists != -1 {
                    lastSeenArray[firstCharIfExists].setterLastSeen(withIndex: index)
                }else {
                    lastSeenArray.append(LastSeenWord(getword: String(firstChar), getlastSeen:index))
                }
                //
                if lastCharIfExists != -1 {
                    lastSeenArray[lastCharIfExists].setterLastSeen(withIndex: index)
                }else {
                    lastSeenArray.append(LastSeenWord(getword: String(lastChar), getlastSeen:index))
                }
            }else {
                lastSeenArray.append(LastSeenWord(getword: String(firstChar), getlastSeen:index))
                lastSeenArray.append(LastSeenWord(getword: String(lastChar), getlastSeen: index))
            }
        }
        
        return lastSeenArray
    }
    //MARK:->Frekansların bulunması
    private func findFrequency(withWords array:[Word] ,andHashs:[Hash])->[Hash]{
        for item in andHashs{
            var firstFR = 0
            var lastFR = 0
            guard let firstChar = item.PerfectString.first else {fatalError()}
            guard let lastChar = item.PerfectString.last else {fatalError()}
            for worditem in array{
                if String(firstChar) == worditem.word{
                    firstFR = worditem.count
                }
                if String(lastChar) == worditem.word{
                    lastFR = worditem.count
                }
            }
            item.frekens = (lastFR + firstFR)
        }
        return andHashs
    }
    //MARK:-> Harf sayısı ile bulunması
    private func findWords(with array:[Hash])->[Word]{
        var wordArray = [Word]()
        for index in 0...array.count - 1{
            guard let first = array[index].PerfectString.first else {fatalError()}
            var firstcount = 1
            guard let last = array[index].PerfectString.last else {fatalError()}
            var lastcount = 1
            if checkIfexists(with: wordArray, withWord: String(first)) == false && checkIfexists(with: wordArray, withWord: String(last)) == false {
                if first == last {
                               // ikiside eşitse
                               firstcount += 1
                               for secondIndex in index + 1 ... array.count - 1{
                                   guard let secondFirst = array[secondIndex].PerfectString.first else {fatalError()}
                                   guard let secondLast = array[secondIndex].PerfectString.last else {fatalError()}
                                   if secondFirst == first{
                                       firstcount += 1
                                   }
                                   if secondLast == first{
                                       firstcount += 1
                                   }
                               }
                               wordArray.append(Word(GetWord:String(first), GetCount: firstcount))
                           }else {
                               // eğer eşit değilse ikisine ayrı ayrı bakılacak
                               for secondIndex in index + 1 ... array.count - 1{
                                   guard let secondFirst = array[secondIndex].PerfectString.first else {fatalError()}
                                   guard let secondLast = array[secondIndex].PerfectString.last else {fatalError()}
                                   if first == secondFirst{firstcount += 1}
                                   if first == secondLast{firstcount += 1}
                                   if last  == secondFirst{lastcount += 1}
                                   if last ==  secondLast{lastcount += 1}
                               }
                               wordArray.append(Word(GetWord: String(first), GetCount: firstcount))
                               wordArray.append(Word(GetWord: String(last), GetCount: lastcount))
                        }
            }
            else if checkIfexists(with: wordArray, withWord: String(first)) == false && checkIfexists(with: wordArray, withWord: String(last)) == true{
                for secondIndex in index + 1 ... array.count - 1{
                    guard let secondFirst = array[secondIndex].PerfectString.first else {fatalError()}
                    guard let secondLast = array[secondIndex].PerfectString.last else {fatalError()}
                    if secondFirst == first{
                        firstcount += 1
                    }
                    if secondLast == first{
                        firstcount += 1
                    }
                }
                wordArray.append(Word(GetWord: String(first), GetCount: firstcount))
            }
            else if checkIfexists(with: wordArray, withWord: String(first)) == true && checkIfexists(with: wordArray, withWord: String(last)) == false{
                for secondIndex in index + 1 ... array.count - 1{
                    guard let secondFirst = array[secondIndex].PerfectString.first else {fatalError()}
                    guard let secondLast = array[secondIndex].PerfectString.last else {fatalError()}
                    if secondFirst == last{
                        lastcount += 1
                    }
                    if secondLast == first{
                        lastcount += 1
                    }
                }
                wordArray.append(Word(GetWord: String(last), GetCount: lastcount))
            }
        }
        return wordArray
    }
    //MARK:->Kelime düzine tanımalamsı
    private func loadArray()->[Hash]{
           var loadArray = [Hash]()
           // create statement
           loadArray.append(Hash(Getstring: "cat", Getfrekans: 0))
           loadArray.append(Hash(Getstring: "ant", Getfrekans: 0))
           loadArray.append(Hash(Getstring: "dog", Getfrekans: 0))
           loadArray.append(Hash(Getstring: "gnat", Getfrekans: 0))
           loadArray.append(Hash(Getstring: "chimp", Getfrekans: 0))
           loadArray.append(Hash(Getstring: "rat", Getfrekans: 0))
           loadArray.append(Hash(Getstring: "toad", Getfrekans: 0))
           return loadArray
    }
    private func checkIfexists(with array:[Word],withWord:String)->Bool{
        for item in array{
            if item.word == withWord{
                return true
            }
        }
        return false
    }
    //MARK:->En son görülen var ise index yollmaası
    private func lastSeentIfExists(with array:[LastSeenWord],andChar:String)->Int{
        for item in array{
            if item.word == andChar{
                guard let index = array.firstIndex(where: {$0.word == item.word}) else {fatalError()}
                return index
            }
        }
        return -1
    }
    //MARK:->Yer değiştirilmesi
    // indexi alacak
    // diğer arraylerde var mu diye kontrol edecek
    //
    private func changePlace(whichOne:Hash,andnewIndex:Int){
        guard let index = self.hashArray.firstIndex(where: {$0.PerfectString == whichOne.PerfectString}) else {fatalError()}
        self.hashArray.remove(at: index)
        self.hashArray.insert(whichOne, at: andnewIndex)
    }
    private func lastPlacement(){
        for item in self.hashArray{
            guard let firstChar = item.PerfectString.first else {fatalError()}
            guard let lastChar = item.PerfectString.last else {fatalError()}
            guard let currentItemIndex = self.hashArray.firstIndex(where: {$0.PerfectString == item.PerfectString}) else {fatalError()}
            calcItem(item: item, firstChar: String(firstChar), lastChar: String(lastChar))
//            for hashItem in self.hashArray{
//                self.calcItem(item: item, hashItem: hashItem, firstChar: String(firstChar), lastChar: String(lastChar))
//            }
            if self.LastPlaceMentLastSeenArray.contains(where: {$0.word == String(firstChar)}) == true{
                guard let index = self.LastPlaceMentLastSeenArray.firstIndex(where: {$0.word == String(firstChar)}) else {fatalError()}
                self.LastPlaceMentLastSeenArray[index].setterLastSeen(withIndex: currentItemIndex)
            }else {self.LastPlaceMentLastSeenArray.append(LastSeenWord(getword: String(firstChar), getlastSeen: currentItemIndex))}
            //
            if self.LastPlaceMentLastSeenArray.contains(where: {$0.word == String(lastChar)}) == true{
                guard let index = self.LastPlaceMentLastSeenArray.firstIndex(where: {$0.word == String(lastChar)}) else {fatalError()}
                self.LastPlaceMentLastSeenArray[index].setterLastSeen(withIndex: currentItemIndex)
            }else {self.LastPlaceMentLastSeenArray.append(LastSeenWord(getword: String(lastChar), getlastSeen: currentItemIndex))}

            // eğer varsa ...
            // yoksa currentIndexi toplamı yap
        }
    }
    private func calcItem(item:Hash,firstChar:String,lastChar:String){
        var new_index = calcNewIndex(firstchar: String(firstChar), lastchar: String(lastChar), itemcount: item.PerfectString.count)
        if self.hashArray.contains(where: {$0.currentIndex == new_index && item.PerfectString != $0.PerfectString}){
            let old = PtableValue(char: String(lastChar))
            PtableUpdate(whichWord: String(lastChar), st: .Plus)
            if old == PtableValue(char: String(lastChar)){
                PtableUpdate(whichWord: String(firstChar), st: .Plus)
            }
            calcItem(item: item, firstChar: String(firstChar), lastChar: String(lastChar))
            new_index = calcNewIndex(firstchar: String(firstChar), lastchar: String(lastChar), itemcount: item.PerfectString.count)
            print("Çakışma var yeni indexi - >  : \(new_index)")
        }
        item.currentIndex = new_index
        print("\(item.PerfectString) : -> \(new_index) ")
    }
    private func calcNewIndex(firstchar:String,lastchar:String,itemcount:Int) -> Int{
        let valueOfFirstCharFromPTable = PtableValue(char: firstchar)
        let valueOfLastCharFromPTable = PtableValue(char: lastchar)
        let new_index = itemcount + valueOfFirstCharFromPTable + valueOfLastCharFromPTable
        return new_index
    }
    //MARK:-> Çakışmların print etmesi
    private func cakismaKontrol(gelen:Hash){
        for item in self.hashArray{
            if item.currentIndex == gelen.currentIndex && item.PerfectString != gelen.PerfectString && item.currentIndex != 0{
                print("-----")
                print("Çakıştığı değer ---  ")
                print(item.PerfectString)
                print(item.currentIndex)
                print("Gelen")
                print(gelen.PerfectString)
                print("-----")
            }
        }
    }
    //MARK:->Harfların P TableDaki değerli
    private func PtableValue(char:String) -> Int{
        for item in self.Ptable{
            if item.word == char{
                return item.count
            }
        }
        return -1
    }
    //MARK:-> Harflerin sayı update (BAĞIMSIZ HARF)
    private func PtableUpdate(whichWord:String,st:Stat){
        guard let index = self.Ptable.firstIndex(where: {$0.word == whichWord}) else {fatalError()}
        if st == .Plus{
            self.Ptable[index].count += 1
            if self.Ptable[index].count > self.ruleOfWord{
                self.Ptable[index].count = self.ruleOfWord
            }
        }else {
            self.Ptable[index].count -= 1
            if self.Ptable[index].count < 0{
                self.Ptable[index].count = 0
            }
        }
    }
}
class Hash{
      init(Getstring:String,Getfrekans:Int) {
          self.PerfectString = Getstring
          self.frekens = Getfrekans
      }
    func getCurrentIndex()->Int{return currentIndex}
    func setCurrentIndex(withIndex:Int){self.currentIndex = withIndex}
      var PerfectString:String = ""
      var frekens:Int = 0
      var currentIndex:Int = 0
  }
class Word {
    init(GetWord:String,GetCount:Int) {
        self.word = GetWord
        self.count = GetCount
    }
      var word:String = ""
      var count:Int = 0
}
class LastSeenWord {
    init(getword:String,getlastSeen:Int) {
        self.word = getword
        self.lastSeenIndex = getlastSeen
        self.status = true
    }
    func setterLastSeen(withIndex:Int){
        self.lastSeenIndex = withIndex
    }
    var word:String = ""
    var status:Bool = false
    var lastSeenIndex:Int = 0
}
enum Stat {
    case Plus
    case Minus
}
