function c101010059.initial_effect(c)
	c:EnableCounterPermit(0x3001)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c101010059.ratg)
	e5:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e5)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101010059.destg)
	e1:SetOperation(c101010059.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--attackup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c101010059.attackup)
	c:RegisterEffect(e2)
end
function c101010059.ratg(e)
	return e:GetHandler()
end
function c101010059.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c101010059.chkfilter(c)
	return c:IsFaceup() and c:IsAttribute(0xff)
end
function c101010059.filter(c,at)
	return c:IsFaceup() and c:IsAttribute(at)
end
function c101010059.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101010059.desfilter(chkc) end
	if chk==0 then return Duel.GetMatchingGroupCount(c101010059.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>0
		and Duel.IsExistingTarget(c101010059.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local at=Duel.AnnounceAttribute(tp,1,0xffff)
	local ct=Duel.GetMatchingGroupCount(c101010059.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,at)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101010059.desfilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101010059.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ctr=Duel.Destroy(g,REASON_EFFECT)
	if ctr>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.BreakEffect()
		e:GetHandler():AddCounter(0x3001,ctr)
	end
end
function c101010059.attackup(e,c)
	return c:GetCounter(0x3001)*1000
end
