--created & coded by Lyris
--Speed Stripe Relay Dragon
function c101010477.initial_effect(c)
	--During the Damage Step of either player's turn, when this card is battling: You can dispose 1 of this card's Points, halve the ATK/DEF of the monster it is battling.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c101010477.condition2)
	e2:SetCost(c101010477.cost2)
	e2:SetOperation(c101010477.operation2)
	c:RegisterEffect(e2)
	--When your opponent Special Summons a Level 5 or higher monster, if this card has no Points: Shuffle that monster and this card into the Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101010477.thcon)
	e1:SetTarget(c101010477.thtg)
	e1:SetOperation(c101010477.thop)
	c:RegisterEffect(e1)
	--deck master effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetCondition(c101010477.dmcon)
	e3:SetTarget(c101010477.dmtg)
	e3:SetOperation(c101010477.dmop)
	c:RegisterEffect(e3)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EFFECT_SEND_REPLACE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_ONFIELD)
	e0:SetTarget(c101010477.reen)
	c:RegisterEffect(e0)
	if not c101010477.global_check then
		c101010477.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(481)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010477.chk)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetLabel(300)
		Duel.RegisterEffect(ge3,0)
	end
end
c101010477.relay=true
c101010477.relay_ext=function(c) local seq=c:GetSequence() return c:IsLocation(LOCATION_SZONE) and (seq==6 or seq==7) end
c101010477.dm=true
c101010477.dm_no_spsummon=true
function c101010477.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,e:GetLabel())
	Duel.CreateToken(1-tp,e:GetLabel())
end
function c101010477.condition2(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc~=nil and c:IsRelateToBattle() and bc:IsRelateToBattle() and not c:IsStatus(STATUS_CHAINING)
end
function c101010477.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return c:GetFlagEffect(10001100)>=1 end
	if point==1 then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-1)
	end
end
function c101010477.operation2(e,tp,eg,ep,ev,re,r,rp)
	local a=e:GetHandler()
	local d=a:GetBattleTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(a)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(d:GetAttack()/2)
	d:RegisterEffect(e1)
	local e2=Effect.CreateEffect(a)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(d:GetDefense()/2)
	d:RegisterEffect(e2)
end
function c101010477.thcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(10001100)~=0 then return false end
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:GetSummonPlayer()~=tp and tc:IsLevelAbove(5)
end
function c101010477.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Group.FromCards(e:GetHandler(),eg:GetFirst())
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c101010477.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==2 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c101010477.dmcon(e,tp,eg,ep,ev,re,r,rp)
	local bt=eg:GetFirst()
	return r~=REASON_REPLACE and bt:IsFaceup() and bt:IsControler(tp) and bt.relay
end
function c101010477.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bt=eg:GetFirst()
	if chk==0 then return true end
	local g=Group.FromCards(bt,bt:GetBattleTarget())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c101010477.dmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local c=Duel.GetAttacker()
	if c:IsRelateToBattle() then g:AddCard(c) end
	c=Duel.GetAttackTarget()
	if c~=nil and c:IsRelateToBattle() then g:AddCard(c) end
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c101010477.condition2(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc~=nil and c:IsRelateToBattle() and bc:IsRelateToBattle()
end
function c101010477.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return c:GetFlagEffect(10001100)>=1 end
	if point==1 then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-1)
	end
end
function c101010477.operation2(e,tp,eg,ep,ev,re,r,rp)
	local a=e:GetHandler()
	local d=a:GetBattleTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(a)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(d:GetAttack()/2)
	d:RegisterEffect(e1)
	local e2=Effect.CreateEffect(a)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(d:GetDefense()/2)
	d:RegisterEffect(e2)
end
function c101010477.reen(e,tp,eg,ep,ev,re,r,r,chk)
	local c=e:GetHandler()
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if chk==0 then return c:IsOnField() and bit.band(c:GetDestination(),LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND)~=0 and (tc1==nil or tc2==nil) end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
