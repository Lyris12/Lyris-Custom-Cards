--created & coded by Lyris
--襲雷竜－銀河
function c101010266.initial_effect(c)
	c:EnableCounterPermit(0x4b)
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_COUNTER)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c101010266.op)
	c:RegisterEffect(e0)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c101010266.discon)
	e2:SetTarget(c101010266.distg)
	e2:SetOperation(c101010266.disop)
	c:RegisterEffect(e2)
	--self-destruct
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c101010266.descon)
	e3:SetOperation(c101010266.desop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c101010266.atcon)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e4)
	--summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c101010266.ttcon)
	e1:SetOperation(c101010266.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--When a "Blitzkrieg" monster(s) leaves the field, except by being destroyed: You can Special Summon this card from your hand, and if you do, any "Blitzkrieg" monster that would leave the field for the rest of this turn is destroyed and sent to the Graveyard, instead.
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c101010266.spcon)
	e5:SetTarget(c101010266.sptg)
	e5:SetOperation(c101010266.spop)
	c:RegisterEffect(e5)
end
function c101010266.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010266.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c101010266.op(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x4b,3)
end
function c101010266.atcon(e,c)
	return c==e:GetHandler()
end
function c101010266.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTribute(tp,c,1,1)
	c:SetMaterial(g)
	Duel.Destroy(g,REASON_MATERIAL+REASON_SUMMON)
end
function c101010266.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetTributeCount(c)>=1
end
function c101010266.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if ex then return false end
	return tg and tg:IsExists(Card.IsOnField,1,nil) and Duel.IsChainNegatable(ev)
end
function c101010266.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101010266.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.BreakEffect()
		if c:IsCanRemoveCounter(tp,0x4b,1,REASON_EFFECT) then
			c:RemoveCounter(tp,0x4b,1,REASON_EFFECT)
		else
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
function c101010266.spcfil(c,tp)
	return c:IsSetCard(0x167) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and not c:IsReason(REASON_DESTROY)
end
function c101010266.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c101010266.spcfil,1,nil,tp)
end
function c101010266.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010266.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EFFECT_SEND_REPLACE)
		e5:SetTarget(c101010266.reptg)
		e5:SetValue(c101010266.repval)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	end
end
function c101010266.repfilter(c)
	return c:IsSetCard(0x167) and c:IsLocation(LOCATION_MZONE) and not c:IsReason(REASON_DESTROY)
end
function c101010266.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101010266.repfilter,1,nil) end
	local g=eg:Filter(c101010266.repfilter,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.Destroy(g,r,tc:GetDestination())
		tc=g:GetNext()
	end
end
function c101010266.repval(e,c)
	return c101010266.repfilter(c)
end
