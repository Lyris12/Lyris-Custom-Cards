--襲雷の空
local id,ref=GIR()
function ref.start(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--choice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(ref.condition)
	e2:SetOperation(ref.operation)
	c:RegisterEffect(e2)
	--choice2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(ref.condition2)
	e3:SetOperation(ref.operation2)
	c:RegisterEffect(e3)
	--must attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(function(e,c) return not c:IsSetCard(0x167) end)
	c:RegisterEffect(e4)
	
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetAttackTarget()~=nil
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x167)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local ats=eg:GetFirst():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if ats:GetCount()==0 or (at and ats:GetCount()==1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=ats:Select(tp,1,1,nil)
	Duel.HintSelection(g)
	Duel.ChangeAttackTarget(g:GetFirst())
end
function ref.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetAttackTarget()~=nil
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x167)
end
function ref.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ats=eg:GetFirst():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if ats:GetCount()==0 or (at and ats:GetCount()==1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=ats:Select(1-tp,1,1,nil)
	Duel.HintSelection(g)
	Duel.ChangeAttackTarget(g:GetFirst())
end
