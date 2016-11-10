include("hlt.jl")

_productions = Vector{Vector{Int64}}()
_width = -1
_height = -1

function serializeMoveSet(moves::Vector{Move})
  returnString = ""
  for move in moves
    returnString *= string(move.loc.x) * " " * string(move.loc.y) * " " * string(move.direction) * " "
  end
  returnString
end

function deserializeMapSize(inputString::String)
  splitString = reverse(split(inputString, " "))

  _width = parse(pop!(splitString))
  _height = parse(pop!(splitString))
end

function deserializeProductions(inputString::String)
  splitString = reverse(split(inputString, " "))

  for a in 0:_height-1
    row = Vector{Int64}()
    for b in 0:_width-1
      push!(row, parse(pop!(splitString)))
    end
    push!(_productions, row)
  end
end

function deserializeMap(inputString::String)
  splitString = reverse(split(inputString, " "))

  m = GameMap(_width, _height)

  y = 0
  x = 0
  counter = 0
  owner = 0
  while y != m.height
    counter = parse(pop!(splitString))
    owner = parse(pop!(splitString))
    for a in 0:counter-1
      m.contents[y][x].owner = owner
      x += 1
      if x == m.width
        x = 0
        y += 1
      end
    end
  end

  for a in 0:_height-1
    for b in 0:_width-1
      m.contents[a][b].strength = parse(pop!(splitString))
      m.contents[a][b].production = _productions[a][b]
    end
  end

  m
end

function sendString(toBeSent::String)
  toBeSent *= '\n'

  write(STDOUT, toBeSent)
  flush(STDOUT)
end

function getString()
  rstrip(readline(), '\n')
end

function getInit()
  playerTag = parse(getString())
  deserializeMapSize(getString())
  deserializeProductions(getString())
  m = deserializeMap(getString())

  (playerTag, m)
end

function sendInit(name::String)
  sendString(name)
end

function getFrame()
  return deserializeMap(getString())
end

function sendFrame(moves::Vector{Move})
  sendString(serializeMoveSet(moves))
end
