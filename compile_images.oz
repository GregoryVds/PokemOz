functor
import
   Module
define
   BASE_PATH = "images/"
   [QTk]     = {Module.link ["x-oz://system/wp/QTk.ozf"]}
   Library   = {QTk.newImageLibrary}

   proc {AddPhoto Folder Name}
     {Library newPhoto(file:BASE_PATH#Folder#"/"#Name#".gif" name:{VirtualString.toAtom Folder#"_"#Name})}
   end

   proc {AddPhoto2 Folder1 Folder2 Name}
     {Library newPhoto(file:BASE_PATH#Folder1#"/"#Folder2#"/"#Name#".gif" name:{VirtualString.toAtom Folder1#"_"#Folder2#"_"#Name})}
   end

   % Add player images
   {AddPhoto2 characters player down0}
   {AddPhoto2 characters player down1}
   {AddPhoto2 characters player down2}
   {AddPhoto2 characters player down3}

   {AddPhoto2 characters player up0}
   {AddPhoto2 characters player up1}
   {AddPhoto2 characters player up2}
   {AddPhoto2 characters player up3}

   {AddPhoto2 characters player left0}
   {AddPhoto2 characters player left1}
   {AddPhoto2 characters player left2}
   {AddPhoto2 characters player left3}

   {AddPhoto2 characters player right0}
   {AddPhoto2 characters player right1}
   {AddPhoto2 characters player right2}
   {AddPhoto2 characters player right3}

   {AddPhoto2 characters brock down0}
   {AddPhoto2 characters brock down1}
   {AddPhoto2 characters brock down2}
   {AddPhoto2 characters brock down3}

   {AddPhoto2 characters brock up0}
   {AddPhoto2 characters brock up1}
   {AddPhoto2 characters brock up2}
   {AddPhoto2 characters brock up3}

   {AddPhoto2 characters brock left0}
   {AddPhoto2 characters brock left1}
   {AddPhoto2 characters brock left2}
   {AddPhoto2 characters brock left3}

   {AddPhoto2 characters brock right0}
   {AddPhoto2 characters brock right1}
   {AddPhoto2 characters brock right2}
   {AddPhoto2 characters brock right3}

   {AddPhoto2 characters james down0}
   {AddPhoto2 characters james down1}
   {AddPhoto2 characters james down2}
   {AddPhoto2 characters james down3}

   {AddPhoto2 characters james up0}
   {AddPhoto2 characters james up1}
   {AddPhoto2 characters james up2}
   {AddPhoto2 characters james up3}

   {AddPhoto2 characters james left0}
   {AddPhoto2 characters james left1}
   {AddPhoto2 characters james left2}
   {AddPhoto2 characters james left3}

   {AddPhoto2 characters james right0}
   {AddPhoto2 characters james right1}
   {AddPhoto2 characters james right2}
   {AddPhoto2 characters james right3}

   {AddPhoto2 characters misty down0}
   {AddPhoto2 characters misty down1}
   {AddPhoto2 characters misty down2}
   {AddPhoto2 characters misty down3}

   {AddPhoto2 characters misty up0}
   {AddPhoto2 characters misty up1}
   {AddPhoto2 characters misty up2}
   {AddPhoto2 characters misty up3}

   {AddPhoto2 characters misty left0}
   {AddPhoto2 characters misty left1}
   {AddPhoto2 characters misty left2}
   {AddPhoto2 characters misty left3}

   {AddPhoto2 characters misty right0}
   {AddPhoto2 characters misty right1}
   {AddPhoto2 characters misty right2}
   {AddPhoto2 characters misty right3}

   {AddPhoto sacha large}

   % Add textures
   {AddPhoto textures grass}
   {AddPhoto textures road}

   % Add pokemons
   {AddPhoto pokemoz bellsprout}
   {AddPhoto pokemoz bulbasoz}
   {AddPhoto pokemoz caterpie}
   {AddPhoto pokemoz charmandoz}
   {AddPhoto pokemoz lapras}
   {AddPhoto pokemoz magby}
   {AddPhoto pokemoz magikarp}
   {AddPhoto pokemoz moltres}
   {AddPhoto pokemoz nidoran}
   {AddPhoto pokemoz oddish}
   {AddPhoto pokemoz omanyte}
   {AddPhoto pokemoz oztirtle}
   {AddPhoto pokemoz poliwag}
   {AddPhoto pokemoz ponyta}
   {AddPhoto pokemoz vulpix}
   {AddPhoto pokemoz onix}
   {AddPhoto pokemoz geodude}
   {AddPhoto pokemoz koffing}
   {AddPhoto pokemoz horsea}

   {AddPhoto pokemoz ivysaur}
   {AddPhoto pokemoz venusaur}
   {AddPhoto pokemoz charmeleon}
   {AddPhoto pokemoz charizard}
   {AddPhoto pokemoz wartortle}
   {AddPhoto pokemoz blastoise}

   {AddPhoto pokemoz vileplume}
   {AddPhoto pokemoz nidorino}
   {AddPhoto pokemoz golem}
   {AddPhoto pokemoz seadra}
   {AddPhoto pokemoz graveler}
   {AddPhoto pokemoz butterfree}
   {AddPhoto pokemoz poliwhirl}
   {AddPhoto pokemoz victreebel}
   {AddPhoto pokemoz poliwrath}
   {AddPhoto pokemoz gyarados}
   {AddPhoto pokemoz weezing}
   {AddPhoto pokemoz metapod}
   {AddPhoto pokemoz gloom}
   {AddPhoto pokemoz rapidash}
   {AddPhoto pokemoz nidoran}
   {AddPhoto pokemoz ninetales}
   {AddPhoto pokemoz nidoking}
   {AddPhoto pokemoz weepinbell}

   % Add characters
   {AddPhoto characters brock}
   {AddPhoto characters james}
   {AddPhoto characters misty}

   {AddPhoto characters player}
   {AddPhoto characters wild}

   % Add types
   {AddPhoto types electric}
   {AddPhoto types fire}
   {AddPhoto types flying}
   {AddPhoto types grass}
   {AddPhoto types ground}
   {AddPhoto types normal}
   {AddPhoto types water}
   {AddPhoto types poison}

   % Add various
   {AddPhoto various hospital}
   {AddPhoto various pikachu}

   % Save library
   {QTk.saveImageLibrary Library "ImageLibrary.ozf"}

   {Exception.'raise' terminate_process_with_exception}
end
