--created & coded by Lyris
--Fate's Doomed Monger
function c101010089.initial_effect(c)
	--If this card is Normal or Special Summoned from the hand or with a "Fate's" card: You can target 1 "Fate's" monster in your Graveyard; Special Summon it in Attack Position. If this card was Pendulum Summoned, you must have a "Fate's" card in your Pendulum Zone to activate this effect. You can only use this effect of "Fate's Doomed Monger" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101010089)
	e2:SetCondition(c101010089.condition)
	e1:SetTarget(c101010089.target)
	e1:SetOperation(c101010089.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c101010089.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then
		local pc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
		local pc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
		return pc1:IsSetCard(0xf7a) or pc2:IsSetCard(0xf7a)
	end
	return c:GetSummonLocation()==LOCATION_HAND or re:GetHandler():IsSetCard(0xf7a)
end
function c101010089.filter(c,e,tp)
	return c:IsSetCard(0xf7a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010089.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010089.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZOME)>0
	and Duel.IsExistingTarget(c101010089.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectTarget(tp,c101010089.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c101010089.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
