--旋風のピクシー
function c101010015.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101010015.condition)
	e1:SetCost(c101010015.cost)
	e1:SetTarget(c101010015.target)
	e1:SetOperation(c101010015.activate)
	c:RegisterEffect(e1)
end
function c101010015.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc~=LOCATION_MZONE and Duel.IsChainNegatable(ev)
end
function c101010015.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToDeck()
end
function c101010015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c101010015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101010015.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	local g=Duel.SelectYesNo(tp,2) and Duel.SelectMatchingCard(tp,c101010015.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	if g and g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_SYNCHRO)
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tc:GetControler()) then
			Duel.SpecialSummon(tc,0,tp,tc:GetControler(),false,false,POS_FACEUP)
		elseif Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE)>0 then
			Duel.MoveToField(tc,tp,tc:GetControler(),LOCATION_MZONE,POS_FACEUP,true)
		else return end
		else return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
end
function c101010015.synlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_WIND)
end
