\define DEBUG

functor
import
   \ifdef DEBUG
   System
   \endif
   OS
export
   Debug
   Rand
   ReplaceNthInList
   PositionInDirection
   BindKeyboardArrows
   UnbindKeyboardArrows
   AtomToCapitalizedString
   Downcase
   Capitalize
   RandomDir
define

  proc {Debug Msg}
    \ifdef DEBUG
    {System.show Msg}
    \else
    skip
    \endif
  end

  fun {Rand I}
     ({OS.rand $} mod I) + 1
  end

  fun {ReplaceNthInList List Nth NewElement}
    case List
    of nil then nil
    [] H|T then
      if Nth>1 then H|{ReplaceNthInList T Nth-1 NewElement}
      else NewElement|T end
    end
  end

  fun {PositionInDirection Pos Direction}
    case Direction
    of up    then pos(x:Pos.x   y:Pos.y-1)
    [] right then pos(x:Pos.x+1 y:Pos.y)
    [] down  then pos(x:Pos.x   y:Pos.y+1)
    [] left  then pos(x:Pos.x-1 y:Pos.y)
    end
  end

  proc {BindKeyboardArrows Window Port}
     {Window bind(event:"<Up>"    action:proc{$} {Send Port up}     end)}
     {Window bind(event:"<Left>"  action:proc{$} {Send Port left}   end)}
     {Window bind(event:"<Down>"  action:proc{$} {Send Port down}   end)}
     {Window bind(event:"<Right>" action:proc{$} {Send Port right}  end)}
  end

  proc {UnbindKeyboardArrows Window}
     {Window bind(event:"<Up>"      action:proc{$} skip end)}
     {Window bind(event:"<Left>"    action:proc{$} skip end)}
     {Window bind(event:"<Down>"    action:proc{$} skip end)}
     {Window bind(event:"<Right>"   action:proc{$} skip end)}
  end

  fun {AtomToCapitalizedString A}
    {Capitalize {Atom.toString A}}
  end

  fun {Capitalize S}
    case S
    of H|T then {Char.toUpper H}|T
    [] nil then nil
    end
  end

  fun {Downcase S}
    case S
    of H|T then {Char.toLower H}|T
    [] nil then nil
    end
  end

  fun {RandomDir}
    {List.nth [up right down left] {Rand 4}}
  end

end
