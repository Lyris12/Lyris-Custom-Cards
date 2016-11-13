--created & coded by Lyris
--荒潮
function c101010232.initial_effect(c)
--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetCondition(c101010232.con)
	e0:SetCost(c101010232.cost)
	e0:SetTarget(c101010232.tg)
	e0:SetOperation(c101010232.activate)
	c:RegisterEffect(e0)
		--destroy replace
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(c101010232.repcon)
		e1:SetTarget(c101010232.reptg)
		e1:SetValue(c101010232.repval)
		c:RegisterEffect(e1)
end
function c101010232.repcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end
function c101010232.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c101010232.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101010232.repfilter,1,nil,tp) end
	if e:GetHandler():IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(101010232,0)) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		return true
	else return false end
end
function c101010232.repval(e,c)
	return c101010232.repfilter(c,e:GetHandlerPlayer())
end
function c101010232.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsAttribute(ATTRIBUTE_WATER) and Duel.IsChainNegatable(ev)
end
function c101010232.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_WATER) or Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	if Duel.SelectOption(tp,aux.Stringid(101010232,1),aux.Stringid(101010232,2))~=0 then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
	else
		local rg=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_WATER)
		Duel.Release(rg,REASON_COST)
	end
end
function c101010232.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101010232.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
