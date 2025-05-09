-- region Cornerjump

local cornerjump = {
	name = "ccc_Cornerjump",
	key = "cornerjump",
	config = {extra = {chips = 90}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 8, y = 6},
	rarity = 1,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Fytos"
	},
    description = "+90 Chips if played hand contains an Ace and either a King or 2"
}

cornerjump.calculate = function(self, card, context)
	if context.joker_main then
		local ace_con = false
		local tk_con = false
		for i = 1, #context.full_hand do
	         	if context.full_hand[i]:get_id() == 14 then ace_con = true end
			if context.full_hand[i]:get_id() == 2 or context.full_hand[i]:get_id() == 13 then tk_con = true end
		end
		if ace_con and tk_con then
			return {
				message = localize {
					type = 'variable',
					key = 'a_chips',
					vars = { card.ability.extra.chips }
				},
				chip_mod = card.ability.extra.chips
			}
		end
	end
end

function cornerjump.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end

return cornerjump
-- endregion Cornerjump