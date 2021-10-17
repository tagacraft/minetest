--[[ part of mod mycustom :
	functions.lua
	release 4.0.3

--]]


function log(lvl, msg)
	-- will store log messages for debug into world_path/mycustom_log.txt :

	local dst = minetest.get_worldpath().."/mycustom_log.txt"
	local log_level

	if not myc then 	-- myc is cleaned up after load-time, but is used in minetest.register_on_joinplayer
		log_level = lvl -- will log the msg if myc has been set to nil (in-game when 1st player log in)
	else
		log_level = myc.log_level
	end

	-- if lvl is nil, clear the file :
	if (lvl == nil) then
		local dst_file, err_dst = io.open(dst, "w")
		dst_file:close()
		return true
	end

	-- take account of old log() proc. when lvl was absent, then only msg was given as first and only parameter :
	-- in that case we will log a warning to help upgrade the obsolete call 
	if msg==nil and lvl~=nil then
		msg = lvl
		lvl = 0
	end

	if lvl <= log_level then  

		local dst_file, err_dst = io.open(dst, "a")

		if not dst_file then return false, err_dst end
		if lvl==0 then dst_file:write("#### LEVEL 0 ! :  ") end  	-- get a warning to upgrade relevant call of log() with a level value.
		dst_file:write(msg.."\n")
		dst_file:close()
	end

end

function equal_tabs(txt)
	--[[ return a number of tabs equivalent to the length of the string txt, where a tab character is supposed to replace 4 chars ]]
	
	local tab = 0

	if type(txt)~="string" or string.len(txt)==0 then goto end_of_equal_tab end

	for i=1, string.len(txt) do
		if string.sub(txt, i, i)=="\9" then
			tab = tab+1
		else
			tab = tab+0.25
		end
	end
	::end_of_equal_tab::
	log(5, "equal_tabs(\""..tostring(txt).."\") (type=="..type(txt)..", len=="..string.len(tostring(txt))..") return "..tostring(math.floor(tab)))
	return math.floor(tab)
end

function count(a_table) -- return the number of primary level entries in a table
	if type(a_table)~="table" then
	   log(5, "function count is called to count entries in a table but parameter transmited was not a table but of type "..type(a_table))
	   return false, "(not a table)"
	end

	local i=0
	for _, _ in pairs(a_table) do i=i+1 end
	return i
end

function count_deep(a_table) -- return the deepest level for the 1st entry of a table
	--[[ example : 
		count_deep({
					a={ 						-- parsed (1st entry),
						b= { 					-- parsed (1st - 1st entry)
							c=3, 				-- parsed (1st - 1st - 1st entry)
							d= {				-- IGNORE (1st - 1st - 2nd entry)
								e={"1","2"}			-- ignored
							}
						}
					},
					2nd = "2nd entry not parsed"
				  })
		will return 3 because 'c' is the deepest level through the 1st entries
		this function is used to determine the indentation of a new setting in a text file according to its hierarchy
	]]
	if type(a_table)==nil then
		log(5, "count_deep was called to parse a nil value. return 1")
		return 1
	elseif a_table=={} then
		log(5, "count_deep was called to parse an empty table. return 1")
		return 1
	elseif type(a_table)~="table" then 
		log(5, "count_deep was called to parse a non-table ("..tostring(a_table).."). return 1")
		return 1
	elseif a_table=={} then 
		log(5, "count_deep was called to parse an empty table. return 1")
		return 1
	else
		log(5, "count_deep will parse "..dump(a_table))
	end

	local deep = 0

	for i, j in pairs(a_table) do
		deep = deep+1
		if type(j)=="table" then
			return deep + count_deep(j)
		end
		return deep
	end
	log(5, "count_deep has parsed "..dump(a_table).."and will return "..tostring(deep))
	do
		return deep -- reach this point if table to parse is empty.
	end
	log(5, "count_deep should never go there !")
end

function get_clone_of(original)
	local clone = {}
	for k, v in pairs(minetest.registered_nodes[original]) do
		clone[k] = v
	end
	return clone
end

function get_nodenames_from_mod(modname)
	local list_nodenames = {}
	local l = string.len(modname)

	for k, v in pairs(minetest.registered_nodes) do
		if string.sub(k, 1, l)==modname then
			table.insert(list_nodenames, {k, true} ) 					-- we want a table of <node_name> = true 
		end
	end
	return list_nodenames
end

function check_node(nodename) -- a TODO function to check if node is a good kind of node to be shaped by the shaper mod
	local node_ok = false

	-- todo code...

	return node_ok
end


