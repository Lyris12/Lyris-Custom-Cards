--Dimension-Magica Sealmaster
function c101010397.initial_effect(c)
	--While this card is banished, apply this effect. (effect below)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101010397.aclimit)
	e1:SetCondition(c101010397.actcon)
	c:RegisterEffect(e1)
	--If this card on the field is banished: You can add 1 "Dimension-Magica" Spell/Trap Card from your Deck to your hand. You can only use this effect of "Dimension-Magica Sealmaster" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101010397)
	e2:SetCondition(c101010397.condition)
	e2:SetTarget(c101010397.target)
	e2:SetOperation(c101010397.operation)
	c:RegisterEffect(e2)
end
--If a DARK Spatial Monster you control battles, your opponent cannot activate cards or effect(s) until the end of the Damage Step.
function c101010397.actfilter(c,tp)
	return c:IsControler(tp) and c.spatial and c:IsAttribute(ATTRIBUTE_DARK) 
end
function c101010397.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c101010397.actcon(e)
	local tp=e:GetHandlerPlayer()
	local at=Duel.GetAttacker()
	local bt=Duel.GetAttackTarget()
	return (at~=nil and c101010397.actfilter(at,tp)) or (bt~=nil and c101010397.actfilter(bc,tp))
end
function c101010397.condition(e)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101010397.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xa03) and c:IsAbleToHand()
end
function c101010397.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010397.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010397.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101010397.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
