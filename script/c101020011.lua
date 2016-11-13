--created by LionHeartKIng
--coded by Lyris
--Flame Flight - Vulture
function c101020011.initial_effect(c)
	--When this card is Normal or Special Summoned: You can target 1 "Flame Flight" monster in your Graveyard, except "Flame Flight - Vulture"; add that target to your hand. You can only use this effect of "Flame Flight - Vulture" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101020011)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101020011.gthtg)
	e2:SetOperation(c101020011.gthop)
	c:RegisterEffect(e2)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c101020011.con)
	e4:SetOperation(c101020011.mat)
	c:RegisterEffect(e4)
end
function c101020011.con(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c101020011.mat(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--Once per turn: You can banish 1 "Flame Flight" monster from your Graveyard, then target 1 Spell/Trap Card your opponent controls; destroy that target.
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(101020011,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101020011.matcost)
	e1:SetTarget(c101020011.mattg)
	e1:SetOperation(c101020011.matop)
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
function c101020011.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa88) and c:IsAbleToRemoveAsCost()
end
function c101020011.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020011.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101020011.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101020011.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c101020011.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c101020011.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101020011.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101020011.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101020011.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c101020011.filter(c)
	return c:IsSetCard(0xa88) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetCode()~=101020011
end
function c101020011.gthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101020011.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101020011.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101020011.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101020011.gthop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
