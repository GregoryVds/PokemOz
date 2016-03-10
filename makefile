all: compileImages lib strings characters gameIntro pokemoz player gameState map autoPilot interface fight game killImageCompiler run

lib:
	ozc -c lib.oz

strings:
	ozc -c strings.oz

characters:
	ozc -c characters.oz

gameIntro:
	ozc -c gameIntro.oz

pokemoz:
	ozc -c pokemoz.oz

player:
	ozc -c player.oz

gameState:
	ozc -c game_state.oz

map:
	ozc -c map.oz

autoPilot:
	ozc -c auto_pilot.oz

interface:
	ozc -c interface.oz

fight:
	ozc -c fight.oz

game:
	ozc -c game.oz -o game.oza

run:
	@echo "Start game"
	ozengine ./game.oza

compileImages:
	ozc -c compile_images.oz -o compile_images.oza
	@echo "Launch compiler as deamon process (cannot terminate properly due to Mozart bug)"
	{ ozengine ./compile_images.oza 2> /dev/null & echo $$! > images_compiler.PID; }

killImageCompiler:
	@echo "Kill our compiler background process"
	kill $$(cat images_compiler.PID)
	rm images_compiler.PID

clean:
	rm ./*.ozf
	rm ./*.oza
