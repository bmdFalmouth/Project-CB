--from https://devforum.play.date/t/a-list-of-helpful-libraries-and-code/221/18
function math.clamp(a, min, max)
    if min > max then
        min, max = max, min
    end
    return math.max(min, math.min(max, a))
end