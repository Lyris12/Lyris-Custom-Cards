--created & coded by Lyris
--Victorious Weapon - Aries
function c101010375.initial_effect(c)
	aux.AddEquipProcedure(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetOperation(c101010375.lmop)
	c:RegisterEffect(e2)
	--second effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetAttacker()==e:GetHandler():GetEquipTarget() end)
	e3:SetTarget(c101010375.destg)
	e3:SetOperation(c101010375.desop)
	c:RegisterEffect(e3)
end
function c101010375.lmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()~=e:GetHandler():GetEquipTarget() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101010375.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c101010375.aclimit(c,re,tp)
	local c=re:GetHandler()
	if not c:IsOnField() then return false end
	if c:IsFacedown() then return true end
	return c:IsHasEffect(EVENT_FLIP) or re:IsActiveType(EFFECT_TYPE_FLIP)
end
function c101010375.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	e:SetLabelObject(ec)
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.SetTargetCard(ec)
end
function c101010375.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	if ec:IsLocation(LOCATION_MZONE) and ec:IsFaceup() and ec:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		ec:RegisterEffect(e1)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetValue(TYPE_TUNER)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		ec:RegisterEffect(e0)
	end
end
