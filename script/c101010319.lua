--created & coded by Lyris
--ドラッグルーオンの伝説
function c101010319.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c101010319.cost)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c101010319.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c101010319.econ)
	e2:SetTarget(c101010319.deftg)
	e2:SetValue(c101010319.defval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e3:SetCondition(c101010319.econ)
	e3:SetTarget(c101010319.disable)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c101010319.handcon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c101010319.efilter1)
	e5:SetTargetRange(0xff,0xff)
	c:RegisterEffect(e5)
end
function c101010319.efilter1(e,c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c101010319.efilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c101010319.econ(e)
	return Duel.IsExistingMatchingCard(c101010319.efilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c101010319.hfilter(c)
	return c:IsFaceup() and c:IsCode(2978414)
end
function c101010319.handcon(e)
	return Duel.IsExistingMatchingCard(c101010319.hfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c101010319.filter(c)
	if c:IsFacedown() then return false end
	if c:IsCode(2978414) then return true end
	return c:IsRace(RACE_DRAGON) and c:IsReleasableByEffect()
end
function c101010319.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010319.filter,tp,LOCATION_MZONE,0,1,nil) end
	if Duel.IsExistingMatchingCard(c101010319.hfilter,tp,LOCATION_ONFIELD,0,1,nil) then return end
	local g=Duel.SelectReleaseGroup(tp,c101010319.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c101010319.disable(e,c)
	return c:IsRace(RACE_WARRIOR) and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
end
function c101010319.target(e,c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsRace(RACE_WARRIOR)
end
function c101010319.deftg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c101010319.defval(e,c)
	return -c:GetBaseDefense()
end
function c101010319.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101010319.efilter,tp,LOCATION_MZONE,0,nil,RACE_DRAGON)
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetOriginalCode()
		if tc:GetFlagEffect(code)==0 then
			c101010319.gainop(e,tp,tc)
			tc:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,1)
		end
		tc=g:GetNext()
	end
end
function c101010319.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR)
end
function c101010319.gainop(e,tp,c)
	local wg=Duel.GetMatchingGroup(c101010319.eqfilter,c:GetControler(),0,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local wbc=wg:GetFirst()
	while wbc do
		if not wbc:IsOnField() or wbc:IsFaceup() then
			local code=wbc:GetOriginalCode()
			if c:IsFaceup() and c:GetFlagEffect(code)==0 then
				c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,1)
				c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)
			end
		end
		wbc=wg:GetNext()
	end
end
