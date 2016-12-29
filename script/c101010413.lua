--Attribrutal VILLAIN Cyber Space Kaiser
function c101010413.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101010413.ffilter,aux.FilterBoolFunction(Card.IsSetCard,0x93),false)
	--Must be Fusion Summoned, and cannot be Special Summoned by other ways.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--If this card is targeted by a card effect controlled by your opponent: Banish this card.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCondition(c101010413.rmcon)
	e3:SetTarget(c101010413.rmtg)
	e3:SetOperation(c101010413.rmop)
	c:RegisterEffect(e3)
	--If this card is banished: Banish 1 LIGHT monster from your Graveyard, then, Special Summon this card, ignoring the Summoning conditions, and if you do, this card gains 700 ATK and 800 DEF.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetTarget(c101010413.sptg)
	e4:SetOperation(c101010413.spop)
	c:RegisterEffect(e4)
end
function c101010413.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(CHAININFO_TRIGGERING_CONTROLER)
	return p~=tp
end
function c101010413.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c101010413.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
function c101010413.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010413.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemove()
end
function c101010413.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010413.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetValue(700)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetValue(800)
			c:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
			Duel.SendtoGrave(c,REASON_RULE)
		end
	end
end
