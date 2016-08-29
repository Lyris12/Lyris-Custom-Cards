--クリアー・リューセイ
function c101010191.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c101010191.slcon)
	e2:SetValue(6)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e3)
	--spell effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,101010191)
	e6:SetTarget(c101010191.tg)
	e6:SetOperation(c101010191.op)
	c:RegisterEffect(e6)
	--remove attribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c101010191.ratg)
	e5:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e5)
	--protect
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e7:SetCondition(c101010191.econ)
	e7:SetTarget(c101010191.etarget)
	e7:SetValue(c101010191.efilter2)
	c:RegisterEffect(e7)
	--atk
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.IsExistingMatchingCard(c101010191.afilter,tp,0,LOCATION_MZONE,1,nil) end)
	e8:SetValue(c101010191.atkval)
	c:RegisterEffect(e8)
end
function c101010191.artg(e,c)
	return not c:IsImmuneToEffect(e) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c101010191.ratg(e)
	return e:GetHandler()
end
function c101010191.slcon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or (not tc:IsSetCard(0x306))
end
function c101010191.actfilter(c)
	return c:IsFaceup() and c:IsCode(33900648)
end
function c101010191.econ(e)
	return Duel.IsExistingMatchingCard(c101010191.actfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(33900648)
end
-- function c101010191.efilter1(e,re,tp)
	-- return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
-- end
function c101010191.etarget(e,c)
	return c:IsType(TYPE_FIELD)
end
function c101010191.efilter2(e,re,tp)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c101010191.afilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c101010191.atkfilter(c)
	return not (c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_WIND) or c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_DEVINE))
end
function c101010191.atkval(e,c)
	return Duel.GetMatchingGroupCount(c101010191.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())*500
end
function c101010191.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101010191.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(ATTRIBUTE_LIGHT)
	tc:RegisterEffect(e5)
end
