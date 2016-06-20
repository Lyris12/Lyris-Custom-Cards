local id,ref=GIR()
function ref.start(c)
c:EnableCounterPermit(0x3001)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(ref.ratg)
	e5:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e5)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(ref.destg)
	e1:SetOperation(ref.desop)
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
	e2:SetValue(ref.attackup)
	c:RegisterEffect(e2)
end
function ref.ratg(e)
	return e:GetHandler()
end
function ref.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function ref.chkfilter(c)
	return c:IsFaceup() and c:IsAttribute(0xff)
end
function ref.filter(c,at)
	return c:IsFaceup() and c:IsAttribute(at)
end
function ref.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and ref.desfilter(chkc) end
	if chk==0 then return Duel.GetMatchingGroupCount(ref.chkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>0
		and Duel.IsExistingTarget(ref.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local at=Duel.AnnounceAttribute(tp,1,0xffff)
	local ct=Duel.GetMatchingGroupCount(ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,at)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,ref.desfilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ctr=Duel.Destroy(g,REASON_EFFECT)
	if ctr>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.BreakEffect()
		e:GetHandler():AddCounter(0x3001,ctr)
	end
end
function ref.attackup(e,c)
	return c:GetCounter(0x3001)*1000
end
