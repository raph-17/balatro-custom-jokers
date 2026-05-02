return {
    descriptions = {
        Joker = {
            j_raph_polycythemia = {
                name = "Polycythemia Vera",
                text = {
                    "{C:mult}+#3#{} Mult for each card",
                    "with {C:hearts}Heart{} suit above",
                    "{C:attention}#2#{} in your full deck",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
                }
            },

            j_raph_revolution = {
                name = "Revolution!",
                text = {
                    "{X:mult,C:white} X#1# {} Mult if there are",
                    "not {C:attention}Kings{} or {C:attention}Queens{}",
                    "in your full deck",
                    "{C:inactive}(Currently {C:attention}#2#{}{C:inactive})"
                }
            },

            j_raph_wish_you_were_here = {
                name = "Wish You Were Here",
                text = {
                    "Copies the ability of the",
                    "last joker sold",
                    "in this run",
                    "{C:inactive}(Copying: {C:attention}#1#{}{C:inactive})",
                    "{C:green}Does not occupy Joker slot{}"
                }
            }
        }
    },

    misc = {
        dictionary = {
            revolution_active = "Active!",
            wish_none = "None"
        }
    }
}
