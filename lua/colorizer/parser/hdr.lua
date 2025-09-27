---Helper function to parse argb
local bit = require "bit"
local floor, min = math.floor, math.min
local band, rshift, lshift = bit.band, bit.rshift, bit.lshift

local utils = require "colorizer.utils"
local byte_is_alphanumeric = utils.byte_is_alphanumeric
local byte_is_hex = utils.byte_is_hex
local parse_hex = utils.parse_hex

local parser = {}

---parse for #rrggbbaa and return rgb hex.
-- a format used in android apps
---@param line string: line to parse
---@param i number: index of line from where to start parsing
---@param opts table: Containing minlen, maxlen, valid_lengths
---@return number|nil: index of line where the hex value ended
---@return string|nil: rgb hex value
function parser.hdr_parser(line, i, opts)
  local minlen = 6
  if #line < i + minlen - 1 then
    return
  end

  local pattern =
    ".%(%s*([%+%-]?%d*%.?%d+)%s*,%s*([%+%-]?%d*%.?%d+)%s*,%s*([%+%-]?%d*%.?%d+)%s*,%s*([%+%-]?%d*%.?%d+)%s*%)"
  local subline = line:sub(i)
  local s, e, a, b, c, d = subline:find(pattern)
  if s then
    local max = math.max(a, b, c, d)
    a = 255 * a / max
    b = 255 * b / max
    c = 255 * c / max
    d = 255 * d / max

    local rgb_hex = string.format("%02x%02x%02x", a, b, c)
    return e, rgb_hex
  end
end

return parser.hdr_parser
