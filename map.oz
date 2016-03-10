functor
import
   Pickle
   Module
   Lib at 'lib.ozf'
export
   Init
   DrawMap
   DrawPlayerAtPosition
   DrawHospitalAtPosition
   DrawPikachuAtPosition
   DrawTrainer
   MovePlayer
   IsGrass
   LoadMapFromFile
define
   [QTk] = {Module.link ["x-oz://system/wp/QTk.ozf"]}
   ImageLibrary = {QTk.loadImageLibrary "ImageLibrary.ozf"}

   % Constants
   CANVAS_OFFSET_BUG = 3
   TILE_SIZE = 80
   GRASS = 1
   ROAD  = 0

   % Handles
   Handles = handles(map_canvas:_ player:_ brock:_ misty:_ james:_)

   % Private methods

   fun {GetImage Name}
      {ImageLibrary get(name:Name image:$)}
   end

   % Coordinates from position helpers
   fun {XCoord XPosition}
      (XPosition*TILE_SIZE)+CANVAS_OFFSET_BUG
   end

   fun {YCoord YPosition}
      (YPosition*TILE_SIZE)+CANVAS_OFFSET_BUG
   end

   % Animations helpers
   fun {GetCoords Handle}
      {Handle getCoords(1:$)}
   end

   fun {GetXPos Handle}
      {FloatToInt {GetCoords Handle}.1}
   end

   fun {GetYPos Handle}
      {FloatToInt {GetCoords Handle}.2.1}
   end

   proc {SetXPos Handle X}
      {Handle setCoords(X {GetYPos Handle})}
   end

   proc {SetYPos Handle Y}
      {Handle setCoords({GetXPos Handle} Y)}
   end

   proc {IncrementXPos Handle Inc}
      {SetXPos Handle {GetXPos Handle}+Inc}
   end

   proc {IncrementYPos Handle Inc}
      {SetYPos Handle {GetYPos Handle}+Inc}
   end

   % Public methods
   proc {Init Placeholder Map}
      MapHeight         = {Width Map}
      MapWidth          = {Width Map.1}
      Canvas            = canvas(width:MapWidth*TILE_SIZE height:MapHeight*TILE_SIZE handle:Handles.map_canvas)
   in
      {Placeholder set(Canvas)}
      {DrawMap Map}
   end

   proc {DrawMap Map}
      fun {AddTileAt Type X Y} ImageName in
        ImageName = if Type==GRASS then textures_grass elseif Type==ROAD then textures_road end
        create(image {XCoord X} {YCoord Y} anchor:nw image:{GetImage ImageName})
      end

      proc {DrawRow RowRecord RowNumber}
	       proc {RecDrawRow TilesList X}
	          case TilesList
	          of nil then skip
	          [] H|T then
	             {Handles.map_canvas {AddTileAt H X RowNumber}}
	             {RecDrawRow T X+1}
	          end
        end
      in
        {RecDrawRow {Record.toList RowRecord} 0}
      end

      proc {Draw}
        proc {RecDraw RowsList RowNumber}
          case RowsList
          of nil then skip
          [] Row|RemainingRows then
            {DrawRow Row RowNumber}
            {RecDraw RemainingRows RowNumber+1}
          end
        end
      in
        {RecDraw {Record.toList Map} 0}
      end
   in
      {Draw}
      {Lib.debug map_drawn}
   end

   proc {DrawImageAtPosition Image Pos Handle}
     {Handles.map_canvas create(image {XCoord Pos.x} {YCoord Pos.y} handle:Handle image:{GetImage Image} anchor:nw)}
   end

   proc {DrawPlayerAtPosition Pos}
      {DrawImageAtPosition characters_player_down3 Pos Handles.player}
      {Lib.debug player_positioned_at(Pos)}
   end

   proc {DrawTrainer Trainer}
     Image = {VirtualString.toAtom "characters_"#{Atom.toString Trainer.name}#"_down3"} in
     {DrawImageAtPosition Image Trainer.position Handles.(Trainer.name)}
   end

   proc {DrawHospitalAtPosition Pos}
     {DrawImageAtPosition various_hospital Pos _}
     {Lib.debug hospital_positioned_at(Pos)}
   end

   proc {DrawPikachuAtPosition Pos}
     {DrawImageAtPosition various_pikachu Pos _}
     {Lib.debug pikachu_positioned_at(Pos)}
   end


   fun {MovePlayer Player Direction TurnDuration}
      IMAGE_STEPS    = 4
      STEPS_BY_MOVE  = 8
      STEP_DURATION  = TurnDuration div STEPS_BY_MOVE
      STEP_INCREMENT = TILE_SIZE div STEPS_BY_MOVE
      Name   = if Player.image==characters_player then player else Player.name end
      Handle = Handles.(Name)

      proc {MoveImageOneStep}
        case Direction
        of up    then {IncrementYPos Handle ~STEP_INCREMENT}
        [] right then {IncrementXPos Handle  STEP_INCREMENT}
        [] down  then {IncrementYPos Handle  STEP_INCREMENT}
        [] left  then {IncrementXPos Handle ~STEP_INCREMENT}
        end
      end

      proc {SetImageForStep Step} ImageName in
        ImageName = {VirtualString.toAtom "characters_"#Name#"_"#Direction#(Step mod IMAGE_STEPS)}
        {Handle set(image:{GetImage ImageName})}
      end

      proc {Anim Step}
        if Step==STEPS_BY_MOVE then skip
        else
          {SetImageForStep Step}
          {MoveImageOneStep}
          {Delay STEP_DURATION}
          {Anim Step+1}
        end
      end
    in
      {Anim 0}
      {QTk.flush}
      true
    end

    fun {IsGrass Map Position}
      Map.(Position.y+1).(Position.x+1) == GRASS
    end

    fun {LoadMapFromFile Path}
       {Pickle.load Path}
    end

end
