import Foundation

struct KMMSETest {
    // 1. 시간 지남력 (5점)
    struct TimeOrientation {
        var year: Bool = false
        var season: Bool = false
        var date: Bool = false
        var dayOfWeek: Bool = false
        var month: Bool = false
        
        var score: Int {
            return [year, season, date, dayOfWeek, month].filter { $0 }.count
        }
    }
    
    // 1. 장소 지남력 (5점)
    struct PlaceOrientation {
        var country: Bool = false
        var province: Bool = false
        var district: Bool = false
        var building: Bool = false
        var floor: Bool = false
        
        var score: Int {
            return [country, province, district, building, floor].filter { $0 }.count
        }
    }
    
    // 2. 기억력 (3점)
    struct Memory {
        var words: [String] = []
        var remembered: [Bool] = [false, false, false]
        
        var score: Int {
            return remembered.filter { $0 }.count
        }
    }
    
    // 3. 주의력 및 계산력 (5점)
    struct Attention {
        var calculations: [Bool] = Array(repeating: false, count: 5)
        var backwardSpelling: [Bool] = Array(repeating: false, count: 5)
        var useCalculation: Bool = true
        
        var score: Int {
            if useCalculation {
                return calculations.filter { $0 }.count
            } else {
                return backwardSpelling.filter { $0 }.count
            }
        }
    }
    
    // 4. 기억 회상 (3점)
    struct Recall {
        var remembered: [Bool] = [false, false, false]
        
        var score: Int {
            return remembered.filter { $0 }.count
        }
    }
    
    // 5. 언어 능력 (8점)
    struct Language {
        var naming: [Bool] = [false, false] // 시계, 연필 (2점)
        var repetition: Bool = false // 문장 따라 말하기 (1점)
        var threeStageCommand: [Bool] = [false, false, false] // 3단계 명령 (3점)
        var reading: Bool = false // 읽고 수행하기 (1점)
        var writing: Bool = false // 쓰기 (1점)
        
        var score: Int {
            return naming.filter { $0 }.count +
                   (repetition ? 1 : 0) +
                   threeStageCommand.filter { $0 }.count +
                   (reading ? 1 : 0) +
                   (writing ? 1 : 0)
        }
    }
    
    // 6. 구성 능력 (1점)
    struct Construction {
        var drawing: Bool = false
        
        var score: Int {
            return drawing ? 1 : 0
        }
    }
    
    var timeOrientation = TimeOrientation()
    var placeOrientation = PlaceOrientation()
    var memory = Memory()
    var attention = Attention()
    var recall = Recall()
    var language = Language()
    var construction = Construction()
    
    var totalScore: Int {
        return timeOrientation.score +
               placeOrientation.score +
               memory.score +
               attention.score +
               recall.score +
               language.score +
               construction.score
    }
} 