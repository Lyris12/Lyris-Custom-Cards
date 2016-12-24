--created & coded by Lyris
--Fate's Joker
function c101010251.initial_effect(c)
	--When this card is destroyed by battle: You can target 1 "Fate's" monster in your Graveyard with less than 1900 ATK, except "Fate's Joker"; Special Summon that target.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(c101010251.settg)
	e1:SetOperation(c101010251.setop)
	c:RegisterEffect(e1)
	--If this card is Special Summoned from the hand or with a "Fate's" card: You can draw 1 card, and if you do, reveal it, then, if it was a "Fate's" monster, Special Summon it in Attack Position, also, draw 1 more card. If this card was Pendulum Summoned, you must have a "Fate's" card in your Pendulum Zone to activate this effect. You can only use this effect of "Fate's Joker" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCountLimit(1,101010251)
	e2:SetCondition(c101010251.condition)
	e2:SetTarget(c101010251.target)
	e2:SetOperation(c101010251.operation)
	c:RegisterEffect(e2)
end
function c101010251.filter(c,e,tp)
	return c:IsSetCard(0xf7a) and c:GetAttack()<1900 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010251.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101010251.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c101010251.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010251.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101010251.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then
		local pc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
		local pc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
		return (pc1 and pc1:IsSetCard(0xf7a)) or (pc2 and pc2:IsSetCard(0xf7a))
	end
	return c:GetSummonLocation()==LOCATION_HAND or re:GetHandler():IsSetCard(0xf7a)
end
function c101010251.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	e:SetCategory(CATEGORY_DRAW)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,0,0)
end
function c101010251.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0xf7a) then
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
