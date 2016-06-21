--ＳＳ－メッセンジャーシール
local id,ref=GIR()
function ref.start(c)
--If this card is sent to the Graveyard for a Synchro Summon: target that Synchro Monster; Draw 1 card, plus another card if that target is WATER.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(ref.con1)
	e1:SetTarget(ref.tg)
	e1:SetOperation(ref.op)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(ref.con2)
	c:RegisterEffect(e0)
	--draw/special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCost(ref.spcost)
	e2:SetTarget(ref.sptg)
	e2:SetOperation(ref.spop)
	c:RegisterEffect(e2)
end
function ref.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function ref.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SYNCHRO)
end
function ref.filter(c,e,tp)
	return c:IsSetCard(0x5cd) and c:IsLevelBelow(4) and c:GetCode()~=id and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
	if chk==0 then return rc:IsCanBeEffectTarget(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SetTargetCard(rc)
	rc:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CANNOT_DISABLE,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local rc=c:GetReasonCard()
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DRAW)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(ref.drcon)
		e1:SetTarget(ref.drtg)
		e1:SetOperation(ref.drop)
		rc:RegisterEffect(e1)
	end
end
function ref.drcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function ref.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	if c:IsAttribute(ATTRIBUTE_WATER) then
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	else
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function ref.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function ref.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	if dc:IsLevelBelow(4) and dc:IsNotTuner() and dc:IsAttribute(ATTRIBUTE_WATER) and dc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(dc,0,tp,tp,false,false,POS_FACEUP)
	end
end