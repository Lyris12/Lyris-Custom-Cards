--Cyber Space
function c101010167.initial_effect(c)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetOperation(c101010167.op)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetRange(LOCATION_FZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x93))
	e0:SetValue(c101010167.value)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(c101010167.rtarget)
	c:RegisterEffect(e1)
end
function c101010167.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4093)
end
function c101010167.value(e)
	return Duel.GetMatchingGroupCount(c101010167.atkfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)*300
end
function c101010167.rtarget(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsControler,1,nil,1-tp) then
		local g=eg:Filter(Card.IsControler,nil,1-tp)
		local tc=g:GetFirst()
		while tc do
			if tc:IsFaceup() then
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
			tc=g:GetNext()
		end
	end
end
function c101010167.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c101010167.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101010167.filter,tp,0,LOCATION_REMOVED,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
end
