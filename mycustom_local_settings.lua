--[[ file <worldpath>/mycustom_local_settings.lua : part of mod mycustom 

	the aim of this file is to preserve your settings over updates of mycustom (new releases).

	in this file you can set the settings you want to apply for your personal world;
	Be sure to modify this file in your Worldpath, not in mycustom mod_path.	
	as long as this file exist in your world_path, it will update default settings of mycustom mod.
	if you meet trouble, you can choose to erase this file from your <world_path> then it will be re-created from
	<mod_path>/mycustom_local_settings.lua at next server restart.

	if a switch exist here, it will overwrite (create if not exist yet) the same switch in default settings;
	if a switch exist in default settings but not here, this switch will remain valid.
	in that way, you must just write here the settings you want to modify and only those ones.
	But you can also choose to keep all the local_settings table and adjust just the ones you want, that way you can see all the other settings,
	even if this method make minetest to read all the table for only a few usefull lines (increasing the loading time by a few milliseconds)

	keep in mind this file is executed by mycustom at loadtime with a "dofile()" command.
	the initial task is to load the variable 'local_settings' with the goal to update the variable 'settings', but
	all the file is executed as a .lua file, so any lua code will be done, eventually running into bugs or crashes 
	if you dont know what you are doing !

	While localised in your worldpath,
	this file will not be overwriten with later releases, so your settings will be saved while updating mycustom mod.
	(except if you erase this file from your world_path, then it will be re-created from the original stored in mod_path.)

	###################
	## W A R N I N G ##
	###################

		This file is likely to be updated automatically by mycustom in following cases :
			1°) switch 'subnodes_made' has a wrong value ;
			2°) a needed switch is missing or has a wrong value ;
		if that occurs, a message may be log in worldpath/mycustom_log.txt accordingly to the log_level set (see beginning of init.lua)

]]

