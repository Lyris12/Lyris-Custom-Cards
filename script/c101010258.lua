--created & coded by Lyris
--Dragluo Elder
function c101010258.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(aux.nfbdncon)
	e1:SetTarget(c101010258.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c101010258.descon)
	e2:SetTarget(c101010258.destg)
	e2:SetOperation(c101010258.desop)
	c:RegisterEffect(e2)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c101010258.xyzlimit)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c101010258.con)
	e4:SetOperation(c101010258.op)
	c:RegisterEffect(e4)
	--avoid battle damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c101010258.tg)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c101010258.tg(e,c)
	return c:IsRace(RACE_DRAGON)
end
function c101010258.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c101010258.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101010258.sumlimit)
	Duel.RegisterEffect(e1,e:GetHandler():GetControler())
end
function c101010258.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_DRAGON
end
function c101010258.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_DRAGON)
end
function c101010258.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c101010258.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_DRAGON) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c101010258.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c101010258.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c101010258.desfilter(c,rc)
	return c:IsFaceup() and c:IsRace(rc)
end
function c101010258.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101010258.desfilter,tp,LOCATION_MZONE,0,1,nil,RACE_DRAGON) and Duel.IsExistingTarget(c101010258.desfilter,tp,0,LOCATION_MZONE,1,nil,RACE_WARRIOR) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101010258.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101010258.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c101010258.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
