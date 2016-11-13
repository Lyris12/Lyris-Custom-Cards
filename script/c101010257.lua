--created & coded by Lyris
--チビ・ドラッグルーオン
function c101010257.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c101010257.target)
	e4:SetValue(c101010257.value)
	c:RegisterEffect(e4)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101010257.spcon)
	e1:SetOperation(c101010257.spop)
	c:RegisterEffect(e1)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c101010257.xyzlimit)
	c:RegisterEffect(e3)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101010257.condition)
	e2:SetOperation(c101010257.operation)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c101010257.con)
	e4:SetOperation(c101010257.op)
	c:RegisterEffect(e4)
end
function c101010257.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c101010257.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101010257.sumlimit)
	Duel.RegisterEffect(e1,e:GetHandler():GetControler())
end
function c101010257.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_DRAGON)
end
function c101010257.filter(c)
	return c:IsFaceup() and c:GetLevel()==8 and c:IsRace(RACE_DRAGON)
end
function c101010257.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()~=8
		and Duel.IsExistingMatchingCard(c101010257.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c101010257.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c101010257.spfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_XYZ)
end
function c101010257.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010257.spfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c101010257.spop(e,tp,eg,ep,ev,re,r,rp,c)
	--change level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(8)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c101010257.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_DRAGON)
end
function c101010257.filter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c101010257.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101010257.dfilter,1,nil,tp) end
	return true
end
function c101010257.value(e,c)
	return c101010257.dfilter(c,e:GetHandlerPlayer())
end
