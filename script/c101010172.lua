--ネオ光の波動
function c101010172.initial_effect(c)
	aux.AddEquipProcedure(c,nil,nil,nil,nil,nil,c101010172.operation)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c101010172.lmop)
	c:RegisterEffect(e1)
	--Attribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e4)
end
function c101010172.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--drawback
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c101010172.ldop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end
function c101010172.lmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()~=e:GetHandler():GetEquipTarget() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,0xff)
	e1:SetTarget(c101010172.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0xff,0xff,e:GetHandler():GetEquipTarget(),TYPE_MONSTER)
	local tc=g:GetFirst()
	while tc do
		--disable
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetRange(0xff)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetRange(0xff)
		e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c101010172.aclimit(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c101010172.distg(c,e)
	return c~=e:GetHandler():GetEquipTarget() and c:IsType(TYPE_MONSTER)
end
function c101010172.ldop(e,tp,eg,ep,ev,re,r,rp)
	local q=e:GetHandler():GetEquipTarget()
	local qp=q:GetControler()
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER)~=qp or Duel.GetCurrentPhase()~=PHASE_DAMAGE then return end
	local atk2=q:GetAttack()
	local atk1=q:GetTextAttack()
	if atk1==-2 then atk1=q:GetBaseAttack() end
	local atk=math.abs(atk1-atk2)
	local lp=Duel.GetLP(qp)
	Duel.SetLP(qp,lp-atk)
end
