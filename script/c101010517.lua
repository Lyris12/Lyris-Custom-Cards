--created & coded by Lyris
--レインボーアイズ・スプリング・メッセージ
function c101010517.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(c101010517.target)
	e1:SetOperation(c101010517.activate)
	c:RegisterEffect(e1)
end
function c101010517.cfilter(c,e,tp)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0xb2d) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c101010517.filter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
end
function c101010517.filter(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsSetCard(0xb2d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--Target 1 "Rainbow-Eyes" monster you control; send that target to the Graveyard, then Special Summon 1 "Rainbow-Eyes" monster from your Deck with the same Level as that target's Level. After activation, banish this card instead of sending it to the Graveyard.
function c101010517.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010517.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101010517.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c101010517.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010517.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101010517.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if e:GetHandler():IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
