--created & coded by Lyris
--サイバネティッカル・ストロングホールド・ドラゴン"Я"
function c101010418.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c101010418.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(function(e,c) return c:IsCode(79229522) and c:IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c101010418.atkcon)
	e1:SetOperation(c101010418.atkop)
	c:RegisterEffect(e4)
end
c101010418[0]=0
function c101010279.mfilter1(c,tp)
	return not c:IsLocation(LOCATION_MZONE+LOCATION_HAND) or c:IsReleasableByEffect()
end
function c101010418.mfilter2(c,f)
	return c:IsFaceup() and f(c)
end
function c101010418.material(tp,loc1,loc2,chk)
	local g=Duel.GetMatchingGroup(c101010418.mfilter1,tp,loc1,loc2,nil,tp)
	local f0=((c:IsOnField() and c:IsControler(tp)) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local f1=aux.FilterBoolFunction(Card.IsCode,79229522) and f0
	if chk==0 then return g:IsExists(c101010418.mfilter2,1,nil,f1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mg=g:FilterSelect(tp,c101010418.mfilter2,1,1,nil,f1)
	c101010418[0]=mg:GetFirst():GetBaseAttack()
	return mg
end
function c101010418.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c101010418[0]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	c101010418[0]=0
end
function c101010418.atkcon(e)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
end
function c101010418.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101010418.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c101010418.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
