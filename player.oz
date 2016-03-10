functor
import
  Lib        at 'lib.ozf'
  PokemozMod at 'pokemoz.ozf'
export
  UpdatePokemoz
  UpdateCurrentPokemoz
  UpdatePositionInDirection
  UpdatePosition
  UpdatePokemozSelection
  GetSelectedPokemoz
  SwitchToPokemoz
  SwitchToNextPokemoz
  HealPokemoz
  EvolveSelectedPokemoz
  CapturePokemoz
  GetWildPlayer
define
  fun {UpdatePokemoz Player NewPokemoz Index}
    case Player
    of player(name:Name image:Img position:Pos pokemoz_list:List selected_pokemoz:SP)
    then NewList = {Lib.replaceNthInList List Index NewPokemoz}
    in player(name:Name image:Img position:Pos pokemoz_list:NewList selected_pokemoz:SP)
    end
  end

  fun {UpdateCurrentPokemoz Player NewPokemoz}
    {UpdatePokemoz Player NewPokemoz Player.selected_pokemoz}
  end

  fun {SwitchToPokemoz Player Index}
    case Player
    of   player(name:Name image:Img position:Pos pokemoz_list:List selected_pokemoz:_)
    then player(name:Name image:Img position:Pos pokemoz_list:List selected_pokemoz:Index)
    end
  end

  fun {GetSelectedPokemoz Player}
    {List.nth Player.pokemoz_list Player.selected_pokemoz}
  end

  fun {SwitchToNextPokemoz Player}
    PokemozCount = {List.length Player.pokemoz_list}
    NextIndex    = (Player.selected_pokemoz mod PokemozCount) + 1
    NewPlayer    = {SwitchToPokemoz Player NextIndex}
  in
    if {GetSelectedPokemoz NewPlayer}.health == 0 then {SwitchToNextPokemoz Player}
    else NewPlayer end
  end

  fun {UpdatePositionInDirection Player Direction}
    case Player
    of   player(name:Name image:Img position:Pos pokemoz_list:Pokemoz selected_pokemoz:SP)
    then player(name:Name image:Img position:{Lib.positionInDirection Pos Direction} pokemoz_list:Pokemoz selected_pokemoz:SP)
    end
  end

  fun {UpdatePosition Player Position}
    case Player
    of   player(name:Name image:Img position:_        pokemoz_list:Pokemoz selected_pokemoz:SP)
    then player(name:Name image:Img position:Position pokemoz_list:Pokemoz selected_pokemoz:SP)
    end
  end

  fun {HealPokemoz Player}
    fun {HealPokemozRec PokemozList}
      case PokemozList
      of nil then nil
      [] H|T then {PokemozMod.setMaxHealth H}|{HealPokemozRec T}
      end
    end
  in
    case Player
    of   player(name:Name image:Img position:Pos pokemoz_list:Pokemoz                  selected_pokemoz:SP)
    then player(name:Name image:Img position:Pos pokemoz_list:{HealPokemozRec Pokemoz} selected_pokemoz:SP)
    end
  end

  fun {EvolveSelectedPokemoz Player DefeatedPokemoz}
    case Player
    of   player(name:Name image:Img position:Pos pokemoz_list:PokemozList selected_pokemoz:SP)
    then EvolvedPokemon = {PokemozMod.evolve {List.nth PokemozList SP} DefeatedPokemoz}
         NewPokemonList = {Lib.replaceNthInList PokemozList SP EvolvedPokemon}
    in player(name:Name image:Img position:Pos pokemoz_list:NewPokemonList selected_pokemoz:SP)
    end
  end

  fun {CapturePokemoz Player NewPokemoz}
    case Player
    of   player(name:Name image:Img position:Pos pokemoz_list:PokemozList                       selected_pokemoz:SP)
    then player(name:Name image:Img position:Pos pokemoz_list:{Append PokemozList [NewPokemoz]} selected_pokemoz:SP)
    end
  end

  fun {GetWildPlayer WildPokemoz}
    player(name:wild image:characters_wild position:nil pokemoz_list:[WildPokemoz] selected_pokemoz:1)
  end

  fun {UpdatePokemozSelection Player NewIndex}
    case Player
    of   player(name:Name image:Img position:Pos pokemoz_list:PokemozList selected_pokemoz:_)
    then player(name:Name image:Img position:Pos pokemoz_list:PokemozList selected_pokemoz:NewIndex)
    end
  end


end
