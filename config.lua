Config = {}

Config.GiveMoney = true
-- Max of 10 cents can be looted by default 
Config.MaxPayRoll = 10 -- WHOLE NUMBER
Config.PayDevider = 100 -- Roll / PayDevider = $ payout

Config.GiveItems = true
Config.Redemrp_Inventory2 = false
Config.ItemPayout = {
    ['2percent'] = { -- 2 percent chance loot 1 of these items
        {item = 'tonic', amount = 1},
        {item = 'stew', amount = 2},
        {item = 'pocket_watch', amount = 1},
    },
    ['6percent'] = { -- 6 percent chance loot 1 of these items
        {item = 'apple', amount = 1},
        {item = 'wheat', amount = 3},
        {item = 'wood', amount = 2},
        {item = 'pistol_ammo', amount = 1},
    },
    ['10percent'] = { -- 10 percent chance loot 1 of these items
        {item = 'cigar', amount = 1},
        {item = 'bread', amount = 2},
    }
}