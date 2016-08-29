--
function c101010275.initial_effect(c)
--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,101010249,3,true,true)
	--Once per turn, during your Main Phase 1: you can activate this effect; and if you do, during the Battle Phase this turn, this card can attack all monsters your opponent controls.
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c101010275.atkdncon)
	e5:SetOperation(c101010275.atkdnop)
	c:RegisterEffect(e5)
	--During your End Phase: you can pay 1000 LP; this card gains 1000 ATK.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c101010275.atkupcon)
	e4:SetTarget(c101010275.atkuptg)
	e4:SetOperation(c101010275.atkupop)
	c:RegisterEffect(e4)
end
function c101010275.atkdncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c101010275.atkdnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-1000)
	e2:SetReset(RESET_EVENT)
	if c:RegisterEffect(e2) then
		local e3=Effect.CreateEffect(c)
		e3:SetCode(EFFECT_EXTRA_ATTACK)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetValue(math.huge)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e4:SetCondition(c101010275.dircon)
		c:RegisterEffect(e4)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_ATTACK)
		e5:SetCondition(c101010275.atkcon)
		c:RegisterEffect(e5)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101010275.antarget)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101010275.antarget(e,c)
	return c~=e:GetHandler()
end
function c101010275.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function c101010275.atkcon(e)
	return e:GetHandler():IsDirectAttacked()
end
function c101010275.atkupcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and tp==Duel.GetTurnPlayer()
end
function c101010275.atkuptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c101010275.atkupop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
