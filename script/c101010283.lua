--レイディアント・ドラグーン
function c101010283.initial_effect(c)
aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(nil),1)
	--reveal
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101010283.cost)
	e1:SetOperation(c101010283.operation)
	c:RegisterEffect(e1)
end
function c101010283.cfilter(c)
	return c:IsSetCard(0x5e) and not c:IsPublic()
end
function c101010283.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010283.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c101010283.cfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	tc:RegisterEffect(e1)
end
function c101010283.atkfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsFaceup()
end
function c101010283.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101010283.atkfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
