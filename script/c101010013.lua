--旋風のライダー
local id,ref=GIR()
function ref.start(c)
--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetRange(LOCATION_HAND)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetCondition(ref.spcon)
	e0:SetTarget(ref.sptg)
	e0:SetOperation(ref.spop)
	c:RegisterEffect(e0)
	--search1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():IsReason(REASON_EFFECT+REASON_MATERIAL) end)
	e1:SetTarget(ref.thtg)
	e1:SetOperation(ref.thop)
	c:RegisterEffect(e1)
	--search2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(ref.thtg1)
	e3:SetOperation(ref.thop1)
	c:RegisterEffect(e3)
end
function ref.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_DECK) and r==REASON_SYNCHRO and c:GetReasonCard():IsSetCard(0x1d5d)
end
function ref.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function ref.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.cfilter,1,nil)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function ref.filter(c)
	return c:IsSetCard(0x1d5d) and c:IsAbleToHand() and c:GetCode()~=id
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function ref.filter1(c)
	return c:IsSetCard(0x1d5d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function ref.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.thop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(ref.filter1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
