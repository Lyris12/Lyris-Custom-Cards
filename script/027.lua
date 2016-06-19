--Cyberspace Turtle
function c101010334.initial_effect(c)
	--add LIGHT attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	--to defence
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(c101010334.poscon)
	e2:SetOperation(c101010334.posop)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c101010334.tg)
	c:RegisterEffect(e3)
	--banished effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetTarget(c101010334.postg)
	e4:SetOperation(c101010334.posop2)
	c:RegisterEffect(e4)
end
function c101010334.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end
function c101010334.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENCE)
	end
end
function c101010334.tg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c101010334.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c101010334.posop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	if Duel.ChangePosition(g,POS_FACEUP_DEFENCE,POS_FACEDOWN_DEFENCE,0,0)==0 then return end
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENCE_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetDefence()/2)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
