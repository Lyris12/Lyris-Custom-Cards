--White Wisteria World
local id,ref=GIR()
function ref.start(c)
	local e1=c:AddActivateProc()
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetOperation(ref.op)
	--Normal Monsters you control and face-down Attack Position monsters cannot be targeted by attacks or your opponent's card effects.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(ref.pcttg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(ref.pctcon)
	e3:SetValue(ref.pcttg)
	c:RegisterEffect(e3)
	--If all monsters a player controls are face-down Attack Position, their opponent can attack 1 of those monsters at random.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(ref.con1)
	e5:SetOperation(ref.op1)
	c:RegisterEffect(e5)
	--choice2
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCondition(ref.con2)
	e6:SetOperation(ref.op2)
	c:RegisterEffect(e6)
end
function ref.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb0) and c:IsAbleToHand()
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(ref.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local tc=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		return
	end
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function ref.exfilter(c)
	return not c:IsPosition(POS_FACEDOWN_ATTACK)
end
function ref.pctcon(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	return (p~=tp and Duel.IsExistingMatchingCard(ref.exfilter,tp,LOCATION_MZONE,0,1,nil)) or (p==tp and Duel.IsExistingMatchingCard(ref.exfilter,1-tp,LOCATION_MZONE,0,1,nil))
end
function ref.pcttg(e,c)
	return (c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsControler(e:GetHandlerPlayer())) or c:IsPosition(POS_FACEDOWN_ATTACK)
end
function ref.con1(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetAttackTarget()~=nil and not Duel.IsExistingMatchingCard(ref.exfilter,tp,LOCATION_MZONE,0,1,nil)
end
function ref.op1(e,tp,eg,ep,ev,re,r,rp)
	local ats=eg:GetFirst():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if ats:GetCount()==0 or (at and ats:GetCount()==1) then return end
	Duel.ShuffleSetCard(ats)
	--[[Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=ats:Select(tp,1,1,at)
	Duel.Hint(HINT_CARD,0,id)
	Duel.HintSelection(g)
	Duel.ChangeAttackTarget(g:GetFirst())]]
end
function ref.con2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetAttackTarget()~=nil and not Duel.IsExistingMatchingCard(ref.exfilter,1-tp,LOCATION_MZONE,0,1,nil)
end
function ref.op2(e,tp,eg,ep,ev,re,r,rp)
	local ats=eg:GetFirst():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if ats:GetCount()==0 or (at and ats:GetCount()==1) then return end
	Duel.ShuffleSetCard(ats)
	--[[Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=ats:Select(1-tp,1,1,nil)
	Duel.HintSelection(g)
	Duel.ChangeAttackTarget(g:GetFirst())]]
end
