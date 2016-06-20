--Radiant Sacred Dragun
local id,ref=GIR()
function ref.start(c)
aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e0:SetCondition(ref.con)
	e0:SetOperation(ref.hop)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(function(e) return Duel.GetMatchingGroupCount(ref.radon,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)==1 end)
	e1:SetTarget(ref.tg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DEVINE_LIGHT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e1:SetCondition(function(e) return Duel.GetMatchingGroupCount(ref.radon,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)==1 end)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PUBLIC)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e4:SetTarget(ref.tg)
	c:RegisterEffect(e4)
end
function ref.radon(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function ref.tg(e,c)
	if Duel.GetMatchingGroupCount(ref.radon,e:GetHandlerPlayer(),LOCATION_MZONE,0,e:GetHandler())~=0 then return false end
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function ref.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsPublic()
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function ref.hop(e,tp,eg,ep,ev,re,r,rp)
	local val=ev/2
	if Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_HAND,0,1,nil) then val=val/2 end
	Duel.ChangeBattleDamage(ep,val)
end
