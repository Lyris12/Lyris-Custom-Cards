--created & coded by Lyris
--Monument Brasscube
function c101010469.initial_effect(c)
	--materials
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c101010469.ffilter,2,false)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--Once per turn: You can target 1 Level 5 or lower LIGHT Machine-Type monster in your Graveyard; this card gains a number of additional attacks equal to half of that target's Level.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101010469.target)
	e1:SetOperation(c101010469.operation)
	c:RegisterEffect(e1)
end
function c101010469.ffilter(c)
	return c:IsLevelBelow(5) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end
function c101010469.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010469.ffilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010469.ffilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101010469.ffilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c101010469.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(math.ceil(tc:GetLevel()/2))
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
