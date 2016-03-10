functor
import
   Lib           at 'lib.ozf'
   PokemozMod    at 'pokemoz.ozf'
   GameStateMod  at 'game_state.ozf'
   Strings       at 'strings.ozf'
export
   GenerateNextInstruction
   ShouldFight
   Init
define
  HospitalPosition
  VictoryPosition
  Interface

  proc {Init HospitalPos VictoryPos Interf}
    HospitalPosition = HospitalPos
    VictoryPosition  = VictoryPos
    Interface        = Interf
  end

  fun {InFrontHospital GameState}
     if GameState.player.position.x == HospitalPosition.x andthen
        GameState.player.position.y == HospitalPosition.y+1 then true
     else false
     end
  end

  fun {InHospital GameState}
    GameState.player.position == HospitalPosition
  end

  fun {MoveToCapture GameState}
     {Interface.setCenterLabel Strings.autoPilotCaptureStep}
     {Lib.debug move_to_capture}
     PlayerX = GameState.player.position.x
     PlayerY = GameState.player.position.y
  in
     if PlayerX > HospitalPosition.x      andthen PlayerY > HospitalPosition.y    then left
     elseif PlayerX == HospitalPosition.x andthen PlayerY > HospitalPosition.y+1  then up
     elseif PlayerX == HospitalPosition.x andthen PlayerY == HospitalPosition.y+1 then down
     end
  end

  fun {MoveToHospital GameState}
     {Lib.debug move_to_hospital}
     PlayerX = GameState.player.position.x
     PlayerY = GameState.player.position.y
  in
     if PlayerY > HospitalPosition.y+2      then up
     elseif PlayerY < HospitalPosition.y+1  then down
     else
        if PlayerX < HospitalPosition.x     then right
        elseif PlayerX > HospitalPosition.x then left
        else up %% Rentre dans l'hopital
        end
     end
  end

  fun {MoveToFinish GameState}
     {Interface.setCenterLabel Strings.autoPilotFinalStep}
     {Lib.debug move_to_finish}
     PlayerX = GameState.player.position.x
     PlayerY = GameState.player.position.y
  in
     if {InFrontHospital GameState} then right
     elseif PlayerY > VictoryPosition.y+2 then
        if {InFrontHospital GameState}     then right
        else up
        end
     elseif PlayerY < VictoryPosition.y+1  then down
     else
        if PlayerX < VictoryPosition.x     then right
        elseif PlayerX > VictoryPosition.x then left
        else up
        end
     end
  end

  fun {MoveToTrainer GameState TrainerName}
     {Interface.setCenterLabel Strings.TrainerName}
     PlayerX = GameState.player.position.x
     PlayerY = GameState.player.position.y
  in
     if {InFrontHospital GameState} then left
     elseif PlayerY < GameState.trainers.TrainerName.position.y then down
     elseif PlayerY > GameState.trainers.TrainerName.position.y andthen {InFrontHospital GameState}==false then up
     elseif PlayerX < GameState.trainers.TrainerName.position.x then right
     else left
     end
  end


  fun {Move GameState}
     if {InHospital GameState}                                                          then down
     elseif {PokemozMod.allPokemozAreDead GameState.player.pokemoz_list}                then {MoveToHospital GameState}
     elseif {Length GameState.player.pokemoz_list} < 3                                  then {MoveToCapture GameState}
     elseif {PokemozMod.allPokemozAreDead GameState.trainers.misty.pokemoz_list}==false then {MoveToTrainer GameState misty}
     elseif {PokemozMod.allPokemozAreDead GameState.trainers.brock.pokemoz_list}==false then {MoveToTrainer GameState brock}
     elseif {PokemozMod.allPokemozAreDead GameState.trainers.james.pokemoz_list}==false then {MoveToTrainer GameState james}
     else {MoveToFinish GameState}
     end
  end

  fun {GenerateNextInstruction GameState}
     Direction = {Move GameState}
     Free?     = GameStateMod.isPositionFree?
     CanMove?  = GameStateMod.canPlayerMoveInDirection?
     XPos      = GameState.player.position.x
     YPos      = GameState.player.position.y
   in
     if {GameStateMod.canPlayerMoveInDirection? GameState Direction} then Direction
     else
	if {CanMove? GameState right} andthen {Free? GameState pos(XPos+1 YPos)} then right
	elseif {CanMove? GameState up}        andthen {Free? GameState pos(XPos YPos-1)} then up
        elseif {CanMove? GameState down}  andthen {Free? GameState pos(XPos YPos+1)} then down
        elseif {CanMove? GameState left}  andthen {Free? GameState pos(XPos-1 YPos)} then left
	end
     end
  end

  fun {ShouldFight GameState WildPokemon}
    true
  end


end
