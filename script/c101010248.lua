--Jeweled Skydancer of Stellar Vine
local id,ref=GIR()
function ref.start(c)
aux.EnableDualAttribute(c)
	--recruit
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetCondition(aux.IsDualState)
	e0:SetCost(ref.cost)
	e0:SetTarget(ref.tg)
	e0:SetOperation(ref.op)
	c:RegisterEffect(e0)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetLabel(0)
	e1:SetCondition(ref.negcon2)
	e1:SetCost(ref.cost1)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_CHAINING)
	e2:SetLabel(1)
	e2:SetCondition(ref.condition1)
	e2:SetCost(ref.cost2)
	e2:SetTarget(ref.target)
	e2:SetOperation(ref.activate)
	c:RegisterEffect(e2)
end
function ref.condition1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsChainNegatable(ev)
end
function ref.costfilter(c,n)
	if not c:IsFaceup() or not c:IsSetCard(0x785e) or c:GetLevel()~=4 then return false end
	if n~=0 then return c:IsAbleToGraveAsCost()
	else return c:IsAbleToRemoveAsCost() end
end
function ref.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(ref.costfilter,tp,LOCATION_HAND,0,1,c,e:GetLabel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.costfilter,tp,LOCATION_HAND,0,1,1,c,e:GetLabel())
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function ref.negcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function ref.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(ref.costfilter,tp,LOCATION_REMOVED,0,1,c,e:GetLabel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,ref.costfilter,tp,LOCATION_REMOVED,0,1,1,c,e:GetLabel())
	cg:AddCard(c)
	Duel.SendtoGrave(cg,REASON_COST+REASON_RETURN)
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil),POS_FACEUP,REASON_COST)
end
function ref.filter(c,e,tp)
	return c:IsSetCard(0x785e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP) then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue((tc:GetLevel()*800)+10)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
