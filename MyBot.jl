include("hlt.jl")
include("networking.jl")

myID, gameMap = getInit()
sendInit("KaiBot")

while true
  moves = Vector{Move}()
  gameMap = getFrame()
  for y in 0:gameMap.height-1
    for x in 0:gameMap.width-1
      if getSite(gameMap, Location(x, y)).owner == myID
        movedPiece = false
        for d in CARDINALS
          if getSite(gameMap, Location(x, y), d).owner != myID && getSite(gameMap, Location(x, y), d).strength < getSite(gameMap, Location(x, y)).strength
            push!(moves, Move(Location(x, y), d))
            movedPiece = true
            break
          end
        end
        if ~movedPiece && getSite(gameMap, Location(x, y)).strength < getSite(gameMap, Location(x, y)).production * 5
          push!(moves, Move(Location(x, y), STILL))
          movedPiece = true
        end
        if ~movedPiece
          push!(moves, Move(Location(x, y), rand([NORTH, WEST])))
          movedPiece = true
        end
      end
    end
  end
  sendFrame(moves)
end
