--If this card is sent to the Graveyard for the Synchro Summon of a Level 4 or lower WATER monster: You can return this card to your hand. If this card is sent to the Graveyard for the Synchro Summon of a "Tide" monster: Special Summon this card in Defense Position.
--ＳＳ－始まり潮アレク
function c101010216.initial_effect(c)
	--to hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(101010216,0))
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1)
	e0:SetCondition(c101010216.thcon1)
	e0:SetTarget(c101010216.thtg)
	e0:SetOperation(c101010216.thop)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010216,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCondition(c101010216.spcon1)
	e1:SetTarget(c101010216.sptg)
	e1:SetOperation(c101010216.spop)
	c:RegisterEffect(e1)
	--[[local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010216,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
	e3:SetLabel(1)
	e3:SetCondition(c101010216.spcon2)
	e3:SetTarget(c101010216.sptg)
	e3:SetOperation(c101010216.spop)
	c:RegisterEffect(e3)]]
end
function c101010216.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and rc:IsLevelBelow(4) and rc:IsAttribute(ATTRIBUTE_WATER)
end
function c101010216.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101010216.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT+REASON_RETURN)>0 then
		Duel.ConfirmCards(1-tp,c)
	end
end
function c101010216.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and rc:IsSetCard(0x5ce)
end
function c101010216.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010216.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
end
