--created & coded by Lyris
--PSYストリーム・ジャーニー
function c101010069.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101010069.condition)
	e1:SetTarget(c101010069.target)
	e1:SetOperation(c101010069.op)
	c:RegisterEffect(e1)
end
function c101010069.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x127)
end
function c101010069.condition(e,tp,eg,ep,ev,re,r,rp)
	local ex,g=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	return ep~=tp and ex and g:IsExists(c101010069.spfilter,1,nil) and Duel.IsChainNegatable(ev)
end
function c101010069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101010069.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

