# minetest
mods for minetest
Mycustom :
----------
    add some missing recipes like : craft darkage:chalk from it's powder, default:savana_dirt_with_dry_grass etc ;
                                  : cook cobble_condensed into 81 default:stone, grass into dry_grass, etc ;
    CAN link the nodes you want to 'shaper' mods like arcs, facade, circular_saw, cnc_machine, etc :
          For example, register darkage:chalk into pkarcs mod;
          register default:meselamp into technic_cnc;
          etc.
       The most powerfull : new shaped nodes keep all the abilities from their parents, like light source :
       a lot of shaping mods lost some fields from the original node but mycustom recover them after the mod done it's work.
    
    All is customizable, by the way of switches turnable in 'true' or 'false', individually or by branch;
    The settings made locally to a server by an admin remain valid while installing a new release : local settings are saved into worldpath
    A special log file 'mycustom_log.txt' is recreated each start in worldpath, with customizable level of details
