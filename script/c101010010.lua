--created & coded by Lyris
--Flame Flight - Owl
function c101010010.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010010,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c101010010.cost)
	e1:SetTarget(c101010010.target)
	e1:SetOperation(c101010010.operation)
	c:RegisterEffect(e1)
	--material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetCondition(c101010010.con)
	e0:SetOperation(c101010010.mat)
	c:RegisterEffect(e0)
end
function c101010010.fus(e)
	local c=e:GetHandler()
	if not c:IsReason(REASON_FUSION) then return false end
	
	return not c:GetReasonCard():IsAttribute(ATTRIBUTE_FIRE)
end
function c101010010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c101010010.filter(c)
	return c:IsCode(101010055) and c:IsAbleToHand()
end
function c101010010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010010.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010010.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010010.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101010010.con(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c101010010.mat(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdcon)
	e1:SetTarget(c101010010.mattg)
	e1:SetOperation(c101010010.matop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
	if not rc:IsAttribute(ATTRIBUTE_FIRE) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then Duel.SendtoDeck(c,nil,2,REASON_EFFECT) end
end
function c101010010.thfilter(c,race,att)
	return (c:IsRace(race) or c:IsAttribute(att)) and c:IsAbleToHand()
end
function c101010010.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c101010010.thfilter,tp,LOCATION_DECK,0,1,nil,bc:GetRace(),bc:GetAttribute()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010010.matop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local g=Duel.GetMatchingGroup(c101010010.thfilter,tp,LOCATION_DECK,0,nil,bc:GetRace(),bc:GetAttribute())
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
