--ファントム・ペンデュレーディ サイバー・ドラゴン・アイン
local id,ref=GIR()
function ref.start(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE+RACE_THUNDER),4,2)
	--Cannot be affected by the effect of "Pendulum Over Limit Field", or "Pendulum Space"
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetValue(ref.efilter)
	c:RegisterEffect(e10)
	--When this card is Xyz Summoned, you can Set 2 "Pendulady" monsters from your hand or Graveyard as Quick-Play Spell Cards.
	
	--While this card has a Xyz Material attached that was originally Thunder-Type, your opponent cannot target Thunder-Type monsters you control by card effects.
	
	--While this card has a Xyz Material attached that was originally Machine-Type, all Machine-Type monsters cannot be destroyed by card effects.
	
	--detach Once per turn, during either player's turn, you can detach 1 Xyz Material from this card; Special Summon 1 "Phantom Pendulady" Fusion Monster from your Extra Deck, but return it to the Extra Deck at the end of the turn.
	
end
function ref.tcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_THUNDER)
end
function ref.dcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_MACHINE)
end
function ref.efilter(e,te)
	local c=te:GetHandler()
	return c:IsCode(503) or c:IsCode(539)
end

