-- region Bunny Hop

local bunnyhop = {
	name = "ccc_Bunny Hop",
	key = "bunnyhop",
	config = {extra = {chips = 1}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 9, y = 6},
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Aurora Aquir"
	},
    description = "Permanently give +1 Chip to all cards held in hand after discarding"
}

bunnyhop.calculate = function(self, card, context)
	if context.discard then
		for i = 1, #G.hand.cards do
			local discarded = false
			for j = 1, #G.hand.highlighted do
				if G.hand.cards[i] == G.hand.highlighted[j] then discarded = true break end
			end
			if not discarded then
				G.hand.cards[i].perma_bonus = G.hand.cards[i].ability.perma_bonus or 0
				G.hand.cards[i].ability.perma_bonus = G.hand.cards[i].ability.perma_bonus + card.ability.extra.chips
			end
		end
		return {
			delay = 0.2,
			message = localize('k_upgrade_ex'),
			card = card,
			colour = G.C.CHIPS
                }
	end
end

function bunnyhop.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end

return bunnyhop
-- endregion Bunny Hop