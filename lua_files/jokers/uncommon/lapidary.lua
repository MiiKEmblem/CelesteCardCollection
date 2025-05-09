-- region Lapidary

local lapidary = {
	name = "ccc_Lapidary",
	key = "lapidary",
	config = { extra = 1.75 },
	pos = { x = 6, y = 3 },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	},
    description = "Jokers with a unique rarity each give X1.75 Mult"
}

lapidary.calculate = function(self, card, context)
	if context.other_joker and not context.other_consumable then -- ?????
		local uniqueRarity = true
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] ~= context.other_joker and G.jokers.cards[i].config.center.rarity == context.other_joker.config.center.rarity then
				uniqueRarity = false
				break
			end
		end

		if uniqueRarity then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			}))
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra } },
				Xmult_mod = card.ability.extra
			}
		end
	end
end

function lapidary.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra } }
end

return lapidary
-- endregion lapidary