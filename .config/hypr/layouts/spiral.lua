local state = {
    ratio = 0.58,
    portrait_ratio = 0.62,
    offset = 0,
}

local sides = { "left", "top", "right", "bottom" }
local opposite = { left = "right", right = "left", top = "bottom", bottom = "top" }

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function portrait(area)
    return area.h > area.w
end

local function place_portrait(ctx)
    local area, count = ctx.area, #ctx.targets
    if count == 1 then
        ctx.targets[1]:place(area)
        return
    end

    local main = ctx:split(area, "top", state.portrait_ratio)
    local stack = ctx:split(area, "bottom", 1.0 - state.portrait_ratio)
    ctx.targets[1]:place(main)

    for index = 2, count do
        local remaining = count - index + 1
        if remaining == 1 then
            ctx.targets[index]:place(stack)
        else
            local row = 1.0 / remaining
            ctx.targets[index]:place(ctx:split(stack, "top", row))
            stack = ctx:split(stack, "bottom", 1.0 - row)
        end
    end
end

hl.layout.register("spiral", {
    recalculate = function(ctx)
        local count = #ctx.targets
        if count == 0 then return end
        if portrait(ctx.area) then
            place_portrait(ctx)
            return
        end

        local area = ctx.area
        for index, target in ipairs(ctx.targets) do
            if index == count then
                target:place(area)
            else
                local side = sides[((index - 1 + state.offset) % #sides) + 1]
                target:place(ctx:split(area, side, state.ratio))
                area = ctx:split(area, opposite[side], 1.0 - state.ratio)
            end
        end
    end,

    layout_msg = function(ctx, message)
        local command, argument = message:match("^(%S+)%s*(.*)$")
        local key = portrait(ctx.area) and "portrait_ratio" or "ratio"
        if command == "ratio" then
            state[key] = clamp(tonumber(argument) or state[key], 0.1, 0.9)
        elseif command == "grow" then
            state[key] = clamp(state[key] + 0.05, 0.1, 0.9)
        elseif command == "shrink" then
            state[key] = clamp(state[key] - 0.05, 0.1, 0.9)
        elseif command == "rotate" and not portrait(ctx.area) then
            state.offset = (state.offset + 1) % #sides
        elseif command ~= "rotate" then
            return "spiral: expected ratio <0.1..0.9>, grow, shrink, or rotate"
        end
        return true
    end,
})
