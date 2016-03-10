functor
import
  PlayerMod at 'player.ozf'
  Lib           at 'lib.ozf'
  PokemozMod    at 'pokemoz.ozf'
export
  UpdatePlayer
  UpdateTrainer
  IncrementTurn
  HealPlayerPokemoz
  UpdatePlayerAndEnemyTrainer
  CanPlayerMoveInDirection?
  IsPlayerNextToTrainer?
  IsPositionFree?
  IsPositionOnMap?
define
  fun {UpdatePlayer GameState NewPlayer}
    case GameState
    of   game_state(turn:Turn player:_         trainers:Trainers          map_info:MI)
    then game_state(turn:Turn player:NewPlayer trainers:Trainers  map_info:MI)
    end
  end

  fun {IncrementTurn GameState}
    case GameState
    of   game_state(turn:Turn    player:Player trainers:Trainers  map_info:MI)
    then game_state(turn:Turn+1  player:Player trainers:Trainers  map_info:MI)
    end
  end

  fun {HealPlayerPokemoz GameState}
    case GameState
    of   game_state(turn:Turn player:Player                         trainers:Trainers map_info:MI)
    then game_state(turn:Turn player:{PlayerMod.healPokemoz Player} trainers:Trainers map_info:MI)
    end
  end

  fun {UpdateTrainer GameState NewTrainer}
      fun {ReplaceTrainer Trainers}
        case Trainers
        of trainers(james:James brock:Brock misty:Misty) then
          if      NewTrainer.name == James.name then trainers(james:NewTrainer brock:Brock      misty:Misty)
          elseif  NewTrainer.name == Brock.name then trainers(james:James      brock:NewTrainer misty:Misty)
          elseif  NewTrainer.name == Misty.name then trainers(james:James      brock:Brock      misty:NewTrainer)
          end
        end
      end
  in
    case GameState
    of   game_state(turn:Turn player:Player map_info:MI trainers:Trainers)
    then game_state(turn:Turn player:Player map_info:MI trainers:{ReplaceTrainer Trainers})
    end
  end

  fun {UpdatePlayerAndEnemyTrainer GameState NewPlayer NewTrainer}
    {UpdatePlayer {UpdateTrainer GameState NewTrainer} NewPlayer}
  end

  fun {IsPositionFree? GameState Position}
    fun {PositionIsFreeRec Trainers}
      case Trainers
      of nil then true
      [] Trainer|T then
        if Trainer.position == Position then false
        else {PositionIsFreeRec T} end
      end
    end
  in
    {Bool.and {PositionIsFreeRec {Record.toList GameState.trainers}} Position\=GameState.player.position}
  end

  fun {IsPositionOnMap? GameState Position}
    MapWidth    = GameState.map_info.width
    MapHeight   = GameState.map_info.height
  in
    if Position.x >= 0
    andthen Position.y >= 0
    andthen Position.x < MapWidth
    andthen Position.y < MapHeight
    then true
    else false
    end
  end


  fun {CanPlayerMoveInDirection? GameState Direction}
    NewPosition = {Lib.positionInDirection GameState.player.position Direction}
    PlayerPos   = GameState.player.position
    HospPos     = GameState.map_info.hospital_pos
  in
    if GameState.player.position == HospPos andthen Direction\=down then
      false % Can only exit hospital by going down...
    else
      if      {IsPositionOnMap? GameState NewPosition}
      andthen {IsPositionFree?  GameState NewPosition} then
        case Direction
        of up    then true
        [] right then
          if (HospPos.x \= PlayerPos.x+1 orelse   HospPos.y \= PlayerPos.y)
            then true else false end
        [] down  then
           if (HospPos.y \= PlayerPos.y+1
           orelse   HospPos.x \= PlayerPos.x)
           then true else false end
        [] left then
           if (HospPos.x \= PlayerPos.x-1
           orelse   HospPos.y \= PlayerPos.y)
           then true else false end
           end
      else % Position was not free.
        false
      end
    end
  end

  fun {IsPlayerNextToTrainer? GameState Trainer}
    fun {PositionsAreAdjacent Pos1 Pos2}
      XDiff = {Abs (Pos1.x - Pos2.x)}
      YDiff = {Abs (Pos1.y - Pos2.y)}
    in
      if (XDiff+YDiff)==1 then true else false end
    end
    fun {TestTrainerMeetingRec Trainers}
      case Trainers
      of nil then false
      [] H|T then
        if {PositionsAreAdjacent GameState.player.position H.position}
        andthen {PokemozMod.allPokemozAreDead H.pokemoz_list}==false then
          Trainer = H
          true
        else {TestTrainerMeetingRec T} end
      end
    end
  in
    {TestTrainerMeetingRec {Record.toList GameState.trainers}}
  end
end
