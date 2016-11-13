--created & coded by Lyris
--Matsuo, Tsuiho Assailant
function c101020053.initial_effect(c)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,101020053)
	e1:SetCondition(c101020053.condition)
	e1:SetCost(c101020053.cost)
	e1:SetTarget(c101020053.target)
	e1:SetOperation(c101020053.operation)
	c:RegisterEffect(e1)
	--grave banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101020053)
	e2:SetCost(c101020053.rmcost)
	e2:SetTarget(c101020053.rmtg)
	e2:SetOperation(c101020053.rmop)
	c:RegisterEffect(e2)
	--end turn/order and banish deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101020053.etcon)
	e3:SetTarget(c101020053.ettg)
	e3:SetOperation(c101020053.etop)
	c:RegisterEffect(e3)
end
function c101020053.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x330)
end
function c101020053.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101020053.cfilter,tp,LOCATION_MZONE,0,1,nil) and re:GetHandler():IsOnField() and re:IsActiveType(TYPE_MONSTER)
end
function c101020053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RETURN)
end
function c101020053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
end
function c101020053.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c101020053.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c101020053.filter(c,n)
	if not c:IsAbleToRemove() then return false end
	if n~=0 then return c:IsType(TYPE_SPELL+TYPE_TRAP)
	else return c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) end
end
function c101020053.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c101020053.filter(chkc,0) end
	local g1=Duel.GetMatchingGroup(c101020053.filter,tp,LOCATION_GRAVE,0,nil,0)
	local g2=Duel.GetMatchingGroup(c101020053.filter,tp,0,LOCATION_GRAVE,nil,0)
	if chk==0 then return g1:GetCount()>0 or g2:GetCount()>0 end
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c101020053.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101020053.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil,0)
	if g:GetCount()==0 then return end
	local g5=Group.CreateGroup()
	local g1=g:Filter(Card.IsControler,nil,tp)
	g5:Merge(g1)
	local g2=g:Filter(Card.IsControler,nil,1-tp)
	g5:Merge(g2)
	local g3=Duel.GetMatchingGroup(c101020053.filter,tp,LOCATION_GRAVE,0,nil,1)
	local g4=Duel.GetMatchingGroup(c101020053.filter,tp,0,LOCATION_GRAVE,nil,1)
	if Duel.Remove(g5,POS_FACEUP,REASON_EFFECT)~=0 then
		g5:Clear()
		g=Duel.GetOperatedGroup()
		local ct=g:GetCount()
		g1=g:FilterCount(Card.IsControler,nil,tp)
		g2=g:FilterCount(Card.IsControler,nil,1-tp)
		if g1>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			g4=g4:Select(tp,ct-g2,ct-g2,nil)
			g5:Merge(g4)
		end
		if g2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			g3=g3:Select(tp,ct-g1,ct-g1,nil)
			g5:Merge(g3)
		end
		Duel.Remove(g5,POS_FACEUP,REASON_EFFECT)
	end
end
function c101020053.etcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101020053.ettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK)
end
function c101020053.etop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,30459350) then return end
	Duel.SortDecktop(tp,tp,3)
	Duel.BreakEffect()
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
