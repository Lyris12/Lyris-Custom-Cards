--Monument Steelshell
function c101010464.initial_effect(c)
	--Fusion Material: 2 Level 5 or lower LIGHT Machine-Type monsters
	aux.AddFusionProcFunRep(c,c101010464.ffilter,2,false)
	--Must first be Fusion Summoned with the above Fusion Materials.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--During either player's turn: You can target 1 of your banished Level 5 or lower LIGHT Machine-Type monsters; return that target to the Graveyard, then draw a number of cards equal to half of that monster's Level/Rank. If you drew 2 or more cards with this effect, you cannot Special Summon any monsters during the turn you activate this effect, except Machine-Type monsters. You can only use this effect of "Monument Steelshell" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101010464)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101010464.target)
	e2:SetOperation(c101010464.operation)
	c:RegisterEffect(e2)
end
function c101010464.ffilter(c)
	return c:IsLevelBelow(5) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end
function c101010464.filter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c101010464.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101010464.filter(chkc) and c101010464.ffilter(chkc) end
	