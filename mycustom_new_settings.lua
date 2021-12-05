--[[	File mycustom_new_settings.lua : part of mycustom mod;
	release 4.0.3

	The goal of this file is to enable you to easily copy the lua code part at the right place in your <worldpath>/mycustom_local_settings.lua
	(if you have a previous release installed) to customize it.

	If you do not, those new settings will be taken in account as default settings.


	Below the hierarchical way to find the new settings in your file (if exist) <Worldpath>/mycustom_local_settings.lua :

local_settings = {
	shapers = {  ### And now the code to copy, below : ]]

		moreblocks = {				-- moreblocks provide circular_saw which is the targeted shaper. 
			main_switch = false,	-- if =false, no work at all will be done for this shaper, whatever the switches below.
			subnodes_made = 49,  	--[[ how many subnodes are made by this mod while registering a node. this value is used to test that actual
										registered nodes more that value will not exceed the limit of minetest.registered_nodes which is currently 32767;
										the shaper will be call for the 1st node with switch set to true, then the real amount of shaped nodes 
										("subnodes_mades") will be calculated and this value updated if needed.
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

