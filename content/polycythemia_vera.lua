-- ========================
-- === POLICITEMIA VERA ===
-- ========================

-- Atlas
SMODS.Atlas {
    key = 'polycythemia_vera_atlas',
    path = 'polycythemia_vera.png',
    px = 71,
    py = 95
}

-- Joker
SMODS.Joker {
    key = 'polycythemia',
    config = { extra = { mult_gain = 3, threshold = 13 } },

    -- === ATRIBUTOS ===
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,

    -- === VISUAL ===
    atlas = 'polycythemia_vera_atlas',
    pos = { x = 0, y = 0 },

    -- === CALCULO DE INFORMACION A MOSTRAR ===
    loc_vars = function(self, info_queue, card)
        -- Calcular corazones segun baraja
        local current_threshold = 13
        if G.GAME and G.GAME.selected_back then
            local back = G.GAME.selected_back
            local back_name = back.name or ""
            local back_key = (back.effect and back.effect.center and back.effect.center.key) or ""

            if back_name == 'Checkered Deck' or back_key == 'b_checkered' then
                current_threshold = 26
            elseif back_name == 'Abandoned Deck' or back_key == 'b_abandoned' then
                current_threshold = 10
            end
        end
        -- Contar corazones en juego y calcular puntaje actual del Joker
        local hearts = 0
        if G.playing_cards then
            for _, v in ipairs(G.playing_cards) do
                if v:is_suit('Hearts') then hearts = hearts + 1 end
            end
        end

        local bonus = math.max(0, hearts - current_threshold) * card.ability.extra.mult_gain
        return { vars = { bonus, current_threshold, card.ability.extra.mult_gain } }
    end,

    -- === CALCULO DURANTE ACTIVACION EN JUEGO ===
    calculate = function(self, card, context)
        if context.joker_main then
            -- Calcular corazones segun baraja
            local current_threshold = 13
            if G.GAME and G.GAME.selected_back then
                local back = G.GAME.selected_back
                local back_name = back.name or ""
                local back_key = (back.effect and back.effect.center and back.effect.center.key) or ""

                if back_name == 'Checkered Deck' or back_key == 'b_checkered' then
                    current_threshold = 26
                elseif back_name == 'Abandoned Deck' or back_key == 'b_abandoned' then
                    current_threshold = 10
                end
            end
            -- Contar corazones en juego y calcular puntaje
            local hearts = 0
            if G.playing_cards then
                for _, v in ipairs(G.playing_cards) do
                    if v:is_suit('Hearts') then hearts = hearts + 1 end
                end
            end

            local bonus = math.max(0, hearts - current_threshold) * card.ability.extra.mult_gain
            -- Adicionar puntaje
            if bonus > 0 then
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = { bonus } },
                    mult_mod = bonus,
                    colour = G.C.MULT
                }
            end
        end
    end
}
