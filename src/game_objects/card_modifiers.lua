SMODS.CardModifiers = {}
SMODS.CardModifier = SMODS.GameObject:extend {
    obj_table = SMODS.CardModifier,
    obj_buffer = {},
    set = 'Modifier',
    required_params = {
        'key',
    },
    rate = 0,
    atlas = 'stickers',
    pos = { x = 0, y = 0 },
    badge_colour = HEX 'FFFFFF',
    default_compat = true,
    compat_exceptions = {},
    sets = { Joker = true },
    needs_enable_flag = true,
    process_loc_text = function(self)
        G.localization.descriptions[self.set] = G.localization.descriptions[self.set] or {}
        SMODS.process_loc_text(G.localization.descriptions[self.set], self.key, self.loc_txt)
        SMODS.process_loc_text(G.localization.misc.labels, self.key, self.loc_txt, 'label')
    end,
    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end
        SMODS.CardModifier.super.register(self)
        self.order = #self.obj_buffer
    end,
    inject = function(self)
        self.modifier_sprite = SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, self.atlas, self.pos)
        G.shared_stickers[self.key] = self.modifier_sprite
        G.P_CENTER_POOLS[self.set] = G.P_CENTER_POOLS[self.set] or {}
        SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
        G.P_MODIFIERS = G.P_MODIFIERS or {}
        G.P_MODIFIERS[self.key] = self
    end,
    should_apply = function(self, card, center, area, bypass_roll)
        if
            ( not self.sets or self.sets[center.set or {}]) and
            (
                center[self.key..'_compat'] or -- explicit marker
                (
                    center[self.key..'_compat'] == nil and
                    ((self.default_compat and not self.compat_exceptions[center.key]) or -- default yes with no exception
                    (not self.default_compat and self.compat_exceptions[center.key]))
                ) -- default no with exception
            ) and
            (not self.needs_enable_flag or G.GAME.modifiers['enable_'..self.key])
        then
            self.last_roll = pseudorandom((area == G.pack_cards and 'packssj' or 'shopssj')..self.key..G.GAME.round_resets.ante)
            return (bypass_roll ~= nil) and bypass_roll or self.last_roll > (1-self.rate)
        end
    end,
    apply = function(self, card, val)
        if not val and card.ability[self.key] and type(card.ability[self.key]) == 'table' then
            if card.ability[self.key].card_limit then card.ability.card_limit = card.ability.card_limit - card.ability[self.key].card_limit end
            if card.ability[self.key].extra_slots_used then card.ability.extra_slots_used = card.ability.extra_slots_used - card.ability[self.key].extra_slots_used end
        end
        card.ability[self.key] = val
        if val and self.config and next(self.config) then
            card.ability[self.key] = {}
            for k, v in pairs(self.config) do
                if type(v) == 'table' then
                    card.ability[self.key][k] = copy_table(v)
                else
                    card.ability[self.key][k] = v
                    if k == 'card_limit' or k == 'extra_slots_used' then
                        card.ability[k] = (card.ability[k] or 0) + v
                    end
                end
            end
        end
    end
}

function Card:calculate_modifier(context, key)
    local mod = G.P_MODIFIERS[key]
    if self.ability[key] and type(mod.calculate) == 'function' then
        local o = mod:calculate(self, context)
        if o then
            if not o.card then o.card = self end
            return o
        end
    end
end

function Card:add_modifier(modifier, bypass_check)
    local modifier = G.P_MODIFIERS[modifier]
    if bypass_check or (modifier and modifier.should_apply and type(modifier.should_apply) == 'function' and modifier:should_apply(self, self.config.center, self.area, true)) then
        modifier:apply(self, true)
        SMODS.enh_cache:write(self, nil)
    end
end

function Card:remove_modifier(modifier)
    if self.ability[modifier] then
        G.P_MODIFIERS[modifier]:apply(self, false)
        SMODS.enh_cache:write(self, nil)
    end
end