function call_pkarcs(ancestor_name)

		if minetest.registered_nodes[ancestor_name]==nil then
			log(4, "mod mycustom try to call pkarcs for node "..ancestor_name..
				" but this node does not exist in minetest.registered_nodes\n")
			return nil
		end
		
		--[[ TODO :
			Before calling pkarcs.register_node, check if the node will make sense if derivated into "_arc",
			"_inner_arc" and "_outer_arc" !
			for example a torch will certainly be useless in form of "torch_arc"...

			local good_node, raison_why = check_node(ancestor_name)
			if not (good_node == true) then
				return false, raison_why
			end
		--]]
		
		pkarcs.register_node(ancestor_name)

		-- now we have a 3 new shaped nodes from ancestor_name in versions "_arc", "_inner_arc" and "_outer_arc";
		-- but pkarcs has forgotten some fields while creating new nodes, especialy the light.. 
		-- so we will retrieve those forgotten fields and add them ;
		-- to do that, as minetest DO NOT allow to modify directly the table registered_nodes, we must
		-- get a clone of our mod, modify it, then use minetest.register_node(:mynode) to overwrite it :

		local suffix = {"_arc", "_inner_arc", "_outer_arc",}
		local clone_name = ""
		local clone = {}

		for _, v in ipairs(suffix) do
			clone_name = "pkarcs:"..
						string.sub(ancestor_name, (string.find(ancestor_name,":")+1))..v
						-- for example clone_name will contain "pkarcs:meselamp_arc" from the ancestor "default:meselamp"
			clone = get_clone_of(clone_name)

			for k, v in pairs(minetest.registered_nodes[ancestor_name]) do
				if not clone[k] then		-- the field named k, founded in ancestor, is not present in clone, so
					clone[k] = v			-- add the field's content handled by v that was in ancestor but not in derivated node
				end
			end
			if clone ~= nil then
				minetest.register_node(":"..clone_name, clone) -- overwrite block with forgotten fields :)
			end
		end
	return true
end

function call_technic_cnc(node_name)

	-- check if node is registered :
	if minetest.registered_nodes[node_name]==nil then
			log(4, "mod mycustom try to call technic_cnc for node "..node_name..
				" but this node does not exist in minetest.registered_nodes\n")
			return nil
	end

	-- node is registered, so we will now try to get it's different fields needed to call technic_cnc.register_all() :

	--[[ in technic_cnc, function to call is : 
		technic_cnc.register_all(recipeitem, groups, images, description)
		like
		technic_cnc.register_all("default:dirt",
                {snappy=2,choppy=2,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
                {"default_dirt.png"},
                "Dirt") 
   	--]]

	local node = minetest.registered_nodes[node_name]

	technic_cnc.register_all(node.name,
							 node.groups,
							 node.tiles,
							 node.description
		)
	-- technic_cnc has registered some derivated nodes named <node_name>.._technic_cnc..<some_suffixes>
	-- as those new blocks miss some ancestor's fields (like light_source), we will add those fields from ancestor.
	
	local derivated_list = {}
	local prefix = node.name .. "_technic_cnc"
	local clone = {}

	-- retrieve the list of the nodes created by technic_cnc from <node_name> :
	for k, _ in pairs(minetest.registered_nodes) do
		if string.sub(k, 1, string.len(prefix)) == prefix then
			table.insert(derivated_list, k)
		end
	end

	-- with each node name of this list, clone it, add if needed missing fields then overwrite minetest.registered_nodes :
	for  _, k in ipairs(derivated_list) do
		
		clone = get_clone_of(k)
		for field, value in pairs(node) do 			-- for each field of ancestor node,
			if not clone[field] then				-- field, founded in ancestor, is not present in derivated, so
				clone[field] = value				-- add the field in derivated node
			end
		end

		minetest.register_node(":"..k, clone) -- overwrite block with forgotten fields :)
		
	end
	return true
end

function call_moreblocks(node_name) --[[ register node_name in circular_saw which is part of moreblocks ]]

	-- check if node is registered :
	if minetest.registered_nodes[node_name]==nil then
			log(4, "mod mycustom try to call moreblocks (circular_saw) for node "..node_name..
				" but this node does not exist in minetest.registered_nodes\n")
			return nil
	end

	-- node is registered, so we will now try to get it's different fields needed to call stairsplus:register_all() :

	--[[ in moreblocks, function to call is : 
		stairsplus:register_all(mod_name, short_node_name, full_nodename, node_def)
		like
		stairsplus:register_all(
				"default",
				"dirt",
				"default:dirt",
                minetest.registered_nodes("default:dirt") ) 

        Yes, i know, it seems all parameters should have been replaced by only the "full_name" that lead to all others informations ...
        But i'm not the author of circular_saw, perhaps there is a raison why such a lot of redundant parameters. 
   	--]]

	local node = minetest.registered_nodes[node_name]
	local mod_name = string.sub(node_name, 1, string.find(node_name, ":")-1 )
	local short    = string.sub(node_name, string.find(node_name, ":")+1)

	stairsplus:register_all(mod_name, short, node_name, node)
							 
	-- Fortunately, it seems circular_saw keeps all the fields from original node to the shaped derivated nodes, 
	-- so we dont need to search for some lost fields. :)

   return true   
end

