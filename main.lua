-- Cargador de Jokers
local archivos_jokers = {
    "policitemia_vera",
    "viva_la_revolucion"
}

for _, nombre_archivo in ipairs(archivos_jokers) do
    local archivo, error = SMODS.load_file("content/" .. nombre_archivo .. ".lua")

    if error then
        sendDebugMessage("ERROR cargando " .. nombre_archivo .. ": " .. error)
    else
        archivo()
    end
end

-- ================================
-- === FUNCION DE DESARROLLADOR ===
-- ================================
-- Esta funcion permite al desarrollador invocar 
-- cualquier Joker para testear nuevos Jokers o sinergias

local is_debug_typing = false
local input_buffer = ""

-- GUARDAR FUNCIONES ORIGINALES
local old_textinput = love.textinput
local old_keypressed = love.keypressed

-- CAPTURAR TEXTO
function love.textinput(t)
    if is_debug_typing then
        input_buffer = input_buffer .. t
    else
        if old_textinput then old_textinput(t) end
    end
end

-- CAPTURAR TECLAS
function love.keypressed(key)
    -- === CASO 1: ACTIVAR/DESACTIVAR CONSOLA ===
    if key == 'tab' then
        is_debug_typing = not is_debug_typing

        if is_debug_typing then
            input_buffer = ""
            G.CONTROLLER.interrupt.focus = true
            play_sound('timpani')
            sendDebugMessage("=== DEBUG: ESCRIBE EL ID ===")
        else
            G.CONTROLLER.interrupt.focus = false
            play_sound('cancel')
            sendDebugMessage("=== DEBUG CERRADO ===")
        end
        return
    end

    -- === CASO 2: ESCRIBIR EN LA CONSOLA ===
    if is_debug_typing then
        if key == 'return' or key == 'kpenter' then
            is_debug_typing = false
            G.CONTROLLER.interrupt.focus = false

            -- Construir el ID
            local full_id = input_buffer
            if string.sub(full_id, 1, 2) ~= "j_" then
                full_id = "j_" .. full_id
            end

            -- FILTRO DE SEGURIDAD
            if G.P_CENTERS[full_id] then
                -- Si el Joker existe se procede a crear
                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, full_id)
                card:add_to_deck()
                G.jokers:emplace(card)
                card:start_materialize()
                play_sound('foil1')
                sendDebugMessage(">>> INVOCADO: " .. full_id)
            else
                -- Si no existe se cancela la accion y se notifica en consola
                play_sound('cancel')
                sendDebugMessage("ERROR: El ID '" .. full_id .. "' no existe en G.P_CENTERS")
            end

            input_buffer = ""

            is_debug_typing = false
            G.CONTROLLER.interrupt.focus = false
        elseif key == 'backspace' then
            local byteoffset = utf8.offset(input_buffer, -1)
            if byteoffset then
                input_buffer = string.sub(input_buffer, 1, byteoffset - 1)
            end
        end
        return
    end

    -- === CASO 3: DEJAR QUE EL JUEGO FUNCIONE CON NORMALIDAD ===
    if old_keypressed then old_keypressed(key) end
end
