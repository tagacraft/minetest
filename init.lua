--[[
Current release : 4.0.3

This mod was written by Gudule initialy for the use of the webserver 'baobab nation';
there is no licence attached except of course for all the mods reffered to ;
So feel free to use-modify-redistribute this mod as you want.

the main aim is to add some functionalities like 
	- usefull recipes forgotten by some installed mods;
	- link (register) some nodes to some mod to obtain shaped derivated nodes ;
see releases.txt for history

Some recipes can be activated / deactivated turning true / false the corresponding settings in the file
	<worldpath>\mycustom_local_recipes.lua  and 
some settings can be customized the same way in the file
	<worldpath>\mycustom_local_settings.lua

!! BE AWARE de-activate a recipe / a setting previously used may result in 'unknown' nodes and items ingame !!

!! BE AWARE if you add some reference to any mod : this referenced mod then MUST be writen in the "optional_depends"
	section of the file "mod.conf" !!
Without that, the corresponding action will abort.

--]]

myc = {}  -- spacename for easyest cleaning at end of work

myc.log_list = {  			-- available levels of log verbose
		[1] = "silent",		-- no log at all,
		[2] = "summary",  	-- only time elapsed at end of work
		[3] = "minimal", 	-- begin + end of major steps
		[4] = "details",	-- all actions a demanding administrator may want to be informed about
		[5] = "debug", 		-- all actions, step by step, for debug purposes
	}
myc.log_level = 4 			-- the level of explanations we want while executing code

-- get the start and stop time of mycustom to log the number of seconds used by this mod at load time :
myc.time_start = os.clock()
myc.time_elapsed = 0

local func_string = ""
local func_exec
local nb_ok = 0
local result = "" -- string to log result of registering a recipe

--[ load "default" settings : ]
dofile(minetest.get_modpath("mycustom").."/mycustom_default_settings.lua")

--[ load "default" recipes definitions : ]
dofile(minetest.get_modpath("mycustom").."/mycustom_default_recipes.lua")

--[ Register functions for mycustom : ]
dofile(minetest.get_modpath("mycustom").."/functions.lua")

log() --clear the file <world_path>/mycustom_log.txt (because of no parameter in the call log() )
if myc.log_level==1 then log(1,"silent mode.") end 
log(2,"mycustom start loading...") -- say hello :)

--[ Check for (and load) local settings made by the Admin of the server and update settings with those local settings : ]
check_local_settings()

--[ check for new settings to add to local settings : ]
check_new_settings()

--[[ check for local recipes definitions that would update the default recipes. 
	see file mycustom_default_recipes.lua for instructions to well manage the recipes ]]
check_local_recipes()

--[ Register recipes :]
last_output = "default:dirt_with_rainforest_litter"

for k, a_recipe_def in ipairs(recipes_defs) do

	result = "recipe #"..tostring(k)..": "
	if (a_recipe_def ~= nil) then
	if (a_recipe_def.ignore~=true) and
	   ((a_recipe_def.setting==nil) or (check_settings(a_recipe_def.setting)==true)) then -- if switches exist for this recipe, they are "on"

	   	if (check_depends(a_recipe_def.depends_of) == true) then -- depending mods are well installed
	   		
	   		if (a_recipe_def.recipe_is_function ~= nil) then 
	   			--[[ recipe is not an item but a function : typically the variable "last_output"
	   			so we will execute the function to rewrite the recipe : ]]

	   			--[[ avoid conflicts with field recipe, if somebody let recipe a table of classic recipe (yes i've done this mistake !) : ]]
	   			if (type(a_recipe_def.recipe)=="table") then
	   				recipes_defs[k].recipe_is_function = nil
	   			else
		   			func_string = "return "..a_recipe_def.def.recipe
	   				func_exec = loadstring(func_string)
					a_recipe_def.def.recipe = { {func_exec()}, }
				end
	   		end
	   		minetest.register_craft(a_recipe_def.def)
 			result = result.."registered (all conditions ok)"
	   		nb_ok = nb_ok+1

	   		-- for cycling crafts we may need to remember the last output of a recipe :
	   		if a_recipe_def.remember_last_output==true then last_output=a_recipe_def.def.output end

	   	else
	   		-- depends unsatisfied : some mods are not installed
	   		result = result.."aborted (at least 1 mod cited in depends is not installed)"
	   	end
	else
		-- switche(s) is/are "off" for this recipe or field ignore==true for this recipe
		if (a_recipe_def.ignore==true) then result = result.."aborted (field 'ignore'=true)" 
		else
			result = result.."aborted (in settings, at least 1 setting is false for that recipe)"
		end
	end 
	else
		result = result.."aborted (definition table is nil);"
	end -- recipe_def not nil
	log(4, result)
end
log(3, tostring(nb_ok).." recipes well registered ")


max_nodes_in_MT 	= settings.max_nodes_allowed_by_minetest or 32767 		-- should be considered as a constant 
nb_nodes_used		= count(minetest.registered_nodes) 						-- should be updated each time mycustom made a node registered_nodes
places_to_left_free = settings.node_places_to_left_free or 0 				-- How many free places in minetest.registered_nodes 
																			--   we DO WANT mycustom to left after it's end of work.
actual_nodes_left 	= max_nodes_in_MT - nb_nodes_used - places_to_left_free -- the free places for mycustom to register new nodes
mod_need_places 	= 1														-- nb of places needed by a shaper mod to register subnodes 


-- Now call some mods to register some nodes to shape them :
log(3, "Now call some mod functions to register nodes we want to be shaped by them :")
for mod_name, _ in pairs(settings.shapers) do
	register_to_mod(mod_name)
end
log(3, "all registered shaper mods called.")

-- Chat commands :
minetest.register_chatcommand("mycustom",{
	params = "?",
	description = "say the improvments mades by mycustom are readable in <world_path>/mycustom_log.txt",
	func = function(name)
		minetest.chat_send_player(name, "what the mod mycustom have done is readable in the file <world_path>/mycustom_log.txt")
	end,
})


-- After have done all the work to do, log the actual values of settings :
log(4, "\nafter mycustom has done it's work, the settings and recipes are :")
log(4, "\nmycustom settings :\n"..
 	   "-------------------\n"..dump(settings))
log(4, "\nmycustom recipes :\n"..
 	   "------------------\n")

for num, def in ipairs(recipes_defs) do
	if (def.recipe_is_function == true) then
		def.recipe_is_function = tostring(def.recipe_is_function).." (recipe was overwriten by the 'last_output' variable)"
	end
	if (def.ignore == true) then
		def.ignore = "true : that means this recipe had not been registered by mycustom into minetest engine"
	end
	log(4, "#"..tostring(num)..": "..dump(def))
end

-- say Good bye :)
::end_of_init::

myc.time_elapsed = os.clock()-myc.time_start
log(2, "Work done in "..string.format("%.3f", tostring(myc.time_elapsed)).." seconds.")
minetest.log("mycustom has loaded in "..string.format("%.3f", tostring(myc.time_elapsed)).." seconds. the work done is recorded in the file <world_path>/mycustom_log.txt")

-- clear the memory :
settings 			= nil
local_settings 		= nil
recipes_defs 		= nil
local_recipes_defs 	= nil
func_string 		= nil
func_exec   		= nil
nb_ok 				= nil
result 				= nil
max_nodes_in_MT 	= nil
nb_nodes_used		= nil
places_to_left_free = nil
actual_nodes_left 	= nil
mod_need_places 	= nil
myc 				= nil