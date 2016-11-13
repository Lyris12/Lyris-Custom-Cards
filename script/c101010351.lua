--created & coded by Lyris
--Rainbow-Eyes Starchaser
function c101010351.initial_effect(c)
	--During your Main Phase 1: You can dispose 1 of this card's Points; this card can attack your opponent directly this turn.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101010351.dacon)
	e3:SetCost(c101010351.dacost)
	e3:SetOperation(c101010351.daop)
	c:RegisterEffect(e3)
	--At the start of your Battle Phase: You can shuffle this face-up card you control into the Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_BATTLE_START,0)
	e1:SetCondition(c101010351.tdcon)
	e1:SetTarget(c101010351.tdtg)
	e1:SetOperation(c101010351.tdop)
	c:RegisterEffect(e1)
	if not c101010351.global_check then
		c101010351.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010351.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010351.relay=true
c101010351.point=2
function c101010351.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,481)
	Duel.CreateToken(1-tp,481)
end
function c101010351.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE and not Duel.CheckPhaseActivity() and Duel.GetCurrentChain()==0
end
function c101010351.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
end
function c101010351.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function c101010351.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c101010351.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return c:GetFlagEffect(10001100)>=1 end
	if point==1 then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-1)
	end
end
function c101010351.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
