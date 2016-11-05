--F・HERO Light－9
function c101010408.initial_effect(c)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c101010408.sttg)
	e1:SetOperation(c101010408.stop)
	c:RegisterEffect(e1)
	--During the End Phase, if face-up card is being treated as a Continuous Trap Card: You can target 1 Special Summoned monster your opponent controls; send it to the Graveyard.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetTarget(c101010408.tgtg)
	e3:SetOperation(c101010408.tgop)
	c:RegisterEffect(e3)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010408,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c101010408.actcost)
	e2:SetOperation(c101010408.act)
	c:RegisterEffect(e2)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_CONTROL+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c101010408.destg)
	e4:SetOperation(c101010408.desop)
	c:RegisterEffect(e4)
end
function c101010408.mat_filter(c)
	return c:GetLevel()~=8
end
function c101010408.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c101010408.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) and Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e0)
end
function c101010408.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsAbleToGrave()
end
function c101010408.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101010408.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010408.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c101010408.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c101010408.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c101010408.cfilter(c)
	return c:IsReleasableByEffect() and c:IsHasEffect(101010187)
end
function c101010408.actcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and (Duel.CheckReleaseGroup(tp,nil,3,nil)
		or Duel.IsExistingMatchingCard(c101010408.cfilter,tp,LOCATION_MZONE,0,1,nil))
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101010408,0xf7a,0xa1,1900,600,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	local g=nil
	if not Duel.CheckReleaseGroup(tp,nil,2,nil) or (Duel.IsExistingMatchingCard(Card.IsHasEffect,1,nil,101010187) and Duel.SelectYesNo(tp,aux.Stringid(101010187,0))) then
		g=cg:FilterSelect(tp,Card.IsHasEffect,1,1,nil,101010187)
	else
		g=Duel.SelectReleaseGroup(tp,nil,3,3,nil)
	end
	Duel.Release(g,REASON_COST)
end
function c101010408.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		if not Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true) then
				Duel.SendtoGrave(c,REASON_RULE)
			end
			return
		end
		c:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
		if ev~=0 then
			local ef=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if ef~=nil and ef:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
				local tf=ef:GetTarget()
				local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(ef:GetCode(),true)
				if not tf(ef,rp,ceg,cep,cev,cre,cr,crp,0,c) then Card.ReleaseEffectRelation(c,ef) end
			end
		end
		c:CompleteProcedure()
		local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_GRAVE,nil,e,0,tp,false,false)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101010408,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil)
			Duel.HintSelection(tc)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101010408.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,g,1,1-tp,g:GetFirst():GetBaseAttack())
end
function c101010408.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Damage(1-tp,g:GetFirst():GetBaseAttack(),REASON_EFFECT)
	end
end
