--剣主 一
local id,ref=GIR()
function ref.start(c)
--pierce
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ref.val)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetTarget(ref.target)
	e2:SetOperation(ref.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function ref.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2)
end
function ref.val(e,c)
	return Duel.GetMatchingGroupCount(ref.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*100
end
function ref.filter(c,e,tp)
	return (c:IsSetCard(0xbb2) or c:IsSetCard(0xbb3)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function ref.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR) and c:IsDiscardable()
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.SelectYesNo(tp,2) then
		Duel.BreakEffect()
		if Duel.DiscardHand(tp,Card.IsRace,1,1,REASON_EFFECT+REASON_DISCARD,nil,RACE_WARRIOR)~=0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
