--created & coded by Lyris
--ホワイト・ウィステリア・ワールド
function c101010388.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101010388.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c101010388.pcttg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c101010388.pctcon)
	e3:SetValue(c101010388.pcttg)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(c101010388.con1)
	e5:SetOperation(c101010388.op1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCondition(c101010388.con2)
	e6:SetOperation(c101010388.op2)
	c:RegisterEffect(e6)
end
function c101010388.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb0) and c:IsAbleToHand()
end
function c101010388.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101010388.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local tc=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		return
	end
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c101010388.exfilter(c)
	return not c:IsPosition(POS_FACEDOWN_ATTACK)
end
function c101010388.pctcon(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	return (p~=tp and Duel.IsExistingMatchingCard(c101010388.exfilter,tp,LOCATION_MZONE,0,1,nil)) or (p==tp and Duel.IsExistingMatchingCard(c101010388.exfilter,1-tp,LOCATION_MZONE,0,1,nil))
end
function c101010388.pcttg(e,c)
	return (c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsControler(e:GetHandlerPlayer())) or c:IsPosition(POS_FACEDOWN_ATTACK)
end
function c101010388.con1(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetAttackTarget()~=nil and not Duel.IsExistingMatchingCard(c101010388.exfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101010388.op1(e,tp,eg,ep,ev,re,r,rp)
	local ats=eg:GetFirst():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if ats:GetCount()==0 or (at and ats:GetCount()==1) then return end
	Duel.ShuffleSetCard(ats)
	local g=ats:Select(tp,1,1,at)
	Duel.Hint(HINT_CARD,0,101010388)
	Duel.HintSelection(g)
	Duel.ChangeAttackTarget(g:GetFirst())]]
end
function c101010388.con2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetAttackTarget()~=nil and not Duel.IsExistingMatchingCard(c101010388.exfilter,1-tp,LOCATION_MZONE,0,1,nil)
end
function c101010388.op2(e,tp,eg,ep,ev,re,r,rp)
	local ats=eg:GetFirst():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if ats:GetCount()==0 or (at and ats:GetCount()==1) then return end
	Duel.ShuffleSetCard(ats)
	local g=ats:Select(1-tp,1,1,nil)
	Duel.HintSelection(g)
	Duel.ChangeAttackTarget(g:GetFirst())]]
end
