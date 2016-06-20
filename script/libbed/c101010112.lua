--Aggecko Guaneri
local id,ref=GIR()
function ref.start(c)
aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6d6),4,2)
	--immune Once per turn, if this card attacks: You can detach 1 Xyz Material from this card; this card is unaffected by other non-"Aggecko" card effects until the end of the Battle Phase. (This is a Quick Effect.)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,101010306)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(ref.con)
	e0:SetCost(ref.cost)
	e0:SetOperation(ref.operation)
	c:RegisterEffect(e0)
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdocon)
	e1:SetTarget(ref.otg)
	e1:SetOperation(ref.oop)
	c:RegisterEffect(e1)
end
function ref.matfilter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsSetCard(0x6d6)
end
function ref.otg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.matfilter,tp,LOCATION_HAND,0,1,nil) end
end
function ref.oop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,ref.matfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>=0 then
		Duel.Overlay(e:GetHandler(),g)
	end
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE and Duel.GetTurnPlayer()==tp
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		e1:SetValue(ref.efilter)
		c:RegisterEffect(e1)
	end
end
function ref.efilter(c,e,te)
	return not te:IsSetCard(0x6d6) and te:GetOwner()~=e:GetOwner()
end