local_settings = {
	node_places_to_left_free = 100,  			-- we want mycustom to left free places for other mods to be able to register nodes
	Cook_compressed_cobble = true, 				-- (dis)allow cooking recipe for compressed_cobble to give 9 default:stone
	Cook_compressed_desert_cobble = true,		-- (dis)allow cooking recipe for compressed_desert_cobble tp give 9 default:desert_stone
	Cook_condensed_cobble = true,				-- (dis)allow cooking recipe for extra:cobble_condensed to give 81 default:stone
	Craft_dirts_default = true,					-- (dis)allow craft recipes for default:dirt_with_<something>, like default:dirt_with_rainforest_litter
	Craft_dirts_cycling = true,					-- (dis)allow craft recipes to cycle from a dirt_with_something to dirt_with_next_thing, like :
													-- dirt_with_grass can craft dirt_with_dry_grass can craft dirt_with_rainforest_litter, etc and 
													-- then last_dirt_with_something can craft dirt_with_grass
	Craft_dirts_mod = true,						-- (dis)allow craft recipes for dirts from other mods than default (e.g. woodsoils mod)
	Craft_darkage_chalk = true,					-- (dis)allow those crafts
	Craft_darkage_old_tuff_bricks = true,

	shapers = {									-- a table of mods we know they can shape nodes
		moreblocks = {				-- moreblocks provide circular_saw which is the targeted shaper. 
			main_switch = false,	-- if =false, no work at all will be done for this shaper, whatever the switches below.
			subnodes_made = 46,  	--[[ how many subnodes are made by this mod while registering a node. this value is used to test that actual
										registered nodes more that value will not exceed the limit of minetest.registered_nodes which is currently 32767;
										the shaper will be call for the 1st node with switch set to true, then the real amount of shaped mod will 
										be calculated and this value updated if needed.
										After that, if limit would be exceeded, the call will not be done to avoid server crash at load time. 
									 ]]
			mods = {
				extra = {
					activated = true,  						-- if false, no work will be done between the shaper and the nodes from this mod
					all_nodes = false,						-- if true, all nodes from this mod will be linked to the shaper
					nodes = {								-- nodes to take in account if 'all_nodes'==false :
						["extra:cobble_condensed"] = true,  -- if true, link this node to the shaper
					},
				},
			},
		},
		technic_cnc = {						-- the name of the mod (must be findable in mod directories)
			subnodes_made = 26,  --[[ how many subnodes are made by this mod while registering a node. this value is used to test that actual
										registered nodes more that value will not exceed the limit of minetest.registered_nodes which is currently 32767
										if limit would be exceeded, the call will not be done to avoid server crash at load time. 
										if the shaper mod make a different amount of shaped nodes, this value will be automatically updated. ]]
			main_switch = true,					-- general switch to (dis)allow calling this shaper mod. if false, nothing will be done with this mod
			mods = {							-- mods concerned to work with this shaper mod
				darkage = {						-- the mod darkage will say below what to deal with the shaper :
					activated = true,					-- if false, do NOT do anything with the shaper for this mod;
														-- the folowing will be parsed only if activated==true !
					all_nodes = false,			-- if true, all nodes from darkage will be registered by the shaper and then the
														-- entry "nodes = {..." is useless and not parsed;
												-- if false, only the node names below will be eventually registered by the shaper
					nodes = {						-- the nodes named below will deal (if and only if ==true) with the shaper
						["darkage:tuff_rubble"] 			= false, -- false : dont do anything between this node and the shaper (technic_cnc);
						["darkage:schist"] 					= false,
						["darkage:tuff_bricks"] 			= false,
						["darkage:gneiss_rubble"] 			= false,
						["darkage:straw_bale"] 				= false,
						["darkage:basalt_block"] 			= false,
						["darkage:stone_brick"] 			= false,
						["darkage:slate_tile"] 				= false,
						["darkage:slate_rubble"] 			= false,
						["darkage:basalt"] 					= false,
						["darkage:basalt_brick"]			= false,
						["darkage:gneiss_brick"] 			= false,
						["darkage:marble_tile"] 			= false,
						["darkage:ors_block"] 				= false,
						["darkage:silt"] 					= false,
						["darkage:ors_brick"] 				= false,
						["darkage:chalked_bricks"] 			= false,
						["darkage:slate"] 					= false,
						["darkage:shale"] 					= false,
						["darkage:serpentine"] 						= true,  -- true : call the shaper to register this node
						["darkage:rhyolitic_tuff_rubble"] 	= false,
						["darkage:marble"] 							= true,
						["darkage:rhyolitic_tuff_bricks"] 	= false,
						["darkage:adobe"] 					= false,
						["darkage:rhyolitic_tuff"] 			= false,
						["darkage:ors"] 					= false,
						["darkage:ors_rubble"] 				= false,
						["darkage:gneiss_block"] 			= false,
						["darkage:slate_brick"] 			= false,
						["darkage:old_tuff_bricks"] 		= false,
						["darkage:chalk"] 							= true,
						["darkage:gneiss"] 					= false,
					},
				},
				default = {
					activated = true,
					all_nodes = false,
					nodes = {
						["default:meselamp"] 				= true,
					},
				},
			},
		},
		pkarcs = {
			subnodes_made = 3,  --[[ how many subnodes are made by this mod while registering a node. this value is used to test that actual
					registered nodes more that value will not exceed the limit of minetest.registered_nodes which is currently 32767
					if limit would be exceeded, the call will not be done to avoid server crash at load time.
					if the shaper mod make a different amount of shaped nodes, this value will be automatically updated. ]]
			main_switch = true,
			mods = {
				darkage = {
					activated = true,
					all_nodes = false,
					nodes = {
						["darkage:adobe"] 					= true,
						["darkage:basalt"] 					= true,
						["darkage:basalt_block"] 				= false,
						["darkage:basalt_brick"] 			= true,
						["darkage:chalk"] 					= true,
						["darkage:chalked_bricks"] 			= true,
						["darkage:gneiss"] 					= true,
						["darkage:gneiss_block"] 				= false,
						["darkage:gneiss_brick"] 			= true,
						["darkage:gneiss_rubble"]			= true,
						["darkage:marble"] 						= false,
						["darkage:marble_tile"] 				= false,
						["darkage:old_tuff_bricks"] 		= true,
						["darkage:ors"] 					= true,
						["darkage:ors_block"] 					= false,
						["darkage:ors_brick"] 				= true,
						["darkage:ors_rubble"] 					= false,
						["darkage:rhyolitic_tuff"] 			= true,
						["darkage:rhyolitic_tuff_bricks"] 	= true,
						["darkage:rhyolitic_tuff_rubble"] 	= true,
						["darkage:schist"] 					= true,
						["darkage:serpentine"] 					= false,
						["darkage:shale"] 					= true,
						["darkage:silt"] 					= true,
						["darkage:slate"] 					= true,
						["darkage:slate_brick"] 			= true,
						["darkage:slate_rubble"] 				= false,
						["darkage:slate_tile"] 					= false,
						["darkage:stone_brick"] 			= true,
						["darkage:straw_bale"] 				= true,
						["darkage:tuff_bricks"] 			= true,
						["darkage:tuff_rubble"] 			= true,
					}
				},
				default = {
					activated = true,
					all_nodes = false,
					nodes = {
						["default:meselamp"] 		= true,
						["default:dirt_with_grass"] = true,
						["default:dirt"] 			= true,
					}
				}
			},
		}
	}
}
