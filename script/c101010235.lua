--created & coded by Lyris
--襲雷渦動
function c101010235.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCost(c101010235.cost)
	e1:SetTarget(c101010235.target)
	e1:SetOperation(c101010235.activate)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e0)
end
function c101010235.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c101010235.filter(c,e,tp,g)
	if not c:IsSetCard(0x167) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	local check=true
	local tc=g:GetFirst()
	while tc do
		if c:GetCode()==tc:GetCode() then check=false end
		tc=g:GetNext()
	end
	return check
end
function c101010235.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c101010235.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c101010235.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101010235.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.NegateSummon(eg)
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	end
end
