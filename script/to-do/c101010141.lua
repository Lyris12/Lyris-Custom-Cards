--F・HEROプロヒビットガイ
function c101010141.initial_effect(c)
--damage half
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_DESTROY)
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
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetOperation(c101010141.act)
	c:RegisterEffect(e2)
end
function c101010141.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,101010141)~=0 then return end
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		if rp~=c:GetControler() then
			e1:SetTargetRange(1,0)
		else
			e1:SetTargetRange(0,1)
		end
		e1:SetValue(c101010141.val)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,101010141,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101010141.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	return bc~=nil and bc:IsFaceup() and bc:IsSetCard(0xf7a)
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
function c101010141.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf7a) and c.after and c.after(e,tp,0)
end
function c101010141.act(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101010141.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		tc.after(e,tp,1)
	end
end
function c101010141.val(e,re,dam)
	return dam/2
end
