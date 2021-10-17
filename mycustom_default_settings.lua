--[[ file mycustom_default_settings.lua : part of mod mycustom 

	the default settings of mycustom.

	DO NOT modify this file.
	If you want to modify some settings for mycustom, see <world_path>/mycustom_local_settings.lua :
		mycustom copy some files from <mod_path> to <world_path> in order to preserve your settings while installing a new release.
		if mycustom_local_settings.lua do not exist yet in <world_path>, then you can modify it in <mod_path> : this file will
		be copied into your world_path at next server restart.
]]

settings = {
	node_places_to_left_free = 100,  			-- we want mycustom to left free places for other mods to be able to register nodes
	max_nodes_allowed_by_minetest = 32767,  	-- The max number of node allowed to be registered by minetest DO NOT MODIFY !
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
	shapers = {								-- a table of mods we know they can shape nodes
		technic_cnc = {						-- the name of the mod (must be findable in mod directories)
			main_switch = true,					-- general switch to (dis)allow calling this shaper mod. if false, nothing will be done with this mod
			subnodes_made = 26,  --[[ how many subnodes are made by this mod while registering a node. this value is used to test that actual
										registered nodes more that value will not exceed the limit of minetest.registered_nodes which is currently 32767
										if limit would be exceeded, the call will not be done to avoid server crash at load time. 
										if the shaper mod make a different amount of shaped nodes, this value will be automatically updated. ]]
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
		moreblocks = {				-- moreblocks provide circular_saw which is the targeted shaper. 
			main_switch = false,	-- if =false, no work at all will be done for this shaper, whatever the switches below.
			subnodes_made = 49,  --[[ how many subnodes are made by this mod while registering a node. this value is used to test that actual
										registered nodes more that value will not exceed the limit of minetest.registered_nodes which is currently 32767;
										the shaper will be call for the 1st node with switch set to true, then the real amount of shaped mod will 
										be calculated and this value updated if needed.
										After that, if limit would be exceeded, the call will not be done to avoid server crash at load time. 
									 ]]
			mods = { 				-- Only if 'main_switch'==true, Check out the following mods to (not) link their nodes to the shaper: 
				extra = {
					activated = true,  						-- if false, no work will be done between the shaper and the nodes from this mod
					all_nodes = false,						-- if true, all nodes from this mod will be linked to the shaper
					nodes = {								-- nodes to take in account if 'all_nodes'==false :
						["extra:cobble_condensed"] = true,  -- if true, link this node to the shaper
					},
				},
				caverealms = {
					activated = true,  						-- if false, no work will be done between the shaper and the nodes from this mod
					all_nodes = false,						-- if true, all nodes from this mod will be linked to the shaper
					nodes = {								-- nodes to take in account if 'all_nodes'==false :
						["caverealms:glow_amethyst"] = true,  -- if true, link this node to the shaper
					},
				},				
			},
		},
		pkarcs = {
			main_switch = true,
			subnodes_made = 3,  --[[ how many subnodes are made by this mod while registering a node. this value is used to test that actual
										registered nodes more that value will not exceed the limit of minetest.registered_nodes which is currently 32767
										if limit would be exceeded, the call will not be done to avoid server crash at load time. 
										if the shaper mod make a different amount of shaped nodes, this value will be automatically updated. ]]
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
						["darkage:tuff_rubble"] 			= true
					}
				},
				default = {
					activated = true,
					all_nodes = false,
					nodes = {
						["default:meselamp"] 		= true,
						["default:dirt_with_grass"] = true,
						["default:dirt"] 			= true
					}
				}
			}
		}
	}
}
