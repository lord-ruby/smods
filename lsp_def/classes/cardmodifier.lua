---@meta

---@class SMODS.CardModifier: SMODS.GameObject
---@field obj_buffer? CardModifiers|string[] Array of keys to all objects registered to this class. 
---@field obj_table? table<CardModifiers|string, SMODS.CardModifier|table> Table of objects registered to this class. 
---@field super? SMODS.GameObject|table Parent class. 
---@field atlas? string Key to the center's atlas. 
---@field pos? table|{x: integer, y: integer} Position of the center's sprite. 
---@field order? number Position of the modifier in collections menu. 
---@field rate? number Chance of this modifier applying onto an eligible card. 
---@field hide_badge? boolean Sets if the modifier badge shows up on the card. 
---@field text_colour? table Colour of the label for the badge.
---@field badge_colour? table HEX color the modifier badge uses. 
---@field default_compat? boolean Default compatibility with cards. 
---@field compat_exceptions? string[] Array of keys to centers that are exceptions to `default_compat`. 
---@field sets? string[] Array of keys to pools that this modifier is allowed to be naturally applied on. 
---@field needs_enable_flag? boolean Sets whether the modifier requires `G.GAME.modifiers["enable_"..key]` to be `true` before it can be applied naturally. 
---@field modifier_sprite? Sprite|table Sprite object of the modifier. 
---@field __call? fun(self: SMODS.CardModifier|table, o: SMODS.CardModifier|table): nil|table|SMODS.CardModifier
---@field extend? fun(self: SMODS.CardModifier|table, o: SMODS.CardModifier|table): table Primary method of creating a class. 
---@field check_duplicate_register? fun(self: SMODS.CardModifier|table): boolean? Ensures objects already registered will not register. 
---@field check_duplicate_key? fun(self: SMODS.CardModifier|table): boolean? Ensures objects with duplicate keys will not register. Checked on `__call` but not `take_ownership`. For take_ownership, the key must exist. 
---@field register? fun(self: SMODS.CardModifier|table) Registers the object. 
---@field check_dependencies? fun(self: SMODS.CardModifier|table): boolean? Returns `true` if there's no failed dependencies. 
---@field process_loc_text? fun(self: SMODS.CardModifier|table) Called during `inject_class`. Handles injecting loc_text. 
---@field send_to_subclasses? fun(self: SMODS.CardModifier|table, func: string, ...: any) Starting from this class, recusively searches for functions with the given key on all subordinate classes and run all found functions with the given arguments. 
---@field pre_inject_class? fun(self: SMODS.CardModifier|table) Called before `inject_class`. Injects and manages class information before object injection. 
---@field post_inject_class? fun(self: SMODS.CardModifier|table) Called after `inject_class`. Injects and manages class information after object injection. 
---@field inject_class? fun(self: SMODS.CardModifier|table) Injects all direct instances of class objects by calling `obj:inject` and `obj:process_loc_text`. Also injects anything necessary for the class itself. Only called if class has defined both `obj_table` and `obj_buffer`. 
---@field inject? fun(self: SMODS.CardModifier|table, i?: number) Called during `inject_class`. Injects the object into the game. 
---@field take_ownership? fun(self: SMODS.CardModifier|table, key: string, obj: SMODS.CardModifier|table, silent?: boolean): nil|table|SMODS.CardModifier Takes control of vanilla objects. Child class must have get_obj for this to function
---@field get_obj? fun(self: SMODS.CardModifier|table, key: string): SMODS.CardModifier|table? Returns an object if one matches the `key`. 
---@field loc_vars? fun(self: SMODS.CardModifier|table, info_queue: table, card: Card|table): table? Provides control over displaying descriptions and tooltips of the modifier's tooltip. See [SMODS.CardModifier `loc_vars` implementation](https://github.com/Steamodded/smods/wiki/SMODS.CardModifier#api-methods) documentation for details. 
---@field calculate? fun(self: SMODS.CardModifier|table, card: Card|table, context: CalcContext|table): table?, boolean?  Calculates effects based on parameters in `context`. See [SMODS calculation](https://github.com/Steamodded/smods/wiki/calculate_functions) docs for details. 
---@field should_apply? boolean|fun(self: SMODS.CardModifier|table, card: Card, center: table, area: CardArea, bypass_roll?: boolean): boolean Determines if the modifier naturally applies onto the card. If `bypass_roll` is true, ignore RNG check. 
---@field apply? fun(self: SMODS.CardModifier|table, card: Card|table, val: any) Handles applying and removing the modifier. By default, sets `card.ability[self.key] = val`. 
---@field draw? fun(self: SMODS.CardModifier|table, card: Card|table, layer: string) Draws the sprite and shader of the modifier. 
---@overload fun(self: SMODS.CardModifier): SMODS.CardModifier
SMODS.CardModifier = setmetatable({}, {
    __call = function(self)
        return self
    end
})

---@type table<modifiers|string, SMODS.CardModifier|table>
SMODS.CardModifiers = {}

---@param self Card|table
---@param modifier modifiers|string Key to the modifier to apply. 
---@param bypass_check? boolean Whether the modifier's `should_apply` function is called. 
--- Adds the modifier onto the card. 
function Card:add_modifier(modifier, bypass_check) end

---@param self Card|table
---@param modifier modifiers|string Key to the modifier to remove. 
--- Removes the modifier from the card, if it has the modifier. 
function Card:remove_modifier(modifier) end

---@param self Card|table
---@param key string
---@return table?
--- Calculates modifiers on cards. 
function Card:calculate_modifier(context, key) end
