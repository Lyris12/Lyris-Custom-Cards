--created & coded by Lyris
--制勝竜♊
function c101010269.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) local c=e:GetHandler() local ct=c:GetFlagEffectLabel(10001000) if not ct then c:RegisterFlagEffect(10001000,RESET_PHASE+PHASE_END,0,1,1) else c:SetFlagEffectLabel(10001000,ct+1) end end)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101010269.sumtg)
	e2:SetOperation(c101010269.sumop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c101010269.tg1)
	e4:SetOperation(c101010269.op1)
	c:RegisterEffect(e4)
end
function c101010269.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x50b) and c:IsAbleToHand()
end
function c101010269.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010269.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010269.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010269.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101010269.spfilter(c,at,e,tp)
	return not c:IsAttribute(at) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010269.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local at=0
		local tc=g:GetFirst()
		while tc do
			at=bit.bor(at,tc:GetAttribute())
			tc=g:GetNext()
		end
		return Duel.IsExistingMatchingCard(c101010269.spfilter,tp,LOCATION_DECK,0,1,nil,at,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010269.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c101010269.spfilter,tp,LOCATION_DECK,0,1,1,nil,at,e,tp)
	if tc:GetCount()>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
