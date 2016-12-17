--Clear Beast
function c101010148.initial_effect(c)
	--destroy replace
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ae1:SetCode(EFFECT_DESTROY_REPLACE)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCountLimit(1)
	ae1:SetCondition(c101010148.con)
	ae1:SetTarget(c101010148.reptg)
	ae1:SetValue(c101010148.repval)
	c:RegisterEffect(ae1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCode(97811903)
	e1:SetCondition(c101010148.tpcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(0,1)
	e2:SetCondition(c101010148.ntpcon)
	c:RegisterEffect(e2)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetValue(1)
	e3:SetCondition(c101010148.ntpcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(1)
	e5:SetCondition(c101010148.ntpcon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)
end
function c101010148.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(c:GetOwner())
end
function c101010148.ntpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-c:GetOwner())
end
function c101010148.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c101010148.con(e,tp,eg,ep,ev,re,r,rp)
	return c101010148.tpcon(e,tp,eg,ep,ev,re,r,rp) and Duel.IsExistingMatchingCard(c101010148.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c101010148.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and c:GetAttack()>0
end
function c101010148.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101010148.repfilter,1,nil,tp) end
	local tc=eg:GetFirst()
	if eg:GetCount()>1 then tc=eg:Select(tp,1,1,nil):GetFirst() end
	local atk=tc:GetAttack()
	if Duel.Damage(1-tp,atk,REASON_EFFECT+REASON_REPLACE) then
		return true
		else return false
	end
end
function c101010148.repval(e,c)
	return c101010148.repfilter(c,e:GetHandlerPlayer())
end
