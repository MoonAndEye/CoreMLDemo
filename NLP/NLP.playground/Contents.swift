import Foundation
import NaturalLanguage

// 語種代碼 ISO 639-1
// https://zh.wikipedia.org/wiki/ISO_639-1
// 日語是 ja
// 추운지방에서살던학자가더운지방으로여행을갔어요
// 飛行機がそらを飛んでくる
// 今天下雨了

// 中文

// "今日的臺北市只包含12個區，面積為271.7997平方公里 ，人口超過260萬。而臺北都會區面積為2,457.1253 平方公里，人口約704萬，包括由同臺北市外的基隆市、新北市的蘆洲、三重、新莊、板橋、中和、永和、新店、汐止、樹林、土城、五股、泰山、淡水由上述2個城市都區與臺北市共同組成的大型都會區，而這片區域又泛稱大臺北地區或雙北市。"

// 馬來語和印尼語有問題,會被判成義大利語,克羅埃西亞語或土耳其語
//     Selamat pagi
// sila berhati hati ruang di platform
// 印尼文
// Sekarang sudah pukul 10.00 siang.  Dia belum bangun?
// Kami akan pergi keluar negeri minggu depan.

// 泰文
// กรุงเทพมหานคร เป็นเมืองหลวงและนครที่มีประชากรมากที่สุดของประเทศไทย เป็นศูนย์กลางการปกครอง การศึกษา การคมนาคมขนส่ง การเงินการธนาคาร การพาณิชย์ การสื่อสาร และความเจริญของประเทศ เป็นเมืองที่มีชื่อยาวที่สุดในโลก ตั้งอยู่บนสามเหลี่ยมปากแม่น้ำเจ้าพระยา มีแม่น้ำเจ้าพระยาไหลผ่านและแบ่งเมืองออกเป็น 2 ฝั่ง คือ ฝั่งพระนครและฝั่งธนบุรี กรุงเทพมหานครมีพื้นที่ทั้งหมด 1,568.737 ตร.กม. มีประชากรตามทะเบียนราษฎรกว่า 5 ล้านคน ทำให้กรุงเทพมหานครเป็นเอกนคร จัด มีผู้กล่าวว่า กรุงเทพมหานครเป็น "เอกนครที่สุดในโลก" เพราะมีประชากรมากกว่านครที่มีประชากรมากเป็นอันดับ 2 ถึง 40 เท่

// 法文
//Bienvenue sur le site « Phonétique ». Ce site s’adresse aux personnes qui veulent apprendre le français mais il peut aussi être utilisé par les francophones

// 德文
//Es ist nun schon lange her, da lebte ein König, dessen Weisheit im ganzen Lande berühmt war. Nichts blieb ihm unbekannt und es war, als ob ihm Nachricht von den verborgensten Dingen durch die Luft zugetragen würde.

let regognizer = NLLanguageRecognizer()
let testStr = "sila berhati hati ruang di platform"
regognizer.processString(testStr)
let lang = regognizer.dominantLanguage
let hypothesis = regognizer.languageHypotheses(withMaximum: 4)




// ===== 斷詞系統 =====

// 斷詞測試
// Document, paragraph, sentence, word
let tokenizer = NLTokenizer(unit: .word)
let str = "下一個講者的演講一定很精釆，對機器學習有興趣的朋友請留下來聽"
let strRange = str.startIndex ..< str.endIndex
tokenizer.string = str
// tokens 會輸出 Range<Set>,
let tokenArray = tokenizer.tokens(for: strRange)
for each in tokenArray {
    print(str[each])
}



//===== Named Entity Recongnition =====

let tagger = NLTagger(tagSchemes: [.nameType])

let nameStr = "Prince Harry and Meghan Markle had their wedding ceremony in Windsor"

let nameStrRange = nameStr.startIndex ..< nameStr.endIndex

tagger.string = nameStr

tagger.setLanguage(.english, range: nameStrRange)

let tags = tagger.tags(in: nameStrRange, unit: .word, scheme: .nameType, options: .omitWhitespace)

for each in tags {
    
    if let eachTag = each.0 {
        
        if eachTag == .personalName {
            print("找到人名: \(nameStr[each.1])")
        }
        else if eachTag == .placeName {
            print("找到地名: \(nameStr[each.1])")
        }
    }
}

