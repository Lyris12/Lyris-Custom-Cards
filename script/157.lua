--Ｓ・Ｖｉｎｅの女王－クラリサ
function c101010591.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101010591.spcon)
	e1:SetOperation(c101010591.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101010591)
	e2:SetTarget(c101010591.rmtg)
	e2:SetOperation(c101010591.rmop)
	c:RegisterEffect(e2)
end
function c101010591.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x785e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c101010591.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return  Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
	and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.IsExistingMatchingCard(c101010591.cfilter,tp,LOCATION_REMOVED,0,2,nil,e,tp)
end
function c101010591.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c101010591.cfilter,tp,LOCATION_REMOVED,0,2,2,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
end
function c101010591.filter(c)
	local code=c:GetCode()
	return c:IsSetCard(0x785e) and code~=101010591 and c:IsAbleToHand()
end
function c101010591.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c101010591.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010591.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(c101010591.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
