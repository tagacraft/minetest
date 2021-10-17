--[[ file mycustom_local_recipes.lua 
	part of mycustom mod
	contains local definitions for recipes to add/modify the default recipes of mycustom mod.
	this file will not be erased by updates, so it will preserve your recipes.

	A single recipe is identified by it's UNIQUE numerical index.
	at load time, mycustom load this file and compare it against the mycustom's global variable recipes_defs :
	if the same index exist in both recipes_defs and recipes_defs_local, then 
		the recipes_defs_local will overwrite the recipes_def
	if you dont want a recipe anymore, you have three ways :
		1°) recommended way :
		--------------------
				create a field "ignore = true" in the recipe : this recipe will be ignore, like :
						recipes_defs_local = {
							[1] = {
					==>			ignore = true,
								description = "Cook moreblocks:cobble_compressed into 9 default:stone",
								depends_of = {"moreblocks",},
								setting = "Cook_compressed_cobble",
								def = {
									type = "cooking",
									output = "default:stone 9",
									recipe = "moreblocks:cobble_compressed",
								},
							},
							etc.
				this way you will remember easily what was this f**ing recipe n°1 AND you are sure this recipe will not be registered
		
		2°) you can turn to 'false' the corresponding setting in <worldpath>/mycustom_local_settings.dat;
			in the example above, you may do :  settings.Cook_compressed_cobble = false,
			but remember a setting may eventually apply to more than one recipe;
		
		3°) you can replace all the recipe's def by the value 'nil' like
				recipes_defs_local = {
					[1] = nil,
					[2] = ...
			but this barbarian method will lost what was the recipe n°1

		So, keep in mind if you work a different way than 1°) or 2°), you may run into bugs...

The differents fields findable in the recipe_defs_local :

	[index]		  : needed 		: Unique indentifier. DO NOT MODIFY, replace or erase. 
	"description" : needed 		: a short humain-readable description for this recipe; currently used in log messages.
	"depends_of"  : optional 	: if present, a table of strings representing mod(s) needed for that recipe to work.
								  if a mod isn't installed, discard the recipe.
	"setting"	  : optional	: if present, a (table of) string(s) representing the settings.<A_Switch_Name> to be true to activate the recipe
									for example, if setting = "Cook_compressed_cobble" then we must find settings.Cook_compressed_cobble==true to
									register this recipe.
									if setting is a table of strings, all the corresponding settings must be true
	"def"		  : needed		: a table containing the craft definition as minetest want it to be 
								 				will be used as minetest.register_craft(def)
	"ignore"	  : optional	: if present AND ==true, this recipe will not be registered whatever the other flags
	"remember_last_output"	: optional 	: if present, will save the "output" craft result in the global variable "last_output"
											this is used for cycling crafts for example for dirts_with_<something> crafted into <other_thing#1>,
											then <other_thing#2>, <#3>, ...<#n> and finally :
											<dirt_with_other_thing#n> cycled in craft <dirt_with_something>
	"recipe_is_function"	: optional : if present, the def.recipe is a string representing a lua code to execute as a function; 
											the result will overwrite the recipe def. 
											Typically the field def.recipe contains the string "last_output" then mycustom will replace it by 
											the value of last_output. 
											This mechanism let be possible the cycling crafts.


]]


