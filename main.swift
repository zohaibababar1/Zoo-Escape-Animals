import Foundation

// create a function which randomly initialize animals in neighborhoods

func initializeAnimals() -> [String: Int] {
//   now this function is used to randomly initializes animals in three neighborhoods (Brooklyn, Queens, Manhattan) with random range.
//    here it returns a dictionary by using key value pairs, where keys are neighborhood names and values are the number of animals.
    
    return [
        "Brooklyn": Int.random(in: 1...10),
        "Queens": Int.random(in: 1...10),
        "Manhattan": Int.random(in: 1...10)
    ]
}

// create another function to Initializes a player in the gamesWonByPlayer dictionary if they are not already present.

func initializePlayer(playerName: String) {
    if gamesWonByPlayer[playerName] == nil {
        gamesWonByPlayer[playerName] = 0
    }
}

// create function to update scoreboard and display games won by each player
// displays the current scoreboard showing games won by each player.
func updateAndDisplayScoreboard(player1Name: String, player2Name: String) {
    print("Scoreboard:")
    print("\(player1Name): \(gamesWonByPlayer[player1Name] ?? 0) games won")
    print("\(player2Name): \(gamesWonByPlayer[player2Name] ?? 0) games won")
}

// Function to display the current escaped animal list
func displayAnimalList(animalsInNeighborhoods: [String: Int]) {
    print("Escaped Animal List")
    print("---------")
    var index = 1
    for (neighborhood, count) in animalsInNeighborhoods {
        if count > 0 {
            var animalIcons = ""
            for _ in 1...count {
                animalIcons += "*"
            }
            print("\(index): \(neighborhood) (\(count)): \(animalIcons)")
            index += 1
        } else {
            print("\(index): \(neighborhood) (0): 0")
            index += 1
        }
    }
    print("")
}
//create a global variable where dictionary is used to tracking the number of games won by each player
var gamesWonByPlayer: [String: Int] = [:]


//Main function to start the game
//Manages game flow, player turns, and gameplay mechanics.
//Uses a while loop to continuously prompt players with a menu and handle their input until the game ends.
func playZooEscape() {
    var player1Name = ""
    var player2Name = ""
//    animalsInNeighborhoods is initialized as an empty dictionary ([String: Int]) to store the count of animals in each neighborhood.
    var animalsInNeighborhoods = [String: Int]()
//    currentPlayer is initialized as an empty string to keep track of the current player's turn.
    var currentPlayer: String = ""

    while true {
//        Players can choose to start the game or view the scoreboard.
        print("Welcome to Zoo Escape!")
        print("MENU:")
        print("1. Start game")
        print("2. Show scoreboard")
        print("Choose an option:")

//        For starting the game, bith players must enter their names which are then initialized in the game state.
        
        if let menuChoice = readLine(), let choice = Int(menuChoice) {
            if choice == 1 {
                print("Two Player Game")
                print("Enter player 1 name: ")
                player1Name = readLine() ?? "Player 1"
                
                initializePlayer(playerName: player1Name)
                
                print("Enter player 2 name: ")
                player2Name = readLine() ?? "Player 2"
                initializePlayer(playerName: player2Name)

//                Animals are randomly initialized in neighborhoods.
                
                animalsInNeighborhoods = initializeAnimals()

                currentPlayer = Bool.random() ? player1Name : player2Name
                print("\(currentPlayer), you go first.")

//                A while loop is initiated, continuing as long as there are animals left in any neighborhood (animalsInNeighborhoods.values.reduce(0, +) > 0).
                
                while animalsInNeighborhoods.values.reduce(0, +) > 0 {
                    
//                    The displayAnimalList() function is called to show the current state of neighborhoods and their animals.
                    
                    displayAnimalList(animalsInNeighborhoods: animalsInNeighborhoods)
                    
                    print("\(currentPlayer), choose a neighborhood (1, 2, 3): ")
//                Players take turns choosing a neighborhood and capturing animals from that neighborhood until all animals are captured.
                    if let neighborhoodIndexStr = readLine(), let neighborhoodIndex = Int(neighborhoodIndexStr), neighborhoodIndex >= 1 && neighborhoodIndex <= 3 {
                        let neighborhoodKey = Array(animalsInNeighborhoods.keys)[neighborhoodIndex - 1]
                        if let neighborhoodCount = animalsInNeighborhoods[neighborhoodKey], neighborhoodCount > 0 {
                            print("How many animals do you want to capture? (1-\(neighborhoodCount)): ")
                            if let captureCountStr = readLine(), let captureCount = Int(captureCountStr), captureCount > 0 && captureCount <= neighborhoodCount {
//                               After each turn, the game state updates, and the turn switches to the other player.
                                animalsInNeighborhoods[neighborhoodKey] = neighborhoodCount - captureCount
                                currentPlayer = (currentPlayer == player1Name) ? player2Name : player1Name
                            } else {
                                print("Invalid capture quantity. Please choose a valid number of animals.")
                            }
                        } else {
                            print("No animals left in \(neighborhoodKey). Please choose another neighborhood.")
                        }
                    } else {
                        print("Invalid neighborhood selection. Please choose a valid neighborhood (1, 2, 3).")
                    }
                }

                // Determine the winner based on the last player who captured an animal
                let winner = (currentPlayer == player1Name) ? player2Name : player1Name
                print("Game Over!")
                print("Congratulations, \(winner)! You captured the last animal and won the game!")
                gamesWonByPlayer[winner] = (gamesWonByPlayer[winner] ?? 0) + 1

            } else if choice == 2 {
                // Show updated scoreboard
                updateAndDisplayScoreboard(player1Name: player1Name, player2Name: player2Name)
            } else {
                print("Invalid menu option. Please choose a valid option.")
            }
        } else {
            print("Invalid input. Please enter a valid menu option.")
        }
    }
}

playZooEscape()
