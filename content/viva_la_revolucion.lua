-- ==========================
-- === VIVA LA REVOLUCION ===
-- ==========================

-- Atlas
SMODS.Atlas {
    key = 'viva_la_revolucion',
    path = 'placeholder.png',
    px = 71,
    py = 95
}

-- Joker
SMODS.Joker {
    key = 'revolucion',
    config = { extra = { Xmult = 5 } },

    -- == ATRIBUTOS ==
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,

    -- === VISUAL ===
    atlas = 'viva_la_revolucion',
    pos = { x = 0, y = 0 },

    -- === LOGICA ===
    loc_vars = function(self, info_queue, card)
        -- Contar reyes y reinas totales en la baraja completa
        local monarchy_count = 0
        if G.playing_cards then
            for _, v in ipairs(G.playing_cards) do
                if v:get_id() == 12 or v:get_id() == 13 then
                    monarchy_count = monarchy_count + 1
                end
            end
        end

        -- Si es 0 mostrar "¡Activo!", sino el conteo
        local status_text = (monarchy_count == 0) and localize('revolucion_active') or monarchy_count

        return { vars = { card.ability.extra.Xmult, status_text } }
    end,

    -- === CALCULO EN JUEGO ===
    calculate = function(self, card, context)
        if context.joker_main then
            local monarchy_count = 0
            -- Contar reyes y reinas totales en la baraja completa
            for _, v in ipairs(G.playing_cards) do
                if v:get_id() == 12 or v:get_id() == 13 then
                    monarchy_count = monarchy_count + 1
                end
            end
            -- Activar habilidad si cumple la condicion
            if monarchy_count == 0 then
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                    Xmult_mod = card.ability.extra.Xmult,
                    colour = G.C.MULT
                }
            end
        end
    end
}
