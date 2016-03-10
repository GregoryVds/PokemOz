functor
import
  Lib at 'lib.ozf'
  CharactersMod at 'characters.ozf'
export
  MaxHealth
  SetHealth
  SetMaxHealth
  DealDamage
  Evolve
  BaseXpForLevel
  New
  WildPokemonLvl
  AllPokemozAreDead
  MinLevel
  MaxLevel
  Grass
  Water
  Fire
  Ground
  Poison
  Electric
  Flying
define
  MinLevel  = 5
  MaxLevel  = 10
  Grass     = grass
  Water     = water
  Fire      = fire
  Ground    = ground
  Poison    = poison
  Electric  = electric
  Flying    = flying

  fun {BaseXpForLevel Level}
    case Level
    of 5  then 0
    [] 6  then 5
    [] 7  then 12
    [] 8  then 20
    [] 9  then 30
    [] 10 then 50
    end
  end

  fun {MaxHealth Level}
     Level * 4
  end

  fun {New Name Type Level}
    pokemoz(name:   Name
            type:   Type
            level:  Level
            health: {MaxHealth Level}
            xp:     {BaseXpForLevel Level})
  end

  fun {WildPokemonLvl Turn}
     ComputedLevel = 4 + {Lib.rand ((Turn div 30)+1)}
  in
     if ComputedLevel > MaxLevel then MaxLevel
     else ComputedLevel
     end
  end

  fun {GrassDamage OtherType}
    case OtherType
    of grass  then 2
    [] water  then 3
    [] fire   then 1
    [] ground then 3
    [] poison then 1
    [] electric  then 2
    [] flying    then 1
    end
  end

  fun {WaterDamage OtherType}
    case OtherType
    of grass  then 1
    [] water  then 2
    [] fire   then 3
    [] ground then 3
    [] poison then 2
    [] electric  then 2
    [] flying    then 2
    end
  end

  fun {FireDamage OtherType}
    case OtherType
    of grass  then 3
    [] water  then 1
    [] fire   then 2
    [] ground then 2
    [] poison then 2
    [] electric  then 2
    [] flying    then 2
    end
  end

  fun {GroundDamage OtherType}
    case OtherType
    of grass  then 1
    [] water  then 2
    [] fire   then 3
    [] ground then 2
    [] poison then 3
    [] electric  then 3
    [] flying    then 0
    end
  end

  fun {PoisonDamage OtherType}
    case OtherType
    of grass  then 3
    [] water  then 2
    [] fire   then 2
    [] ground then 1
    [] poison then 2
    [] electric  then 2
    [] flying    then 2
    end
  end

  fun {ElectricDamage OtherType}
    case OtherType
    of grass     then 1
    [] water     then 3
    [] fire      then 2
    [] ground    then 0
    [] poison    then 2
    [] electric  then 1
    [] flying    then 3
    end
  end

  fun {FlyingDamage OtherType}
    case OtherType
    of grass     then 3
    [] water     then 2
    [] fire      then 2
    [] ground    then 2
    [] poison    then 2
    [] electric  then 1
    [] flying    then 2
    end
  end


  fun {Damage AType DType}
    case AType
    of grass     then {GrassDamage    DType}
    [] water     then {WaterDamage    DType}
    [] fire      then {FireDamage     DType}
    [] ground    then {GroundDamage   DType}
    [] poison    then {PoisonDamage   DType}
    [] electric  then {ElectricDamage DType}
    [] flying    then {FlyingDamage   DType}
    end
  end

  fun {LevelForXp Xp}
    if Xp < 5      then 5
    elseif Xp < 12 then 6
    elseif Xp < 20 then 7
    elseif Xp < 30 then 8
    elseif Xp < 50 then 9
    else 10
    end
  end

  fun {SetHealth Pokemoz Health}
    case Pokemoz
    of   pokemoz(name:Name type:Type level:Level health:_      xp:Xp)
    then pokemoz(name:Name type:Type level:Level health:Health xp:Xp)
    end
  end

  fun {SetMaxHealth Pokemoz}
    {SetHealth Pokemoz {MaxHealth Pokemoz.level}}
  end

  % Return defender
  fun {DealDamage Defender AttackerType}
    case Defender
    of pokemoz(name:Name type:Type level:Level health:Health xp:Xp)
    then Dmg = {Damage AttackerType Type}
    in pokemoz(name:Name type:Type level:Level health:{Max 0 (Health-Dmg)} xp:Xp)
    end
  end

  fun {Evolve Pokemon DefeatedPokemoz}
    case Pokemon
    of   pokemoz(name:Name type:Type level:Level health:Health xp:Xp)
    then
      NewXp    = Xp+DefeatedPokemoz.level
      NewLevel = {LevelForXp NewXp}
      NewHp    = if NewLevel==Level then Health else {MaxHealth NewLevel} end
      NewName
      if {Bool.'or' NewLevel==7 NewLevel==9} andthen {Value.hasFeature CharactersMod.evolutions Name} then
        NewName = CharactersMod.evolutions.Name
      else
        NewName = Name
      end

    in pokemoz(name:NewName type:Type level:NewLevel health:NewHp xp:NewXp)
    end
  end

  fun {AllPokemozAreDead PokemozList}
    case PokemozList
    of nil then true
    [] H|T then if H.health==0 then {AllPokemozAreDead T} else false end
    end
  end

end
