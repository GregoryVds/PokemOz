functor
import
  Application
  System
  Module
  Property
  Lib           at 'lib.ozf'
  Strings       at 'strings.ozf'
  CharactersMod at 'characters.ozf'
  MapMod        at 'map.ozf'
  InterfaceMod  at 'interface.ozf'
  FightMod      at 'fight.ozf'
  GameIntro     at 'gameIntro.ozf'
  GameStateMod  at 'game_state.ozf'
  PlayerMod     at 'player.ozf'
  AutoPilot     at 'auto_pilot.ozf'
  PokemozMod    at 'pokemoz.ozf'
define
  {Lib.debug game_started}

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %  ____   _    ____  ____  _____      _    ____   ____ ____
  % |  _ \ / \  |  _ \/ ___|| ____|    / \  |  _ \ / ___/ ___|
  % | |_) / _ \ | |_) \___ \|  _|     / _ \ | |_) | |  _\___ \
  % |  __/ ___ \|  _ < ___) | |___   / ___ \|  _ <| |_| |___) |
  % |_| /_/   \_\_| \_\____/|_____| /_/   \_\_| \_\\____|____/
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Default values
  DELAY           = 200
  MAP             = 'Map.txt'
  WILD_POKE_PROBA = 20
  SPEED           = 9
  AUTOFIGHT       = false
  Say             = System.showInfo
  Args = {Application.getArgs record(
             map(single char:&m type:atom default:MAP)
     probability(single char:&p type:int  default:WILD_POKE_PROBA)
           speed(single char:&s type:int  default:SPEED)
       autofight(single char:&a type:bool default:AUTOFIGHT)
            help(single char:[&? &h] default:false))}

  if Args.help then
    {Say "Usage: "#{Property.get 'application.url'}#" [option]"}
    {Say "Options:"}
    {Say "  -m, --map FILE\tFile containing the map (default "#MAP#")"}
    {Say "  -p, --probability INT\tProbability to find a wild pokemoz in tall grass"}
    {Say "  -s, --speed INT\tThe speed of your pokemoz trainer in a range from 0 to 10"}
    {Say "  -a, --autofight BOOL\tChoice weither the game is automatic or not"}
    {Say "  -h, -?, --help\tThis help"}
    {Application.exit 0}
  end

  MapPath          = Args.map
  WildPokemozProba = Args.probability
  Speed            = Args.speed
  AutoFight        = Args.autofight
  TurnDuration = (10-Speed)*DELAY
  {Lib.debug arguments_parsed}

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %  ___ _   _ ___ _____    ____    _    __  __ _____ ____ _____  _  _____ _____
  % |_ _| \ | |_ _|_   _|  / ___|  / \  |  \/  | ____/ ___|_   _|/ \|_   _| ____|
  %  | ||  \| || |  | |   | |  _  / _ \ | |\/| |  _| \___ \ | | / _ \ | | |  _|
  %  | || |\  || |  | |   | |_| |/ ___ \| |  | | |___ ___) || |/ ___ \| | | |___
  % |___|_| \_|___| |_|    \____/_/   \_\_|  |_|_____|____/ |_/_/   \_\_| |_____|
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  InstructionsStream
  InstructionsPort = {NewPort InstructionsStream}

  fun {InitGame}
    % Ask player name and starting pokemoz
    PlayerName PokemozName
    {GameIntro.getUserChoice PlayerName PokemozName}

    % Load map
    Map       = {MapMod.loadMapFromFile MapPath}
    MapHeight = {Width Map}
    MapWidth  = {Width Map.1}

    % Configure map elements
    VictoryPosition  = pos(x:MapWidth-1 y:0)
    HospitalPosition = pos(x:4 y:3)

    % Prepare main data structures
    MapInfo          = map_info(map_record:Map height:MapHeight width:MapWidth
                                hospital_pos:HospitalPosition victory_pos:VictoryPosition)
    StartingPos      = pos(x:MapInfo.width-1 y:MapInfo.height-1)
    Player           = player(name:{String.toAtom PlayerName}
                              image:characters_player
                              position:StartingPos
                              selected_pokemoz:1
                              pokemoz_list:[CharactersMod.basePokemoz.PokemozName])
    GameState        = game_state(turn:0 player:Player trainers:CharactersMod.trainers map_info:MapInfo)


    BindKeys         = proc {$} {Lib.bindKeyboardArrows   Window InstructionsPort} end
    UnbindKeys       = proc {$} {Lib.unbindKeyboardArrows Window} end

    % Prepare application main window
    MapPlaceHolder
    InterfacePlaceHolder
    [QTk]  = {Module.link ["x-oz://system/wp/QTk.ozf"]}
    Window = {QTk.build td(title:Strings.title td(pady:20 padx:20 % Cannot set padding on top-level.
                            placeholder(glue:n handle:MapPlaceHolder        width:1100 height:560)
                            placeholder(glue:n handle:InterfacePlaceHolder  width:1100 height:220)))}
    {Window show}
    {Window set(geometry:geometry(width:1 height:1))}

    % Initialize map interface
    {MapMod.init MapPlaceHolder Map}
    {MapMod.drawPikachuAtPosition  VictoryPosition}
    {MapMod.drawTrainer            GameState.trainers.brock}
    {MapMod.drawTrainer            GameState.trainers.misty}
    {MapMod.drawTrainer            GameState.trainers.james}
    {MapMod.drawPlayerAtPosition   GameState.player.position}
    {MapMod.drawHospitalAtPosition GameState.map_info.hospital_pos}

    % Initialize other modules
    {InterfaceMod.init InterfacePlaceHolder GameState BindKeys UnbindKeys}
    {FightMod.init InterfaceMod AutoFight}
    if AutoFight then {AutoPilot.init GameState.map_info.hospital_pos VictoryPosition InterfaceMod} else {BindKeys} end

    % Show window
    {Window set(geometry:geometry(width:1200 height:810))}
  in
    GameState
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %   ____    _    __  __ _____ _     ___   ___  ____
  %  / ___|  / \  |  \/  | ____| |   / _ \ / _ \|  _ \
  % | |  _  / _ \ | |\/| |  _| | |  | | | | | | | |_) |
  % | |_| |/ ___ \| |  | | |___| |__| |_| | |_| |  __/
  % \____/_/   \_\_|  |_|_____|_____\___/ \___/|_|
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  fun {PlayerMeetsWildPokemoz? GameState}
     {Bool.and {MapMod.isGrass GameState.map_info.map_record GameState.player.position} ({Lib.rand 100}=<WildPokemozProba)}
  end

  proc {SendNextAutoPilotInstruction GameState}
    {Send InstructionsPort {AutoPilot.generateNextInstruction GameState}}
  end

  fun {MoveTrainers GameState}
     TrainerToMove = {List.nth {Record.toList GameState.trainers} ((GameState.turn mod 3)+1)}
     fun {MoveTrainersRec GameState Trainer}
       Dir    = {Lib.randomDir}
       NewPos = {Lib.positionInDirection Trainer.position Dir}
     in
        if {GameStateMod.isPositionOnMap? GameState NewPos}
           andthen {GameStateMod.isPositionFree?  GameState NewPos}
           andthen (NewPos\=GameState.map_info.hospital_pos)
           andthen {Bool.'or' (NewPos.x\=GameState.map_info.hospital_pos.x)
                              (NewPos.y\=GameState.map_info.hospital_pos.y+1)} % Dont block hospital...
           andthen (NewPos\=GameState.map_info.victory_pos) then
           NewTrainer = {PlayerMod.updatePositionInDirection Trainer Dir} in
           thread {MapMod.movePlayer Trainer Dir TurnDuration _} end
           {GameStateMod.updateTrainer GameState NewTrainer}
        else
           {MoveTrainersRec GameState Trainer}
        end
     end
  in
    {MoveTrainersRec GameState TrainerToMove}
  end

  proc {GameLoop InstructionsStream GameState}
    fun {PlayerIsAtHospital GameState} GameState.player.position == GameState.map_info.hospital_pos end
    fun {PlayerWon GameState}
      if GameState.player.position == GameState.map_info.victory_pos
      andthen {Length GameState.player.pokemoz_list} == 3
      andthen {PokemozMod.allPokemozAreDead GameState.trainers.misty.pokemoz_list}
      andthen {PokemozMod.allPokemozAreDead GameState.trainers.brock.pokemoz_list}
      andthen {PokemozMod.allPokemozAreDead GameState.trainers.james.pokemoz_list}
      then true else false end
    end

    fun {MovePlayer GameState Direction}
      PlayerDone
      NewPlayer         = {PlayerMod.updatePositionInDirection GameState.player Direction}
      AfterPlayerMove   = {GameStateMod.updatePlayer GameState NewPlayer}
      AfterTrainerMoves = {MoveTrainers AfterPlayerMove} in
      thread PlayerDone = {MapMod.movePlayer GameState.player Direction TurnDuration} end
      if PlayerDone then AfterTrainerMoves end
    end
    AfterMoveState AfterActionState Trainer
  in
    case InstructionsStream of Direction|T then
    {Lib.debug instruction_received(Direction)}

    % Test is movement is valid
    if {GameStateMod.canPlayerMoveInDirection? GameState Direction}==false then
       {Lib.debug invalid_command(Direction)}
       {GameLoop T GameState}
    else
       {Lib.debug turn_started(GameState.turn)}
       AfterMoveState = {MovePlayer GameState Direction}
       {Lib.debug player_moved_to(AfterMoveState.player.position)}
    end

    % Execute turn action
    if {PlayerIsAtHospital AfterMoveState} then
      AfterActionState = {GameStateMod.healPlayerPokemoz AfterMoveState}
      {InterfaceMod.updatePlayer1 AfterActionState.player}
    elseif {GameStateMod.isPlayerNextToTrainer? AfterMoveState Trainer} then
      AfterActionState = {FightMod.fightTrainer AfterMoveState Trainer}
    elseif {PlayerMeetsWildPokemoz? AfterMoveState} then
      AfterActionState = {FightMod.meetWildPokemoz AfterMoveState}
    else
      AfterActionState = AfterMoveState
    end

    % Test if player won the game
    if {PlayerWon AfterActionState} then
      {Lib.debug game_won}
      {InterfaceMod.writeMessage Strings.gameWon}
      {Exception.'raise' terminate_process_with_exception}
    end

    % Start next loop
    if AutoFight then {SendNextAutoPilotInstruction AfterActionState} end
      {GameLoop T {GameStateMod.incrementTurn AfterActionState}}
    end
  end

  % Kickoff!
  InitialGameState = {InitGame}
  if AutoFight then {SendNextAutoPilotInstruction InitialGameState} end
  {GameLoop InstructionsStream InitialGameState}

end
