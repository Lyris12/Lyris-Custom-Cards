--Flame Flight - Strix
function c101020072.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101020072.ffilter1,c101020072.ffilter2,true)
	--Must first be Fusion Summoned.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--If this card attacks a Defense Position monster, inflict piercing battle damage to your opponent.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--If this card is destroyed by a card effect and sent to the Graveyard: You can target 2 of your banished "Flame Flight" monsters; add them to your hand. You can only use this effect of "Flame Flight - Strix" once per turn.
	--If this card was Fusion Summoned with "Flame Fusion", it gains this effect; Once per turn, during either player's turn: You can banish 1 "Flame Flight" monster from your Graveyard, then target 1 face-up monster your opponent controls; change it to face-down Defense Position, and if you do, this card gains 500 ATK, until the end of this turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e1:SetCondition(c101020072.con)
	e1:SetCost(c101020072.cost)
	e1:SetTarget(c101020072.target)
	e1:SetOperation(c101020072.activate)
	c:RegisterEffect(e1)
end
function c101020072.ffilter1(c)
	return c:IsAttribute(ATTRIBUTE_WIND) or (c:IsHasEffect(101010012) and not c:IsLocation(LOCATION_DECK))
end
function c101020072.ffilter2(c)
	return c:IsRace(RACE_WINDBEAST) or (c:IsHasEffect(101010085) and not c:IsLocation(LOCATION_DECK))
end
function c101020072.con(e)
	return e:GetHandler():IsHasEffect(101010055)
end
function c101020072.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa88) and c:IsAbleToRemoveAsCost()
end
function c101020072.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020072.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101020072.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101020072.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c101020072.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101020072.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101020072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101020072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c101020072.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end
