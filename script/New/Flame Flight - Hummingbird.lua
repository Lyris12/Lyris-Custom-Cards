--Flame Flight - Hummingbird
function c101010557.initial_effect(c)
	--fusion substitute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e1:SetCondition(c101010557.subcon)
	c:RegisterEffect(e1)
	--material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetCondition(c101010557.con)
	e0:SetOperation(c101010557.mat)
	c:RegisterEffect(e0)
end
function c101010557.con(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c101010557.mat(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdcon)
	e1:SetTarget(c101010557.mattg)
	e1:SetOperation(c101010557.matop)
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
function c101010557.thfilter(c,lv)
	return c:IsLevelBelow(lv) and c:IsAbleToHand()
end
function c101010557.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	local lv=bc:GetLevel()
	if lv==0 then lv=bc:GetRank() end
	if chk==0 then return Duel.IsExistingMatchingCard(c101010557.thfilter,tp,LOCATION_DECK,0,1,nil,lv) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010557.matop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local lv=bc:GetLevel()
	if lv==0 then lv=bc:GetRank() end
	local g=Duel.SelectMatchingCard(tp,c101010557.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	if sg:GetCount()>0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c101010557.subcon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
