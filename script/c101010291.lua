--created & coded by Lyris
--Radiant Sacred Dragun
function c101010291.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,2)
	--This card's effects cannot be negated.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	--Unless you have a LIGHT monster revealed in your hand, your opponent takes no battle damage from battles involving this card.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e4:SetCondition(c101010291.rdcon)
	c:RegisterEffect(e4)
	--This card cannot declare an attack unless you detach 1 Xyz Material from this card.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_COST)
	e5:SetCost(c101010291.atcost)
	e5:SetOperation(c101010291.atop)
	c:RegisterEffect(e5)
end
function c101010291.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsPublic()
end
function c101010291.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c101010291.filter,tp,LOCATION_HAND,0,1,nil)
end
function c101010291.atcost(e,c,tp)
	return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c101010291.atop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
