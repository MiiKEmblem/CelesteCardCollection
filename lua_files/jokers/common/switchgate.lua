-- region Switch Gate

local switchgate = {
	name = "ccc_Switch Gate",
	key = "switchgate",
	config = { extra = { chips = 0, chips_scale = 8, cards = { [1] = { rank = 'Ace', suit = 'Spades', id = 14 }, [2] = { rank = 'Ace', suit = 'Hearts', id = 14 }, [3] = { rank = 'Ace', suit = 'Clubs', id = 14 } } } },
	pos = { x = 4, y = 3 },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	},
    description = "Gains +8 Chips if any of 3 randomly chosen cards in deck are scored. Cards change every round"
}

switchgate.set_ability = function(self, card, initial, delay_sprites) -- shamelessly copied from idol
	local valid_gate_cards = {}
	if G.playing_cards ~= nil then
		for k, v in ipairs(G.playing_cards) do
			if v.ability.effect ~= 'Stone Card' then
				valid_gate_cards[#valid_gate_cards + 1] = v
			end
		end
		if valid_gate_cards[1] then
			for i = 1, 3 do
				local gate_card = pseudorandom_element(valid_gate_cards,
					pseudoseed('switchgate' .. G.GAME.round_resets.ante))
				card.ability.extra.cards[i].rank = gate_card.base.value
				card.ability.extra.cards[i].suit = gate_card.base.suit
				card.ability.extra.cards[i].id = gate_card.base.id
			end
		end
	end
end

-- this may work. but it may also break. i hope it doesn't but i won't be surprised if it does

switchgate.calculate = function(self, card, context)
	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		local valid_gate_cards = {}
		for k, v in ipairs(G.playing_cards) do
			if v.ability.effect ~= 'Stone Card' then
				valid_gate_cards[#valid_gate_cards + 1] = v
			end
		end
		if valid_gate_cards[1] then
			for i = 1, 3 do
				local gate_card = pseudorandom_element(valid_gate_cards,
					pseudoseed('switchgate' .. G.GAME.round_resets.ante))
				card.ability.extra.cards[i].rank = gate_card.base.value
				card.ability.extra.cards[i].suit = gate_card.base.suit
				card.ability.extra.cards[i].id = gate_card.base.id
			end
		end
	end

	if context.individual and not context.blueprint then
		if context.cardarea == G.play then
			local count = 0
			for i = 1, 3 do
				if context.other_card:get_id() == card.ability.extra.cards[i].id and context.other_card:is_suit(card.ability.extra.cards[i].suit) then
					count = count + 1
				end
			end
			if count > 0 then
				card.ability.extra.chips = card.ability.extra.chips + (card.ability.extra.chips_scale * count)
				return {
					extra = { focus = card, message = localize('k_upgrade_ex') },
					colour = G.C.CHIPS, -- why doesn't this work???????? it's fine but it should really be chip coloured
					card = card
				}
			end
		end
	end

	if context.joker_main then
		if card.ability.extra.chips ~= 0 then
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

function switchgate.loc_vars(self, info_queue, card) -- what a mess
	return {
		vars = {
			card.ability.extra.chips,
			localize(card.ability.extra.cards[1].rank, 'ranks'),
			localize(card.ability.extra.cards[1].suit, 'suits_plural'),
			localize(card.ability.extra.cards[2].rank, 'ranks'),
			localize(card.ability.extra.cards[2].suit, 'suits_plural'),
			localize(card.ability.extra.cards[3].rank, 'ranks'),
			localize(card.ability.extra.cards[3].suit, 'suits_plural'),
			card.ability.extra.chips_scale,
			colours = {
				G.C.SUITS[card.ability.extra.cards[1].suit],
				G.C.SUITS[card.ability.extra.cards[2].suit],
				G.C.SUITS[card.ability.extra.cards[3].suit]
			}
		}
	}
end

return switchgate
-- endregion Switch Gate