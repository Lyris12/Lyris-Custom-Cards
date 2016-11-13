--created by LionHeartKIng
--coded by Lyris
--Real Rights - Guardian
function c101020034.initial_effect(c)
	--hand des
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101020034)
	e2:SetCondition(c101020034.con)
	e2:SetTarget(c101020034.target)
	e2:SetOperation(c101020034.operation)
	c:RegisterEffect(e2)
	--to grave You can banish this card from your Graveyard; send 1 "Real Rights" monster from your Deck to the Graveyard, except "Real Rights - Guardian".
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,201010465)
	e1:SetCost(c101020034.cost)
	e1:SetTarget(c101020034.tg)
	e1:SetOperation(c101020034.op)
	c:RegisterEffect(e1)
end
function c101020034.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return r==REASON_RITUAL and rc:IsSetCard(0x2ea)
end
function c101020034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c101020034.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c101020034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c101020034.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2ea) and c:GetCode()~=101020034 and c:IsAbleToGrave()
end
function c101020034.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020034.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101020034.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101020034.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
