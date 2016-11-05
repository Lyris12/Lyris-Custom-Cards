--Dimension-Magica Knight
function c101010396.initial_effect(c)
	--While this card is banished, DARK Spatial Monsters you control cannot be destroyed by card effects.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_REMOVED)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e0:SetTarget(c101010396.indtg)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--Once per turn: You can banish 1 Spellcaster-Type monster from your hand; increase or decrease this card's Level by the banished monster's Level.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010396,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101010396.lvcost)
	e2:SetTarget(c101010396.lvtg)
	e2:SetOperation(c101010396.lvop)
	c:RegisterEffect(e2)
	--If this card is banished from the field: You can add 1 "Dimension-Magica" monster from your Deck to your hand, except "Dimension-Magica Knight". You can only use this effect of "Dimension-Magica Knight" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101010396)
	e1:SetCondition(c101010396.condition)
	e1:SetTarget(c101010396.target)
	e1:SetOperation(c101010396.operation)
	c:RegisterEffect(e1)
end
function c101010396.indtg(e,c)
	return c.spatial and c:IsAttribute(ATTRIBUTE_DARK)
end
function c101010396.filter(c)
	return c:GetLevel()>0 and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost()
end
function c101010396.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010396.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101010396.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c101010396.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=Duel.SelectOption(tp,aux.Stringid(101010396,0),aux.Stringid(101010396,1))
	e:SetLabel(opt)
end
function c101010396.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabelObject():GetLevel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		if e:GetLabel()==0 then
			e1:SetValue(lv)
		else
			e1:SetValue(-lv)
		end
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c101010396.condition(e)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101010396.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa03) and c:IsAbleToHand() and c:GetCode()~=101010396
end
function c101010396.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010396.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010396.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101010396.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
