-- 1. Atlas
SMODS.Atlas {
    key = 'policitemia_vera',
    path = 'policitemia.png',
    px = 71,
    py = 95
}

-- 2. Jokers

-- ========================
-- === POLICITEMIA VERA ===
-- ========================
SMODS.Joker {
    key = 'policitemia',
    config = { extra = { mult_gain = 6, threshold = 13 } },

    -- === ATRIBUTOS ===
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,

    -- === GRÁFICOS ===
    atlas = 'policitemia_vera',
    pos = { x = 0, y = 0 },

    -- === LÓGICA ===
    loc_vars = function(self, info_queue, card)

        print("MI ID REAL ES: " .. card.config.center.key)

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
        return { vars = { card.ability.extra.mult_gain, current_threshold, bonus } }
    end,

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

            if bonus > 0 then
                return {
                    message = "Policitemia!",
                    mult_mod = bonus,
                    colour = G.C.MULT
                }
            end
        end
    end
}