local_recipes_defs = {
	[1] = {		-- numerical explicit index to preserve order because some recipes depends on previous recipes (e.g. cycling recipes for dirts)
		description = "Cook moreblocks:cobble_compressed into 9 default:stone",
		depends_of = {"moreblocks",},
		setting = "Cook_compressed_cobble",
		def = {
			type = "cooking",
			output = "default:stone 9",
			recipe = "moreblocks:cobble_compressed",
		},
	},
	[2] = {
		description = "Cook moreblocks:desert_cobble_compressed into 9 default:desert_stone",
		depends_of = {"moreblocks",},
		setting = "Cook_compressed_desert_cobble",
		def = {
			type = "cooking",
			output = "default:desert_stone 9",
			recipe = "moreblocks:desert_cobble_compressed",
		},
	},
	[3] = {
		description = "Cook extra:cobble_condensed into 81 default:stone",
		depends_of = {"extra",},
		setting = "Cook_condensed_cobble",
		def = {
			type = "cooking",
			output = "default:stone 81",
			recipe = "extra:cobble_condensed",
		},
	},
	[4] = {
		description = "Craft back darkage:chalk from 2 darkage:chalk_powder (horiz)",
		depends_of = {"darkage",},
		setting = "Craft_darkage_chalk",
		def = {
			output = "darkage:chalk",
			recipe = {
				{"darkage:chalk_powder",	"darkage:chalk_powder"},
			},
		},
	},
	[5] = {
		description = "Craft back darkage:chalk from 2 darkage:chalk_powder (vertic)",
		depends_of = {"darkage",},
		setting = "Craft_darkage_chalk",
		def = {
			output = "darkage:chalk",
			recipe = {
				{"darkage:chalk_powder"},
				{"darkage:chalk_powder"},
			},
		},
	},
	[6] = {
		description = "Craft darkage:old_tuff_bricks ",
		depends_of = {"darkage",},
		setting = "Craft_darkage_old_tuff_bricks",
		def = {
			output = "darkage:old_tuff_bricks 2",
			recipe = {
				{"darkage:mud",	"darkage:tuff_bricks"},
			},
		},
	},
	[7] = {
		description = "Craft darkage:old_tuff_bricks (alternate recipe)",
		depends_of = {"darkage",},
		setting = "Craft_darkage_old_tuff_bricks",
		def = {
			output = "darkage:old_tuff_bricks 2",
			recipe = {
				{"darkage:tuff_bricks", "darkage:mud"},
			},
		},
	},
	[8] = {
		description = "Craft default:dirt_with_coniferous_litter",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_coniferous_litter",
			recipe = {
				{"default:pine_bush_needles"},
				{"default:dirt"},
			},
		},
	},
	[9] = {
		description = "Craft default:dirt_with_coniferous_litter",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_coniferous_litter",
			recipe = {
				{"default:pine_needles"},
				{"default:dirt"},
			},
		},
	},
	[10] = {
		description = "Craft default:dirt_with_coniferous_litter",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_coniferous_litter",
			recipe = {
				{"default:pine_bush_sapling"},
				{"default:dirt"},
			},
		},
	},
	[11] = {
		description = "Craft default:dirt_with_coniferous_litter",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_coniferous_litter",
			recipe = {
				{"default:pine_bush_stem"},
				{"default:dirt"},
			},
		},
	},
	[12] = {
		description = "Craft default:dirt_with_coniferous_litter",
		depends_of = {"default", "trunks",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_coniferous_litter",
			recipe = {
				{"trunks:pine_treeroot"},
				{"default:dirt"},
			},
		},
	},
	[13] = {
		description = "Craft default:dirt_with_coniferous_litter",
		depends_of = {"default", "moretrees",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_coniferous_litter",
			recipe = {
				{"moretrees:cedar_cone"},
				{"default:dirt"},
			},
		},
	},
	[14] = {
		description = "Craft default:dirt_with_coniferous_litter",
		depends_of = {"default", "moretrees",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_coniferous_litter",
			recipe = {
				{"moretrees:fir_cone"},
				{"default:dirt"},
			},
		},
	},
	[15] = {
		description = "Craft default:dirt_with_coniferous_litter",
		depends_of = {"default", "moretrees",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_coniferous_litter",
			recipe = {
				{"moretrees:spruce_cone"},
				{"default:dirt"},
			},
		},
	},
	[16] = {
		description = "Craft default:dirt_with_coniferous_litter",
		depends_of = {"default", "moretrees",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_coniferous_litter",
			recipe = {
				{"moretrees:acorn"},
				{"default:dirt"},
			},
		},
	},
	[17] = {
		description = "Cook default:dirt_with_grass into default:dry_dirt_with_dry_grass",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			type = "cooking",
			output = "default:dry_dirt_with_dry_grass",
			recipe = "default:dirt_with_grass",
			cooktime = 1,
		},
	},
	[18] = {
		description = "Craft default:dry_dirt_with_dry_grass",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dry_dirt_with_dry_grass",
			recipe = {
				{"default:dry_grass_1"},
				{"default:dry_dirt"},
			},
		},
	},
	[19] = {
		description = "Cook default:grass_1 into default:dry_grass_1",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			type = "cooking",
			output = "default:dry_grass_1",
			recipe = "default:grass_1",
			cooktime = 1,
		},
	},
	[20] = {
		description = "Cook default:dirt into default:dry_dirt",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			type = "cooking",
			output = "default:dry_dirt",
			recipe = "default:dirt",
			cooktime = 1,
		},
	},
	[21] = {
		description = "Craft default:dirt_with_rainforest_litter",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_rainforest_litter",
			recipe = {
				{"default:jungleleaves"},
				{"default:dirt"},
			},
		},
	},
	[22] = {
		description = "Craft default:dirt_with_rainforest_litter",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_rainforest_litter",
			recipe = {
				{"default:junglegrass"},
				{"default:dirt"},
			},
		},
	},
	[23] = {
		description = "Craft default:dirt_with_rainforest_litter",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_rainforest_litter",
			recipe = {
				{"default:junglesapling"},
				{"default:dirt"},
			},
		},
	},
	[24] = {
		description = "Craft default:dirt_with_rainforest_litter",
		depends_of = {"default",},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_rainforest_litter",
			recipe = {
				{"group:leaves"},
				{"default:dirt"},
			},
		},
		remember_last_output = true,
	},
	[25] = {
		description = "Craft default:dirt_with_rainforest_litter",
		depends_of = {"default","moretrees"},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_rainforest_litter",
			recipe = {
				{"moretrees:jungletree_leaves_yellow"},
				{"default:dirt"},
			},
		},
	},
	[26] = {
		description = "Craft default:dirt_with_rainforest_litter",
		depends_of = {"default","moretrees"},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_rainforest_litter",
			recipe = {
				{"moretrees:jungletree_leaves_red"},
				{"default:dirt"},
			},
		},
	},
	[27] = {
		description = "Craft default:dirt_with_rainforest_litter",
		depends_of = {"default","moretrees"},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_rainforest_litter",
			recipe = {
				{"moretrees:jungletree_sapling_ongen"},
				{"default:dirt"},
			},
		},
	},
	[28] = {
		description = "Craft default:dirt_with_rainforest_litter",
		depends_of = {"default","vines"},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_rainforest_litter",
			recipe = {
				{"vines:jungle_end"},
				{"default:dirt"},
			},
		},
	},
	[29] = {
		description = "Craft default:dirt_with_rainforest_litter",
		depends_of = {"default","vines"},
		setting = "Craft_dirts_default",
		def = {
			output = "default:dirt_with_rainforest_litter",
			recipe = {
				{"vines:jungle_middle"},
				{"default:dirt"},
			},
		},
	},
	[30] = {
		description = "Craft default:dirt_with_dry_grass",
		depends_of = {"default",},
		setting = {"Craft_dirts_default", "Craft_dirts_cycling",},
		def = {
			output = "default:dirt_with_dry_grass",
			recipe = {
				{"default:dirt_with_grass"},
			},
		},
	},
	[31] = {
		description = "Craft default:dry_dirt_with_dry_grass",
		depends_of = {"default",},
		setting = {"Craft_dirts_default", "Craft_dirts_cycling",},
		def = {
			output = "default:dry_dirt_with_dry_grass",
			recipe = {
				{"default:dirt_with_dry_grass"},
			},
		},
	},
	[32] = {
		description = "Craft default:dirt_with_coniferous_litter",
		depends_of = {"default",},
		setting = {"Craft_dirts_default", "Craft_dirts_cycling",},
		def = {
			output = "default:dirt_with_coniferous_litter",
			recipe = {
				{"default:dry_dirt_with_dry_grass"},
			},
		},
	},
	[33] = {
		description = "Craft default:dirt_with_rainforest_litter",
		depends_of = {"default",},
		setting = {"Craft_dirts_default", "Craft_dirts_cycling",},
		def = {
			output = "default:dirt_with_rainforest_litter",
			recipe = {
				{"default:dirt_with_coniferous_litter"},
			},
		},
	},
	[34] = {
		description = "Craft woodsoils:dirt_with_leaves_1",
		depends_of = {"default","woodsoils",},
		setting = {"Craft_dirts_mod",},
		def = {
			output = "woodsoils:dirt_with_leaves_1",
			recipe = {
				{"group:leaves"},
				{"default:dirt_with_grass"},
			},
		},
	},
	[35] = {
		description = "Craft woodsoils:dirt_with_leaves_2",
		depends_of = {"default","woodsoils",},
		setting = {"Craft_dirts_mod",},
		def = {
			output = "woodsoils:dirt_with_leaves_2",
			recipe = {
				{"woodsoils:dirt_with_leaves_1"},
			},
		},
	},
	[36] = {
		description = "Craft woodsoils:dirt_with_leaves_1 by cycling last_output",
		depends_of = {"default","woodsoils",},
		setting = {"Craft_dirts_mod","Craft_dirts_cycling"},
		def = {
			output = "woodsoils:dirt_with_leaves_1",
			recipe = "last_output",
		},
		recipe_is_function = true,
	},
	[37] = {
		description = "Craft woodsoils:dirt_with_leaves_2",
		depends_of = {"default","woodsoils",},
		setting = {"Craft_dirts_mod","Craft_dirts_cycling"},
		def = {
			output = "woodsoils:dirt_with_leaves_2",
			recipe = {
					{"woodsoils:dirt_with_leaves_1"},
				},
		},
	},
	[38] = {
		description = "Craft woodsoils:grass_with_leaves_1",
		depends_of = {"default","woodsoils",},
		setting = {"Craft_dirts_mod",},
		def = {
			output = "woodsoils:grass_with_leaves_1",
			recipe = {
				{"group:leaves"},
				{"default:dirt_with_grass"},
			},
		},
	},
	[39] = {
		description = "Craft woodsoils:grass_with_leaves_2",
		depends_of = {"default","woodsoils",},
		setting = {"Craft_dirts_mod",},
		def = {
			output = "woodsoils:grass_with_leaves_2",
			recipe = {
				{"woodsoils:grass_with_leaves_1"},
			},
		},
		remember_last_output = true,
	},
	[40] = {
		description = "Craft woodsoils:grass_with_leaves_1 by cycling",
		depends_of = {"default","woodsoils",},
		setting = {"Craft_dirts_mod","Craft_dirts_cycling"},
		def = {
			output = "woodsoils:grass_with_leaves_1",
			recipe = {
					{"woodsoils:dirt_with_leaves_2"},
				},
		},
	},
	[41] = {
		description = "Craft default:dirt_with_grass by cycling last_output",
		depends_of = {"default",},
		setting = {"Craft_dirts_default","Craft_dirts_cycling"},
		def = {
			output = "default:dirt_with_grass",
			recipe = "last_output",
			},
		recipe_is_function = true,
	},
}