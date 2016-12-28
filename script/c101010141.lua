--created & coded by Lyris
--フェイツ・プロヒビトガル
function c101010141.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_DESTROY)
	e0:SetCountLimit(1,101010141)
	e0:SetCondition(function(e) return e:GetHandler():IsReason(REASON_EFFECT) end)
	e0:SetOperation(c101010141.regop)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetHintTiming(TIMING_DAMAGE_CAL)
	e4:SetCondition(c101010141.rdcon)
	e4:SetCost(c101010141.rdcost)
	e4:SetOperation(c101010141.rdop)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c101010141.condition)
	e2:SetTarget(c101010141.target)
	e2:SetOperation(c101010141.operation)
	c:RegisterEffect(e2)
end
function c101010141.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,101010141)~=0 then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	if rp~=c:GetControler() then
		e1:SetTargetRange(1,0)
	else
		e1:SetTargetRange(0,1)
	end
	e1:SetValue(function(e,re,dam,r,rp,rc) return dam/2 end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,101010141,RESET_PHASE+PHASE_END,0,1)
end
function c101010141.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	return bc~=nil and bc:IsFaceup() and bc:IsControler(tp) and bc:IsSetCard(0xf7a)
end
function c101010141.rdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c101010141.rdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c101010141.damop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101010141.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
end
function c101010141.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then
		local pc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
		local pc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
		return (pc1 and pc1:IsSetCard(0xf7a)) or (pc2 and pc2:IsSetCard(0xf7a))
	end
	return c:GetSummonLocation()==LOCATION_HAND or re:GetHandler():IsSetCard(0xf7a)
end
function c101010141.cpfilter(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf7a) and not c:IsCode(101010141) and (not c.target or c.target(e,tp,eg,ep,ev,re,r,rp,0))
end
function c101010141.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010141.cpfilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(c101010141.cpfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectTarget(tp,c101010141.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	if tc.target then tc.target(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c101010141.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	tc.operation(e,tp,eg,ep,ev,re,r,rp)
end
