functor
import
   Module
   Lib          at 'lib.ozf'
   PokemozMod   at 'pokemoz.ozf'
export
  Init
  UpdatePlayer1
  UpdatePlayer2
  ShowPlayer2
  HidePlayer2
  AskQuestion
  WriteMessage
  ChoosePokemonToFight
  SelectPlayer1Panel
  SetCenterLabel
define
   [QTk] = {Module.link ["x-oz://system/wp/QTk.ozf"]}
   ImageLibrary = {QTk.loadImageLibrary "ImageLibrary.ozf"}

   Player1Handles
   Player2Handles
   CenterAreaHandles
   BindKeys
   UnbindKeys


   fun {GetImage Name}
      {ImageLibrary get(name:Name image:$)}
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    ____ ____  _____    _  _____ _____   _        _ __   _____  _   _ _____
%  / ___|  _ \| ____|  / \|_   _| ____| | |      / \\ \ / / _ \| | | |_   _|
% | |   | |_) |  _|   / _ \ | | |  _|   | |     / _ \\ V / | | | | | | | |
% | |___|  _ <| |___ / ___ \| | | |___  | |___ / ___ \| || |_| | |_| | | |
%  \____|_| \_\_____/_/   \_\_| |_____| |_____/_/   \_\_| \___/ \___/  |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {CreatePokemozInterface Handles Number}
     NameLabelH LevelXpLabelH ImageCanvasH TypeCanvasH HealthCanvas TopLevelH

     ImageCanvas = canvas(handle:ImageCanvasH glue:w width:150 height:150 bg:white borderwidth:0 highlightthickness:0)
     TypeCanvas  = canvas(handle:TypeCanvasH  width:40  height:40  bg:white borderwidth:0 highlightthickness:0)
     InfosArea   = td(background:white glue:nswe
        TypeCanvas
        label(handle:NameLabelH font:{QTk.newFont font(weight:bold size:16)} bg:white)
        label(handle:LevelXpLabelH bg:white)
        canvas(width:100 height:30 handle:HealthCanvas bg:white borderwidth:0 highlightthickness:0)
     )
   in
     Handles = handles( top_level:          TopLevelH
                        name_label:         NameLabelH
                        level_xp_label:     LevelXpLabelH
                        image_canvas:       ImageCanvasH
                        type_canvas:        TypeCanvasH
                        health_canvas:      HealthCanvas
                        green_bar_handle:   _
                        pokemoz_img:        _
                        type_img:           _
                        )
      lr(handle:TopLevelH borderwidth:0 highlightthickness:0 background:white
         title:{VirtualString.toString "Pokemoz "#Number} ImageCanvas InfosArea)
   end


   fun {CreatePlayerInterface Handles}
     PlaceHolderH TopLevelH PanelH PictureCanvasH NameLabelH Panel1H Panel2H Panel3H
     PictureCanvas = canvas(handle:PictureCanvasH glue:w width:100 height:100
                            bg:white borderwidth:0 highlightthickness:0)
     Panel = panel(borderwidth:0 highlightthickness:0 glue:n handle:PanelH bg:white
        {CreatePokemozInterface Panel1H 1}
        {CreatePokemozInterface Panel2H 2}
        {CreatePokemozInterface Panel3H 3}
     )
     Content = lr(background:white glue:nsew handle:TopLevelH
                 td(glue:wn bg:white
                   PictureCanvas
                   label(handle:NameLabelH bg:white font:{QTk.newFont font(weight:bold size:18)}
                         wraplength:100 justify:center anchor:center))
                 Panel)
   in
     Handles = handles( place_holder:   PlaceHolderH
                        top_level:      TopLevelH
                        panel:          PanelH
                        picture_canvas: PictureCanvasH
                        picture_img:    _
                        name_label:     NameLabelH
                        panel1handles:  Panel1H
                        panel2handles:  Panel2H
                        panel3handles:  Panel3H)
     placeholder(glue:ns handle:PlaceHolderH background:white width:394 padx:20 pady:20 Content)
   end

   CenterAreaPlaceHolderH
   fun {CreateCenterAreaPlaceHolder}
     td(glue:ns padx:0 pady:20
        canvas(bg:white width:300 height:0) % Hack to constrain the width...
        placeholder(glue:nsew bg:white handle:CenterAreaPlaceHolderH background:white))
   end

   proc {CreateCenterAreaDialogs}
     InfoToplevel InfoLabel InfoBtn
     QuestionTopLevel QuestionLabel QuestionBtnYes QuestionBtnNo
     SelectTopLevel SelectLabel Select1 Select2 Select3

     Info = td(handle:InfoToplevel bg:white
       label(justify:center handle:InfoLabel background:white height:6 width:30 wraplength:245)
       button(handle:InfoBtn width:10)
     )
     {CenterAreaPlaceHolderH set(Info)}
     {CenterAreaPlaceHolderH set(empty)}

     Question = td(handle:QuestionTopLevel bg:white
       label(justify:center handle:QuestionLabel background:white height:6 width:30 wraplength:245)
       lr(bg:white
         button(handle:QuestionBtnYes width:10)
         button(handle:QuestionBtnNo  width:10)
       )
     )
     {CenterAreaPlaceHolderH set(Question)}
     {CenterAreaPlaceHolderH set(empty)}

     PokemozChoice = td(handle:SelectTopLevel bg:white
        label(justify:center handle:SelectLabel background:white height:2 width:30 wraplength:245)
        td(bg:white
          button(handle:Select1 width:25)
          button(handle:Select2 width:25)
          button(handle:Select3 width:25)
        )
     )
     {CenterAreaPlaceHolderH set(PokemozChoice)}
     {CenterAreaPlaceHolderH set(empty)}
   in
     CenterAreaHandles = handles( place_holder:   CenterAreaPlaceHolderH
                                  info:info(
                                      top_level: InfoToplevel
                                      label:     InfoLabel
                                      btn:       InfoBtn
                                  )
                                  question:question(
                                      top_level: QuestionTopLevel
                                      label:     QuestionLabel
                                      btn_yes:   QuestionBtnYes
                                      btn_no:    QuestionBtnNo
                                  )
                                  select_pokemoz:select(
                                      top_level: SelectTopLevel
                                      label:     SelectLabel
                                      btn1:      Select1
                                      btn2:      Select2
                                      btn3:      Select3
                                  ))
      skip
   end

   % We already create all the image without specifying the image.
   % We save the handles to each of them so that we can easily change them afterwards.
   proc {AddImagesToCanvas Handles}
     proc {CreateImageForPanel Handles}
       {Handles.image_canvas  create(image 0 0 anchor:nw handle:Handles.pokemoz_img)}
       {Handles.type_canvas   create(image 0 0 anchor:nw handle:Handles.type_img   )}
       {Handles.health_canvas create(rectangle 0 0 0 30 width:0 outline:green fill:green handle:Handles.green_bar_handle)}
     end
   in
     {Handles.picture_canvas create(image 0 0 anchor:nw handle:Handles.picture_img)}
     {CreateImageForPanel Handles.panel1handles}
     {CreateImageForPanel Handles.panel2handles}
     {CreateImageForPanel Handles.panel3handles}
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _   _ ____  ____    _  _____ _____   _        _ __   _____  _   _ _____
%  | | | |  _ \|  _ \  / \|_   _| ____| | |      / \\ \ / / _ \| | | |_   _|
%  | | | | |_) | | | |/ _ \ | | |  _|   | |     / _ \\ V / | | | | | | | |
%  | |_| |  __/| |_| / ___ \| | | |___  | |___ / ___ \| || |_| | |_| | | |
%   \___/|_|   |____/_/   \_\_| |_____| |_____/_/   \_\_| \___/ \___/  |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   proc {UpdateImage CanvasHandle ImageHandle ImageVs}
      CurrentImage = {CanvasHandle get(tooltips:$)}
    in
      if CurrentImage == ImageVs then skip
      else
        {ImageHandle set(image:{GetImage {VirtualString.toAtom ImageVs}})}
        {CanvasHandle set(tooltips:ImageVs)}
      end
   end

   proc {UpdatePlayerInterface Player Handles}
     proc {LoopPokemoz PokemozList N}
       case PokemozList
       of nil then skip
       [] H|T then
         {FillPokemoz Handles.{VirtualString.toAtom panel#N#handles} H}
         {LoopPokemoz T N+1}
       end
     end

     proc {FillPokemoz Handles Pokemoz}
       fun {HealthGreen Pokemoz}
         {FloatToInt ({IntToFloat Pokemoz.health}/{IntToFloat {PokemozMod.maxHealth Pokemoz.level}})*100.0}
       end
     in
       {Handles.name_label       set(text:{Lib.atomToCapitalizedString Pokemoz.name})}
       {Handles.level_xp_label   set(text:{VirtualString.toString Pokemoz.health#"hp - Lvl "#Pokemoz.level#" - "#Pokemoz.xp#" XP"})}
       {Handles.health_canvas    set(bg:red)}
       {UpdateImage Handles.image_canvas Handles.pokemoz_img pokemoz_#Pokemoz.name}
       {UpdateImage Handles.type_canvas  Handles.type_img    types_#Pokemoz.type}
       {Handles.green_bar_handle  set(width:{HealthGreen Pokemoz}*2 fill:green)}
     end

     SelectedPanel = Handles.{VirtualString.toAtom panel#Player.selected_pokemoz#handles}.top_level
   in
     {UpdateImage Handles.picture_canvas  Handles.picture_img Player.image}
     {Handles.name_label set(text:{Lib.atomToCapitalizedString Player.name})}
     {Handles.panel selectPanel(SelectedPanel)}
     {LoopPokemoz Player.pokemoz_list 1}
   end


   proc {ClearPlayerInterface Handles}
     proc {ClearPanel Handles}
       {Handles.name_label          set(text:nil)}
       {Handles.level_xp_label      set(text:nil)}
       {Handles.pokemoz_img         set(image:nil)}
       {Handles.image_canvas        set(tooltips:nil)}
       {Handles.type_img            set(image:nil)}
       {Handles.type_canvas         set(tooltips:nil)}
       {Handles.green_bar_handle    set(width:0 fill:white)}
       {Handles.health_canvas       set(bg:white)}
       {Handles.green_bar_handle    set(width:0)}
     end
   in
     {Handles.picture_img    set(image:nil)}
     {Handles.picture_canvas set(tooltips:nil)}
     {Handles.name_label  set(text:nil)}
     {ClearPanel Handles.panel1handles}
     {ClearPanel Handles.panel2handles}
     {ClearPanel Handles.panel3handles}
   end

   proc {Init PlaceHolder GameState BindKeyboardActions UnbindKeyboardActions}
     Player1    = {CreatePlayerInterface Player1Handles}
     Player2    = {CreatePlayerInterface Player2Handles}
     Center     = {CreateCenterAreaPlaceHolder}
     Content    = lr(Player1 Center Player2)
   in
     BindKeys   = BindKeyboardActions
     UnbindKeys = UnbindKeyboardActions
     {PlaceHolder set(Content)}
     {CreateCenterAreaDialogs}
     {AddImagesToCanvas Player1Handles}
     {AddImagesToCanvas Player2Handles}
     {HidePlayer2}
     {HideCenterArea}
     {UpdatePlayerInterface GameState.player Player1Handles}
     {Lib.debug auxialiary_interface_drawn}
     {QTk.flush}
   end

  proc {HideCenterArea}
    {CenterAreaHandles.place_holder set(empty)}
  end

  proc {UpdatePlayer1 Player}
    {UpdatePlayerInterface Player Player1Handles}
    {QTk.flush}
  end

  proc {ShowPlayer2 Player}
    {UpdatePlayerInterface Player Player2Handles}
    {Player2Handles.place_holder set(Player2Handles.top_level)}
    {QTk.flush}
  end

  proc {UpdatePlayer2 Player}
    {UpdatePlayerInterface Player Player2Handles}
    {QTk.flush}
  end

  proc {HidePlayer2}
    {Player2Handles.place_holder set(empty)}
    {ClearPlayerInterface Player2Handles}
    {QTk.flush}
  end

  proc {SelectPlayer1Panel Index}
    {Player1Handles.panel selectPanel(Player1Handles.{VirtualString.toAtom panel#Index#handles}.top_level)}
    {QTk.flush}
  end

  proc {CenterAreaCleanup}
    {HideCenterArea}
    {BindKeys}
  end

  fun {AskQuestion QuestionText BtnTrueText BtnFalseText}
    {UnbindKeys}
    Answer
    proc {HitBtnTrue}  Answer=false end
    proc {HitBtnFalse} Answer=true end
  in
    {CenterAreaHandles.question.label     set(text:QuestionText)}
    {CenterAreaHandles.question.btn_yes   set(text:BtnTrueText action:HitBtnTrue)}
    {CenterAreaHandles.question.btn_no    set(text:BtnFalseText action:HitBtnFalse)}

    {CenterAreaHandles.place_holder set(CenterAreaHandles.question.top_level)}
    {QTk.flush}
    if Answer==true then {CenterAreaCleanup} Answer else {CenterAreaCleanup} Answer end
  end

  proc {WriteMessage Message}
    {UnbindKeys}
    Answer
    proc {HitBtn} Answer=0 end
  in
    {CenterAreaHandles.info.label   set(text:Message)}
    {CenterAreaHandles.info.btn     set(text:"Got it!" action:HitBtn)}
    {CenterAreaHandles.place_holder set(CenterAreaHandles.info.top_level)}
    {QTk.flush}
    if Answer==1 then {CenterAreaCleanup} else {CenterAreaCleanup} end
  end

  proc {SetCenterLabel Message}
    {CenterAreaHandles.info.label   set(text:Message)}
    {CenterAreaHandles.info.btn     set(text:"Be patient")}
    {CenterAreaHandles.place_holder set(CenterAreaHandles.info.top_level)}
    {QTk.flush}
  end

  fun {ChoosePokemonToFight Player Text}
    {UnbindKeys}
    Answer
    proc {HitBtn1} Answer=1 end
    proc {HitBtn2} Answer=2 end
    proc {HitBtn3} Answer=3 end
    PokemonList  = Player.pokemoz_list
    PokemozCount = {Length PokemonList}
    fun {TextBtn Index}
      if PokemozCount >= Index then
        Name = {List.nth PokemonList Index}.name
        Type = {List.nth PokemonList Index}.type in
        {Lib.atomToCapitalizedString Name}#" - "#{Lib.atomToCapitalizedString Type}
      else nil end
    end
    fun {StateBtn Index}
      if PokemozCount >= Index andthen {List.nth PokemonList Index}.health>0 then normal else disabled end
    end
  in
    {Lib.debug CenterAreaHandles.select_pokemoz}
    {CenterAreaHandles.select_pokemoz.label   set(text:Text)}
    {CenterAreaHandles.select_pokemoz.btn1    set(text:{TextBtn 1} state:{StateBtn 1} action:HitBtn1)}
    {CenterAreaHandles.select_pokemoz.btn2    set(text:{TextBtn 2} state:{StateBtn 2} action:HitBtn2)}
    {CenterAreaHandles.select_pokemoz.btn3    set(text:{TextBtn 3} state:{StateBtn 3} action:HitBtn3)}
    {CenterAreaHandles.place_holder set(CenterAreaHandles.select_pokemoz.top_level)}
    {QTk.flush}
    if Answer==1 then {CenterAreaCleanup} Answer else {CenterAreaCleanup} Answer end
  end

end
