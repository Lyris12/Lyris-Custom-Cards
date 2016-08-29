--Cyberspace Dragon
function c101010024.initial_effect(c)
--add LIGHT attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c101010024.spcon)
	c:RegisterEffect(e2)
end
function c101010024.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c101010024.spcon(e,c)
	if c==nil then return true end
	return not Duel.IsExistingMatchingCard(c101010024.filter,c:GetControler(),0,LOCATION_REMOVED,1,nil)
		and Duel.IsExistingMatchingCard(c101010024.filter,c:GetControler(),LOCATION_REMOVED,0,1,nil)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
