import UIKit

//卡牌值
enum Rank: Int {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    func description() -> String {
        switch self {
        case .Ace:
            return "A"
        case .Jack:
            return "J"
        case .Queen:
            return "Q"
        case .King:
            return "K"
        default:
            return String(self.rawValue)
        }
    }
}

//卡牌类型
enum Suit: String {
    case Spade, Heart, Diamond, Club
    func description() -> String {
        switch self {
        case .Spade:
            return "♠︎"
        case .Heart:
            return "♥︎"
        case .Diamond:
            return "◆"
        case .Club:
            return "♣︎"
        }
    }
}

protocol EnumerataleEnumType {
    static var allValues: [Self] {get}
}

extension Suit: EnumerataleEnumType {
    static var allValues: [Suit] {
        return [.Spade, .Heart, .Diamond, .Club]
    }
}

extension Rank: EnumerataleEnumType {
    static var allValues: [Rank] {
        return [.Ace, .Two, .Three, .Four,
                .Five, .Six, .Seven, .Eight,
                .Nine, .Ten, .Jack, .Queen, .King]
    }
}

struct Card {
    var rank: Rank
    var suit: Suit
    func description() -> String {
        return "(\(suit.description()),\(rank.description()))"
    }
}

struct Player {
    var cards = [Card]()
    func showAllCards() -> Void {
        print("-----")
        for card in cards {
            print(card.description())
        }
        print("-----")
    }
}


class CardFactory {
    var cards = [Card]()
    
    init() {
        createCardGroup()
    }
    /**
     创建牌组（除去大小王）
     */
    func createCardGroup() -> Void {
        for suit in Suit.allValues {
            for rank in Rank.allValues {
                let card = createCard(pCardRank: rank, pCardSuit: suit)
                cards.append(card)
            }
        }
    }
    /**
     创建一张卡牌
     */
    func createCard(pCardRank: Rank, pCardSuit: Suit) -> Card {
        let card = Card(rank: pCardRank, suit: pCardSuit)
        return card
    }
    /**
     从牌组中挑选一张卡牌
     */
    func selectCard() -> Card {
        let cardCount = cards.count
        //获取0到cardCount的随机数
        let order = Int(arc4random_uniform(UInt32(cardCount)))
        let card = cards[order]
        cards.remove(at: order)
        return card
    }
    /**
     发牌(玩家数，卡牌数)
     */
    func dealCards(pPlayersNum: Int, pCardsNum: Int) -> [Player] {
        var players = [Player]()
        //需要的牌数多于现有牌数，不分配牌
        if (pPlayersNum * pCardsNum) > cards.count {
            print("需要的牌数多于现有牌数！请重新分配")
            return players
        }
        for i in 0..<pPlayersNum {
            players.append(Player())
            for _ in 0..<pCardsNum {
                players[i].cards.append(selectCard())
            }
        }
        return players
    }
}

let cardGroup = CardFactory()
//从牌组中抽取一张卡牌
print("抽取的卡牌为 \(cardGroup.selectCard().description())")
//多位玩家抽取多张卡牌
let players = cardGroup.dealCards(pPlayersNum: 4, pCardsNum: 12)
for player in players {
    player.showAllCards()
}

