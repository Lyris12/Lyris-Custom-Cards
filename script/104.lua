--F・HEROトワイライトガル
function c101010165.initial_effect(c)
	c:EnableReviveLimit()
	--token
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(c101010165.lpop)
	c:RegisterEffect(e0)
	local e4=e0:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e0:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010161,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c101010165.actcon)
	e2:SetCost(c101010165.actcost)
	e2:SetTarget(c101010165.acttg)
	e2:SetOperation(c101010165.act)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(101010161,1))
	e3:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e3)
end
function c101010165.mat_filter(c)
	return c:GetLevel()~=7
end
function c101010165.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_STANDBY)
	e1:SetTarget(c101010165.sptg)
	e1:SetOperation(c101010165.spop)
	c:RegisterEffect(e1)
end
function c101010165.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101010166,0,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101010165.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ft>ct then ft=ct end
	if ft<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,101010166,0,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	local ctn=true
	while ft>0 and ctn do
		local token=Duel.CreateToken(tp,101010166)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		ft=ft-1
		if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(101010165,2)) then ctn=false end
	end
	Duel.SpecialSummonComplete()
end
function c101010165.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_SET_TURN) or e:GetHandler():GetFlagEffect(101010170)~=0
end
function c101010165.cfilter(c)
	return c:IsReleasableByEffect() and (c:IsLevelBelow(6) or c101010165.star(c))
end
function c101010165.star(c)
	return c:IsCode(101010176) and c:IsHasEffect(101010176)
end
function c101010165.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c101010165.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	if chk==0 then return cg:IsExists(c101010165.star,1,nil) or cg:CheckWithSumEqual(Card.GetLevel,12,1,99) end
	local g=nil
	if not cg:CheckWithSumEqual(Card.GetLevel,12,1,99) or (cg:IsExists(c101010165.star,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101010176,0))) then
		g=cg:FilterSelect(tp,c101010165.star,1,1,nil)
	else
		g=cg:SelectWithSumEqual(tp,Card.GetLevel,12,1,99)
	end
	Duel.Release(g,REASON_COST)
end
function c101010165.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010165.filter(c,e,tp)
	return c:IsSetCard(0x9008) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010165.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)==0 then return end
		if ev~=0 then
			local ef=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if ef~=nil and ef:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then Card.ReleaseEffectRelation(c,ef) end
		end
		c:CompleteProcedure()
		c101010165.after(e,tp)
	end
end
function c101010165.after(e,tp)
	local g=Duel.GetMatchingGroup(c101010165.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
