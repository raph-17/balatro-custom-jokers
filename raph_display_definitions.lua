-- ========================================
-- === DESCRIPCIONES PARA JOKER DISPLAY ===
-- ========================================

local jd_def = JokerDisplay.Definitions

-- 1. Policitemia Vera
jd_def["j_raph_polycythemia"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        -- Contar corazones segun baraja seleccionada
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
        card.joker_display_values.mult = bonus
    end
}

-- 2. ¡Viva la Revolución!
jd_def["j_raph_revolution"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    text_config = { colour = G.C.WHITE },

    reminder_text = {
        { text = "(",                              colour = G.C.UI.TEXT_INACTIVE },
        { ref_table = "card.joker_display_values", ref_value = "forbidden_count" },
        { text = "/0",                             colour = G.C.UI.TEXT_INACTIVE },
        { text = ")",                              colour = G.C.UI.TEXT_INACTIVE },
    },

    calc_function = function(card)
        local monarchy = 0
        if G.playing_cards then
            for _, v in ipairs(G.playing_cards) do
                local id = v:get_id()
                if id == 12 or id == 13 then
                    monarchy = monarchy + 1
                end
            end
        end

        card.joker_display_values = card.joker_display_values or {}

        card.joker_display_values.forbidden_count = monarchy

        local is_active = (monarchy == 0)
        card.joker_display_values.active = is_active

        local xmult_val = (card.ability and card.ability.extra and card.ability.extra.Xmult) or 5
        card.joker_display_values.x_mult = is_active and xmult_val or 1
    end,

    style_function = function(card, text, reminder_text, extra)
        if card.joker_display_values then
            local status_colour = card.joker_display_values.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE

            if reminder_text and reminder_text.children and reminder_text.children[2] then
                reminder_text.children[2].config.colour = status_colour
            end

            if text and text.children and text.children[1] then
                text.children[1].config.colour = G.C.XMULT
            end
        end
    end
}
