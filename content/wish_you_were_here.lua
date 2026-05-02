-- ==========================
-- === WISH YOU WERE HERE ===
-- ==========================

-- == FUNCION GLOBAL ==
-- Hook para rastrear la venta
if not Card.sell_hooked_for_wish then
    Card.sell_hooked_for_wish = true
    local old_sell_card = Card.sell_card
    
    function Card:sell_card()
        if self.ability.set == 'Joker' and self.config.center.key ~= 'j_raph_wish_you_were_here' then
            G.GAME.raph_wish_data = G.GAME.raph_wish_data or {}
            G.GAME.raph_wish_data.last_sold_key = self.config.center.key
            
            -- Aseguramos que guarde el estado sin crashear
            if self.ability.extra then
                if type(self.ability.extra) == 'table' then
                    G.GAME.raph_wish_data.last_sold_extra = copy_table(self.ability.extra)
                else
                    G.GAME.raph_wish_data.last_sold_extra = self.ability.extra
                end
            else
                G.GAME.raph_wish_data.last_sold_extra = nil
            end
        end
        old_sell_card(self)
    end
end

-- Atlas
SMODS.Atlas {
    key = 'wish_you_were_here_atlas',
    path = 'placeholder.png',
    px = 71,
    py = 95
}

-- Joker
SMODS.Joker {
    key = 'wish_you_were_here',
    config = {},

    -- == ATRIBUTOS ==
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,

    -- == VISUAL ==
    atlas = 'wish_you_were_here_atlas',
    pos = { x = 0, y = 0 },

    -- == CALCULO DE INFORMACION A MOSTRAR ==
    -- Mostrar el nombre del joker copiado en la descripción
    loc_vars = function(self, info_queue, card)
        local target_name = localize('wish_none')
        
        if G.GAME and G.GAME.raph_wish_data and G.GAME.raph_wish_data.last_sold_key then
            local target_key = G.GAME.raph_wish_data.last_sold_key
            
            -- Buscamos el nombre del comodín
            local loc_target = localize{type = 'name_text', key = target_key, set = 'Joker'}
            
            if loc_target and loc_target ~= "UNDEFINED" then
                target_name = loc_target
            elseif G.P_CENTERS[target_key] then
                target_name = G.P_CENTERS[target_key].name
            end
        end
        
        return { vars = { target_name } }
    end,

    -- No ocupa espacio
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - 1
    end,

    -- == CALCULO DURANTE ACTIVACION EN JUEGO ==
    calculate = function(self, card, context)
        if G.GAME and G.GAME.raph_wish_data and G.GAME.raph_wish_data.last_sold_key then
            local target_key = G.GAME.raph_wish_data.last_sold_key
            local target_center = G.P_CENTERS[target_key]

            if target_center then
                -- 1. Guardar nuestra identidad
                local my_center = card.config.center
                local my_name = card.ability.name
                local my_extra = card.ability.extra

                -- 2. Disfraz
                card.config.center = target_center
                card.ability.name = target_center.name 
                card.ability.extra = G.GAME.raph_wish_data.last_sold_extra

                -- 3. Ejecutar cálculo nativo
                local result = card:calculate_joker(context)

                -- 4. Quitarnos el disfraz
                card.config.center = my_center
                card.ability.name = my_name
                card.ability.extra = my_extra

                return result
            end
        end
    end
}