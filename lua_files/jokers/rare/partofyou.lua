-- region Part Of You

local partofyou = {
	name = "ccc_Part Of You",
	key = "partofyou",
	config = {},
	pos = { x = 3, y = 0 },
	rarity = 3,
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "Fytos"
	},
    description = "If first hand of round contains exactly 2 cards, convert their ranks into their complements"
}

partofyou.calculate = function(self, card, context)
	if context.before and not context.blueprint then
		if G.GAME.current_round.hands_played == 0 and #context.full_hand == 2 then
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.75, func = function()
				context.full_hand[1]:flip(); play_sound('card1', 1, 0.6); context.full_hand[1]:juice_up(0.3, 0.3); return true
			end }))
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
				context.full_hand[2]:flip(); play_sound('card1', 1, 0.6); context.full_hand[2]:juice_up(0.3, 0.3); return true
			end }))
			for i = 1, 2 do
				local suit = string.sub(context.full_hand[i].config.card.suit, 1, 1) .. "_"
				local _table = { "", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2", "A", "K" }
				local rank = _table[context.full_hand[i]:get_id()]
				G.P_CARDS[suit .. rank].delay_change = {
					suit = context.full_hand[i].config.card.suit,
					value = context.full_hand[i].config.card.value,
					pos = copy_table(context.full_hand[i].config.card.pos),
				}
				context.full_hand[i]:set_base(G.P_CARDS[suit .. rank])

				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.15,
					func = function()
						G.P_CARDS[suit .. rank].delay_change = nil -- this is blasphemous but it shouldn't break anything????????
						context.full_hand[i]:set_base(G.P_CARDS[suit .. rank])
						context.full_hand[i]:set_edition({ ccc_mirrored = true }, true, true)
						return true
					end
				}))
			end
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.75, func = function()
				context.full_hand[1]:flip(); play_sound('tarot2', 1, 0.6); context.full_hand[1]:juice_up(0.3, 0.3); return true
			end }))
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
				context.full_hand[2]:flip(); play_sound('tarot2', 1, 0.6); context.full_hand[2]:juice_up(0.3, 0.3); return true
			end }))
			delay(0.4)
			return nil, true
		end
	end
end

function partofyou.loc_vars(self, info_queue, card)
	info_queue[#info_queue + 1] = { key = 'partofyou_complements', set = 'Other' }
	info_queue[#info_queue + 1] = { key = 'e_mirrored', set = 'Other' }
end

-- scuffed

local gfsiref = get_front_spriteinfo
function get_front_spriteinfo(_front)
	if _front and _front.delay_change then
		return gfsiref(_front.delay_change)
	else
		return gfsiref(_front)
	end
end

return partofyou
-- endregion Part Of You