--created & coded by Lyris
--Dimension-Magica White Kuribohle
function c101010399.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010399,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,101010399)
	e1:SetCondition(c101010399.condition)
	e1:SetCost(c101010399.cost)
	e1:SetOperation(c101010399.operation)
	c:RegisterEffect(e1)
end
function c101010399.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=0x04 and ph<=0x100
end
function c101010399.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c101010399.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCountLimit(1)
	e1:SetValue(c101010399.rdval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(function(e,tp,eg,ep) return ep==tp and Duel.GetFlagEffect(tp,101010399)==0 end)
	e2:SetOperation(c101010399.disop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c101010399.rdval(e,re,dam,r,rp,rc)
	local tp=e:GetOwnerPlayer()
	if bit.band(r,REASON_EFFECT)~=0 and Duel.GetFlagEffect(tp,101010399)==0 then
		Duel.Hint(HINT_CARD,0,101010399)
		Duel.RegisterFlagEffect(tp,101010399,RESET_PHASE+PHASE_END,0,1)
		return 0
	else return dam end
end
function c101010399.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101010399)
	Duel.RegisterFlagEffect(tp,101010399,RESET_PHASE+PHASE_END,0,1)
	Duel.ChangeBattleDamage(tp,0)
end
