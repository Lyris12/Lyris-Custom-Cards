--ＳＳ－ナース・レイダー
local id,ref=GIR()
function ref.start(c)
--revive
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(ref.con)
	e1:SetCost(ref.cost)
	e1:SetTarget(ref.tg)
	e1:SetOperation(ref.op)
	c:RegisterEffect(e1)
end
function ref.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function ref.filter(c,e,tp)
	return c:IsSetCard(0x5cd) and c:GetCode()~=id and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and ref.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(ref.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local sg=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=sg:Select(tp,1,1,nil)
	if g:GetFirst():IsType(TYPE_TUNER) then
		sg:Remove(Card.IsType,nil,TYPE_TUNER)
		else
		sg:Remove(Card.IsNotTuner,nil)
	end
	if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local sc=sg:Select(tp,1,1,nil)
		g:AddCard(sc:GetFirst())
	end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=tg:GetCount()-1 then return end
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_DISABLE)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
