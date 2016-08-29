--Radiant Flash
function c101010320.initial_effect(c)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetCondition(c101010320.actlimit)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_MSET)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c101010320.actlimit)
	e3:SetTargetRange(0,1)
	e3:SetValue(aux.TRUE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c101010320.condition)
	e4:SetCost(c101010320.cost)
	e4:SetTarget(c101010320.target)
	e4:SetOperation(c101010320.activate)
	c:RegisterEffect(e4)
end
function c101010320.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp or not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c101010320.filter(c)
	return c:IsSetCard(0x5e) and not c:IsPublic()
end
function c101010320.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010320.filter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101010320.filter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	g:RegisterEffect(e1)
end
function c101010320.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToHand() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
	end
end
function c101010320.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		rc:CancelToGrave()
		if Duel.SendtoHand(rc,nil,REASON_EFFECT)~=0 then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_PUBLIC)
			e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			rc:RegisterEffect(e0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetCondition(c101010320.actlimit)
			e1:SetValue(aux.TRUE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			rc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SSET)
			rc:RegisterEffect(e2)
		end
	end
end
function c101010320.actlimit(e)
	return e:GetHandler():IsPublic()
end
