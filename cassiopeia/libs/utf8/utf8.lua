-- PUT4 MERDA
function utf8_sub(s, i, j)
    j = j or -1
    local len = #s
    local byteStart, byteEnd = 1, len
    local curCharIndex, curByteIndex = 1, 1

    -- Ajusta índices negativos
    if i < 0 then i = len + i + 1 end
    if j < 0 then j = len + j + 1 end

    -- Localiza o byte de início e fim com base no índice de caracteres
    while curByteIndex <= len do
        if curCharIndex == i then
            byteStart = curByteIndex
        end
        if curCharIndex == j + 1 then
            byteEnd = curByteIndex - 1
            break
        end

        local byte = string.byte(s, curByteIndex)
        if byte >= 0xF0 then
            curByteIndex = curByteIndex + 4
        elseif byte >= 0xE0 then
            curByteIndex = curByteIndex + 3
        elseif byte >= 0xC0 then
            curByteIndex = curByteIndex + 2
        else
            curByteIndex = curByteIndex + 1
        end

        curCharIndex = curCharIndex + 1
    end

    byteEnd = byteEnd or len
    return string.sub(s, byteStart, byteEnd)
end