function check_depends(mods)
	--[[ mods is a table of mods names, or just a string with only 1 mod name to check;
		this function check if all mods names are installed (return true)
		or return false if at least one isn't installed  ]]
	if type(mods) == "table" then
		for _, mod_name in ipairs(mods) do
			if minetest.get_modpath(mod_name) == nil then return false end
		end
		return true
	end
	if type(mods) == "string" then
		if minetest.get_modpath(mods) == nil then return false end
		return true
	end
	return false -- mods is not of type table nor of type string.
end

function check_settings(a_table_of_settings)
	--[[ compare a_table_of_settings with global variable settings :
		all switches in a_table_of_settings must be 'true' in global settings;
		take acount of case where a_table_of_settings contains only 1 switch so it is not of type 'table' but 'string'
		also take care of 3 possibles results : true, false OR nil (when switch isnt defined in settings)
	]]
	if type(a_table_of_settings) == "table" then
		for _, setting in ipairs(a_table_of_settings) do
			if (settings[setting]~=true) then return false end
		end
		return true
	end
	if type(a_table_of_settings) == "string" then
		if (settings[a_table_of_settings]~=true) then return false end
		return true
	end
	return false
end


function update_table(src, dst)
	--[[ update table dst with table src  : used for updating settings process; for recipes, procedure is simpler ]]
	--[[ this function will update, in dst, ONLY mentioned entries in src : if a dst.field isnt mentioned in src, then it will remain ]]

	if (type(src)~="table") or (type(dst)~="table") then 
		log(5, "function update_table() called with wrong parameters")
		return false
	end

	for k, v in pairs(src) do 					-- for each element of src :
		if (dst[k]==nil) then 					-- if not defined in dst, create it in dst;
			dst[k]=v
		else 									-- if defined :
			if (type(src[k])=="table") then 				-- if src element is a table :
				if (type(dst[k])~="table") then 				-- if dst is not, replace old dst element by src element (overwrite old)
					dst[k] = src[k]
				else 											-- if dst is also a table, parse this table recursively
					update_table(src[k], dst[k])
				end
			else								-- if src element is not a table, overwrite dst with it.
				dst[k] = src[k]
			end
		end
	end
end


function file_exist(file_name)
	local f, err = io.open(file_name, "r")
	if not f then return false, err end
	f:close()
	return true
end

function copy_file(src, dst)
	--[[ on the hard disk, copy a file from src to dst, erasing dst if exist. ]]

	local src_file, err_src = io.open(src, "r")
	local dst_file, err_dst = io.open(dst, "w")

	if not src_file then return false, err_src end
	if not dst_file then return false, err_dst end

	for line in src_file:lines() do
		dst_file:write(line.."\n")
	end
	src_file:close()
	dst_file:close()
	return true
end

function copy_locals(file_name)
	--[[ at first launch, copy mycustom_settings_local and or mycustom_recipes_local from mod to world_path ]]

	local src = minetest.get_modpath("mycustom").."/"..file_name
	local dst = minetest.get_worldpath().."/"..file_name
	local ok, err_msg = copy_file(src, dst)
	return ok, err_msg
end

function check_local_settings()
	--[[  at first install, if <world_path>/mycustom_local_settings.lua does not exist, 
			create it with a copy of <mod_path>/mycustom_local_settings.lua;
		if this file already exist, load it and complete/rewrite global variable settings
	]]
	log(3, "check_local_settings...")
	local settings_local_filename = minetest.get_worldpath().."/mycustom_local_settings.lua"
	local file, err_msg = io.open(settings_local_filename, "r")
	if not file then
		-- the local settings file doest not exist yet :
		-- copy it from mod path to world path :
		log(4, "local settings not founded in world_path. get a copy from mod_path...")
		copy_locals("mycustom_local_settings.lua")
		-- As eventually new settings are already in the just copied local_settings.lua, remove file new_settings.lua :
		os.remove(minetest.get_modpath("mycustom").."/mycustom_new_settings.lua") -- no matter the result of os.remove
	end

	-- file mycustom_local_settings.lua now exist, load it :
	file, err_msg = io.open(settings_local_filename, "r")
	if not file then
		-- what a terrible wrong way : something disallow read-write the file ! log it in minetest.log :
		minetest.log("[ERROR] mycustom was unable to read/write the local settings data file in the world path !\n"..
			"the system io error message was : "..err_msg.."\n"..
			"The mycustom's default settings will remain untouched")
		return false, err_msg		
	end
	file:close()
	dofile(settings_local_filename)

	-- settings must be now updated from local settings :
	update_table(local_settings, settings)
	log(3, "local settings loaded and settings updated;")
end

function check_local_recipes()
	--[[  at first install, if <world_path>/mycustom_local_recipes.lua does not exist, 
			create it with a copy of mod_path/mycustom_local_recipes.lua;
		if this file already exist, load it and complete/rewrite global variable recipes_defs
	]]
	log(3, "check_local_recipes...")
	local recipes_local_filename = minetest.get_worldpath().."/mycustom_local_recipes.lua"
	local file, err_msg = io.open(recipes_local_filename, "r")
	if not file then
		-- the local recipes file doest not exist yet :
		-- copy it from mod path to world path :
		log(4, "local recipes not founded in world_path. get a copy from mod_path...")
		copy_locals("mycustom_local_recipes.lua")
	end
	-- file mycustom_local_recipes.lua now exist, load it :
	file, err_msg = io.open(recipes_local_filename, "r")
	if not file then
		-- what a terrible wrong way : something disallow read-write the file !
		minetest.log("[ERROR] mycustom was unable to read/write the local recipes data file in the world path !\n"..
			"the system io error message was : "..err_msg.."\n"..
			"The mycustom's default recipes will remain untouched")
		return false, err_msg		
	end
	file:close()
	dofile(recipes_local_filename) -- local_recipes_def is now loaded

	--[[ recipes_defs must be now updated with local_recipes_def :
		As far as I know, a minetest craft can't be identified by a unique key but a group of output+recipe (input);
		so i store recipes with a unique numerical index precisely mentioned and then,
		a local recipe will always replace the same numerical index of default recipe (or create it if not yet defined).
		in default recipes, no field will remain from the previous #indexed recipe while updated by the same #indexed local recipe

		To erase a previous recipe you can store local_recipes_defs[#The_index_to_erase]=nil
		or set a field local_recipes_defs[#The_index_to_ignore].ignore = true -- then the recipe will be ignored (not registered) whatever the other fields
		or if only this recipe is concerned by, set the corresponding local_settings["the_corresponding_setting"] = false
		setting the field .ignore to true make possible to keep all the recipe for memory.
	]]

	local nb = 0
	for num, recipe in pairs(local_recipes_defs) do
		recipes_defs[num] = local_recipes_defs[num]
		nb = nb+1
	end
	log(3, tostring(nb).." local recipes loaded and recipes updated;")

end

function chain_index(a_table, str, most, missing) --[[ return a concatained list of each first field: field.field.field... from a_table
	a_table may be of type table (or string if there is only one node ) :
	for example :
		a_table = "pkarcs"
	or :
		a_table = {parent_1 = {
						parent_2 = {
							parent_3 = {
								node_1 = a_value#1,
								node_2 = a_value#2
							}
						},
					other_node = <something>
				}
		str = <root_node_inside_local_settings>
		}}
	used by function check_new_settings() 
	]]
local chk = ""
local myfunc
local most_accurate = most

if type(a_table)=="table" then
		for k, v in pairs(a_table) do

		-- check if v exist in local_settings :
		-- when a field is missing in local_settings, the table missing will receive that field, so:
		-- if missing is empty (==nil) we can try to access local_settings[that_chained_field_k] but else,
		-- when missing is not empty means we have already found a missing node_parent before, so trying to access local_settings
		-- for that field is useless because all childs from a missing node will always be also missing : you will never find a leave if the tree is not here...
		-- moreover, while parent==nil, trying to access table[nil][child] will crash the code and the server.

		if count(missing)==0 and type(v)=="table" then 
			if string.find(k, "[%s:]")==nil then 			-- special chars space and/or colon 
				chk = "return "..str.."."..k 			-- get the syntax parent.child
			else
				chk = "return "..str.."[\""..k.."\"]" 	-- get the syntax parent["a child"]
			end
			myfunc = loadstring(chk)
--			log("chain_index will try to access "..chk)
			if (myfunc()~=nil) then 
				most_accurate = k 
--				log("which exist, so most_accurate remember it;")
			else
				table.insert(missing, k)
--				log("which not exist, so missing table will remember it;")
			end
		else
			if type(v)=="table" then table.insert(missing, k) end
		end

		if type(v)=="table" then
			if string.find(k, "[%s:]")==nil then
				str = str.."."..k
			else
				str = str.."[\""..k.."\"]"
			end
--			log("As field "..k.." is a table, recurse call chain_index with that field...")
			return chain_index(v, str, most_accurate, missing)
		end
	end
end
log(5, "end of chain_index()")
return str, most_accurate, missing
end

var= "" -- only for example purpose below :
function find_comment(line, pattern, start)
	-- return the index of pattern in line, where pattern is not included in a LUA's string markers like :

	 		var = [[ a string enclosed in [[ cant have ']].."]]"..[[' inside! \n]] .. "\n"..
	 			  [[ { ["a_field"] = 'a_value --[[ "abc" '} ]] .. "\n"..
	 			  [[ -- isnt comment, but text; \n]] .. "\n"..
	 			  " enclosed by dble quotes txt with [[, ]], is txt " .. "\n" ..
	 			  [[ in sqr-brackets, escape chars \n is not a line-feed as in "" string markers ]] .. "\n"..
	 			  [[ string including ", ',  --[[, ]] .. "\n"..
	 			  "string with [[, ', \", "   -- then we have true comments and eventually x-lines if --[[ not in a 1-line comment.
	
	-- return #line if not found so we will can get the string.sub(txt, 1, index_returned) that have no comments

	start = start or 1

	local index
	local marker = ""
	local char, prev ="", ""
	local in_brackets = 0
	local continue = true

	index = string.find(line, pattern, start) or #line
	continue = (index<#line) and (index>1)
	while continue do
		-- pattern is found, check if not in a string :
		for i=start, index do

			char = string.sub(line, i, i)
--			log("look char#"..tostring(i).."="..char)
			if i>1 then 
				prev = string.sub(line, i-1, i-1) or ""
			else 
				prev = ""
			end
			if (char=="[" or char=="]") then char=string.sub(line, i, i+1) end -- if [ found, look if it is [[

			if (char=='"' or char=="'") then 	-- potentially found a marker for begin/end a string 
				if char==marker then 			-- this is a closing marker
					marker = ""
				elseif marker=="" then 				-- this is a string begin marker
					marker = char
				end
			end
			if (char=="[[" and marker=="") then marker=char end -- find valid opening brackets
			if (char=="]]" and marker=="[[") then marker="" end -- find closing brackets
		end
		if marker~="" then 		-- pattern is included in a string, search next pattern in line :
			index = string.find(line, pattern, index+1) or #line
			marker = ""
			continue = (index<#line)
		else
		-- pattern is not in a string
			return index			
		end
	end
	return index
end

function check_new_settings()
	--[[ if this release brings new settings that an admin of a server (you) may want to customize over later releases,
		then we must transfer those settings in world_path/mycustom_local_settings.lua ;
 ]]

	log(3, "check_new_settings...")

	-- first, detect if exist a file <mod_path>/new_settings.lua :
	if not file_exist(minetest.get_modpath("mycustom").."/mycustom_new_settings.lua") then
		log(3, "file mycustom_new_settings.lua not found : there is no new setting to include in local settings.")
		return true, "no new setting"		-- there is no file new_settings.lua in mod_path, so the work is done for check_new_settings().
	end
	-- the file exist, so log a message for the admin to eventually customize those new settings :
	log(3, "There are some new settings brought by this release. See file <mod_path>/mycustom_new_settings.lua if you wish to customize it")

	-- will send a message to each player that joins the game with priv "server", or is "singleplayer" (the owner of the game, obviously)
	minetest.register_on_joinplayer(
		function(player)
			minetest.after(5, function()
				local name = player:get_player_name()
				local priv = minetest.get_player_privs(name)
				if (name=="singleplayer") or (priv.server==true) then
					minetest.chat_send_player(name, "The mod mycustom have new settings available you can integrate in your local settings.\n"..
						" see the <modpath>/mycustom_new_settings.lua for explanations;\n"..
						" rename or remove that file to avoid this message next time.")
				end
			end)
		end
	)
end



--[ initiate some nodes to be registered by some mods which are able to shape them : ]
function register_to_mod(shaper_name)

	log(4, "\9Shaper mod "..shaper_name.." : ")

	-- check if shaper mod is installed :
	if not check_depends(shaper_name) then 
		log(4, "\9\9aborted : mod not installed.")
		return 
	end 

	--[[ check if the specialized function exist :
		for the shaper mod, we MUST have a function called call_<shapr's_name>() in this file functions.lua. for example :
		for the mod moreblocks, we must find the function "call_moreblocks()".
		those functions are referenced in the Lua's global variable _G{}
		trying to call a function that doesn't exist will result in server crash while loading.
	]]
	if type(_G["call_"..shaper_name])~="function" then
		log(4, 	"######################\n"..
				"##  W A R N I N G : ##\n"..
				"##==================##")
		log(4, 	"\9\9aborted : The function 'call_"..shaper_name.."()' is missing in mycustom's file functions.lua .\n"..
				"\9\9    if you want some shaping function of this mod to work, the corresponding calling function \n"..
				"\9\9    must be writen in the file functions.lua. \n"..
				"\9\9    You can see for example the function 'call_pkarcs()' as a model to write yours.")
		return
	end

	local str_func = "" -- a string to build the rigth shaper's function to call, like "call_pkarcs()" or "call_technic_cnc()"
	local result = ""
	local nb_ok = 0
	mod_need_places = settings.shapers[shaper_name].subnodes_made or 1 -- if settings is nil, get 1
	local mod_really_need = 0 -- will check the real amount of places needed in minetest.registered_nodes for that mod to register derivared nodes

	if settings.shapers[shaper_name].main_switch==false then
		log(4, "\9\9aborted : in settings, shapers."..shaper_name..".main_switch is set to false")
		return
	end

	if settings.shapers[shaper_name].subnodes_made == nil then
		log(4, "\9\9WARNING : in <worldpath>/mycustom_local_settings.lua, the setting shapers."..shaper_name..".subnodes_made was missing.\n"..
			"\9\9this setting will be inserted and updated to the right value for your server after the next \n"..
			"\9\9call to the "..shaper_name..".register_node() procedure, to avoid exceed of minetest.register_nodes limit,\n"..
			"\9\9then to avoid a server crash in the future.")
		insert_new_setting("local", {[1]="shapers", [2]=shaper_name, [3]="subnodes_made"}, 1, 
			" --[[ how many subnodes are made by this mod while registering a node. this value is used to test that actual\n"..
			"\9\9\9\9\9registered nodes more that value will not exceed the limit of minetest.registered_nodes which is currently 32767\n"..
			"\9\9\9\9\9if limit would be exceeded, the call will not be done to avoid server crash at load time.\n"..
			"\9\9\9\9\9the value is automatically updated if needed ]]")
		settings.shapers[shaper_name].subnodes_made = 1
	end

	local func_called, func_msg -- to test 'call_<shaper_name>()' with assert() exist

	for mod_name, mod_switches in pairs(settings.shapers[shaper_name].mods) do

		log(4, "\9\9With nodes from mod "..mod_name..":")
		if mod_switches.activated == true then -- global switch is 'on' for this mod

			-- Check if mod to get nodes from is still here !
			if minetest.get_modpath(mod_name) ~= nil then
				if mod_switches.all_nodes == true then -- get all possible nodes from this mod to call shaper to register them
					mod_switches.nodes = get_nodenames_from_mod(mod_name)
					log(4, "\9\9\9switch 'all_nodes' is true, register all it's "..tostring(count(mod_switches.nodes)).." nodes :")
				else
					log(4, "\9\9\9switch 'all_nodes' is false, register only few nodes ("..tostring(count(mod_switches.nodes))..") :")
				end
				-- mod_switches.nodes contain now the list of the nodes to register to shaper;
				for node_name, node_switch in pairs(mod_switches.nodes) do
					result = "\9\9\9\9"..node_name.." :"
					if node_switch==true then
						-- check if limit of minetest.registered_nodes is not to be exceeded :
						if (actual_nodes_left >= mod_need_places) then
							if mod_really_need==0 then nb_nodes_used = count(minetest.registered_nodes) end
							str_func = loadstring("return call_"..shaper_name.."(\""..node_name.."\")")
							-- here we call the adaptated function for this shaper :
							-- remember if the function call_<shaper's_name>(node_name)
							if (str_func()==nil) then goto next_node_to_register end
							if mod_really_need==0 then mod_really_need = count(minetest.registered_nodes)-nb_nodes_used end
							if mod_really_need~=mod_need_places then
								log(4, "\9\9\9\9###############\n"..
									"\9\9\9\9## WARNING : ##\n"..
									"\9\9\9\9###############   the setting "..shaper_name..".subnodes_made was set to "..
									tostring(settings.shapers[shaper_name].subnodes_made).."\n"..
									"\9\9\9\9		But we experienced that "..shaper_name.." mod just created "..tostring(mod_really_need).." nodes shaped from "..node_name..".\n"..
									"\9\9\9\9		The setting 'shapers."..shaper_name..".subnodes_made' were automatically updated to "..tostring(mod_really_need) )
								mod_need_places = mod_really_need
								-- determine if subnodes_made is missing in local or default settings :
								if local_settings.shapers[shaper_name]~=nil then 
									if local_settings.shapers[shaper_name].subnodes_made==nil then 
										insert_new_setting("local", {[1]="shapers", [2]=shaper_name, [3]="subnodes_made"}, mod_really_need)
									else
										update_a_local_setting("local", {[1]="shapers",[2]=shaper_name,[3]="subnodes_made"}, mod_really_need)
									end
									log(4, 	"\9\9\9\9       in the file <world_path>/mycustom_local_settings.lua to avoid future server crash.")
								else -- if subnodes_made is not in locals, we have to update defaults :
									update_a_local_setting("default", {[1]="shapers",[2]=shaper_name,[3]="subnodes_made"}, mod_really_need)
									log(4, 	"\9\9\9\9       in the file <mod_path>/mycustom_default_settings.lua to avoid future server crash.\n"..
											"\9\9\9\9       You are encouraged to copy this setting into your <world_path>/mycustom_local_settings.lua\n"..
											"\9\9\9\9       to avoid overwriting by a later release. ")
								end
								settings.shapers[shaper_name].subnodes_made = mod_really_need
							end
							actual_nodes_left = actual_nodes_left-mod_need_places
							nb_ok = nb_ok+1
							log(4, result.."\9\9 registered by "..shaper_name.."; ("..tostring(actual_nodes_left).." free places left to register others)")
						else
							log(4, result.."\9\9 aborted : not enough place ("..tostring(actual_nodes_left).." left) to register "..
								tostring(mod_need_places).." shaped nodes from this one.")
							break
						end
					else
						log(4, result.."\9\9 aborted : switch is set to false for this node;")
					end
					::next_node_to_register::
				end
			else
				log(4, "\9\9\9aborted : mod "..mod_name.." is not installed")
			end
		else
			-- do nothing for this mod with pkarcs, as global switch is "off"
			log(4, "\9\9\9aborted : the setting shapers."..shaper_name..".mods."..mod_name..".activated is set to false")
		end
	end
	log(4, "\9\9finaly, "..shaper_name.." has shaped "..tostring(nb_ok).." basic nodes; each shaped in "..
		tostring(mod_need_places).." new nodes, \n"..
		"so "..shaper_name.." has registered "..tostring(nb_ok*mod_need_places).." new nodes in minetest.registered_nodes{}.")
end

function insert_new_setting(mode, setting, value, comment)
--[[ insert a new setting = value in the file 
		<worldpath>/mycustom_local_settings.lua if mode=='local'
		<modpath>/mycustom_default_settings.lua if mode=='default'

	setting is a table of settings's hierarchical nodes to follow to insert the new setting, like
	setting = {[1]="shapers", [2]="pkarcs", [3]="subnodes_made"}
	meaning we have to find the lines :
	 		shapers = {    ...
				pkarcs = { ...
	then we have to insert the line :
			subnodes_made = value
	that's it : this function was initialy meaned to insert the setting 
		shapers = {
			<some_mod> = {
				subnodes_made = <a_value>,
	which is necessary to avoid exceeding the limit of minetest.registered_nodes 
	when calling <some_mod>.register_node()'s function that create new shaped nodes from the one provided to it

	that said, this function insert_new_setting would be able to insert any setting needed. (To be carefully tested)
]]

	-- check if valid parameters received :
	if type(setting)~="table" then return end
	if value==nil then return end
	if count(setting)==0 then return end

	local src, dst

	if mode=="local" then 
		src = minetest.get_worldpath().."/mycustom_local_settings.lua"
		dst = minetest.get_worldpath().."/mycustom_local_settings_before_insert.lua"
	else
		src = minetest.get_modpath("mycustom").."/mycustom_default_settings.lua"
		dst = minetest.get_modpath("mycustom").."/mycustom_default_settings_before_insert.lua"
	end

	local ok, err = copy_file(src, dst)

	if not ok then log("Error copying to _before_insert.lua :"..err) end
	
	local nb_nodes = count(setting) 		-- the number of parent-nodes to find in the file; the last is the node to insert
	local cur_node = 1						-- the currently node to find
	local i 								-- index
	local found = 0 						-- index of setting in line readen if found
	local inserted_status = "looking for" 	-- will go thru 'looking for', 'to insert', "inserted"
	local x_lines_flag = false  			-- are we in a multilines comment ?
	local str = "" 							-- a working string

	src = dst
	if mode=="local" then 
		dst = minetest.get_worldpath().."/mycustom_local_settings.lua"
	else
		dst = minetest.get_modpath("mycustom").."/mycustom_default_settings.lua"
	end

	local file_src, err_src = io.open(src, "r")
	local file_dst, err_dst = io.open(dst, "w")

	for line in file_src:lines() do

		if inserted_status=="inserted" then goto read_next_line_to_insert end  	-- we have already inserted the setting. just transfert the end of file.

		if x_lines_flag then 									-- we are in a x-lines comments
			 iz = string.find(line, "]]") or 0						-- detect end of x-lines comment marker
			 if iz>0 then  											-- find end of x-lines comment :
			 	file_dst:write(string.sub(line, 1, iz+1)) 			-- write the "x-line comment" part of line;
			 	line = string.sub(line, iz+2) 						-- keep the end of line to analyse;
			 	x_lines_flag = false
			 else
			 	goto read_next_line_to_insert 						-- not found: all the line is x-line comment: dont parse, go next.
			 end
		end

		i = find_comment(line, "%-%-") 	-- i is the index in line where find a true comment marker (not included in "" or '' or [[ ]] ) 
										-- if no true comment found, i receive the length of line;
		if string.sub(line, i+2, i+3)=="[[" then x_lines_flag = true end -- a x-lines comment begin

		found = string.find(string.sub(line,1,i-1), setting[cur_node]) or 0	
		if found>0 then  				-- the setting[cur_node] is found :

			if cur_node<nb_nodes-1 then 	--  find the next :
				cur_node = cur_node+1
				goto read_next_line_to_insert
			end

			-- the setting[cur_node] is the last after which one we want to insert :
			-- the setting[nb_nodes] is the one we want to insert
			str = string.rep("\9", nb_nodes)
			if string.find(setting[nb_nodes], "[%s:]") then 		-- special char (space or colon) need special syntax :
				str = str.."[\""..setting[nb_nodes].."\"]".." = " 		-- get the syntax ["name of : node"] = 
			else
				str = str..setting[nb_nodes].." = "						-- get the syntax name_of_node = 
			end
			if type(value) == "string" then 
				str = str..'"'..tostring(value)..'", ' 
			elseif type(value) == "table" then 
				str = str..dump(value)..",\n"
			else
				str = str..tostring(value)..", "
			end
			inserted_status = "to insert"
			if comment~=nil then str=str..comment end
			str = str.."\n"
		end

		::read_next_line_to_insert::
		file_dst:write(line.."\n")
		if inserted_status=="to insert" then 
			file_dst:write(str)
			str = ""
			inserted_status = "inserted"
		end						
	end

	::end_of_insert_a_local_setting::
	file_src:close()
	file_dst:close()
	os.remove(src) 		-- remove the temporary working file 

end

function string_is_a_table_unclosed(a_string)
	-- return true if a_string contain an unclosed table (like a_string="{ something={}" where closure parenthesis is missing)
	-- initialy called from function update_a_local_setting (below) to avoid multilines value

	local num = 0
	local in_text = false
	local txt_marker = ""
	local a_char = ""

	for i = 1, #a_string do
		a_char = string.sub(a_string, i, i)
		if not in_txt then
			if a_char=="'" or a_char=='"' then
				txt_marker = a_char
				in_text = true
			elseif a_char=="[" and string.sub(a_string, i+1, i+1)=="[" then
				txt_marker = "[["
				in_text = true
			end
		else -- we are in text : detect end-of-text marker :
			if a_char==txt_marker and string.sub(a_string, i-1, i-1)~="\\" then
				txt_marker = ""
				in_text = false
			end
			if a_char=="]" and txt_marker=="[[" and string.sub(a_string, i+1, i+1)=="]" then
				txt_marker = ""
				in_text = false
			end
		end
		if not in_text then
			if a_char=="{" then num = num+1 end
			if a_char=="}" then num = num-1 end
		end
	end
	return (num~=0)
end

function string_is_a_text_unclosed(a_string)
	-- return true if a_string contain a not closed string like a_string=" 'something'.. ending with concatenation symbol
	if string.sub(a_string, -2, -1)==".." then return true end
	return false
end

function update_a_local_setting(mode, setting, value)
--[[ this function update an existing setting in 
		<worldpath>/mycustom_local_settings.lua if mode=="local"
		<modpath>/mycustom_default_settings.lua if mode=="default"
	we may have to update a default setting when that setting is not present in local file, even if it will be overwriten by later release.

	 the first use is to update the setting 'subnodes_made' when a call to a_mode_register(a_node) reveal that 
	 the amount of new shaped nodes is different from the corresponding setting 'subnodes_made' 

	 setting is a table of settings's hierarchical nodes to follow to find the value to update, like
	 setting = {[1]="shapers", [2]="pkarcs", [3]="subnodes_made"}
	 meaning we have to update the value of
	 local_settings["shaper"]["pkarcs"]["subnodes_made"]

]]
	-- check if valid parameters received :
	if type(setting)~="table" then return end
	if value==nil then return end
	if count(setting)==0 then return end

	local src, dst, case_path
	if mode=="default" then 
		src = minetest.get_modpath("mycustom").."/mycustom_default_settings.lua"
		dst = minetest.get_modpath("mycustom").."/mycustom_default_settings_before_update.lua"
		case_path = "<mod_path>"
	else  
		src = minetest.get_worldpath().."/mycustom_local_settings.lua"
		dst = minetest.get_worldpath().."/mycustom_local_settings_before_update.lua"
		case_path = "<world_path>"
	end

	local ok, err = copy_file(src, dst)
	
	local nb_nodes = count(setting) 	-- the number of parent-nodes to find in the file; the last is the node to update
	local cur_node = 1					-- the currently node to find
	local i 					-- index
	local found = 0 			-- index of setting in line readen if found
	local updated = false		-- true when setting has been updated (useless to test anything else)
	local x_lines_flag = false  -- are we in a multilines comment ?
	local iz					-- index (for ]] closing x-lines comment)
	local string_of_value = ""  -- the string extracted from line where value must be found
	local index_of_equal		-- index of "=" find in line as separator between the setting name and the value affected to
	local str = "" 				-- a working string

	str = src 					--
	src = dst 					-- swap src and dst 
	dst = str 					-- 

	local file_src, err_src = io.open(src, "r")
	local file_dst, err_dst = io.open(dst, "w")

	for line in file_src:lines() do
		if updated then goto read_next_line_to_update end  		-- we have already updated the setting. just transfert the end of file.

		if x_lines_flag then 									-- detect if end of x-lines comment found :
			 iz = string.find(line, "]]") or 0
			 if iz>0 then  											-- find end of x-lines comment :
			 	file_dst:write(string.sub(line, 1, iz+1)) 			-- write the "x-line comment" part of line;
			 	line = string.sub(line, iz+2) 						-- keep the end of line to analyse;
			 	x_lines_flag = false
			 else
			 	goto read_next_line_to_update 						-- not found: all the line is x-line comment: dont parse, go next.
			 end
		end

		i = find_comment(line, "%-%-") 	-- i is the index in line where find a true comment marker (not included in "" or '' or [[ ]] ) 
										-- if no true comment found, i receive the length of line;

		found = string.find(string.sub(line,1,i-1), setting[cur_node]) or 0	
		if string.sub(line, i+2, i+3)=="[[" then x_lines_flag = true end -- a x-lins comment begin
		if found>0 then  				-- the setting[cur_node] is found :

			if cur_node<nb_nodes then 	--  find the next :
				cur_node = cur_node+1
				goto read_next_line_to_update
			end

			-- the setting[cur_node] is the one we want to update : extract the string which is the value :
			-- in the part of string out of comments, get the right side of symbol "="
			index_of_equal = string.find( string.sub(line,1,i-1), "=", found+string.len(setting[cur_node]) )
			if index_of_equal==nil then goto read_next_line_to_update end -- this was not the good line to update : no symbol = found

			string_of_value = string.sub( string.sub(line,1,i-1), index_of_equal+1 ) -- the rigth part of '=' symbol
			while string.sub(string_of_value,1,1)==" " do string_of_value=string.sub(string_of_value, 2) end
			while string.sub(string_of_value,-1,-1)==" " do string_of_value=string.sub(string_of_value,1,-2) end

			-- is there a marker that say the value is written on several lines ?
			if string_is_a_table_unclosed(string_of_value) or 
			   string_is_a_text_unclosed(string_of_value) then
				str = "local_settings = { "
				for j,s in ipairs(setting) do
					str = str..tostring(s).." = { "
				end
				str = string.sub(str, 1, -5)
				log(4, "WARNING : the function update_a_local_setting() is called to update the setting "..
					setting[cur_node].." which is find in the line :\n"..line.."\n"..
					"But the value seems to be writen on several lines in the file mycustom_"..mode.."_settings.lua :\n"..
					"That case is not taken in account at this time, so the update will not set the new value.\n"..
					"You are requested to update by yourself :\n"..
					"in the file "..case_path.."/mycustom_"..mode.."_settings.lua, the node \n"..
					str.." with the expected value to be :\n")
				if type(value)=="table" then
					str = dump(value)
				else
					str = tostring(value)
				end
				log(4, str)
				updated = true
				goto read_next_line_to_update
			end
			if 		type(value)=="string" then string_of_value = " \""..value.."\", "
			elseif 	type(value)=="table"  then string_of_value = " "..dump(value)..", " 
			else 	string_of_value = " "..tostring(value)..", " end

			-- rebuild the line to write in dst file :
			str = string.sub(line, 1, index_of_equal).. 		-- the left part of = (setting name) including '='
					string_of_value 							-- the rigth part of = (setting value)
			if i<#line then 
				str = str.." "..string.sub(line, i) 			-- the end of line (eventual comments)
			end
			line = str
			updated = true
		end

		::read_next_line_to_update::
		file_dst:write(line.."\n")						
	end

	::end_of_update_a_local_setting::
	file_src:close()
	file_dst:close()
	os.remove(src)
end
