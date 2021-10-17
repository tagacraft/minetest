--[[ file recipes_factory.lua 
	part of mycustom mod
	contains definitions for recipes to add to the game

	DO NOT modify this file as it is factory default recipes.
	modify instead the file <worldpath>/mycustom_local_recipes.lua if you want to add-modify recipes and preserve them while updating mycustom

]]


recipes_defs = {
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
		remember_last_output = true,
	},
	[38] = {
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